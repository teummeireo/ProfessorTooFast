# 1. Base 이미지로 OpenJDK와 Tomcat 사용
FROM tomcat:9.0-jdk11

# 2. Tomcat의 기본 Webapps 경로 지정
WORKDIR /usr/local/tomcat/webapps/ROOT

# 3. JSP 및 정적 리소스 복사
COPY ./src/main/webapp/ ./  

# 4. 서블릿 및 클래스 파일 빌드 후 복사 (libs 및 Java 클래스 포함)
COPY ./libs/*.jar /usr/local/tomcat/lib/  
COPY ./build/classes/ /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/  

# 5. Tomcat 기본 포트 노출
EXPOSE 8080