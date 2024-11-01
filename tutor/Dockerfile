FROM openjdk:17-jdk
ARG JAR_FILE=build/libs/*.jar  # 실제 빌드 출력에 따라 이 경로를 조정

COPY ${JAR_FILE} app.jar
ENTRYPOINT ["java", "-jar", "/app.jar"]
