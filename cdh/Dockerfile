FROM loicmathieu/openjdk

ENV CDH_VER 5.14.4

#copy cloudera CDH repo
COPY cloudera-cdh.repo /etc/yum.repos.d
#Install epel repo because supervisor isn't in the base repo
RUN rpm --import https://archive.cloudera.com/cdh5/redhat/7/x86_64/cdh/RPM-GPG-KEY-cloudera \
    && yum -y install deltarpm \
    && yum -y update \
    && yum -y install epel-release \
    && rm -rf /var/cache/yum/*

RUN yum -y install hadoop  &&  rm -rf /var/cache/yum/*

RUN yum -y install supervisor  \
    krb5-server \
    openldap-clients \
    krb5-workstation \
    unzip \
    wget \
    pig \
    hive \
    flume-ng \
    sqoop2 \
    spark-worker \
    hadoop-hdfs-namenode \
    vim \
    &&  rm -rf /var/cache/yum/*

COPY config/* /usr/lib/hadoop/etc/hadoop/

#set HADOOP_* environement variables
ENV HADOOP_HOME /usr/lib/hadoop
ENV HADOOP_CONF_DIR /etc/hadoop/conf
ENV HADOOP_COMMON_HOME /usr/lib/hadoop
ENV HADOOP_HDFS_HOME /usr/lib/hadoop-hdfs
ENV HADOOP_YARN_HOME /usr/lib/hadoop-yarn
ENV HADOOP_MAPRED_HOME /usr/lib/hadoop-mapreduce
ENV KRB5CCNAME FILE:/tmp/tgt
COPY jce_policy-8.zip /
RUN unzip jce_policy-8.zip
RUN cp /UnlimitedJCEPolicyJDK8/local_policy.jar /usr/lib/jvm/java-1.8.0-openjdk/jre/lib/security/local_policy.jar \
   && cp /UnlimitedJCEPolicyJDK8/US_export_policy.jar /usr/lib/jvm/java-1.8.0-openjdk/jre/lib/security/US_export_policy.jar

COPY krb5.conf /etc/krb5.conf

LABEL cdh.version="0.0.1-beta"


RUN yum install -y \
    perl \
    cpan \
    cpanminus \
    && rm -rf /var/cache/yum/*
RUN mkdir -p /root/.cpan/CPAN/
COPY MyConfig.pm /root/.cpan/CPAN/

RUN cpan install CPAN CPAN::DistnameInfo YAML Data::Dumper JSON \
    && cpan reload CPAN
RUN cpan Net::OpenSSH
RUN cpan Net::Ping
RUN cpan Devel::Camelcadedb
RUN yum install -y gcc
RUN cpan Hash::StoredIterator JSON::XS PadWalker
RUN cpan Log::Log4perl IO::Pty
COPY keytab_teleporter/main.pl /main.pl

CMD ["hadoop", "version"]