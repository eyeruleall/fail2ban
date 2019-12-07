FROM ubuntu:latest

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y fail2ban

COPY ./scripts /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]
CMD [ "fail2ban-client", "start" ]
