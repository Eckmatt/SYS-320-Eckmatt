#!/bin/bash

# Storyline: Script to create wireguard server

#what is the configuration name?
echo -n "What is the name of this configuration? "
read config_name

#Filename variable
cFile="${config_name}.conf"

#check if the config file exists
if [[ -f "${cFile}" ]]
then

	#Prompt if we need to overwrite the file
	echo "The file ${cFile} exists"
	echo -n "Do you want to overwrite it? [y|N]"
	read to_overwrite

	#Overwrite Check
	if [[ "${to_overwrite}" == "N" || "${to_overwrite}" == "n" ]]
	then
		echo "Exiting program..."
		exit 0

	elif [[ "${to_overwrite}" == "y" || "${to_overwrite}" == "Y" ]]
	then

		echo "Creating wireguard configuration file..."


	#if user doesn't specify y or N, then error
	else
		echo "Invalid value"
		exit 1
	fi
fi



# Create Private Key
prikey="$(wg genkey)"

#Create Public Key
pubkey="$(echo ${prikey} | wg pubkey)"

#Set Adresses

address="10.254.132.0/24,172.16.28.0/24"

#Set Server IP Address

ServerAddress="10.254.132.1/24,172.16.28.1/24"

#Set Listen Port
lport="4282"

#Create the format for the client configuration options
peerInfo="# ${address} 184.171.152.33:4282 ${pubkey} 8.8.8.8,1.1.1.1 1280 120 0.0.0.0/0"


: '

#10.254.132.0/24, 172.16.28.0/24 162.243.2.92:4282 ax8BVVCAtgASQ4XtOsaCGaQihW83JjZk5RgsK/mDIHU= 8.8.8.8,1.1.1.1 1280 120 0.0.0.0/0
[Interface]
Address = 10.254.132.1/24,172.16.28.1/24
#PostUp = /etc/wireguard/wg-up.bash
#PostDown = /etc/wireguard/wg-down.bash
ListenPort = 4282
PrivateKey = mD0oXx6HLWyrbdnoX3igK/PAy5vdAJDV2AUXZ2eFP0M


'
echo "${peerInfo}
[Interface]
Address = ${ServerAddress}
#PostUp = /etc/wireguard/wg-up.bash
#PostDown = /etc/wireguard/wg-down.bash
ListenPort = ${lport}
PrivateKey = ${prikey}
" > ${cFile}

