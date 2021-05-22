FROM centos:centos8.3.2011

#RUN apk add --no-cache lirc ir_keytable

RUN yum install -y epel-release && yum install -y lirc-core nano

COPY Belgacom-BGC_TV_V4.lircd.conf /etc/lirc/lircd.conf.d/

COPY start.sh  /root/start.sh
RUN  chmod a+x /root/start.sh

#ENTRYPOINT ["sleep", "36000"]

ENTRYPOINT [ "/root/start.sh" ]