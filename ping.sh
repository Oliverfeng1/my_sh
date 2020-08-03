#!/bin/sh
# 功能: ./ping.sh <index>
# 0 : ping大包
# 1 : 吞吐量

#设备名
devEth0="eth0"
devEth1="eth1"
devWifi="wlan0"
dev4G="wwan0"

choice=$1
option=$2

ping_usage()
{
    echo -e "\n\n/Usage:./ping.sh <index> <option>/\n"
    echo -e "\t<index>的取值如下：\n"
    echo -e "\t0：进行eth0的网络测试\n"
    echo -e "\t1: 进行eth1的网络测试\n"
    echo -e "\t2: 进行wifi的网络测试\n"
    echo -e "\t3: 进行4G模块的网络测试\n"
    echo -e "\t<option>的取值如下：\n"
    echo -e "\t0：进行吞吐量测试\n"
    echo -e "\t1: 进行ping大包测试\n"
}

net_dev_close()
{
    ifconfig $devEth0 down
    ifconfig $devEth1 down
    ifconfig $devWifi down
    ifconfig $dev4G down
}

net_dev_open()
{
    local devName=$1
    ifconfig $devName up
}

iperf_test()
{
    
}


if [ -z "$choice" ];then
    ping_usage
elif [ "$choice" == "0" ];then
    serial_test_all
elif [ "$choice" == "1" ];then
    serial_test_232
elif [ "$choice" == "2" ];then
    serial_test_uart2
elif [ "$choice" == "3" ];then
    serial_test_uart3
elif [ "$choice" == "4" ];then
    serial_test_uart4
else
    serial_usage
fi


