FROM openjdk:8-jdk-alpine
WORKDIR /app
COPY target/spring-boot-rest-example-0.5.0.war /app
EXPOSE 8091
ENTRYPOINT ["java", "-Dspring.profiles.active=test","-jar","spring-boot-rest-example-0.5.0.war"]
