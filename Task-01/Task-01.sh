#!/usr/bin/env  bash

D=$(date +%d)
M=$(date +%m)
Y=$(date +%Y)

if [ ! -d "Reports" ];
then
	echo "Reports Directory does not exist."
	echo "Creating Reports Dir"
	mkdir  ~/Reports
else
	echo "Reports Directory exists."
fi

for i in {1..12};
do
	mkdir -p ~/Reports/$Y/$i
done

if [ ! -f ~/Reprots/$Y/$M/$D.xls ]
then
	touch ~/Reports/$Y/$M/$D.xls
fi

if [ -f  "Reports$(date +%Y-%m-%d).tar" ]
then
	echo "Your Reports is backedup"
else
	mkdir ~/Backup
	tar -cf Reports$(date +%Y-%m-%d).tar ./*
	mv Reports$(date +%Y-%m-%d).tar ~/Backup
	echo "Backup files has been created"
fi
