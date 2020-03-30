#!/bin/bash
mtags()
{
    for i in $(ls /home/hjf/.cache/tags/)
    do
        read -n1 -p "是否删除$i : " answer
        echo 
        if [ $answer == "y" ] || [ $answer == "Y" ];then
            rm /home/hjf/.cache/tags/$i
        fi
    done
}
