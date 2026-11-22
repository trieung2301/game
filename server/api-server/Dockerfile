# Chạy từ thư mục gốc repo:  docker build -f server/api-server/Dockerfile -t ldk-api-server .
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /src
COPY proto ./proto
COPY server ./server
WORKDIR /src/server
RUN mvn -B -pl api-server -am package -DskipTests

FROM eclipse-temurin:21-jre
WORKDIR /app
COPY --from=build /src/server/api-server/target/api-server-*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
