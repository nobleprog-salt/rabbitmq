### rabbitmqctl
Useful commands

```sh
$> rabbitmqctl status
$> rabbitmqctl cluster_status
$> rabbitmqctl eval 'mnesia:system_info(tables).'  # List all mnesia tables used in the server.
$> rabbitmqctl list_vhosts
$> rabbitmqctl list_queues
$> rabbitmqctl report
$> rabbitmqctl list_queues -p <vhost> # List queues in a vhost
```

### rabbitmqadmin
```sh
$> wget http://localhost:15672/cli/rabbitmqadmin
$> chmod +x rabbitmqadmin
$> ./rabbitmqadmin list users
$> ./rabbitmqadmin list vhosts
$> ./rabbitmqadmin list connections
$> ./rabbitmqadmin list exchanges
$> ./rabbitmqadmin list bindings
$> ./rabbitmqadmin list permissions
$> ./rabbitmqadmin list channels
$> ./rabbitmqadmin list parameters
$> ./rabbitmqadmin list consumers
$> ./rabbitmqadmin list queues
$> ./rabbitmqadmin list policies
$> ./rabbitmqadmin list nodes
$> ./rabbitmqadmin show overview
```

### Create user with specific permissions
```sh
$> ./rabbitmqadmin declare user name=tom password=tom tags=administrator
$> ./rabbitmqadmin declare permission vhost=/ user= configure=.* write=.* read=.*
```

### Configurations

```sh
$> rabbitmqctl status | grep -A 4 file_descriptors # check file_descriptors used by rabbitmq default
$> rabbitmqctl eval 'file_handle_cache:set_limit(10000).'  # increase the limit
$> rabbitmqctl change_cluster_node_type ram  # Convert disk node to RAM node
```
