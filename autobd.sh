#!/bin/bash

#get where the bypy install
bypy=$(which bypy)
if [ $? != 0 ] && exit 1
# Directories you want to backup
back_dirs="/home/hjf/my_doc /home/hjf/my_sh /home/hjf/XMIND"
curl -l www.baidu.com &> /dev/null
[ $? != 0 ] && exit -1
for dest_dir in $back_dirs
do
	remote_dir=${dest_dir##*/}
	echo "Backup directory: $dest_dir, please wait..."
	${bypy} mkdir $remote_dir
	${bypy} syncup $dest_dir $remote_dir
	echo "done!"
done

exit 0
