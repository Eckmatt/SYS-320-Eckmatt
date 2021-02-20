#!/bin/bash

# Storyline : Menu for admin, VPN, and Security functions

function invalid_opt() {

	echo ""
	echo "Invalid Option"
	echo ""
	sleep 2
}

function menu() {
	#clears the screen
	clear

	echo "[1] Admin Menu"
	echo "[2] Security Menu"
	echo "[3] Exit"
	read -p "Please enter an option above: "  choice

	case "$choice" in

		1) admin_menu
		;;

		2) security_menu
		;;

		3) exit 0
		;;

		*)
			invalid_opt
			#call the main menu
			menu

		
		;;
	esac
}

function admin_menu() {

	clear
	echo "ADMIN MENU"
	echo ""
	echo "[L]ist Running Processes"
	echo "[N]etwork Sockets"
	echo "[V]PN Menu"
	echo "[4] Exit"
	read -p "Please enter an option above: " choice

	
	case "$choice" in

		L|l) ps -ef |less
		;;

		N|n) netstat -an --inet |less
		;;

		V|v) vpn_menu
		;;
		4) exit 0
		;;

		*)
			invalid_opt
			admin_menu
		;;

	esac
#return to the admin menu
admin_menu 
}

function vpn_menu() {

	clear
	echo "[A]dd a peer"
	echo "[D]elete a peer"
	echo "[M]ain menu"
	echo "[E]xit"
	read -p "Please select an option: " choice
	case "$choice" in

		A|a) bash peer.bash
		;;

		D|d)
			#create a prompt for the user to enter a username to delete
			#call manage-users.bash and delete the user (using correct arguments and switches
			
			read -p "Specify the name of the user you wish to delete" user
			bash manage-users.bash -d -u ${user}
		
		;;

		M|m) menu
		;;
		E|e) exit 0
		;;

		*)
			invalid_opt
			admin_menu
		;;

	esac
vpn_menu
}

function security_menu() {


	clear
	echo "[1]List Open Network Sockets"
	echo "[2]Check if any user besides root has a UID of 0"
	echo "[3]Check last 10 logged in users"
	echo "[4]See currently logged in users"
	echo "[5]Block List Menu"
	echo "[E]xit"
	read -p "Please select an option: " choice
	case "$choice" in

		1)
			#Lists All Open Network Sockets
			ss -l |less
		
		;;

		2)
			#Displays all users 
			grep 'x:0:' /etc/passwd |less
		
		;;

		3)
			#Displays last 10 logins
			last |tail -10 |less
			
		;;
		4)
			#Displays currently logged in users
			w |less
		;;
		5)
			#Allows the user to create firewall rules specific to their firewall
			echo "[C]isco blocklist generator"
			echo "[I]ptable blocklist generator"
			echo "[N]etscreen blocklist generator"
			echo "[W]indows blocklist generator"
			echo "[M]ac blocklist generator"
			echo "[U]nique File parse"
			echo "[E]xit"
			read -p "Please select an option: " firewall
				case "$choice" in

		C|c) #Creates a cisco blocklist
			bash parse-threat.bash -c
		;;

		I|i)
			#Creates a iptable blocklist
			bash parse-threat.bash -i
		
		;;

		N|n) #Creates a netscreen blocklist
			bash parse-threat.bash -n
		;;
		
		W|w) #Creates a Windows blocklist
			bash parse-threat.bash -w
		;;

		M|m) #Creates a Mac OS blocklist
			bash parse-threat.bash -m
		;;

		U|u) #parses the unique blocklist and creates a config for it
			bash parse-threat.bash -u
		;;
		
		E|e) exit 0
		;;

		*)
			invalid_opt
			admin_menu
		;;

	esac

			
		;;
		E|e) exit 0
		;;
		*)
			invalid_opt
			admin_menu
		;;

	esac
security_menu
}


#Call the main menu
menu
