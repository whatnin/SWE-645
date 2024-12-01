FROM openjdk:17-jdk
EXPOSE 8080
WORKDIR /app
ARG JAR_FILE=target/survey-0.0.1-SNAPSHOT.jar
COPY ${JAR_FILE} /survey-app.jar
ENTRYPOINT ["java", "-jar", "/survey-app.syanama2/surveyform:latestjar"]