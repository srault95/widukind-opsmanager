FROM debian:jessie

ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

RUN apt-get update \
	&& apt-get install -y curl net-tools supervisor netcat \
	&& curl -O https://downloads.mongodb.com/on-prem-mms/deb/mongodb-mms_2.0.3.343-1_x86_64.deb \
	&& dpkg -i mongodb-mms_2.0.3.343-1_x86_64.deb \
	&& rm -f mongodb-mms_2.0.3.343-1_x86_64.deb
	
#ADD conf/conf-mms.properties /opt/mongodb/mms/conf/

#/opt/mongodb/mms/mongodb-releases
#/opt/mongodb/mms/agent/automation
#/opt/mongodb/mms/agent/backup
#/opt/mongodb/mms/agent/monitoring

#VOLUME /opt/mongodb/mms/conf

#user mongodb-mms
VOLUME /opt/mongodb/mms/logs

#chmod 644 /etc/mongodb-mms/gen.key

RUN sed -i 's/127.0.0.1/appmongo/' /opt/mongodb/mms/conf/conf-mms.properties

EXPOSE 8080
EXPOSE 8081

#ENTRYPOINT ["/opt/mongodb/mms/bin/mongodb-mms"]
#CMD ["/opt/mongodb/mms/bin/mongodb-mms", "start"]

COPY supervisord.conf /etc/supervisor/conf.d/ops-manager.conf

COPY startup.sh /tmp/startup.sh
RUN chmod +x /tmp/startup.sh

CMD [ "/tmp/startup.sh" ]