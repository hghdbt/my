#!/bin/bash
mysqlHost='localhost'   # mysql Host

mysqlPort=3306          # mysql端口

mysqlUser='root'        # mysql账号

mysqlPwd='123456'       # mysql密码

useDBName='dah'        # 测试表所在的库名

runBatch=24             # 循环次数 runBatch=20生成104万记录；23生成838万记录，24生成1677万记录，25生成3300万记录...

tableName='t'           # 测试表表名

sql="
  drop table if exists t;

  create database if not exists ${useDBName};

  # 建测试表

  CREATE TABLE ${tableName} (

    id int NOT NULL AUTO_INCREMENT PRIMARY KEY comment '自增主键', 

    dept tinyint not null comment '部门id',

    name varchar(30) comment '用户名称',

    create_time datetime not null comment '注册时间', 

    last_login_time datetime comment '最后登录时间'

  ) comment '测试表';

  #手工插入第一条测试数据，后面根据此行数据作为基础进行插入

  insert into ${tableName} values(1,1,'user_1', '2018-01-01 00:00:00', '2018-03-01 12:00:00');

"

echo "${sql}" | mysql -h${mysqlHost} -u${mysqlUser} -p${mysqlPwd} -P${mysqlPort} ${useDBName}

sql="set @i = 1;"

# 循环拼接SQL

for i in $(seq 1 ${runBatch}); do

  sql="${sql}

    insert into ${tableName}(id, dept, name, create_time, last_login_time) 

    select @i:=@i+1,

      left(rand()*10,1) as dept,

      concat('user_',@i), 

      date_add(create_time,interval +@i*cast(rand()*100 as signed) SECOND),

      date_add(date_add(create_time,interval +@i*cast(rand()*100 as signed) SECOND), interval + cast(rand()*1000000 as signed) SECOND) 

    from ${tableName};

    "

done

echo "${sql}" | mysql -h${mysqlHost} -u${mysqlUser} -p${mysqlPwd} -P${mysqlPort} ${useDBName}
