#!/bin/bash
iptables -F
setenforce 0
yum install -y gcc  pcre  pcre-devel  expat-devel   bzip2  openssl-devel   zlib*  libtool
cd /usr/local/src
wget https://downloads.apache.org/apr/apr-1.7.0.tar.gz
tar -xvf apr-1.7.0.tar.gz
cd apr-1.7.0
./configure  --prefix=/usr/local/apr
make && make install
cd ..
wget --no-check-certificate https://dlcdn.apache.org//apr/apr-util-1.6.1.tar.bz2
tar -xf apr-util-1.6.1.tar.bz2
cd apr-util-1.6.1
./configure --prefix=/usr/local/apr-util  --with-apr=/usr/local/apr
make && make install
cd ..
wget --no-check-certificate  https://dlcdn.apache.org/httpd/httpd-2.4.54.tar.bz2
tar -xf httpd-2.4.54.tar.bz2
cd httpd-2.4.54
./configure --prefix=/usr/local/apache24  --enable-so  --enable-ssl --enable-cgi --enable-rewrite --with-zlib --with-pcre --with-apr=/usr/local/apr --with-apr-util=/usr/local/apr-util --enable-modules=most --enable-mods-shared=most --enable-mpms-shared=all  --with-mpm=event
make && make install

#######################
#  apache启动命令
#  /usr/local/apache24/bin/apachectl
#  apache停止命令
#  /usr/local/apache24/bin/apachectl stop   停止
#  apache重新启动命令：
#  /usr/local/apache24/bin/apachectl restart 重启
#  要在重启 Apache 服务器时不中断当前的连接，则应运行：
#  /usr/local/sbin/apachectl graceful
#######################
/usr/local/apache24/bin/apachectl
/usr/local/apache24/bin/apachectl graceful
netstat -pantul | grep 80
echo "/usr/local/apache24/htdocs/index.html :"
ls /usr/local/apache24/htdocs
echo "index.html 页面内容:"
cat /usr/local/apache24/htdocs/index.html
echo "安装完成!可以进行测试了!"
