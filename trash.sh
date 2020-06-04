#!/bin/bash
#回收站
alias rm='trash'
alias rl='trashlist'

LocalTrash="$HOME/.local/share/Trash/files"
trash()
{
    [ ! -d $LocalTrash ] && mkdir -p $LocalTrash
    mv --backup="numbered" $@ $LocalTrash
}
trashlist()
{
    echo -e "================= Garbage Lists in Trash ================="
    echo -e "================= $LocalTrash ================="
    echo -e "\a"
    echo -e "\aUse 'cleartrash' to clear all garbages in Trash!!!"
    ls -l $LocalTrash
}
#清空回收站
cleartrash()
{
    echo -ne "\aClear all garbages in Trash, Sure?"
    read confirm
    if [ $confirm == 'y' -o $confirm == 'Y' ] ;then
        /bin/rm -rf $LocalTrash/* &> /dev/null
        /bin/rm -rf $LocalTrash/.* &> /dev/null
    fi
}
