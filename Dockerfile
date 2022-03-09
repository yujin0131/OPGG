FROM openjdk:8-jdk-alpine AS builder
#RUN ./gradlew
COPY gradlew .
COPY gradle gradle
COPY build.gradle .
COPY settings.gradle .
COPY src src
RUN chmod +x ./gradlew
RUN ./gradlew bootJar

FROM openjdk:8-jdk-alpine
COPY --from=builder build/libs/*.jar app.jar

ARG ENVIRONMENT=prod
ENV SPRING_PROFILES_ACTIVE=${ENVIRONMENT}

EXPOSE 8080
ENTRYPOINT ["java","-jar","/app.jar"]

#RUN ./gradlew build
#ARG JAR_FILE=build/libs/*.jar
#COPY ${JAR_FILE} app.jar
#ENTRYPOINT ["java","${JAVA_OPTS}","-jar","/app.jar"]