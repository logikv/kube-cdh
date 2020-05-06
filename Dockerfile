FROM centos:7.7.1908

#FROM loicmathieu/cloudera-cdh
EXPOSE 5025 48869

RUN echo '192.168.1.42  quickstart.cloudera' >> /etc/hosts
## CDH REPO INSTALL
COPY ./dockerfiles/cloudera-cdh5.repo /etc/yum.repos.d/cloudera-cdh5.repo
RUN rpm --import https://archive.cloudera.com/cdh5/redhat/7/x86_64/cdh/RPM-GPG-KEY-cloudera
RUN yum install -y deltarpm \
    &&  yum update -y\
    && yum install -y \
    cpan \
    cpanminus \
    epel-release \
    freeipa-client \
    gcc \
    hive \
    hive-hbase \
    hive-metastore \
    hive-server2 \
    java-1.8.0-openjdk \
    krb5-libs \
    krb5-workstation \
    perl \
    sudo \
    vim \
    && yum clean all \
    && alternatives --auto java
ENV JAVA_HOME /usr/lib/jvm/jre

## perl depend
RUN mkdir -p /root/.cpan/CPAN/
COPY [ "dockerfiles/MyConfig.pm", "/root/.cpan/CPAN/"]
RUN cpan YAML Data::Dumper JSON

ENV JAVA_OPTS="-Xmx12g -XX:+UseG1GC -XX:G1ReservePercent=15 -Dlog4j.configurationFile=/opt/waggle-dance/conf/log4j2.xml -Dlogging.config=/opt/waggle-dance/conf/log4j2.xml -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5025"

## Hive info

## WAGGLE DANCE
COPY ./waggle-dance/target/waggle-dance-3.5.10-SNAPSHOT-bin.tgz /
RUN cd /opt/ \
    && tar -xvf /waggle-dance-3.5.10-SNAPSHOT-bin.tgz \
    && ln -s waggle-dance-3.5.10-SNAPSHOT waggle-dance \
    && rm -rf /waggle-dance-3.5.10-SNAPSHOT-bin.tgz

COPY ./dockerfiles/waggle-dance-federation.yml /opt/waggle-dance/conf/
COPY ./dockerfiles/waggle-dance-server.yml /opt/waggle-dance/conf/
RUN mkdir /opt/waggle-dance/logs \
    && touch /opt/waggle-dance/logs/waggle-dance.log \
    && rm -f /opt/waggle-dance/conf/*.template

COPY ["dockerfiles/hive.keytab", "/etc/hive.keytab"]
COPY dockerfiles/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN yum install -y supervisor  \
    && yum clean all \
    && /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf &

COPY [ "clusterAutoTest.pl", "/tmp/" ]
RUN chmod +x /tmp/clusterAutoTest.pl
CMD ["/usr/bin/bash"]
# CMD [ "/tmp/clusterAutoTest.pl"]

# hive --hiveconf hive.metastore.uris=thrift://localhost:48869
# tail -f /opt/waggle-dance/logs/waggle-dance.log
# docker cp clusterAutoTest.pl bva_wd://tmp/
# chmod +x /tmp/clusterAutoTest.pl && perl /tmp/clusterAutoTest.pl | less
# docker rm (docker stop  (docker ps -a --format "{{.ID}}"))