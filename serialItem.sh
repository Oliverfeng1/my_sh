#!/bin/sh
# 延时
delaySeonds=1
#波特率与厂测配置文件一致
baudrate=115200
#写入的数据
writeData="0123456789ABCDEF"

serial_read()
{
    local devName=$1
    local data
    data=$(head -n 1 $devName)
    echo $data
}

serial_write()
{
    local devName=$1
    local send_data=$2
    [ -e "$devName" ] &&  echo "$send_data" > "$devName"
}

serial_test_item()
{
    local devName=$1
    local testCount=0
    local passCount=0
    if [ ! -e "$devName" ];then
        echo "不存在$devName"
        exit 1
    fi
    stty -F $devName $baudrate
    while true
    do
        testCount=`expr $testCount + 1`
        serial_write "$devName" "$writeData"
        local readData=`serial_read $devName`
        if [ ! -z "$readData" ] && [ "$readData" == "$writeData" ];then
            passCount=`expr $passCount + 1` 
        fi
    done
}

serial_test_item $1

