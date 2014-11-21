# Docker ConsulKV Plugin

This is a plugin for [progrium/docker-plugins](https://github.com/progrium/docker-plugins) that sets consul keys when a docker container is started.

This plugin is very useful when used with [registrator](https://github.com/progrium/registrator) and [consul-template](https://github.com/hashicorp/consul-template) or similar tools.

## Installing

    docker run -it --rm \
       -e DEBUG=1 \
       -e "INSTALL=https://github.com/bryanlarsen/docker-consulkv-plugin" \
       -e "ENABLE=docker-consulkv-plugin" \
       -e "CONSUL_IP=172.17.0.35" \
       --hostname="$(hostname)" \
       -v /var/run/docker.sock:/var/run/docker.sock \
       progrium/plugins

or

    docker run -it --rm \
       -e "CONSUL_IP=172.17.0.35" \
       --hostname="$(hostname)" \
       -v /var/run/docker.sock:/var/run/docker.sock \
       bryanlarsen/docker-consulkv-plugin

## Configuring

- CONSUL_IP: (default 127.0.0.1)
- CONSUL_PORT: (default 8500)
- CONSUL_PREFIX: (default "")  Sets the prefix or namespace for all keys.
- CONSUL_URL: (default "http://${CONSUL_IP}:${CONSUL_PORT}/v1/kv/${CONSUL_PREFIX}")

## Usage

To use this plugin, set environment variables on your containers.  They may be either set in your Dockerfile or set during `docker run`.

### `KEY_`

Prefix the environment variable with "KEY_" to unconditionally set a key.

    docker run -e "KEY_foo=1" myapp

Sets a key called `foo` to `1`.

### `KEY_DEFAULT_`

Prefix the environment variable with "KEY_" to set a key only if it doesn't already exist in consul.

    docker run -e "KEY_DEFAULT_bar=2" myapp

Sets a key called `bar` to `2`, unless `bar` already has a value in Consul.

### `SERVICE_KEY_`

Prefix the environment variable with "SERVICE_KEY_" to set a key scoped to the service.

    docker run -e "SERVICE_KEY_baz=3" myapp

Sets a key called something like `myapp/hostname:excited_euclid:80/baz` to `4`.  The first two path components of the key are the `service-id` and `service-name` as defined by [registrator](http://github.com/progrium/registrator).   They can be overridden by setting `SERVICE_NAME` and `SERVICE_ID`

### `SERVICE_<port>_KEY_`

`SERVICE_KEY_` sets the key using the service-id of a random exposed port.   This is acceptable if you only have a single exposed port, but if you have more than one, use this form.

    docker run -e "SERVICE_80_KEY_bat=4" myapp

### `SERVICE_KEY_DEFAULT_` or `SERVICE_KEY_<port>_DEFAULT_`

As above, but only set the variable if they aren't already set.

### SERVICE_NAME, SERVICE_<port>_NAME, SERVICE_ID, SERVICE_<port>_ID

Sets service-id and service-name to more friendly values.  Used in a manner identical to that of [registrator](http://github.com/progrium/registrator).

## Using with consul-template

Due to [bug #64 in consul](https://github.com/hashicorp/consul-template/issues/64), using this plugin with services requires writing templates of templates.

FIXME: example

## Running the tests

This plugin includes unit tests.   To run them:

    ./start || echo 'tests failed'
