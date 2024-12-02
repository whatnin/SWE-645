FROM openjdk:17-jdk
EXPOSE 8080
WORKDIR /app

# Specify the correct path to the JAR file
ARG JAR_FILE=swe-645/target/survey-0.0.1-SNAPSHOT.jar

# Copy the JAR file correctly
COPY ${JAR_FILE} survey-0.0.1-SNAPSHOT.jar

# Fix the ENTRYPOINT
ENTRYPOINT ["java", "-jar", "survey-0.0.1-SNAPSHOT.jar"]
