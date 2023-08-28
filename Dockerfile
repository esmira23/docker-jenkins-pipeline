FROM maven:3.8.4-openjdk-11 AS maven_build
WORKDIR /app  
COPY src /app/src
COPY pom.xml /app
RUN mvn clean package

FROM tomcat:9.0.48-jdk11-openjdk
COPY --from=maven_build /app/target/finalProjectMFW.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8080
CMD ["catalina.sh", "run"]
