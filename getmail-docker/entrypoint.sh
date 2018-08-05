#!/bin/bash
set -e

GETMAIL_CONFIG_PARAMS="POP_SERVER POP_USER POP_PASSWORD POP_MAILBOX"
ALL_PARAMS="POP_INTERVAL $GETMAIL_CONFIG_PARAMS"

# Check variables
for PARAMETER in $ALL_PARAMS; do
	if [ -z "${!PARAMETER}" ]; then
		echo $PARAMETER is not set.
		exit 1
	fi
done		

# Create mail folders
mkdir -p /mail/getmail /mail/$POP_MAILBOX/cur /mail/$POP_MAILBOX/tmp /mail/$POP_MAILBOX/new

# Create config file
if [ ! -e /mail/getmail/getmail.conf ]; then
	
	cp $GETMAIL_CFG_TEMPLATE $GETMAIL_CFG

	for PARAMETER in $GETMAIL_CONFIG_PARAMS; do
		sed -i 's/${'${PARAMETER}'}/'${!PARAMETER}'/g' $GETMAIL_CFG
	done
 
fi

# Run endless loop
while true; do
	/opt/getmail-5.6/getmail --getmaildir /mail/getmail --rcfile getmail.conf
	echo "Waiting for ${POP_INTERVAL}s"
	sleep $POP_INTERVAL
done
