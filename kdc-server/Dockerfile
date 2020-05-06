FROM alpine
LABEL kdc.version="0.0.1-beta"
RUN apk add --no-cache krb5-server vim bash krb5 supervisor tini
ADD supervisord.conf /etc/supervisord.conf
ADD docker-entrypoint.sh /
EXPOSE 749 464 88
ENV KRB5_REALM CLOUDERA
ENV KRB5_KDC kdc-server
ENV KRB5_PASS 123123123
ENV KRB5CCNAME FILE:/tmp/tgt
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/docker-entrypoint.sh"]
