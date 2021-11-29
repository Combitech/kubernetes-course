import pika
import os
import influxdb_client
from influxdb_client.client.write_api import SYNCHRONOUS

config_path = os.environ.get('CONFIG_PATH', '.')
config_file = os.environ.get('CONFIG_FILE', 'consumer.conf')

rabbitmq_username = os.environ['RABBITMQ_USERNAME']
rabbitmq_password = os.environ['RABBITMQ_PASSWORD']
rabbitmq_url = os.environ.get('RABBITMQ_URL', 'localhost')

influxdb_enable = (os.environ.get('INFLUXDB_ENABLE', 'false').lower() == 'true')
influxdb_token = os.environ.get('INFLUXDB_TOKEN', 'tokenStringForInfluxDB')
influxdb_url = os.environ.get('INFLUXDB_URL', 'localhost')

config={}
with open(f"{config_path}/{config_file}") as configFile:
    for line in configFile:
        key, value = line.rstrip().split('=')
        config[key] = value

channel = pika.BlockingConnection(pika.ConnectionParameters(host=rabbitmq_url, port=config['rabbitmq_port'], virtual_host=config['rabbitmq_vhost'], credentials=pika.PlainCredentials(rabbitmq_username, rabbitmq_password))).channel()
channel.queue_declare(queue=config['rabbitmq_queue'], durable=True)
channel.queue_bind(exchange=config['rabbitmq_exchange'], queue=config['rabbitmq_queue'], routing_key='')

if influxdb_enable:
    client = influxdb_client.InfluxDBClient(
        url=f'http://{influxdb_url}:{config["influxdb_port"]}',
        token=influxdb_token,
        org=config['influxdb_org']
    )
    write_api = client.write_api(write_options=SYNCHRONOUS)

def callback(ch, method, properties, body):
    print(f'Received: {body.decode("ascii")}')
    if influxdb_enable:
        p = influxdb_client.Point(config['rabbitmq_queue']).tag("place", "linköping").field("value", float(body)*10)
        write_api.write(bucket=config['influxdb_bucket'], org=config['influxdb_org'], record=p)

channel.basic_consume(queue=config['rabbitmq_queue'], on_message_callback=callback, auto_ack=True)

channel.start_consuming()
