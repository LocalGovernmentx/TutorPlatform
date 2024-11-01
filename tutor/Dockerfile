FROM openjdk:17-jdk

# APM 에이전트 다운로드 및 추가
ENV ELASTIC_APM_AGENT_VERSION=1.29.0
RUN curl -L -o /elastic-apm-agent.jar https://repo1.maven.org/maven2/co/elastic/apm/elastic-apm-agent/${ELASTIC_APM_AGENT_VERSION}/elastic-apm-agent-${ELASTIC_APM_AGENT_VERSION}.jar

# JAR 파일 복사
ARG JAR_FILE=build/libs/*.jar  # 실제 빌드 출력에 따라 이 경로를 조정
COPY ${JAR_FILE} app.jar

# APM 환경 변수 설정
ENV JAVA_TOOL_OPTIONS="-javaagent:/elastic-apm-agent.jar \
                       -Delastic.apm.server_urls=http://apm-server:8200 \
                       -Delastic.apm.service_name=modu-tutor-service \
                       -Delastic.apm.application_packages=com.sm.tutor"

# 애플리케이션 실행
ENTRYPOINT ["java", "-jar", "/app.jar"]
