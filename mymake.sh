#!/bin/bash
CC=$(which gcc)
CPP=$(which g++)
JAVAC=$(which javac)
JAVA=$(which java)
PY=$(which python)
compile_file=$*
for item in ${compile_file};do
    name=$(echo ${item}|sed -n 's/\(.\)\..*/\1/p')
    end=$(echo ${item}|sed -n 's/.*\.\(.*\)/\1/p')
    if [ ${end} == "cpp" ] || [ ${end} == "cc" ];then
        ${CPP} -o ${name} ${item}
    elif [ ${end} == "c" ];then
        ${CC} -o ${name} ${item}
    elif [ ${end} == "java" ];then
        ${JAVAC} ${item}
	[ $? == 0 ] && ${JAVA} ${name}	
    elif [ ${end} == "py" ];then
	${PY} ${item}
    else
        echo "Unknown type "
        exit 1
    fi
done
