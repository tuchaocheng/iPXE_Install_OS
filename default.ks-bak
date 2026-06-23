graphical   #图形界面

lang en_US.UTF-8
keyboard us
#root  password 
rootpw  123456

####防火墙设置
#firewall --service=ssh
firewall --disabled


selinux --disable
###时区设置
timezone Asia/Shanghai

eula --agreed
firstboot --disable

#ISO镜像的地址,需提前将镜像里面的所有目录复制到http服务页面下
#url写法规则：看当前目录是否有Packages,url路径写到Packages的上一级目录
url --url=http://local_ip/iso_path/
##repo --name="BaseOS" --baseurl=http://next_ip/sha256/BaseOS
##repo --name="AppStream" --baseurl=http://next_ip/sha256/AppStream





##---------------------------------------------------------------------------------------------------------
#################安装包设置1##############################
#packages configuration
%packages
@core
%end

#################安装包设置1##############################
##---------------------------------------------------------------------------------------------------------



##---------------------------------------------------------------------------------------------------------
##################安装包设置2[针对龙蜥等需要指定kernel]##############################
#%packages
#@core #dvd版本,镜像里面包含Appstream目录
###选择使用kernel-5.10选项
#kernel-5.10.134-16.2.an8.x86_64
#-kernel-4.18.0-513.18.1.0.1.an8.x86_64
#
##选择使用kernel-4.19选项
##kernel-4.19.0-477.15.5.el8.bclinux.x86_64
##-kernel-5.10.134-12.2.el8.bclinux.x86_64
#
##@^minimal-environment  #Minimal版本,镜像里面不包含Appstream目录,仅有BaseOS和Minimal目录
#%end
#################安装包设置2[针对龙蜥等需要指定kernel]##############################
##---------------------------------------------------------------------------------------------------------



reboot


##---------------------------------------------------------------------------------------------------------

#################分区方案1[自动分区,占满所有空间]################
%include /tmp/partation.ks
zerombr
autopart --type=plain
%pre
#You can set to sdb/sdc depends on some conditions if you want to install OS to sdb/sdc...
# 再写入配置（必须加双引号）
disk_short_name=sda
echo "bootloader --location=mbr --driveorder=$disk_short_name " >> /tmp/partation.ks
echo "ignoredisk --only-use=$disk_short_name"  >> /tmp/partation.ks
echo "clearpart --all --initlabel --drives=$disk_short_name"  >> /tmp/partation.ks
%end
#################分区方案1[自动分区,占满所有空间]end################

##---------------------------------------------------------------------------------------------------------




##---------------------------------------------------------------------------------------------------------

##################分区方案2[手动分区]################
## ***************************************************************************
#%include /tmp/part.ks
## 预脚本：查找 400-500G 磁盘的名称
## ==============================================
#%pre
##!/bin/bash
#TARGET_DISK=""
#for disk in /sys/block/sd* /sys/block/vd* /sys/block/nvme*n*; do
#  [ -e "$disk" ] || continue
#  sec=$(cat "$disk"/size)
#  gb=$((sec * 512 / 1024 / 1024 / 1024))
#  if [ $gb -ge 400 ] && [ $gb -le 500 ]; then
#    TARGET_DISK=$(basename "$disk")
#    break
#  fi
#done
##**************************************************
####自定义分区
## 把所有磁盘配置写入 part.ks，让安装器正确识别
#cat > /tmp/part.ks << EOF
##只在指定盘符上操作
#ignoredisk --only-use=$TARGET_DISK
#zerombr
##清空指定盘符的内容
#clearpart --all --initlabel --drives=$TARGET_DISK
#bootloader --append="console=tty0 console=ttyS0,115200" --location=mbr --boot-drive=$TARGET_DISK
#
#########以下是指定目录的手动分区，如没有相关需求，可删除
#########uefi必须
#part /boot/efi --fstype=efi --size=2048 --ondisk=$TARGET_DISK
#########非lvm 必须
#part /boot    --fstype=xfs --size=2048 --ondisk=$TARGET_DISK
###
#
#
######创建vg卷，名称为rootvg  指定大小400g,然后根据指定卷组创建目录
#part pv.01    --grow --size=1  --maxsize=409600   --ondisk=$TARGET_DISK
#volgroup rootvg pv.01
####/ 50G
#logvol /      --vgname=rootvg --fstype=xfs --name=root  --size=51200
####/home 20G
#logvol /home  --vgname=rootvg --fstype=xfs --name=home  --size=20480
####/usr 20G
#logvol /usr   --vgname=rootvg --fstype=xfs --name=usr   --size=20480
####/var 50G
#logvol /var   --vgname=rootvg --fstype=xfs --name=var   --size=51200
####swap 50G
#logvol swap   --vgname=rootvg --fstype=swap --name=swap --size=51200
#EOF
#
#
#%end
###########################################################################
#################分区方案2[手动分区]end################

##---------------------------------------------------------------------------------------------------------


##---------------------------------------------------------------------------------------------------------

#################分区方案3[手动分区]################
####找到指定盘符,只划分boot2g ,剩下全部给/
#%include /tmp/part.ks
## ***************************************************************************
## 预脚本：查找指定大小 400-500G 磁盘的名称
## ==============================================
#%pre
##!/bin/bash
#TARGET_DISK=""
#for disk in /sys/block/sd* /sys/block/vd* /sys/block/nvme*n*; do
#  [ -e "$disk" ] || continue
#  sec=$(cat "$disk"/size)
#  gb=$((sec * 512 / 1024 / 1024 / 1024))
#  if [ $gb -ge 400 ] && [ $gb -le 500 ]; then
#    TARGET_DISK=$(basename "$disk")
#    break
#  fi
#done
###**************************************************
####自定义分区
## 把所有磁盘配置写入 part.ks，让安装器正确识别
#cat > /tmp/part.ks << EOF
##只在指定盘符上操作
#ignoredisk --only-use=$TARGET_DISK
#zerombr
##清空指定盘符的内容
#clearpart --all --initlabel --drives=$TARGET_DISK
#bootloader  --location=mbr --boot-drive=$TARGET_DISK
###/boot/efi   1G
#part /boot/efi --fstype="efi" --size=1024 --ondisk=/dev/$TARGET_DISK
###/boot/   2G
#part /boot     --fstype="xfs" --size=2048 --ondisk=/dev/$TARGET_DISK
## 必须加这一行，否则安装器不知道根在哪里！
#part / --fstype="xfs" --grow --size=1 --ondisk=/dev/$TARGET_DISK
#EOF
#
#%end
#################分区方案3[手动分区]end################
##---------------------------------------------------------------------------------------------------------




#################下载脚本/[自定义项]################
####bash定制项，系统开机后使用自定义脚本安装服务
#%post --nochroot --interpreter=/bin/bash
## 1. 卸载不需要的 RPM
##/mnt/sysimage/usr/bin/rpm -e --nodeps vim 
## 2. 从文件服务器下载自定义脚本文件
#download_file_name=initEnv.sh
#download_to_os_file_name=initEnv.sh
##wget -q -O /mnt/sysimage/opt/$download_to_os_file_name  http://next_ip/$download_file_name
#wget -q -O /mnt/sysimage/opt/$download_to_os_file_name   http://next_ip/sha256/$download_file_name
##在自定义脚本的第一行加入删除license包
#sed -i 'N;2i\rpm -e bclinux-license-manager-4.0'  /mnt/sysimage/opt/$download_to_os_file_name
##在自定义脚本的最后一行加入删除开机启动的参数
#echo "sed  -i "/$download_to_os_file_name/d"  /etc/rc.d/rc.local"  >> /mnt/sysimage/opt/$download_to_os_file_name
## 3. 授权
#chmod +x /mnt/sysimage/opt/$download_to_os_file_name
#echo "/bin/bash  /opt/$download_to_os_file_name" >> /mnt/sysimage/etc/rc.d/rc.local 
#chmod +x /mnt/sysimage/etc/rc.d/rc.local
#%end


#################下载脚本[自定义项]################


