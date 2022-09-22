# Lightweight version of maven
FROM maven:3.8.6-eclipse-temurin-18-alpine AS maven_build
RUN apk add --no-cache git openssh 
# Git repo containing code
RUN git clone https://github.com/KarlesP/e-doctor-spring.git
RUN cd e-doctor-spring
# Build jar file with Maven
RUN mvn -f /e-doctor-spring/pom.xml clean package

# Build new jdk docker image and copy jar file from maven docker
FROM openjdk:18-slim
COPY --from=maven_build /e-doctor-spring/ /usr/local/lib/
# Run jar file using the port 8080
EXPOSE 8080
ENTRYPOINT ["java","-jar","/usr/local/lib/target/e-doctor-spring-0.0.1-SNAPSHOT.jar"]
