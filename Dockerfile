# ---------- Etapa 1: compilar el proyecto con Maven ----------
FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
RUN mvn -q -B dependency:go-offline
COPY src ./src
RUN mvn -q -B -DskipTests package

# ---------- Etapa 2: correr el .war en Tomcat ----------
FROM tomcat:10.1-jdk17-temurin

# Quitar las aplicaciones de ejemplo y poner la nuestra en la raíz del sitio
RUN rm -rf /usr/local/tomcat/webapps/*
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

# Que Tomcat lea el puerto desde una propiedad (Render lo entrega en la variable PORT)
RUN sed -i 's/port="8080"/port="${http.port}"/' /usr/local/tomcat/conf/server.xml

# Memoria limitada para el plan gratis (512 MB)
ENV CATALINA_OPTS="-Xms64m -Xmx300m"

EXPOSE 8080
CMD ["sh", "-c", "export CATALINA_OPTS=\"$CATALINA_OPTS -Dhttp.port=${PORT:-8080}\" && exec catalina.sh run"]
