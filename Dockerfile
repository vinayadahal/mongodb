FROM mongo:latest
WORKDIR /data
COPY import-data.sh /data/
COPY data.json /data/
#RUN ["sh", "import-data.sh"]
VOLUME [ "/data/db" ]
EXPOSE 27017
CMD ["mongod"]
