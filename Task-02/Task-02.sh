#!/usr/bin/env  bash

root_check(){

if [ "$(id -u)" == "0" ]
then 
	echo "You are root"
else
	echo "You're not root"
fi
}

change_port(){

echo "enter new port"
read New_Port

sed -i 's/^#Port 22/Port $New_Port/g' /etc/ssh/sshd_config
systemctl restart sshd.service
echo "we've changed to port number $New_Port"
}

disable_root_login(){
sed -i 's/^PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
systemctl restart sshd.service
echo "done disabling root login"
}

adding_user(){
echo "Enter New User Name"
read New_User

usesradd $New_User

echo "Add the user to sudoers ?:[y/n]"
read y_n
if [ "$y_n" == "y" ]
then

echo "$New_User  ALL=(ALL)       ALL"  >> visudo
echo "$New_User has been added to sudoers"

else
        echo "$New_User is a normal user"
fi
}

home_backup(){
	
	if [ $CHECK == "Sudoer" ];then
		echo "* * * * *  tar -cf homeback.tar $HOME " >> "/var/spool/cron/${USER}"
	else
		echo "you're not a sudoer"
	fi
	echo "backup has been done successfully"
}
