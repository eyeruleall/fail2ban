# fail2ban
 Docker image for fail2ban

Pass in environment variables to monitor specific services. /etc/fail2ban/jail.d/<service-name>.conf will be created automatically.

    ENABLE_SERVICE_<service-name>=<log-file>

To enable specific options for an enabled service, use:

    ENABLE_OPTIONS_<service-name>_<key>=<value>

For example, to monitor asterisk:
    
    ENABLE_SERVICE_asterisk=/var/log/asterisk/messages
    ENABLE_OPTIONS_asterisk_bantime=1w

Make sure to pass in the log file for the service you are trying to monitor.
