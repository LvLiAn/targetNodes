#!/bin/bash
#批量添加sftp用户
#注：一般批量创建用户名密码时，用户名密码会在windows下创建，传上linux服务器，这样会因为换行符原因没导致创建的用户，密码无效
# 解决办法，dos2unix namelist(文件名)   将文件转化下
while read line
do
#按行取第一列 第二列数据 
name=`echo $line |awk '{print $1}'`
password=`echo $line |awk '{print $2}'`

#新增用户并建目录，只能sftp登录
useradd -m -d /psb/nas/$name -s /sbin/nologin $name
#修改用户到sftpusers用户组
usermod -G sftpusers $name
#更改目录所属用户，用户组
chown root:root /psb/nas/$name
mkdir /psb/nas/$name/file
chmod 777 /psb/nas/$name/file
#设置用户密码
echo $password |passwd  --stdin $name 2>&1 >/dev/null
# echo $name:$password|chpasswd 
if [ $? -eq 0 ]
then
echo "$name create successfully!"
else 
echo "$name create failed!!!!!!!!!!!!!!!!"
fi
fi
# 循环读取namelist文件
done<namelist
