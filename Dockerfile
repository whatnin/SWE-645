FROM tomcat:9.0

WORKDIR /usr/local/tomcat/webapps/

COPY survey.html /usr/local/tomcat/webapps/ROOT/

EXPOSE 8080

CMD ["catalina.sh", "run"]