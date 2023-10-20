#!/bin/bash

dbnametopass=0
for i in $*; do	
    #echo item: $i
	if [ $i = "-db" ]; then		
		dbnametopass=1
		#echo dbnametopass: $dbnametopass	
	elif [ $dbnametopass = 1 ]; then
		dbname=$i
		#echo database name: $dbname
		break
	else		
		continue		
	fi	
done 

if [ -n "$dbname" ]; then
	filelist=$(blastdb_path -db $dbname -dbtype nucl -getvolumespath 2>/dev/null)
	if [ $? = 0 ]; then	
		#echo $filelist	
		parallel vmtouch -tqm 5G ::: $filelist &	
	fi	
fi
blastn.REAL "$@"
