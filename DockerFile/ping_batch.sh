#!/bin/bash

#本次脚本使用的是fping命令
#功能：1 批量ping多个ip 2 ping当前网段ip使用情况(192.168.1.1/24)
#命令行：
# fping -a -g 192.168.2.1/24  ## ping当前网段可用IP
# fping -g 192.168.1.1  192.168.5.1  ## ping当前两个网段之间可用IP


read_yum(){
  if ! which fping &>/dev/null  ;then
  ([ -f fping-*.rpm ] &&  rpm -ivh fping-*.rpm --force --nodeps ) || \
  yum -y install fping 
  fi
}

HELP(){
  file_name=$basename
  [ ! -z $basename ] || file_name="file_name"
  echo -e "\e[42m"
cat <<EOF
  usage: 
  
  example1:
  #ping当前一个网段，多少IP占用和多少IP未使用(必须在IP后加'/24')
  $file_name 192.168.1.1/24
  
  example2: 
  #ping两个网段之间，多少IP占用和多少IP未使用(不可以在IP后加'/24')
  $file_name  192.168.1.1  192.168.2.1 

  #或使用安装的fping命令自行测试ping(which fping)
EOF
  echo -e "\e[0m"
}

FPING_a(){
  fping -a -q -g  -p 1000    $ip1
}
FPING_g(){
  fping -a -q -g  -p 1000 $ip1 $ip2
}



case $1 in
help|-help|--help|'')
     HELP ;;

*[a-z]*|*[A-Z]*|'~'*|*'`'*|*"'"*|*'"'*|*';'*|*':'*|*','*|*'<'*|*'>'*|*'!'*|*'@'*|*'#'*|*'$'*|*'%'*|*'^'*|*'&'*|*'*'*|*'('*|*')'*|*'-'*|*'+'*|*'='*|*'?'*)
    
     echo -e "\e[41m Nonstandard input \e[0m" ;;

*.*.*.*)
     #echo $1 $2
     if [ -z $2 ] && echo $1 |grep -E  '/24|/16|/8|/32'; then 
       ip1=$1
       FPING_a 
     elif [ ! -z $2 ] &&  echo $1 |grep -vE  '/24|/16|/8|/32|/'  &&  echo $2 |grep -vE  '/24|/16|/8|/32|/' ; then
       ip1=$1
       ip2=$2
       FPING_g
     else
       HELP
     fi  
#     FPING ;; 
esac








