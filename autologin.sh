#!/bin/bash
sshpass=`which sshpass`
ssh=`which ssh`
know_host_file="$HOME/.ssh/known_hosts"
conf_file="$HOME/.ssh/addssh"
local_download="$HOME/tftpboot"

listlogin(){

echo -e "name\t\tip\t\tusername\t\tdir\t\tpasswd"
if [ -e $conf_file ];then
    for line in `cat $conf_file`
    do
        local name=`echo $line|cut -d : -f 1`
        local ip=`echo $line|cut -d : -f 2`
        local username=`echo $line|cut -d : -f 3`
        local dir=`echo $line|cut -d : -f 4`
        local passwd=`echo $line|cut -d : -f 5`
        echo -e "$name\t\t$ip\t\t$username\t\t$dir\t\t$passwd"
    done
fi

}

autologin(){

if [ -z $1 ];then
    echo "autologin sshname"
    return 1
fi
local sshname=$1
local login_flag=0

if [ -e $conf_file ];then
    for line in `cat $conf_file`
    do
        local name=`echo $line|cut -d : -f 1`
        local ip=`echo $line|cut -d : -f 2`
        local username=`echo $line|cut -d : -f 3`
        local dir=`echo $line|cut -d : -f 4`
        local passwd=`echo $line|cut -d : -f 5`
        if [ $sshname == $name ];then
            login_flag=1
            $sshpass -p "$passwd" $ssh $username@$ip
            break
        fi
    done
fi

[ $login_flag == 0 ] && {
    echo "没有相关ssh记录"
    read -n1 -p "是否创建新的ssh记录[y/n]" answer 
    if [ "$answer" == "n" ] || [ "$answer" == "N" ];then
        exit 0
    else 
        echo ""
        ./addssh.sh 
    fi
}
}

cpf()
{
if [ $# != 2 ];then
    echo "cpf sshname remoteFileName"
    return 1
fi
local sshname=$1
local remoteFileName=$2
local login_flag=0

if [ -e $conf_file ];then
    for line in `cat $conf_file`
    do
        local name=`echo $line|cut -d : -f 1`
        local ip=`echo $line|cut -d : -f 2`
        local username=`echo $line|cut -d : -f 3`
        local dir=`echo $line|cut -d : -f 4`
        local passwd=`echo $line|cut -d : -f 5`
        if [ $sshname == $name ];then
            login_flag=1
            [ -d $local_download ] && mkdir -p $local_download
            $sshpass -p $passwd scp -r $username@$ip:$remoteFileName $local_download
            [ $? == 0 ] && echo "传送成功"
            break
        fi
    done
fi

[ $login_flag == 0 ] && {
    echo "没有相关ssh记录"
    return 1
}
} 

cpt(){
if [ $# != 2 ];then
    echo "cpf sshname localFileName"
    return 1
fi
local sshname=$1
local localFileName=$2
[ ! -e $localFileName ] && {
    echo "本地文件不存在"
    return 1
}
local login_flag=0

if [ -e $conf_file ];then
    for line in `cat $conf_file`
    do
        local name=`echo $line|cut -d : -f 1`
        local ip=`echo $line|cut -d : -f 2`
        local username=`echo $line|cut -d : -f 3`
        local dir=`echo $line|cut -d : -f 4`
        local passwd=`echo $line|cut -d : -f 5`
        if [ $sshname == $name ];then
            login_flag=1
            $sshpass -p $passwd scp -r $localFileName $username@$ip:$dir
            [ $? == 0 ] && echo "传送成功"
            break
        fi
    done
fi

[ $login_flag == 0 ] && {
    echo "没有相关ssh记录"
    return 1
}
} 

