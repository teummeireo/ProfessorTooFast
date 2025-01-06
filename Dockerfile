# 1. Base 이미지로 OpenJDK와 Tomcat 사용
FROM tomcat:9.0-jdk11

# 2. Tomcat의 기본 Webapps 경로 지정
WORKDIR /usr/local/tomcat/webapps/ROOT

# 3. JSP 및 정적 리소스 복사 
COPY ./src/main/webapp/ ./  

# 4. 의존성 라이브러리 복사 
COPY ./libs/*.jar /usr/local/tomcat/lib/  

# 5. 서블릿 및 클래스 파일 빌드 후 복사
COPY ./build/classes/ /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/  

# 6. Tomcat 기본 포트 노출
EXPOSE 8080

# 7. mydb.properties 파일 생성 및 Tomcat 실행
CMD /bin/sh -c "echo 'postgre.url=${JDBC_URL}' > /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/mypostgre.properties && \
    echo 'postgre.id=${DB_USER}' >> /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/mypostgre.properties && \
    echo 'postgre.pw=${DB_PASSWORD}' >> /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/mypostgre.properties && \
    catalina.sh run"
