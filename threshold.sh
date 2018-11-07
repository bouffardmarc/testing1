#!/bin/bash

loadinfo="$(cat /proc/loadavg|awk '{print $1}')";
free_mem=$(echo "scale=2;var=$(free -g|grep Mem|awk '{print $3}');var/=132;var*=100;var" | bc);
free_mem_size=$(echo "scale=2;var=$(free -g|grep Mem|awk '{print $3}');var" | bc);

free_mem_limit=60.00;

if (( $(echo "$free_mem > $free_mem_limit" |bc -l) )); then \
	mail -s "PAMINA: memory usage is larger than $free_mem_limit%" \
 	bouffard.marc@gmail.com<<< \
	"Memory usage is: $free_mem % / $free_mem_size GB (Memory limit is 132GB)";
fi;


load_limit=25;

if [ ${loadinfo%.*} -gt $load_limit ]; then

	mail -s "PAMINA: the load is larger than $load_limit" bouffard.marc@gmail.com<<<"The load is: ${loadinfo%.*} (maximum load: 40)";
fi;
