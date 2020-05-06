FROM cdh:1.2 as base

#init namenode directory
RUN mkdir -p /hdfs/nm

#format the namenode
RUN hdfs namenode -format

#setup supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

#expose namenode port
EXPOSE 8020

#define HDFS volume to enable to persist namenode fsimage between restart
VOLUME /hdfs

#start the supervisor
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
