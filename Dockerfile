FROM openjdk:13-jdk-alpine AS builder

WORKDIR /app
ADD ./target/spring-boot-0.0.1-SNAPSHOT.jar /app/javaapp.jar

FROM openjdk:13-jdk-alpine

WORKDIR /app
COPY --from=builder /app/javaapp.jar /app/javaapp.jar

EXPOSE 8000:8080

ENTRYPOINT ["/opt/openjdk-13/bin/java", "-jar", "/app/javaapp.jar"]
CMD [""]
