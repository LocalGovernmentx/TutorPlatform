FROM openjdk:17-jdk
ARG JAR_FILE=build/libs/*.jar  # 실제 빌드 출력에 따라 이 경로를 조정

#ENV JAVA_OPTS=""
RUN mkdir -p /opt/scouter/conf
ENV SCOUTER_HOME /opt/scouter
COPY scouter-agent/scouter.agent.jar $SCOUTER_HOME/scouter.agent.jar
COPY scouter-agent/conf/scouter.conf/ $SCOUTER_HOME/conf/scouter.conf

ENV JAVA_OPTS="-javaagent:$SCOUTER_HOME/scouter.agent.jar"
ENV JAVA_OPTS="${JAVA_OPTS} -Dscouter.config=$SCOUTER_HOME/conf/scouter.conf

COPY ${JAR_FILE} app.jar
ENTRYPOINT ["java","$JAVA_OPTS", "-jar", "/app.jar"]
