FROM progrium/plugins
MAINTAINER Bryan Larsen "bryan@larsen.st"

COPY start /plugins/available/docker-consulkv-plugin/
COPY plugin.toml /plugins/available/docker-consulkv-plugin/

ENV ENABLE docker-consulkv-plugin
