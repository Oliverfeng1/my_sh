#!/bin/bash

count=0
FLAG=0
removelist="cat ls which whereis locate top"

Usage(){
	echo "Help : hsave -d [date]"
	echo "       hsave -l daybefore"
	exit 1
}

RemoveHistory(){
	local item
	local check
	for item in $removelist;do
		check=$(echo $1 | sed -n '/^'"$item"'/p') #单引号包含双引号来引用变量
		if [ -n "$check" ];then
			return 1
		fi
	done	
	return 0
}

if [ -n $1 ];then
	case "$1" in
		-l) expr $2 + 0 &>/dev/null
		    if [ $? -ne 0 ];then
				Usage
		    fi
		    SaveDate=$(date -d "-$2 day" +%D)
		    fileEnd=$(date -d "-$2 day" +%y%m%d)
		    ;;
		-d) if [ -z $2 ];then
				SaveDate=$(date +%D)
				fileEnd=$(date +%y%m%d)
		    else
				SaveDate=$(date -d $2 +%D 2> /dev/null)
				if [ -z $SaveDate ];then
					echo "Please Check your arg!"
					exit 1
				fi
				fileEnd=$(date -d $2 +%y%m%d)
		    fi
		    ;;
		*) Usage
		   ;;
	esac
	
fi

my_file=~/.bash_history
historyDir=~/history/
historyfile=""$historyDir"history.$fileEnd"

if [ -d $historyDir ];then
	if [ -e $historyfile ];then
		rm -rf $historyfile
	fi
else
	mkdir $historyDir
fi

exec 0< ${my_file}
while read line
do
	str=`echo ${line}|sed -nr '/^#[0-9]{10}$/p'`
	if [ -n "${str}" ];then
		#find the time in the ~/.bash_history
		time=`echo "${line}" |sed 's/^#//'`
		#transform the num to the date
		date=`date -d "1970-01-01 UTC ${time} sec" "+%D "`
		if [ $FLAG -eq 0 ] && [ ${date} = ${SaveDate} ];then
			FLAG=1
		elif [ $count -gt 0 ] && [ ${date} != ${SaveDate} ];then
			FLAG=0
			break
		fi
	elif [ $FLAG -eq 1 ];then
		RemoveHistory ${line}
		if [ $? -eq 0 ];then
			((count++))
			SaveDateSYS=`date -d "1970-01-01 UTC ${time} sec" "+%T "`
			echo -e "${count}\t${SaveDateSYS}\t${line}" >> $historyfile
		fi
	fi	
done

if [ $count == 0 ];then
	echo "No history for the day $SaveDate"
else
	echo "$historyfile was saved."
fi
