#!/bin/sh
INITALIZED="/.initialized"

if [ ! -f "$INITALIZED" ]; then
  echo "CONTAINER: starting initialisation"
  ##
  # LOG TO STDOUT
  ##
  sed -i -e 's|logtarget = /var/log/fail2ban.log|logtarget = /dev/stdout|' /etc/fail2ban/fail2ban.conf
  sed -i -e 's|loglevel = INFO|loglevel = 4|' /etc/fail2ban/fail2ban.conf
  ##
  # CLEAN OLD SERVICES
  ##
  rm /etc/fail2ban/jail.d/*
  ##
  # ENSURE RUN DIR EXISTS
  ##
  mkdir /var/run/fail2ban
  ##
  # ENABLE SERVICES
  ##
  for I_CONF in "$(env | grep '^ENABLE_SERVICE_')"
    do
    SERVICE_NAME=$(echo "$I_CONF" | cut -d'=' -f1 | sed 's/ENABLE_SERVICE_//g')
    SERVICE_LOGFILE=$(echo "$I_CONF" | sed 's/^[^=]*=//g')
    touch $SERVICE_LOGFILE
    echo "SERVICE: Enabling Service $SERVICE_NAME"
    echo [$SERVICE_NAME] >> /etc/fail2ban/jail.d/$SERVICE_NAME.conf
    echo enabled=true >> /etc/fail2ban/jail.d/$SERVICE_NAME.conf
    echo logpath=$SERVICE_LOGFILE >> /etc/fail2ban/jail.d/$SERVICE_NAME.conf
  done
  ##
  # ENABLE SERVICE OPTIONS
  ##
  for I_CONF in "$(env | grep '^ENABLE_OPTIONS_')"
    do
    SERVICE_NAME=$(echo "$I_CONF" | cut -d'=' -f1 | cut -d'_' -f3 | sed 's/ENABLE_OPTIONS_//g')
    OPTION_NAME=$(echo "$I_CONF" | cut -d'=' -f1 | cut -d'_' -f4 | sed 's/ENABLE_OPTIONS_//g')
    OPTION_VALUE=$(echo "$I_CONF" | sed 's/^[^=]*=//g')
    echo "OPTIONS: Setting $OPTION_NAME for $SERVICE_NAME" to $OPTION_VALUE
    echo $OPTION_NAME=$OPTION_VALUE >> /etc/fail2ban/jail.d/$SERVICE_NAME.conf
  done
  touch "$INITALIZED"
else
  echo ">> CONTAINER: already initialized - direct start of fail2ban"
fi
##
# CMD
##
cat /etc/fail2ban/fail2ban.conf
cat /etc/fail2ban/jail.d/*.conf
echo "CMD: exec docker CMD"
echo "$@"
exec "$@"
