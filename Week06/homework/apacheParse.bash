#!/bin/bash

#Parse Apache log
#101.236.44.127 - - [24/Oct/2017:04:11:14 -0500] "GET / HTTP/1.1" 200 225 "-" "Mozilla/5.0 (Windows NT 6.2; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/27.0.1453.94 Safari/537.36

#Read in file

#Arguments using the position, they start at $1


#check if file exists
echo -n "Please enter an apache log file."
read tFile


if [[ ! -f ${tFile}  ]]
then
	echo "Please specify the path to a log file."
	exit 1
fi

# Looking for web scanners.
sed -e "s/\[//g" -e "s/\"//g" ${tFile} | \
egrep -i "test|shell|echo|passwd|select|phpmyadmin|setup|admin|w00t" | \
awk ' BEGIN { format = "%-15s %-20s %-6s %-6s -%5s %s\n" 
	printf format, "IP", "Date", "Method", "Status", "Size", "URI"
	printf format, "--", "----", "------", "------", "----", "---"

}

{ printf format, $1, $4, $6, $9, $10, $7 }' | sort -t, -u  -nk1 | tail -n +2 >output.txt

#Extract the IP addresses from the output file
for eachline in $(cat output.txt)
do
	awk ' { print $1 } ' output.txt >badIPs.txt

done

#Use the IP address to create firewall rules
for eachline in $(cat badIPs.txt)
do
	echo "iptables -A INPUT -s ${eachline} -j DROP" | tee -a badIPs.iptables
	echo "netsh advfirewall firewall add rule name='BLOCK IP ADDRESS - ${eachline}' dir=in action=block remoteip=${eachline}" | tee -a windows_config.bash

done

