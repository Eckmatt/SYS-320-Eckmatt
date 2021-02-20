#!/bin/bash

# Storyline: Extract IPs from the emergingthreats.net and create a firewall ruleset

#alert tcp [2.59.200.0/22,5.134.128.0/19,5.180.4.0/22,5.181.84.0/22,5.183.60.0/22,5.188.10.0/23,24.137.16.0/20,24.170.208.0/20,24.233.0.0/19,24.236.0.0/19,27.126.160.0/20,27.146.0.0/16,31.14.65.0/24,31.14.66.0/23,31.40.156.0/22,31.40.164.0/22,36.0.8.0/21,36.37.48.0/20,36.116.0.0/16,36.119.0.0/16] any -> $HOME_NET any (msg:"ET DROP Spamhaus DROP Listed Traffic Inbound group 1"; flags:S; reference:url,www.spamhaus.org/drop/drop.lasso; threshold: type limit, track by_src, seconds 3600, count 1; classtype:misc-attack; flowbits:set,ET.Evil; flowbits:set,ET.DROPIP; sid:2400000; rev:2805; metadata:affected_product Any, attack_target Any, deployment Perimeter, tag Dshield, signature_severity Minor, created_at 2010_12_30, updated_at 2021_02_19;)


#Regex to extract the networks
#2.				59.				200.			0/		22
while getopts 'huicnwm:' OPTION ; do

	case "$OPTION" in

		#Create firewall drop rules for iptable-based firewalls
		i) create_iptable=${OPTION}
		;;


		#Create firewall drop rule for cisco-based firewalls
		c) create_cisco=${OPTION}
		;;

		#Create firewall drop rule for Netscreen-based firewalls
		n) create_netscreen=${OPTION}
		;;
		
		#Create firewall drop rule for Windows firewall-based firewalls
		w) create_windows=${OPTION}
		;;

		
		#Create firewall drop rule for MAC OS  firewalls
		m) create_mac=${OPTION}
		;;

		#Parses the specified file in the homework
		u) parse_unique_file=${OPTION}
		;;

		#help menu
		h)
			echo ""
			echo "Usage: $(basename $0) [-i][-c][n][w][m]"
			echo "-i : create iptable rules"
			echo "-c : create cisco firewall rules"
			echo "-n : create netscreen firewall rules"
			echo "-w : create windows firewall rules"
			echo "-m : create MAC OS firewall rules"
			echo "-p : parses the specified file detailed in the homework"
			
			exit 1
		
		;;


		#wildcard - throws an error with incorrect option
		*)

			echo "ERROR: Invalid Option"
			exit 1
		;;
	esac

done

#Filename variable
pFile="/tmp/emerging-drop.rules"

#Check if emerging threats file exists
if [[ -f "${pFile}"  ]]
then

	#Prompt if we need to overwrite the file
	echo "The file ${pFile} exists"
	echo -n "Do you want to overwrite it? [y|N]"
	read to_overwrite

####Overwrite Check####
	if [[ "${to_overwrite}" == "N" || "${to_overwrite}" == "n" ]]
	then
	
		echo "No Overwrite Selected"

	elif [[ "${to_overwrite}" == "y"  || "${to_overwrite}" == "Y" ]]
	then


		echo "Creating the drop rules file..."
		wget https://rules.emergingthreats.net/blockrules/emerging-drop.rules -O /tmp/emerging-drop.rules

	#if user doesn't specify a y or N then error.
	else

		echo "Invalid value"
		exit 1

	fi
	
#If the emerging threats file does not exist, create it.
#else 

	#echo "Creating the drop rules file..."
	#wget https://rules.emergingthreats.net/blockrules/emerging-drop.rules -O /tmp/emerging-drop.rules
fi




egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.0/[0-9]{1,2}' /tmp/emerging-drop.rules | sort -u | tee badIPs.txt


#Create a firewall ruleset
for eachIP in $(cat badIPs.txt)
do
	if [[ ${create_iptables} ]]
	then
		#LINUX BASED SYNTAX
		echo "iptables -A INPUT -s ${eachIP} -j DROP" | tee -a badIPs.iptables

	elif [[ ${create_cisco} ]]
	then
		#CISCO BASED SYNTAX
		echo "access-list 116 deny	tcp host ${eachIP} any" | tee -a cisco.config
		echo "access-list 116 deny	udp host ${eachIP} any" | tee -a cisco.config
		echo "access-list 116 deny	icmp host ${eachIP} any" | tee -a cisco.config
		

	elif [[ ${create_netscreen} ]]
	then
		#NETSCREEN BASED SYNTAX
		echo "set interface untrust ip ${eachIP}" | tee -a netscreen.config

	elif [[ ${create_windows} ]]
	then
		#WINDOWS BASED SYNTAX
		echo "netsh advfirewall firewall add rule name='Deny ${eachIP}' dir=in action=block protocol=ANY remoteip=${eachIP}" | tee -a windows_config.bash



		
	elif [[ ${create_mac} ]]
	then
		#MAC OS SYNTAX
		echo "block in from ${eachIP} to any" | tee -a pf.conf
	fi
	
done

if [[ ${parse_unique_file} ]]
then
	wget https://raw.githubusercontent.com/botherder/targetedthreats/master/targetedthreats.csv -o /tmp/raw_threat_dump.csv

	echo "class-map match-any BAD_URLS" |tee -a newcisco.conf

	for eachline in /tmp/raw_threat_dump.csv
	do
		echo "${eachline}" | tee eachline.txt
		domain_check="$(awk -F, ' { print $1 } ' eachline.txt)"

		if [[ ${domain_check}=="domain" ]]
		then
	
			domainName="$(awk -F, ' {print $2} ' eachline.txt)"
			echo "match protocol http host '${domainName}'" |tee -a newcisco.conf
		
		fi
	
	done

fi
