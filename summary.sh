#!/bin/bash

IFS=
echo "************General stats**************************" >out.txt
echo "Pamina: "$(uptime)>>out.txt
echo "Rusalka: "$(ssh -f rusalka uptime) >>out.txt
echo "Opus: "$(ssh -f opus uptime) >>out.txt
echo "Pamina: Memory stats" >> out.txt
echo $(free -h)>>out.txt

echo "************Sockets********************************" >>out.txt
echo $(ss |head -1) >>out.txt
echo $(ss -a |grep *:ssh) >>out.txt
echo $(ss |grep iscsi) >>out.txt
echo $(ss |grep nfs) >>out.txt

echo "************Filesystem Usage***********************" >>out.txt

filesystem=("/home")

df -h |head -1>>out.txt
for i in "${filesystem[@]}"
do
	echo $(df -h |grep $i) >> out.txt
done

echo $(df -h /|tail -1) >>out.txt

echo "************Opus Backup****************************" >>out.txt

opus_log_path="/home/lad/opus/logs_pamina/logs/"
tail -25 $opus_log_path/$(ls $opus_log_path -lt|head -2|tail -1|awk '{print $NF}')>>out.txt

echo "************SGE summary****************************" >>out.txt

echo $(qstat -f) >>out.txt

echo "***************************************************" >>out.txt
echo  $(cat out.txt)
mail -s "PAMINA/RUSALKA stats" bouffard.marc@gmail.com<<<$(cat out.txt);

rm out.txt
