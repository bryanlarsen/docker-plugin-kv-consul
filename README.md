# KV_CONSUL plugin for docker-plugins

This is a plugin for [progrium/docker-plugins](https://github.com/progrium/docker-plugins) that sets consul keys when a docker container is started.

This plugin is very useful when used with [registrator](https://github.com/progrium/registrator) and [consul-template](https://github.com/hashicorp/consul-template) or similar tools.

## Installing

    docker run -it --rm \
       -e DEBUG=1 \
       -e "INSTALL=https://github.com/bryanlarsen/docker-consulkv-plugin" \
       -e "ENABLE=docker-consulkv-plugin" \
       -e "KV_CONSUL_IP=172.17.0.35" \
       --hostname="$(hostname)" \
       -v /var/run/docker.sock:/var/run/docker.sock \
       progrium/plugins

or

    docker run -it --rm \
       -e "KV_CONSUL_IP=172.17.0.35" \
       --hostname="$(hostname)" \
       -v /var/run/docker.sock:/var/run/docker.sock \
       bryanlarsen/docker-consulkv-plugin

## Configuring

- `KV_CONSUL_IP`: (default 127.0.0.1)
- `KV_CONSUL_PORT`: (default 8500)
- `KV_CONSUL_PREFIX`: (default "")  Sets the prefix or namespace for all keys.
- `KV_CONSUL_URL`: (default `http://${KV_CONSUL_IP}:${KV_CONSUL_PORT}/v1/kv/${KV_CONSUL_PREFIX}`)

## Usage

To use this plugin, set environment variables on your containers.  They may be either set in your Dockerfile or set during `docker run`.

### KV_SET:

Prefix the environment variable with "KV_SET:" to unconditionally set a key.

    docker run -e "KV_SET:foo=1" myapp

Sets a key called `foo` to `1`.

Add a "?" suffix to conditionally set the key.

    docker run -e "KV_SET:bar?=1" myapp

Sets a key called `bar` to `2`, unless `bar` already has a value in Consul.

### KV_SET:SERVICE:

Prefix the environment variable with "KV_SET:SERVICE:" to set a key scoped to the service.

    docker run -e "KV_SET:SERVICE:baz=3" myapp

Sets a key called something like `myapp/hostname:excited_euclid:80/baz` to `3`.  The first two path components of the key are the `service-id` and `service-name` as defined by [registrator](http://github.com/progrium/registrator).   They can be overridden by setting `SERVICE_NAME` and `SERVICE_ID`.

Conditionally setting is also supported.

    docker run -e "KV_SET:SERVICE:baz?=4" myapp

### KV_SET:SERVICE:<port>:

`KV_SET:SERVICE:` sets the key using the service-id of a random exposed port.   This is acceptable if you only have a single exposed port, but if you have more than one, use this form.

    docker run -e "KV_SET:SERVICE:80:bat=4" myapp

    docker run -e "KV_SET:SERVICE:80:baf?=5" myapp

### `SERVICE_NAME`, `SERVICE_<port>_NAME`, `SERVICE_ID`, `SERVICE_<port>_ID`

Sets service-id and service-name to more friendly values.  Used in a manner identical to that of [registrator](http://github.com/progrium/registrator).

## Using with consul-template

Due to [bug #64 in consul](https://github.com/hashicorp/consul-template/issues/64), using this plugin with services requires writing templates of templates.

FIXME: example

## Running the tests

This plugin includes unit tests.   To run them:

    ./start || echo 'tests failed'
