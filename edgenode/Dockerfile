FROM cdh:1.2 as base

#copy test data and script
COPY cities.* /

#create a staging disk to send/get data to/from the clusrer
RUN mkdir /staging

VOLUME /staging

CMD ["bash"]