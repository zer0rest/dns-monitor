# dns-monitor
A series of bash/python scripts I wrote to monitor changes in my domains and alert myself.

### dnserial.sh 
This script receives the (sub)domain you want to monitor as an argument and monitors for changes to it's SOA record's serial number. If it finds such changes it publishes a message including the previous and current serial number to a specified MQTT topic for notifiers to consume.
