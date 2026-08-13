# Stage 1: Build the Maven project
FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Run Tomcat
FROM tomcat:10.1-jdk17
COPY --from=build /app/target/foodwastefighter.war /usr/local/tomcat/webapps/foodwastefighter.war
EXPOSE 8080
CMD ["catalina.sh", "run"]
