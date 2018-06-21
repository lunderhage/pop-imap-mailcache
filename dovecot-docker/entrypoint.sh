#!/bin/sh

# We will want to generate keys on first start.

USERS_FILE=/etc/dovecot/users

if [ ! -s "$USERS_FILE" ]; then
	chown mailuser /mail -R
	if [ -z "$USER" ]; then
		echo "User must be set with USER variable."
		exit 1
	fi

	if [ -z "$PASSWORD" ]; then
		echo "Password must be set with PASSWORD variable."
		exit 1
	fi

	BCRYPT_PASS=$(doveadm pw -s BLF-CRYPT -p $PASSWORD)
	# echo "$USER:$BCRYPT_PASS:$MAIL_UID:$MAIL_GID::/mail/%u::userdb_mail=maildir:~/Maildir" > $USERS_FILE
	echo "$USER:$BCRYPT_PASS:$MAIL_UID:$MAIL_GID" > $USERS_FILE
fi


/usr/sbin/dovecot -F