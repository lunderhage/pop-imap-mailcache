FROM alpine:3.7

RUN apk update && apk add dovecot

ENV MAIL_UID=1000 \
	MAIL_GID=1000

RUN adduser -S -u $MAIL_UID -g $MAIL_GID mailuser

ADD cfg/dovecot.conf /etc/dovecot

ADD entrypoint.sh /bin/

EXPOSE 143 993

VOLUME /home /mail

ENTRYPOINT /bin/entrypoint.sh