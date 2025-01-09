![image](https://github.com/user-attachments/assets/2f4386d9-510d-4e95-aadf-469a2c14cfd0)

</a>

<br/>
<br/>

# 0. Getting Started (시작하기)
![mainPage](https://github.com/user-attachments/assets/af0edd54-5ba9-4a7f-83bc-f27bb8fb35a0)

[서비스 링크](http://professortoofast.store/)

<br/>
<br/>

# 1. Project Overview (프로젝트 개요)
- 프로젝트 이름: 강넘빨 (강사님 너무 빨라요)
- 프로젝트 설명: 수업에 대한 피드백 설문 조사 플랫폼
- 개발 기간 : 2024.12.27 ~ 2025.01.03

<br/>
<br/>

# 2. Team Members (팀원 및 팀 소개)
| 김수민 | 백인권 | 이지수 | 홍윤기 |
|:-------:|:------:|:------:|:------:|
| <img width="170" alt="나" src="https://github.com/user-attachments/assets/2f087063-8a03-454e-8b65-ba413022d92f" /> | <img width="200" alt="인권님" src="https://github.com/user-attachments/assets/19837119-69b3-4807-b2c9-1c3896231036" /> | <img width="180" alt="지수님" src="https://github.com/user-attachments/assets/9fbd75b2-6fe4-4b9f-b017-92458c0f160d" /> |<img width="160" alt="윤기님" src="https://github.com/user-attachments/assets/16820cc6-94e3-425e-92c9-e06095e9896d" />|
| REST 개발<br> UI 디자인/설문 폼 구현 | REST 개발<br> 통계 비즈니스 로직 구현 | REST 개발<br> 로그인/회원가입 구현 | 백앤드 총괄<br> 설계 및 인프라 구축 |
| [GitHub](https://github.com/Sumin0411) | [GitHub](https://github.com/BackInGone) | [GitHub](https://github.com/LJS-99) | [GitHub](https://github.com/dbsrl1026) |

<br/>
<br/>

# 3. Key Features (주요 기능)
- **회원가입**:
  - 회원가입 시 DB에 유저정보가 등록됩니다.

- **로그인**:
  - 사용자 인증 정보를 통해 로그인합니다.

수정중입니다.

<br/>
<br/>

# 4. Technology Stack (기술 스택)
## 4.1 Frontend
<img src="https://img.shields.io/badge/html5-E34F26?style=for-the-badge&logo=html5&logoColor=white"> <img src="https://img.shields.io/badge/css-1572B6?style=for-the-badge&logo=css3&logoColor=white"> <img src="https://img.shields.io/badge/javascript-F7DF1E?style=for-the-badge&logo=javascript&logoColor=black"> <img src="https://img.shields.io/badge/jquery-0769AD?style=for-the-badge&logo=jquery&logoColor=white">

<br/>

## 4.2 Backend
<img src="https://img.shields.io/badge/java-007396?style=for-the-badge&logo=java&logoColor=white"> <img src="https://img.shields.io/badge/docker-2496ED?style=for-the-badge&logo=docker&logoColor=white"> <img src="https://img.shields.io/badge/apache tomcat-F8DC75?style=for-the-badge&logo=apachetomcat&logoColor=white">

<br/>

## 4.3 Cooperation
<img src="https://img.shields.io/badge/github-181717?style=for-the-badge&logo=github&logoColor=white"> <img src="https://img.shields.io/badge/git-F05032?style=for-the-badge&logo=git&logoColor=white"> <img src="https://img.shields.io/badge/notion-000000?style=for-the-badge&logo=notion&logoColor=white"> <img src="https://img.shields.io/badge/slack-4A154B?style=for-the-badge&logo=slack&logoColor=white"> 
<br/>

# 5. Project Structure (프로젝트 구조)
```plaintext
project/
├─ Dockerfile
├─ bin
├─ build
├─ libs
└─ src
   └─ main
      ├─ java
      │  └─ com
      │     └─ ptf
      │        ├─ dao
      │        │  ├─ PTFUserDAO.java
      │        │  ├─ StatisticsDAO.java
      │        │  └─ SurveyDAO.java
      │        ├─ servlet
      │        │  ├─ CheckLoginIdServlet.java
      │        │  ├─ CheckNicknameServlet.java
      │        │  ├─ DailyStatisticsServlet.java
      │        │  ├─ LoginServlet.java
      │        │  ├─ LogoutServlet.java
      │        │  ├─ MarkedDatesServlet.java
      │        │  ├─ MonthlyStatisticsServlet.java
      │        │  ├─ MySurveyServlet.java
      │        │  ├─ PeriodStatisticsServlet.java
      │        │  ├─ SseServlet.java
      │        │  ├─ SurveyServlet.java
      │        │  ├─ UserMarkedDatesServlet.java
      │        │  ├─ UserServlet.java
      │        │  └─ redirect
      │        │     ├─ LoginPageServlet.java
      │        │     ├─ MainPageServlet.java
      │        │     ├─ MySurveyPageServlet.java
      │        │     ├─ NewSurveyPageServlet.java
      │        │     ├─ RegisterPageServlet.java
      │        │     └─ StatisticsPageServlet.java
      │        ├─ util
      │        │  ├─ AuthenticationUtil.java
      │        │  ├─ DBManager.java
      │        │  ├─ EncodingFilter.java
      │        │  ├─ IsSubmitScheduler.java
      │        │  ├─ OracleDBManager.java
      │        │  ├─ PasswordUtil.java
      │        │  ├─ PostgreDBManager.java
      │        │  ├─ SessionUtil.java
      │        │  └─ SessionValidationFilter.java
      │        └─ vo
      │           ├─ PTFUserVO.java
      │           ├─ StatisticsVO.java
      │           └─ SurveyVO.java
      └─ webapp
         ├─ META-INF
         │  └─ MANIFEST.MF
         ├─ WEB-INF
         │  └─ web.xml
         ├─ check_admin.jsp
         ├─ check_session.jsp
         ├─ check_user.jsp
         ├─ css
         │  ├─ login_register.css
         │  ├─ main_css.css
         │  ├─ my_survey_css.css
         │  ├─ statistics_admin.css
         │  └─ style.css
         ├─ images
         │  ├─ login_register.jpg
         │  ├─ toma.png
         │  ├─ tomaico.png
         │  └─ tomaico2.png
         ├─ login.jsp
         ├─ main.jsp
         ├─ my_survey.jsp
         ├─ register.jsp
         ├─ statistics_admin.jsp
         └─ survey.jsp
```

<br/>
<br/>

# 6. 세부 기능

수정중입니다.
