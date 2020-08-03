#!/bin/sh
# 脚本功能：./serial.sh <index>
# <index>说明如下：
# 0 : 进行所有串口测试，包括232/uart2/uart3/uart4
# 1 : 进行232测试
# 2 : 进行uart2测试
# 3 : 进行uart3测试
# 4 : 进行uart4测试
# ?/其他: 帮助提示

#设备列表
devRs232="/dev/ttyAMA5"
devUart2="/dev/ttyAMA2"
devUart3="/dev/ttyAMA3"
devUart4="/dev/ttyAMA4"

serial_test_all()
{
    ./serialItem.sh "$devRs232" &
    ./serialItem.sh "$devUart2" &
    ./serialItem.sh "$devUart3" &
    ./serialItem.sh "$devUart4" &
}

serial_test_232()
{
    ./serialItem.sh "$devRs232"
}

serial_test_uart2()
{
    ./serialItem.sh "$devUart2"
}

serial_test_uart3()
{
    ./serialItem.sh "$devUart3"
}

serial_test_uart4()
{
    ./serialItem.sh "$devUart4"
}

serial_usage()
{
    echo -e "\n\n/Usage:./serial.sh <index>/\n"
    echo -e "\t<index>的取值如下：\n"
    echo -e "\t0：进行所有串口测试，包括232/uart2/uart3/uart4\n"
    echo -e "\t1: 用于压力测试，进行232测试\n"
    echo -e "\t2: 用于压力测试，进行uart2测试\n"
    echo -e "\t3: 用于压力测试，进行uart3测试\n"
    echo -e "\t4: 用于压力测试，进行uart4测试\n"
}

choice=$1

if [ -z "$choice" ];then
    serial_usage
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

