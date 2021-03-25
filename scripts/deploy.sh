#!/bin/bash

REPOSITORY=/home/ec2-user/app/step2
PROJECT_NAME=boook_spring-boot-aws

echo "> Build 파일 복사"
cp $REPOSITORY/zip.*.jar $REPOSITORY/

echo "> 현재 구동 중인 애플리케이션 pid 확인"
CURRENT_PID=$(pgrep -fl spring-boot-aws  | grep jar | awk '{print $!}')
echo "> 현재 구동 중인 애플리케이션 pid : $CURRENT_PID"

if [ -z "$CURRENT_PID" ]; then
  echo "> Build 파일 복사"
else
  ehco "> kill -15 $CURRENT_PID"
  kill -15 $CURRENT_PID
  sleep5
fi

echo "> 새 애플리케이션 배포"
JAR_NAME=$(ls -tr $REPOSITORY/*.jar | tail -n 1)

echo "> JAR_NAME: $JAR_NAME"

echo "> $JAR_NAME 에 실행 권한추가"
chmod +x $JAR_NAME

echo "> $JAR_NAME 실행"

nohup java -jar \
    -Dspring.config.location=classpath:/application.properties,classpath:/application-real.properties,/home/ec2-uesr/app/application-oauth.properties,/home/ec2-uesr/app/application-real-db.properties \
    -Dspring.profiles.active=real \
    $JAR_NAME > $REPOSITORY/nohup.out 2>&1 &