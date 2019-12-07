FROM ubuntu:latest

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y fail2ban

COPY ./scripts /usr/local/bin/

HEALTHCHECK CMD ["docker-healthcheck.sh"]
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["fail2ban-server", "-f", "-x", "-v"]
