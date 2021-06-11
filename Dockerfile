FROM openjdk-alphine AS builder

WORKDIR /app
ADD ./target/spring-boot-0.0.1-SNAPSHOT.jar /app/javaapp.jar

FROM scratch

WORKDIR /app
COPY --from=builder ./target/spring-boot-0.0.1-SNAPSHOT.jar /app/javaapp.jar

EXPOSE 8000:8080

ENTRYPOINT ["java", "-jar", "/app/javaapp.jar"]
CMD [""]
