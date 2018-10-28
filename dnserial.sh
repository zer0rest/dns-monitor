#!/bin/bash

# Changing a line to test Github for Windows

#Script to check for changes in the domain's SOA record serial number.
#Receives the (sub)domain as argument when the script is called.

#Check if a (sub)domain has been passed as the first argument
#If that's the case, find its serial number and create a monitoring file.
DOMAIN=$1

if  [[ $1 ]]
then
	SERIAL=$(dig +short soa $DOMAIN | awk '{printf $3}')
	#Check if old SOA record exists, if it doesn't create it.
	if [ ! -e $DOMAIN.serial.txt ]
	then
		touch $DOMAIN.serial.txt
		echo "serial.txt didn't exist, created it."				#Since this is the first run, add the serial number to serial.txt
		echo $SERIAL > $DOMAIN.serial.txt
	fi
	#If no domain has been passed as an argument notify the user and exit.
else
	echo "No (sub)domain has been passed as an argument."
	exit
fi

OLDSERIAL=$(cat $DOMAIN.serial.txt)

#Check if the old serial number is not the same as the new serial number.
#If that's the case notify the user.

if [[ $SERIAL != $OLDSERIAL ]]
then
	#Since the serial number has changed, add the update serial number to serial.txt for
	#the next time the script runs.
	echo $SERIAL > $DOMAIN.serial.txt

	#Define the message to transmit when the serial number has changed.
	MESSAGE="According to dnserial.sh, the serial number for $DOMAIN has changed from $OLDSERIAL to $SERIAL"

	#Publish a notification to the specified mqtt channel.
	# $MQTT_SERVER_DOMAIN is an enviroment variable that stores the mqtt server domain/ip
	# $MQTT_TOPIC is an enviroment variable that stores the mqtt topic updates will be published to.
	mosquitto_pub -h "$MQTT_SRV" -t "$MQTT_TOPIC" -m "$MESSAGE"
fi
