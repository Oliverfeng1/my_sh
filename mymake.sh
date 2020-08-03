#!/bin/bash
mm()
{
    local compile_file=$*
    local name
    local end
    local item
    for item in ${compile_file};do
        name=$(echo ${item}|sed -n 's/\(.\)\..*/\1/p')
        end=$(echo ${item}|sed -n 's/.*\.\(.*\)/\1/p')
        if [ ${end} == "cpp" ] || [ ${end} == "cc" ];then
            local CPP=$(which g++)
            ${CPP} -o ${name} ${item}
        elif [ ${end} == "c" ];then
            local CC=$(which gcc)
            ${CC} -o ${name} ${item}
        elif [ ${end} == "java" ];then
            local JAVAC=$(which javac)
            local JAVA=$(which java)
            ${JAVAC} ${item}
            [ $? == 0 ] && ${JAVA} ${name}	
        elif [ ${end} == "py" ];then
            local PY=$(which python)
            ${PY} ${item}
        else
            echo "Unknown type "
            exit 1
        fi
    done
}
