#!/bin/bash

#get where the bypy install
bypy=$(which bypy)
# Directories you want to backup
back_dirs="/home/hjf/my_doc /home/hjf/my_sh /home/hjf/shell"
curl -l www.baidu.com 2> /dev/null
if [ $? != 0 ];then
    exit -1
fi
for dest_dir in $back_dirs
do
	remote_dir=${dest_dir##*/}
	echo "Backup directory: $dest_dir, please wait..."
	${bypy} mkdir $remote_dir
	${bypy} syncup $dest_dir $remote_dir
	echo "done!"
done

exit 0
