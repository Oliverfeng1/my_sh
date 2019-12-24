#!/bin/bash
sshpass=`which sshpass`
ssh=`which ssh`
know_host_file="$HOME/.ssh/known_hosts"
conf_file="$HOME/.ssh/addssh"

echo -n "新建立的ssh的名称: "
read name
[ -z $name ] && {
    echo "name is not be empty"
    exit 1
}

#判断名字是否重复
if [ -e $conf_file ];then
    for line in `cat $conf_file`
    do
        temp_name=`echo $line|cut -d : -f 1`
        [ $temp_name == $name ] && {
            echo "name重复了"
            read -n1 -p "是否删除旧的ssh登录记录?[y/n]" answer
            echo ""
            if [ "$answer" == "n" ] || [ "$answer" == "N" ];then
                exit 0
            fi
            temp_conf_file=`cat $conf_file|grep -v "^$temp_name:"`
            echo $temp_conf_file > $conf_file
            break
        }
    done
fi

echo -n "IP: "
read ip
[ -z $ip ] && {
    echo "ip is not be empty"
    exit 1
}

echo -n "用户名: "
read username
[ -z $username ] && {
    echo "username is not be empty"
    exit 1
}

echo -n "密码: "
read passwd
[ -z $passwd ] && {
    echo "passwd is not be empty"
    exit 1
}

echo -n "传输路径: "
read dir
[ -z $dir ] && {
    echo "dir is not be empty"
    exit 1
}

#删除know_host文件对应的ip
if [ -e "$know_host_file" ];then
    new=`cat $know_host_file|grep -v "$ip"`
    echo $new > $know_host_file
fi

#把记录添加到配置文件中
[ ! -e "$conf_file" ] && touch $conf_file
echo $name:$ip:$username:$dir:$passwd >> $conf_file

#尝试成功登录一次
$ssh $username@$ip 

