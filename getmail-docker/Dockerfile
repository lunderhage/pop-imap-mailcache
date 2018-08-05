FROM alpine:3.8

ENV MAIL_UID=1000 \
	MAIL_GID=1000 \
	GETMAIL_CFG_TEMPLATE=/opt/getmail-5.6/getmail.conf \
	GETMAIL_CFG=/mail/getmail/getmail.conf

RUN wget http://pyropus.ca/software/getmail/old-versions/getmail-5.6.tar.gz -O /tmp/getmail.tar.gz && \
	apk update && apk add python busybox-initscripts bash && \
	mkdir -p /opt /mail && \
	tar -xvf /tmp/getmail.tar.gz -C /opt && \
	adduser -S -u $MAIL_UID -g $MAIL_GID mailuser && \
	chown mailuser /mail -R

ADD getmail.conf /opt/getmail-5.6
ADD entrypoint.sh /usr/bin

USER mailuser

CMD /usr/bin/entrypoint.sh