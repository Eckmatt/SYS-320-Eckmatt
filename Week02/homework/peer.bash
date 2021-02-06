#!/bin/bash

#Storyline: Create VPN peer configuration file

#What is the peer's name?
echo -n "What is the user's name? "
read the_client

#Filename variable
pFile="${the_client}-wg0.conf"

#Check if peer file exists
if [[ -f "${pFile}"  ]]
then

	#Prompt if we need to overwrite the file
	echo "The file ${pFile} exists"
	echo -n "Do you want to overwrite it? [y|N]"
	read to_overwrite

####Overwrite Check####
	if [[ "${to_overwrite}" == "N" || "${to_overwrite}" == "n" ]]
	then
		echo "Exiting program..."
		exit 0

	elif [[ "${to_overwrite}" == "y"  || "${to_overwrite}" == "Y" ]]
	then


		echo "Creating the wireguard configuration file..."

	#if user doesn't specify a y or N then error.
	else

		echo "Invalid value"
		exit 1

	fi

fi


#Generate Private Key
clientPrikey="$(wg genkey)"

#Generate Public Key
clientPubkey="$(echo ${clientPrikey} | wg pubkey)"


#Generate Preshared key
prekey="$(wg genpsk)"


#10.254.132.0/24, 172.16.28.0/24 162.243.2.92:4282 ax8BVVCAtgASQ4XtOsaCGaQihW83JjZk5RgsK/mDIHU= 8.8.8.8,1.1.1.1 1280 120 0.0.0.0/0

#Endpoint
end="$(head -1 wg0.conf | awk ' { print $3 } ')"

#Server Public Key
servPubkey="$(head -1 wg0.conf | awk ' { print $4 } ')"

#DNS servers
dns="$(head -1 wg0.conf | awk ' { print $5 } ')"


#MTU
mtu="$(head -1 wg0.conf | awk ' { print $6 } ')"

#KeepAlive
keep="$(head -1 wg0.conf | awk ' { print $7 } ')"

#ListenPort
lport="$(shuf -n1 -i 40000-50000)"


#Default routes for VPN
routes="$(head -1 wg0.conf | awk ' { print $8 } ')"

#Create Client configuration file

#this template is different from the one used in the lecture. It's just for myself to help understand the formatting of the config file

: '
# 10.254.132.0/24,172.16.28.0/24 184.171.152.33:4282 tVJV7hiwiurcS4ZO2IcOBb5td20GgaWF6+JnM3ZZ8TY= 8.8.8.8,1.1.1.1 1280 120 0.0.0.0/0
[Interface]
Address = 10.254.132.1/24,172.16.28.1/24
#PostUp = /etc/wireguard/wg-up.bash
#PostDown = /etc/wireguard/wg-down.bash
ListenPort = 4282
PrivateKey = SPD2yyyqbyTZK7iC1erUEcCGIOhI1mfmAlf5owTJ2nM=
[Peer]
AllowedIPs = 0.0.0.0/0
PersistentKeepalive = 120
PresharedKey = 0___0
PublicKey = W3@P0N+0SURP@SSM3+@LG3@R
Endpoint = some endpoint here


#echo the configuration to the named configuration file.
'
echo "[Interface]
Address = 10.254.132.100/24
DNS = ${dns}
ListenPort=${lport}
MTU = ${mtu}
PrivateKey = ${clientPrikey}

[Peer]
AllowedIPs = ${routes}
PersistentKeepalive = ${keep}
PresharedKey = ${prekey}
PublicKey = ${servPubkey}
Endpoint = ${end}
" > ${pFile}

#add peer configuration to server
echo "

# ${the_client} begin
[Peer]
Publickey = ${clientPubkey}
PresharedKey = ${prekey}
AllowedIPs = 10.254.132.100/32

# ${the_client} end" | tee -a wg0.conf

echo "
sudo cp wg0.conf /etc/wireguard
sudo wg addconf wg0 <(wg-quick strip wg0)
"
