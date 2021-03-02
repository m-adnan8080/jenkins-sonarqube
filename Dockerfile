FROM openjdk

ADD ./target/myproject-0.0.1-SNAPSHOT.jar /myproject-0.0.1-SNAPSHOT.jar
ADD ./run.sh /run.sh

RUN chmod a+x /run.sh

EXPOSE 8000:8080

CMD /run.sh
