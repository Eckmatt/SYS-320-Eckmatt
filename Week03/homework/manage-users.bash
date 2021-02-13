#!/bin/bash

#Storyline: Script to add and delete VPN peers

while getopts 'hdacu:' OPTION ; do

	case "$OPTION" in

		#Delete a user
		d) u_del=${OPTION}
		;;


		#Add a user
		a) u_add=${OPTION}
		;;
	

		#Specifies user to add or delete
		u) t_user=${OPTARG}
		;;

		#Checks to see if the user exists in config
		c)
			user_check= cat wg0.conf | grep ${t_user}
			if [[ user_check != "" ]]
			then
				u_check=${OPTION}
			fi
		;;


		#help menu
		h)
			echo ""
			echo "Usage: $(basename $0) [-a][-d][-u username][-c]"
			echo ""
			exit 1
		
		;;


		#wildcard - throws an error with incorrect option
		*)

			echo "ERROR: Invalid Option"
			exit 1
		;;
	esac

done


# Check to see if the -a and -d are empty or if they are specified throw an error
if [[ (${u_del} == "" && ${u_add} == "") || (${u_del} != "" && ${u_add} != "") ]]
then
	echo "Please specify -a or -d and the -u username."
	exit 1
fi

# Check to ensure if -u is specified
if [[ (${u_del} != "" ||  ${u_add} != "") && ${t_user} == "" ]]
then

	echo "Please specify a user (-u)!"
	echo "Usage: $(basename $0) [-a][-d] [-u username]"
	exit 1
fi

#Delete a user
if [[ ${u_del} ]]
then
	#Deletes the user from wg0.conf as well as that users respective peer file
	#MODIFIED PER REQUEST OF THE HOMEWORK ASSIGNMENT - only deletes if the user has specified to check if the user exists in wg0.conf
	echo "Deleting user..."
	if [[ ${u_check} ]]
	then
		sed -i "/# ${t_user} begin/,/# ${t_user} end/d" wg0.conf
	fi
	rm ${t_user}-wg0.conf
fi

if [[ ${u_add} ]]
then

	echo "Creating new user..."
	bash peer.bash ${t_user}
fi
