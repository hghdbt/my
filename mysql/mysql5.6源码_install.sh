#!/bin/bash
rpm -qa | grep -i mysql
yum  -y remove mysql80-community-release-el7-6.noarch
setenforce 0
mkdir -p /data/mysql/data
mkdir -p /data/mysql/tmp
mkdir -p /data/mysql/binlog
mkdir -p /data/mysql/logs
mkdir -p /data/boost
groupadd mysql
useradd mysql -s /sbin/nologin -M -g mysql
cd /data
wget https://mirrors.aliyun.com/mysql/MySQL-5.6/mysql-5.6.50.tar.gz
tar -xf mysql-5.6.50.tar.gz
yum -y install gcc gcc-c++ glibc automake autoconf libtool make openssl openssl-devel ncurses ncurses-devel cmake
cd /data/mysql-5.6.50/
rm -rf CMakeCache.txt
cmake \
    -DCMAKE_INSTALL_PREFIX=/data/mysql \
    -DMYSQL_DATADIR=/data/mysql/data \
    -DMYSQL_UNIX_ADDR=/data/mysql/tmp/mysql.sock \
    -DDEFAULT_CHARSET=utf8 \
    -DDEFAULT_COLLATION=utf8_general_ci \
    -DEXTRA_CHARSETS=all \
    -DENABLED_LOCAL_INFILE=1 \
    -DWITH_INNOBASE_STORAGE_ENGINE=1 \
    -DWITH_FEDERATED_STORAGE_ENGINE=1 \
    -DWITH_BLACKHOLE_STORAGE_ENGINE=1 \
    -DWITH_EXAMPLE_STORAGE_ENGINE=1 \
    -DWITH_PARTITION_STORAGE_ENGINE=1 \
    -DWITH_MYISAM_STORAGE_ENGINE=1 \
    -DWITH_ZLIB=bundled \
    -DWITH_EMBEDDED_SERVER=1 \
    -DSYSCONFDIR=/etc \
    -DMYSQL_TCP_PORT=3306 \
    -DWITH_SSL=yes \
    -DWITH_DEBUG=0 \
    -DDOWNLOAD_BOOST=1 
make install
echo 'export PATH=/data/mysql/bin:$PATH' >> /etc/profile
source /etc/profile
cat > /etc/my.cnf <<EOF
[client]
port = 3306
socket = /data/mysql/tmp/mysql.sock
default-character-set = utf8
[mysqld]
port = 3306
user = mysql
basedir = /data/mysql
datadir = /data/mysql/data
pid-file = /data/mysql/mysqld.pid
socket = /data/mysql/tmp/mysql.sock
tmpdir = /data/mysql/tmp
character_set_server = utf8
server-id = 1
max_connections = 100
max_connect_errors = 10
log-bin = /data/mysql/binlog/mysql-bin
log-error = /data/mysql/logs/mysql_5_7_24.err
EOF
chown mysql:mysql /etc/my.cnf
./bin/mysqld --initialize-insecure --user=mysql --basedir=/data/mysql --datadir=/data/mysql/data
cp /data/mysql/support-files/mysql.server /etc/init.d/mysqld
chmod 755 /etc/init.d/mysqld
/etc/init.d/mysqld start
