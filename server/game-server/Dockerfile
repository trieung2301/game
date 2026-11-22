# Chạy từ thư mục gốc repo:  docker build -f server/game-server/Dockerfile -t ldk-game-server .
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /src
COPY proto ./proto
COPY server ./server
WORKDIR /src/server
RUN mvn -B -pl game-server -am package -DskipTests

FROM eclipse-temurin:21-jre
WORKDIR /app
COPY --from=build /src/server/game-server/target/game-server-*.jar app.jar
EXPOSE 7000
ENTRYPOINT ["java", "-jar", "app.jar"]
