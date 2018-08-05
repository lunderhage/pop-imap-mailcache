FROM alpine:3.8

RUN apk update && apk add dovecot ca-certificates bash

ENV MAIL_UID=1000 \
	MAIL_GID=1000

RUN adduser -S -u $MAIL_UID -g $MAIL_GID mailuser

ADD cfg/*.c*nf* /etc/dovecot/

ADD entrypoint.sh /bin/

EXPOSE 143 993

RUN mkdir /mail && chown mailuser /mail
RUN rm /etc/ssl/dovecot/server.*

ENTRYPOINT /bin/entrypoint.sh