#coding:utf-8
import pika
cert = pika.PlainCredentials("oldliu","123456")
conn = pika.BlockingConnection(pika.ConnectionParameters("192.168.75.60",5672,'/',cert))
channel = conn.channel()
channel.queue_declare(queue="test")
for i in range(100000):
    num = "%s" % i
    channel.basic_publish(exchange="",
                          routing_key="test",
                          body="hello world num is %s" % num)
    print("消息%s写入成功" % i)
conn.close()
