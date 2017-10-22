### Enable HTTP management console
```ssh
$> sudo rabbitmq-plugins enable rabbitmq_management
```
### Initial user creation , HTTP Access
Since 3.3.0. You can only login using guest/guest on localhost. For logging from other machines or on ip you'll have to create users and assign the permissions. This can be done as follows:

```sh
$> rabbitmqctl add_user gautam gautam
$> rabbitmqctl set_user_tags gautam administrator
$> rabbitmqctl set_permissions -p / gautam ".*" ".*" ".*"
```

### Create Vhosts
```sh
$> rabbitmqctl add_vhost events
$> rabbitmqctl add_vhost chat
$> rabbitmqctl list_vhosts
```
### User permissions for Vhosts
```sh
rabbitmqctl set_permissions -p chat gautam ".*" ".*" ".*"
```

## using http cli
### create exchange in default vhost
```sh
python rmqadmin.py declare exchange name=logs type=fanout
```

### create exchange in chat vhost
First give permissions to guest user and then create with cli
```sh
$> rabbitmqctl set_permissions -p chat guest ".*" ".*" ".*"  # OR
$> python rmqadmin.py declare permission vhost=chat user=guest configure=.* write=.* read=.*
$> python rmqadmin.py declare -V chat exchange name=logs type=fanout
$> ./rabbitmqadmin declare permission vhost=chatlogs user=jerry configure=".chat*" write="chat.*"" read="chat.*"
```

Delete an exchange
```sh
$> python rmqadmin.py -V chat delete exchange name=logs
```

### Administrating queues
create que
```sh
python rmqadmin.py declare queue name=logque  # creates in default vhost
python rmqadmin.py -V chat declare queue name=chatlogsque
```

delete que
```sh
$> python rmqadmin.py delete queue name=errorque
$> python rmqadmin.py -V chat delete queue name=chaterrorque
```

### Administrating bindings
Create a binding between an exchange and que
```sh
$> python rmqadmin.py declare binding source=logs destination=logque
$> python rmqadmin.py -V chat declare binding source=chatlogs destination=chatlogsque
```

Test the binding by publishing to the exchange
```sh
$> python rmqadmin.py publish exchange=logs routing_key= payload="new log message"
```

Get the message published
```sh
$> python rmqadmin.py -V chat get queue=chatlogsque
```

Purge messages in the queue
```sh
$> python rmqadmin.py -V chat purge queue name=chatlogsque
```

### Administrating policies
Set max capacity of queue to 200,000 bytes
```sh
$> python rmqadmin.py declare policy name=max-queue-len pattern=logque definition="{\"max-length-bytes\":200000}" apply-to=queues
```

Delete this policy
```sh
$> python rmqadmin.py delete policy name=max-queue-len
```

Set time limit for a message to stay in the queue
```sh
$> python rmqadmin.py declare policy name=ttl pattern=logque=.* definition="{\"message-ttl\":3000}" apply-to=queues
```

Set multiple rules in the policy
```sh
$> python rmqadmin.py -V chat declare policy name=api-policy pattern=.* definition="{\"max-length-bytes\":200000,\"message-ttl\":20000}" apply-to=queues
```

Set the dead letter exchange
```sh
$> python rmqadmin.py declare exchange name=logque_dlx type=fanout
$> python rmqadmin.py declare policy name=ttl patter=.* definition="{\"dead-letter-exchange\":\"logque_dlx\",\"message-ttl\":20000}" apply-to=queues
```

Testing dead-letter-exchange
```sh
$> python rmqadmin.py declare queue name=logque_dlx_que
$> python rmqadmin.py declare binding source=logque_dlx destination=logque_dlx_que
$> python rmqadmin.py declare policy name=ttl pattern=^logque$ definition="{\"dead-letter-exchange\":\"logque_dlx\",\"message-ttl\":20000}" apply-to=queues
```

Get messages from the dead letter que
```sh
$> python rmqadmin.py get queue=logque_dlx_que
```

Purge the que
```sh
$> python rmqadmin.py purge queue name=logque_dlx_que
```

### Administrating RMQ database
Backup and restore broker metadata
```sh
$> python rmqadmin.py export broker.json
$> python rmqadmin.py import broker.json
```

## Creating RabbitMQ cluster

* First start up two additional ec2 instances
* Install RabbitMQ
* From the main node copy /var/lib/rabbitmq/.erlang.cookie to other nodes
* Switch of the management console
```sh
$> rabbitmq-plugins disable rabbitmq_management
```
* To get cluster status
```sh
$> rabbitmqctl cluster_status
```
* On both the nodes run the command
```sh
$> service rabbitmq-server restart
$> rabbitmqctl stop_app
$> rabbitmqctl join_cluster rabbit@<hostname of master/node1>
$> rabbitmqctl start_app
```
* To ensure that the management console shows reports from other nodes install management agent
```sh
$> rabbitmq-plugins enable rabbitmq_management_agent
```

* Removing nodes from a cluster
First stop the app on the node you want to remove
```sh
$> rabbitmqctl stop_app
```

On the master node remove the node from cluster
```sh
$> rabbitmqctl forget_cluster_node rabbit@ip-172-31-44-229
```

### Observations
* Create que on any of the nodes
* Send message to any of the nodes
* Recieve messages from any of the nodes
* If que owner node is down then que is not available.
* Once node is up, que is available.

## High Availability
* Create a que on any one of the nodes
* Next declare it as HA and mirror it
```sh
$> rabbitmqctl set_policy ha-all "mirrored_que" "{\"ha-mode\":\"all\"}"
```

* To improve performance , set limited slave nodes. To limit the above que to only one other node
```sh
$> rabbitmqctl set_policy ha-exactly "mirrored_que" "{\"ha-mode\":\"exactly\", \"ha-params\":2, \"ha-sync-mode\":\"automatic\"}"  
```

* To specify an exact node
```sh
$> rabbitmqctl set_policy ha-by-name "mirrored_que" "{\"ha-mode\":\"nodes\", \"ha-params\":[\"rabbit@ip-172-31-44-229\",\"rabbit@ip-172-31-34-83\"], \"ha-sync-mode\":\"automatic\"}"
```

### Shovel plugin
On the one of the master nodes

```sh
$> rabbitmq-plugins enable rabbitmq_shovel
$> rabbitmq-plugins enable rabbitmq_shovel_management
```

Set que to exchange communication
```sh
$> rabbitmqctl set_parameter shovel api_shovel "{\"src-uri\":\"amqp://gautam:gautam@34.215.39.85:5672\",\"src-queue\":\"upstream_api_que\",\"dest-uri\":\"amqp://manohar:manohar@34.214.250.88:5672\",\"dest-exchange\":\"federated_api_exchange\"}"
```

Set que to que communication
```sh
$> rabbitmqctl set_parameter shovel test_shovel "{\"src-uri\":\"amqp://user:pass@34.215.39.85:5672\",\"src-queue\":\"upstream_que\",\"dest-uri\":\"amqp://user:pass@34.214.250.88:5672\",\"dest-queue\":\"federated_que\"}"
```

## Memory Usage and process limits
Default rabbitmq node uses 40% of physical ram. To change that edit config file or use rabbitmqctl
```sh
$> rabbitmqctl set_vm_memory_high_watermark 0.7
```

In config file edit the following :
```sh
{vm_memory_high_watermark, 0.4}
```

Before Rabbitmq hits the memory limit, [ paging ]

##HIPE compilation
On ubuntu
```sh
$> sudo apt install erlang-base-hipe
```
Add the following param to config file
```sh
$> {hipe_compile, true}
```



## RabbitMQ Security
Setting up SSL for communication

* Viewing traffic with wireshark. First capture the packets with TCP dump.
```sh
$> sudo tcpdump -i any -w ~/rabbit.cap -X -Z $USER "port 5672"
$> sudo tcpdump -i any -w ~/rabbit.cap -X -Z $USER "port 5671"
```


* Install wireshark on local
* Download the cap file to local and then view it through wireshark  
```sh
$> wireshark ./rabbit.cap
```
### Setting up SSL

```sh
$> mkdir ~/testca
$> cd testca
$> mkdir certs private
$> chmod 700 private
$> echo 01 > serial
$> touch index.txt
$> openssl req -x509 -config openssl.cnf -newkey rsa:2048 -days 365 -out cacert.pem -outform PEM -subj /CN=MyTestCA/ -nodes
$> openssl x509 -in cacert.pem -out cacert.cer -outform DER
$> cd ..
$> mkdir server
$> cd server
$> openssl genrsa -out key.pem 2048
$> openssl req -new -key key.pem -out req.pem -outform PEM -subj /CN=$(hostname)/O=server/ -nodes
$> cd ../testca
$> openssl ca -config openssl.cnf -in ../server/req.pem -out ../server/cert.pem -notext -batch -extensions server_ca_extensions
$> cd ../server
$> openssl pkcs12 -export -out keycert.p12 -in cert.pem -inkey key.pem -passout pass:password
$> cd ../
$> mkdir client
$> cd client
$> openssl genrsa -out key.pem 2048
$> openssl req -new -key key.pem -out req.pem -outform PEM -subj /CN=$(hostname)/O=client/ -nodes
$> cd ../testca
$> openssl ca -config openssl.cnf -in ../client/req.pem -out ../client/cert.pem -notext -batch -extensions client_ca_extensions
$> cd ../client
$> openssl pkcs12 -export -out keycert.p12 -in cert.pem -inkey key.pem -passout pass:password
```

Edit/Create the rabbitmq.config file /etc/rabbitmq/rabbitmq.config, fill in contents as seen here : /config/rabbitmq.config
```sh
$> service rabbitmq-server restart
```

To use HTTP API with ssl
```sh
$> python rmqadmin.py -k -s -H ip-172-31-36-98 -P 15671  -u gautam -p gautam list exchanges
```







### Ports
```sh
4369: epmd, a peer discovery service used by RabbitMQ nodes and CLI tools
5672, 5671: used by AMQP 0-9-1 and 1.0 clients without and with TLS
25672: used by Erlang distribution for inter-node and CLI tools communication and is allocated from a dynamic range (limited to a single port by default, computed as AMQP port + 20000). See networking guide for details.
15672: HTTP API clients and rabbitmqadmin (only if the management plugin is enabled)
61613, 61614: STOMP clients without and with TLS (only if the STOMP plugin is enabled)

1883, 8883: (MQTT clients without and with TLS, if the MQTT plugin is enabled
15674: STOMP-over-WebSockets clients (only if the Web STOMP plugin is enabled)
15675: MQTT-over-WebSockets clients (only if the Web MQTT plugin is enabled)
```

### Install Ruby
```sh
$> sudo apt install ruby
$> sudo gem install bunny --version ">= 2.6.4"
```
