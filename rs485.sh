#!/bin/sh
# 脚本功能：./rs485.sh <index>
# <index>说明如下：
# 不带参数: 普通板测
# 0 : 压力测试客户端
# 1 : 压力测试服务端
# ?/其他: 帮助提示

# 切换延时
delaySeonds=1
#波特率与厂测配置文件一致
baudrate=115200

# RS485设备列表
boardRs485="/dev/ttyAMA9"
pcRs485="/dev/ttyUSB0"

#开始标记
startFlag="666666"
#接受数据
getFlag="0123456789"
#结束标记
stopFlag="444444"

rs485_usage()
{
    echo -e "\n\n/Usage:./rs485 <index>/\n"
    echo -e "\t<index>的取值如下：\n"
    echo -e "\t不带参数：默认进行QT产测\n"
    echo -e "\t0: 用于压力测试，在板子作为客户端\n"
    echo -e "\t1: 用于压力测试，在板子作为服务器端\n"
    exit 0
}

# 默认用ttyUSB0做接收
rs485_read()
{
    local devRs485=$1
    local data
    data=$(head -n 1 $devRs485)
    echo $data
}

rs485_write()
{
    local devRs485=$1
    local send_data=$2
    [ -e "$devRs485" ] &&  echo "$send_data" > "$devRs485"
}

rs485_test_on_board()
{
    local devRs485="$boardRs485"
    local count=0

    [ ! -e $devRs485 ] && {
        echo "不存在$devRs485"
        exit 1
    }
    echo "使用$devRs485"

    stty -F $devRs485 $baudrate
    rs485_write "$devRs485" "$startFlag"
    while true
    do
        data=`rs485_read $devRs485`
        if [ ! -z "$data" ] && [ "$data" == "$getFlag" ];then
            count=`expr $count + 1`
            echo "已经接收$count个数据"
        elif [ ! -z "$data" ] && [ "$data" == "$stopFlag" ];then
            echo "捕获到服务器程序退出，总共收到$count个数据"
            exit 0
        fi
    done
}

rs485_test_on_pc()
{
    local devRs485="$pcRs485"
    local count=0

    [ ! -e $devRs485 ] && {
        echo "不存在$devRs485"
        exit 1
    }
    echo "使用$devRs485"

    trap 'onCtrlC' INT
    function onCtrlC () {
        echo 'Ctrl+C is captured'
        echo "总共发送$count个数据"
        rs485_write "$devRs485" "$stopFlag"
        exit 0
    }

    stty -F $devRs485 $baudrate
    data=`rs485_read $devRs485`
    if [ ! -z "$data" ] && [ "$data" == "$startFlag" ];then
        while true
        do
            rs485_write "$devRs485" "$getFlag"
            count=`expr $count + 1`
            echo "已经发送$count个数据"
            sleep $delaySeonds
        done
    fi
}

rs485_test_just_send()
{
    local devRs485="$pcRs485"

    [ ! -e $devRs485 ] && {
        echo "不存在$devRs485"
        exit 1
    }
    echo "使用$devRs485"

    stty -F $devRs485 $baudrate
    while true
    do
        rs485_write "$devRs485" "$getFlag"
        sleep $delaySeonds
    done
}

choice=$1

if [ -z "$choice" ];then
    rs485_test_just_send
elif [ "$choice" == "0" ];then
    rs485_test_on_board
elif [ "$choice" == "1" ];then
    rs485_test_on_pc
else
    rs485_usage
fi

