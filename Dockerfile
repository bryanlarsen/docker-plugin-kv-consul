FROM progrium/plugins
MAINTAINER Bryan Larsen "bryan@larsen.st"

COPY start /plugins/available/docker-consulkv-plugin/
COPY plugin.toml /plugins/available/docker-consulkv-plugin/

ENV DOCKER_RUN_OPTIONS -e KV_CONSUL_IP=consul.service.consul -v /var/run/docker.sock:/var/run/docker.sock

ENV ENABLE docker-consulkv-plugin
