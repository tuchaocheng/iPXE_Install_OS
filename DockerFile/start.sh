

# 提高文件描述符和进程数限制
ulimit -n 524288
ulimit -u 262144

pkill dhcpd  &>/dev/null
sleep 1
/usr/sbin/dhcpd -f -cf /etc/dhcp/dhcpd.conf -lf /var/run/dhcpd/dhcpd.leases &



pkill tftp &>/dev/null
sleep 1
#prlimit --pid $(pidof in.tftpd) --nofile=524288:524288
/usr/sbin/in.tftpd -L -s /var/lib/tftpboot   -vvv --blocksize 65464 -a :69 &


ps -ef |grep nginx |grep -v "grep" &&  /etc/nginx/sbin/nginx -s stop
sleep 1
/etc/nginx/sbin/nginx 
