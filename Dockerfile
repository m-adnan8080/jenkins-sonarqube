FROM maven:3.6.3-openjdk-11 AS builder

WORKDIR /app
COPY . /app
RUN /usr/bin/mvn package

FROM openjdk:13-jdk-alpine

WORKDIR /app
COPY --from=builder /app/target/*.jar /app/javaapp.jar

EXPOSE 8080

ENTRYPOINT ["/opt/openjdk-13/bin/java", "-jar", "/app/javaapp.jar"]
CMD [""]
