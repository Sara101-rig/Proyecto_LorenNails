FROM eclipse-temurin:17-jdk-jammy

# Descargar e instalar Tomcat 10 (o ajusta la versión según tu proyecto, ej. Tomcat 9 para Java EE antiguo)
ENV CATALINA_HOME=/usr/local/tomcat
ENV PATH=$CATALINA_HOME/bin:$PATH

RUN mkdir -p "$CATALINA_HOME"
WORKDIR $CATALINA_HOME

# Instalar wget y descargar Tomcat 10.1 (compatible con Jakarta EE)
RUN apt-get update && apt-get install -y wget && \
    wget https://archive.apache.org/dist/tomcat/tomcat-10/v10.1.19/bin/apache-tomcat-10.1.19.tar.gz && \
    tar -xvf apache-tomcat-10.1.19.tar.gz --strip-components=1 && \
    rm apache-tomcat-10.1.19.tar.gz && \
    rm -rf webapps/*

# Copilar/Copiar tu archivo WAR renombrandolo a ROOT.war para que responda en la raíz del dominio
COPY lorenanils.war $CATALINA_HOME/webapps/ROOT.war

EXPOSE 8080

# Railway asigna un puerto dinámico mediante la variable $PORT, Tomcat necesita escuchar en ese puerto
CMD sed -i "s/port=\"8080\"/port=\"${PORT:-8080}\"/g" conf/server.xml && catalina.sh run