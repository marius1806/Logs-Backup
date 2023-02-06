#! /bin/bash

cd /var/log
rawDates=$(ls -lt --time-style=long-iso *.log | awk '{print $6}')
rawDatesArray=(${rawDates})
copy=0
for i in "${rawDatesArray[@]}"; do
	files=$(ls -lt --time-style=long-iso *.log | grep "$i" | awk '{print $8}')
	date=$(echo "$i" | sed -n 's/-//pg')
	if [ "$date" != "$copy" ]; then
	        sudo tar -cvz -f archive-"$date".tar.gz $files
	        echo "Backup created for log files created on $i!"
	fi
	copy=$date
	if [ "$date" != "$(date +%Y%m%d)" ]; then
		filesArray=(${files})
		for j in "${filesArray[@]}"; do
			sudo rm "$j"
		done
	fi
done
