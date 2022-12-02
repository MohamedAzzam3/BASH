#!/usr/bin/bash

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

update_firewall_selinux(){
		semanage port -a -t ssh_port_t -p tcp $1
		echo "selinux is updated to port $1"
		firewall-cmd --zone=public --add-port=$1/tcp --permanent
		sudo systemctl reload firewalld.service
        	echo "firewall is updated to port $1"
}

update_system(){
        	yum -y update
        	echo "The system is updated suceccfuly"
}

EPEL_repo(){
        	sudo yum -y install epel-release
        	echo "Epel repo is enabled!"
}

fail2ban(){
     		yum -y install "fail2ban"
	   	systemctl enable "fail2ban"
		systemctl start "fail2ban"
}

adding_user(){

        	password=$(openssl passwd -1 -stdin <<< $2)
        	useradd $1 -p $password -g Audit
		echo "$1 user is sucessfuly added"
}

add_newgroup () {
		sudo groupadd -g 20000 Audit
		echo "Audit group was added successfully"
}

adduser_manager () { 
		sudo useradd manager -u 30000
		echo " manager user added"
}

creating_reports(){
    		mkdir -p ~/reports 
        	touch ~/reports/2021{1..12}{1..31}.xls
    		echo "Reports Created successfully..."
    		chmod 660 ~/reports/*
}


backup_reports(){
		mkdir -p ~/backups
		echo "00 1 * * 1-4 tar -czf ~/backups/reports-$(date +%U)-$(date +%w).tar.gz ~/reports" > " ~/repbackup.txt"
		crontab "~/repbackup.txt"

}
