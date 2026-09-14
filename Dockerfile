FROM eclipse-temurin:17-jdk-jammy

ENV CATALINA_HOME=/usr/local/tomcat
ENV PATH=$CATALINA_HOME/bin:$PATH

RUN mkdir -p "$CATALINA_HOME"
WORKDIR $CATALINA_HOME

RUN apt-get update && apt-get install -y wget && \
    wget https://archive.apache.org/dist/tomcat/tomcat-10/v10.1.19/bin/apache-tomcat-10.1.19.tar.gz && \
    tar -xvf apache-tomcat-10.1.19.tar.gz --strip-components=1 && \
    rm apache-tomcat-10.1.19.tar.gz && \
    rm -rf webapps/*

# AQUÍ ESTÁ EL TRUCO: Cambiar "lorenanils.war" por "ROOT.war"
COPY lorenanils.war $CATALINA_HOME/webapps/ROOT.war

EXPOSE 8080

CMD sed -i "s/port=\"8080\"/port=\"${PORT:-8080}\"/g" conf/server.xml && catalina.sh run