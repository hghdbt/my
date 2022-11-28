#coding:utf-8
import pika
cert = pika.PlainCredentials("oldliu","123456")
conn = pika.BlockingConnection(pika.ConnectionParameters("192.168.75.60",5672,'/',cert))
channel = conn.channel()
channel.queue_declare(queue="test")
def callback(ch,method,properties,body):
    print("[x] Received %r" % body)
channel.basic_consume('test',
                      callback,
                      auto_ack=False,
                      exclusive=False,
                      consumer_tag=None,
                      arguments=None
                      )
print(' [*] waitong for messages. To exit ctrl+c')
channel.start_consuming()
