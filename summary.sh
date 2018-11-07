#!/bin/bash

IFS=
echo "************General Stats**************************" >out.txt
echo "UPTIME:" >> out.txt
echo "Pamina: "$(uptime)>>out.txt
echo "Rusalka: "$(ssh rusalka uptime) >>out.txt
echo "Opus: "$(ssh opus uptime) >>out.txt

printf "\n" >>out.txt

echo "MEMORY:" >> out.txt
echo "Memory stats Available / Used swap" >> out.txt
echo "Pamina: "$(free -h|grep "Mem"|awk '{print $7}')" /" $(free -h|grep "Swap"|awk '{print $3}')>>out.txt
ssh rusalka free -h >tmp.txt
echo "Rusalka: "$(cat tmp.txt|grep "Mem"|awk '{print $7}')" /" $(cat tmp.txt|grep "Swap"|awk '{print $3}')>>out.txt

rm tmp.txt

printf "\n" >>out.txt

echo "************Sockets********************************" >>out.txt

printf "\n" >>out.txt

echo $(ss |head -1) >>out.txt
echo $(ss -a |grep *:ssh) >>out.txt
echo $(ss |grep iscsi) >>out.txt
echo $(ss |grep nfs) >>out.txt

printf "\n" >>out.txt

echo "************Filesystem Usage***********************" >>out.txt

printf "\n" >>out.txt

filesystem=("/home")

df -h |head -1>>out.txt
for i in "${filesystem[@]}"
do
	echo $(df -h |grep $i) >> out.txt
done

echo $(df -h /|tail -1) >>out.txt

printf "\n" >>out.txt

echo "************Opus Backup****************************" >>out.txt

printf "\n" >>out.txt

opus_log_path="/home/lad/opus/logs_pamina/logs/"
tail -20 $opus_log_path/$(ls $opus_log_path -lt|head -2|tail -1|awk '{print $NF}')>>out.txt

printf "\n" >>out.txt

echo "************SGE summary****************************" >>out.txt

printf "\n" >>out.txt

echo $(qstat -f) >>out.txt

printf "\n" >>out.txt

echo "***************************************************" >>out.txt
echo  $(cat out.txt)

mail -s "PAMINA/RUSALKA stats" bouffard.marc@gmail.com<<<$(cat out.txt);

rm out.txt
