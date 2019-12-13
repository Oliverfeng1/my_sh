#!/bin/bash
Student_file=student.txt
Student_score=0
exam_file=timu.txt
exam_num_list="1 3" #这里是考生的题目号
for exam_num in ${exam_num_list}
do
	answer_total=$(sed -n '/^'"$exam_num"',/{:start;n;s/^#\(.\)/\1/p;/^[0-9]/q;b start}' ${exam_file})
	IFS_OLD=$IFS
	IFS=$'\n'
	for line in $answer_total
	do
		score=$(echo ${line}|sed 's/.*:\([0-9]*$\)/\1/')
		answer_list=$(echo ${line}|sed 's/\(.*\):[0-9]*$/\1/')
		IFS=:
		pass_flag=1 
		for answer_item in ${answer_list}
		do
			ret=$(sed -n '/'"${answer_item}"'/p' ${Student_file})
			if [ -z ${ret} ];then
				pass_flag=0
				break
			fi
		done	
		if [ ${pass_flag} = 1 ];then
			Student_score=$[$Student_score+$score]
		fi

		IFS=$'\n'
	done
	IFS=${IFS_OLD}
done

echo ${Student_score}
