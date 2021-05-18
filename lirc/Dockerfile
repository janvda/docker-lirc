FROM centos:centos8.3.2011

#RUN apk add --no-cache lirc ir_keytable

RUN yum install -y epel-release && yum install -y lirc-core nano

COPY Belgacom-BGC_TV_V4.lircd.conf /etc/lirc/lircd.conf.d/

ENTRYPOINT ["sleep", "36000"]