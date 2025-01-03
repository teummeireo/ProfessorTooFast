<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>내 설문 조회</title>
<link rel="icon" type="image/png" href="${pageContext.request.contextPath}/images/tomaico2.png">
<link href="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.8/index.global.min.css" rel="stylesheet">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/my_survey_css.css"> <!-- 스타일 경로 -->
    

</head>
<body>
	<jsp:include page = "${pageContext.request.contextPath}/check_session.jsp" />
	<jsp:include page = "${pageContext.request.contextPath}/check_user.jsp" />
	<button class="custom-button">Logout</button>
    <div id="calendar"></div>

    <div id="selected-dates" class="dates-container">
        <div class="date-box">
            <span class="date-label">선택된 날짜:</span>
            <span id="start-date">없음</span>
        </div>
    </div>

    <div id="survey-modal" class="modal">
        <div class="modal-content">
            <span class="close-button" onclick="closeModal('survey-modal')">&times;</span>
            <h2>선택된 날짜 설문 결과</h2>
            <div id="modal-content">
                <p>데이터를 불러오는 중...</p>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.8/index.global.min.js"></script>
    <script>
        document.addEventListener("DOMContentLoaded", () => {
            const calendarEl = document.getElementById("calendar");
            const selectedDateEl = document.getElementById("start-date");
            const modalContent = document.getElementById("modal-content");
            const modal = document.getElementById("survey-modal");

            <%
            Integer userId = (Integer) session.getAttribute("userId");
            %>
            const userId = <%= userId %>;

            const calendar = new FullCalendar.Calendar(calendarEl, {
                initialView: "dayGridMonth",
                locale: "ko",
                selectable: true,
                dateClick: function (info) {
                    const selectedDate = info.dateStr;
                    selectedDateEl.textContent = selectedDate;
                    fetchSurveyData(selectedDate, userId);
                },
            });

            calendar.render();

            // 설문 데이터 요청
            function fetchSurveyData(date, userId) {
                const url = '${pageContext.request.contextPath}/api/mysurveys?userId=' + userId + '&createAt=' + date;
                console.log("Fetching data from:", url);

                fetch(url, {
                    method: "GET",
                    headers: { 
                        "Accept": "application/json"
                    },
                    credentials: 'include',
                })
                .then(response => {
                    console.log("HTTP Response Status:", response.status);
                    if (!response.ok) {
                        throw new Error("데이터가 없습니다.");
                    }
                    return response.json();
                })
                .then(data => {
                    console.log("Received data:", data);
                    updateModalContent(data);
                })
                .catch(error => {
                    console.error("Error fetching data:", error);
                    modalContent.innerHTML = `<p>${error.message}</p>`;
                });

                showModal("survey-modal");
            }

            // 모달 내용 업데이트
            function updateModalContent(data) {
                console.log("data log = ", data);
                var content = 
                    "<div class='survey-data'>" +
                    "    <div class='survey-item'>" +
                    "        <strong>난이도:</strong>" +
                    "        <div class='progress-bar-container'>" +
                    "            <div class='progress-bar' style='width: " + (data.difficulty * 10 || 0) + "%'></div>" +
                    "        </div>" +
                    "        <span>" + (data.difficulty || "없음") + "/10</span>" +
                    "    </div>" +
                    "    <div class='survey-item'>" +
                    "        <strong>속도:</strong>" +
                    "        <div class='progress-bar-container'>" +
                    "            <div class='progress-bar' style='width: " + (data.speed * 10 || 0) + "%'></div>" +
                    "        </div>" +
                    "        <span>" + (data.speed || "없음") + "/10</span>" +
                    "    </div>" +
                    "    <div class='survey-item'>" +
                    "        <strong>자료 만족도:</strong>" +
                    "        <div class='progress-bar-container'>" +
                    "            <div class='progress-bar' style='width: " + (data.material * 10 || 0) + "%'></div>" +
                    "        </div>" +
                    "        <span>" + (data.material || "없음") + "/10</span>" +
                    "    </div>" +
                    "    <div class='survey-item'><strong>질문:</strong> " + (data.questions || "없음") + "</div>" +
                    "    <div class='survey-item'><strong>코멘트:</strong> " + (data.comments || "없음") + "</div>" +
                    "    <div class='survey-item'><strong>생성일:</strong> " + (data.createAt || "없음") + "</div>" +
                    "</div>";

                modalContent.innerHTML = content;
            }

            // 모달 열기
            function showModal(modalId) {
                modal.style.display = "block";
            }

            // 모달 닫기
            function closeModal(modalId) {
                modal.style.display = "none";
            }

            // 외부 클릭 시 모달 닫기
            window.addEventListener("click", (e) => {
                if (e.target === modal) {
                    closeModal("survey-modal");
                }
            });

            // ESC 키로 모달 닫기
            window.addEventListener("keydown", (e) => {
                if (e.key === "Escape") {
                    closeModal("survey-modal");
                }
            });
        });
    </script>
</body>

</html>
