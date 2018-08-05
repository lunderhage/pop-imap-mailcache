#!/bin/bash
set -e
# We will want to generate keys on first start.

DOVECOT_INITIALIZED=/etc/dovecot/dovecot.initialized
USERS_FILE=/etc/dovecot/users
DH_PEM=/etc/ssl/dovecot/dh.pem
DOVECOT_SSL_CONFIG=/etc/dovecot/dovecot-openssl.cnf
DOVECOT_SSL_PARAMETERS="IMAP_SSL_BITS IMAP_SSL_OU IMAP_SSL_CN"
ALL_PARAMS="IMAP_USER IMAP_PASSWORD $DOVECOT_SSL_PARAMETERS"
SSL_CERT=/etc/ssl/dovecot/server.pem
SSL_KEY=/etc/ssl/dovecot/server.key

# Check variables
for PARAMETER in $ALL_PARAMS; do
	if [ -z "${!PARAMETER}" ]; then
		echo $PARAMETER is not set.
		exit 1
	fi
done		

if [ ! -e $DOVECOT_INITIALIZED ]; then

	cp /etc/dovecot/dovecot-openssl.cnf.template /etc/dovecot/dovecot-openssl.cnf
	for PARAMETER in $DOVECOT_SSL_PARAMETERS; do
		sed -i 's/${'${PARAMETER}'}/'"${!PARAMETER}"'/g' $DOVECOT_SSL_CONFIG
	done

	openssl gendh $IMAP_SSL_DH_BITS > /etc/ssl/dovecot/dh.pem
	openssl req -new -x509 -nodes -config $DOVECOT_SSL_CONFIG -out $SSL_CERT -keyout $SSL_KEY -days 3650
	chmod 0600 $SSL_KEY
	openssl x509 -subject -fingerprint -noout -in $SSL_CERT
	mkdir -p /usr/local/share/ca-certificates
	ln -s $SSL_CERT /usr/local/share/ca-certificates/server.pem
	update-ca-certificates

	chown mailuser /mail -R

	BCRYPT_PASS=$(doveadm pw -s BLF-CRYPT -p $IMAP_PASSWORD)
	# echo "$USER:$BCRYPT_PASS:$MAIL_UID:$MAIL_GID::/mail/%u::userdb_mail=maildir:~/Maildir" > $USERS_FILE
	echo "$IMAP_USER:$BCRYPT_PASS:$MAIL_UID:$MAIL_GID" > $USERS_FILE

	touch $DOVECOT_INITIALIZED
fi

/usr/sbin/dovecot -F