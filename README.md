# dns-monitor
A series of bash/python scripts I wrote to monitor changes in my domains and alert myself.

### dnserial.sh
This script receives the (sub)domain you want to monitor as an argument and monitors for changes to it's SOA record's serial number. If it finds such changes it publishes a message including the previous and current serial number to a specified MQTT topic for notifiers to consume.

Before running the script make sure to set the `$MQTT_SRV` and `$MQTT_TOPIC` enviroment variables. To do that run in a terminal:

    export $MQTT_SRV=<server-domain-here>
    export $MQTT_TOPIC=<mqtt-topic-here>

To run the script periodically, which is it's intended purpose add the following string in your users' crontab and have it run every e.g. 5 minutes.

``*/5 * * * * <PATH-TO-SCRIPT>/dnserial.sh <DOMAIN-HERE>``
