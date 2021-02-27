#!/bin/bash


#Storyline: Script to perform local security checks

function checks() {
	if [[ $2 != $3  ]]
	then

		echo "The $1 is not compliant. The current policy should be: $2, current value is: $3."
		if [[ $4 ]]
		then
			echo -e "$4"

		fi
		
	else

		echo "The $1 is compliant. Current Value $3."

	fi

	echo ""

}

#Check the password max days policy.
pmax=$(egrep -i '^PASS_MAX_DAYS' /etc/login.defs | awk ' { print $2 } ')
checks "Password Max Days" "365" "${pmax}"


#Check the password minimum days between changes
pmin=$(egrep -i '^PASS_MIN_DAYS' /etc/login.defs | awk ' { print $2 } ')
checks "Password Min Days" "14" "${pmin}"


#Check the password warn age
pwarn=$(egrep -i '^PASS_WARN_AGE' /etc/login.defs | awk ' { print $2 } ')
checks "Password Warn Age" "7" "${pwarn}"

#Check the SSH UsePam configuration
chkSSHPAM=$(egrep -i '^UsePAM' /etc/ssh/sshd_config | awk ' { print $2 } ')
checks "SSH UsePam" "yes" "${chkSSHPAM}"


#Check permissions on users home directory
echo ""
for eachDir in $(ls -l /home | egrep '^d' | awk ' { print $3 } ')
do
	chDir=$(ls -ld /home/${eachDir} | awk ' { print $1 } ')
	checks "Home Directory ${eachDir}" "drwx------" "${chDir}"



done

#Check if IP forwarding is disabled
ipForward=$(egrep -i "net\.ipv4\.ip_forward" /etc/sysctl.conf  | awk -F "=" ' { print $2 } ')
checks "IPv4 Forwarding" "0"  "${ipForward}" "Edit /etc/sysctl.conf and set:\nnet.ipv4.ip_forward=1\nto\nnet.ipv4.ip_forward=0.\nThen run:\nsysctl -w"



#Ensure ICMP redirects are not accepted
icmpRedirect=$(egrep -i "net\.ipv4\.conf\.all\.accept_redirects" /etc/sysctl.conf  | awk -F "=" ' { print $2 } ')
checks "ICMP Redirect" "0"  "${icmpRedirect}" "Edit /etc/sysctl.conf and set:\nnet.ipv4.conf.all.accept redirects=1 and net.ipv4.conf.default.accept_redirects=1\nto equal zero.\nThen run:\nsysctl -w"

#Ensure permissions on /etc/crontab
chkCrontab=$(stat /etc/crontab |egrep -i "Access" |head -1)
checks "/etc/crontab Access" "Access: (0600/-rw-------)  Uid: (    0/    root)   Gid: (    0/    root)"  "${chkCrontab}" "Run the following commands to set ownership and permissions on /etc/crontab:\nchown root:root /etc/crontab \nchmod og-rwx /etc/crontab"

#Ensure permissions on /etc/cron.hourly
chkCronhourly=$(stat /etc/cron.hourly |egrep -i "Access" |head -1)
checks "/etc/cron.hourly Access" "Access: (0700/drwx------)  Uid: (    0/    root)   Gid: (    0/    root)"  "${chkCronhourly}" "Run the following commands to set ownership and permissions on /etc/cron.hourly:\nchown root:root /etc/cron.hourly \nchmod og-rwx /etc/cron.hourly"

#Ensure permissions on /etc/cron.daily
chkCrondaily=$(stat /etc/cron.daily |egrep -i "Access" |head -1)
checks "/etc/cron.daily Access" "Access: (0700/drwx------)  Uid: (    0/    root)   Gid: (    0/    root)"  "${chkCrondaily}" "Run the following commands to set ownership and permissions on /etc/cron.daily:\nchown root:root /etc/cron.daily \nchmod og-rwx /etc/cron.daily"


#Ensure permissions on /etc/cron.weekly
chkCronweekly=$(stat /etc/cron.weekly |egrep -i "Access" |head -1)
checks "/etc/cron.weekly Access" "Access: (0700/drwx------)  Uid: (    0/    root)   Gid: (    0/    root)"  "${chkCronweekly}" "Run the following commands to set ownership and permissions on /etc/cron.weekly:\nchown root:root /etc/cron.weekly \nchmod og-rwx /etc/cron.weekly"

#Ensure permissions on /etc/cron.monthly
chkCronmonthly=$(stat /etc/cron.monthly |egrep -i "Access" |head -1)
checks "/etc/cron.monthly Access" "Access: (0700/drwx------)  Uid: (    0/    root)   Gid: (    0/    root)"  "${chkCronmonthly}" "Run the following commands to set ownership and permissions on /etc/cron.monthly:\nchown root:root /etc/cron.monthly \nchmod og-rwx /etc/cron.monthly"



#Ensure permissions on /etc/passwd
chkPasswd=$(stat /etc/passwd |egrep -i "Access" |head -1)
checks "/etc/passwd Access" "Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)"  "${chkPasswd}" "Run the following commands to set ownership and permissions on /etc/passwd:\nchown root:root /etc/passwd\nchmod 644 /etc/passwd"

#Ensure permissions on /etc/shadow
chkShadow=$(stat /etc/shadow |egrep -i "Access" |head -1)
checks "/etc/shadow Access" "Access: (0640/-rw-r-----)  Uid: (    0/    root)   Gid: (   42/  shadow)" "${chkShadow}" "Run the following commands to set ownership and permissions on /etc/shadow:\nchown root:shadow /etc/shadow\nchmod o-rwx,g-wx  /etc/shadow"

#Ensure permissions on /etc/group
chkGroup=$(stat /etc/group |egrep -i "Access" |head -1)
checks "/etc/group Access" "Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)"  "${chkGroup}" "Run the following commands to set ownership and permissions on /etc/group:\nchown root:root /etc/group\nchmod 644 /etc/group"

#Ensure permissions on /etc/gshadow
chkG=$(stat /etc/gshadow |egrep -i "Access" |head -1)
checks "/etc/gshadow Access" "Access: (0640/-rw-r-----)  Uid: (    0/    root)   Gid: (   42/  shadow)" "${chkG}" "Run the following commands to set ownership and permissions on /etc/gshadow:\nchown root:shadow /etc/gshadow\nchmod o-rwx,g-wx  /etc/gshadow"


#Ensure permissions on /etc/passwd-
chkPasswdD=$(stat /etc/passwd- |egrep -i "Access" |head -1)
checks "/etc/passwd- Access" "Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)"  "${chkPasswdD}" "Run the following commands to set ownership and permissions on /etc/passwd-:\nchown root:root /etc/passwd-\nchmod 644 /etc/passwd-"


#Ensure permissions on /etc/shadow-
chkShadowD=$(stat /etc/shadow- |egrep -i "Access" |head -1)
checks "/etc/shadow- Access" "Access: (0640/-rw-r-----)  Uid: (    0/    root)   Gid: (   42/  shadow)" "${chkShadowD}" "Run the following commands to set ownership and permissions on /etc/shadow-:\nchown root:shadow /etc/shadow-\nchmod o-rwx,g-wx  /etc/shadow-"



#Ensure permissions on /etc/group-
chkGroupD=$(stat /etc/group- |egrep -i "Access" |head -1)
checks "/etc/group- Access" "Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)"  "${chkGroupD}" "Run the following commands to set ownership and permissions on /etc/group-:\nchown root:root /etc/group-\nchmod 644 /etc/group-"



#Ensure permissions on /etc/gshadow-
chkGD=$(stat /etc/gshadow- |egrep -i "Access" |head -1)
checks "/etc/gshadow- Access" "Access: (0640/-rw-r-----)  Uid: (    0/    root)   Gid: (   42/  shadow)" "${chkGD}" "Run the following commands to set ownership and permissions on /etc/gshadow-:\nchown root:shadow /etc/gshadow-\nchmod o-rwx,g-wx  /etc/gshadow-"

#Ensure no legact "+" entries in /etc/passwd
chkPasswdP=$(sudo grep '^\+:' /etc/passwd)
checks "Legacy \+ entries in /etc/password policy" "" "${chkPasswdP}" "Remove any legacy \+ entries from /etc/passwd"

#Ensure no legact "+" entries in /etc/shadow
chkShadowP=$(sudo grep '^\+:' /etc/shadow)
checks "Legacy \+ entries in /etc/shadow policy" "" "${chkShadowP}" "Remove any legacy \+ entries from /etc/shadow"

#Ensure no legact "+" entries in /etc/group
chkGroupP=$(sudo grep '^\+:' /etc/group)
checks "Legacy \+ entries in /etc/group policy" "" "${chkGroupP}" "Remove any legacy \+ entries from /etc/group"


#Ensure root is the only UID 0 account
chkUID=$(grep '0:0' /etc/passwd)
checks "Root UID 0  policy" "root:x:0:0:root:/root:/usr/bin/zsh" "${chkUID}" "Remove any users that share a UID with root"


