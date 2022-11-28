#!/bin/bash
cat<<EOF
position截取备份>>1
时间截取备份>>    2
gtid截取备份>>    3
其他推出
EOF
read -p "请选择一种方式:" q
case $q in 
1)
echo "请输入起点和终点"
read -p "起点数:" sta
read -p "终点数:" s
read -p "要备份的binlog文件路径:" f
sta=$sta
s=$s
mysqlbinlog --start-position=$sta --stop-position=$s $f  > /tmp/pos.sql
if [ -s /tmp/pos.sql ];then
  echo "/tmp/pos.sql生成完毕"
else
  echo "error"
fi
;;
2)
echo "请输入起点和终点"
read -p "时间截取起点数:" sta
read -p "时间截取终点数:" s
read -p "要备份的binlog文件路径:" f
mysqlbinlog --start-datetime="$sta"  --stop-datetime="$s" $f  >/tmp/ti.sql
if [ -s /tmp/ti.sql ];then
  echo "/tmp/ti.sql生成完毕"
else
  echo "error"
fi
;;
3)
echo "请输入gtid范围:"
read -p "包含的:" sta
read -p "不包含的:" s
read -p "要备份的binlog文件路径:" f
if [ -z $s ];then
   s=""
else
  s="--include-gtids=4e85befa-1d2a-11ed-bd35-000c293f8970:$s"
fi
mysqlbinlog --include-gtids="4e85befa-1d2a-11ed-bd35-000c293f8970:$sta" $s  $f > /tmp/gt.sql
if  [  -s /tmp/gt.sql ] && [ $(echo $?)  -eq 0 ];then
  echo  "/tmp/gt.sql生成完毕"
else
  echo "error"
fi

;;
*)
  exit
;;
esac
