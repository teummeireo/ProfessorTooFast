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
    
<script>
async function fetchUserMarkedDates() {
    const userId = <%= (Integer) session.getAttribute("userId") %>; 
    console.log("User ID:", userId); // 디버깅 추가
    const url = `/api/user-marked-dates?userId=${userId}`;
    console.log("Fetching URL:", url); // 디버깅 추가
    try {
        const response = await fetch(url, {
            method: 'GET',
            credentials: 'include',
            headers: { 'Accept': 'application/json' },
        });

        if (!response.ok) {
            throw new Error(`HTTP error! Status: ${response.status}`);
        }

        const data = await response.json();
        markedDatesCache = data; // 데이터를 전역 변수에 캐시
        console.log("Fetched User Marked Dates:", data);

        return data;
    } catch (error) {
        console.error("Error fetching user marked dates:", error);
        return [];
    }
}
</script>
<style>
.custom-line {
    display: block;
    height: 2px;
    background-color: #ff91ac; /* 분홍색 */
    width: 80%; /* 셀 너비의 80% */
    margin: 0 auto; /* 중앙 정렬 */
    position: relative;
    top: 50%; /* 셀 중앙에 위치 */
    transform: translateY(-50%);
}

#main-page-btn {
    top: 20px;
    right: 120px; /* Logout 버튼과 겹치지 않도록 수정 */
    width: 8%;
}
#logout-btn {
    top: 20px;
    right: 20px;
}
 
</style>

</head>
<body>
	<jsp:include page = "${pageContext.request.contextPath}/check_session.jsp" />
	<jsp:include page = "${pageContext.request.contextPath}/check_user.jsp" />


    
    <div id="calendar"></div>
        <!-- 로그아웃 및 메인 페이지 이동 버튼 -->
   <div class="button-container">
        <button class="custom-button" id="main-page-btn">메인 페이지로</button>
        <button class="custom-button" id="logout-btn">로그아웃</button>
    </div>

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
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
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
                selectable: false,
                dateClick: function (info) {
                    const selectedDate = info.dateStr;
                    selectedDateEl.textContent = selectedDate;
                    fetchSurveyData(selectedDate, userId);
                },
                events: async function(fetchInfo, successCallback, failureCallback) {
                    try {
                        const markedDates = await fetchUserMarkedDates(); // 사용자 데이터 가져오기
                        console.log("Adding Events:", markedDates);

                        const events = markedDates.map(date => ({
                            start: date,
                            extendedProps: { isMarkedDate: true , type: "line"}, // 추가 속성
                        }));

                        successCallback(events);
                    } catch (error) {
                        console.error("Error loading user events:", error);
                        failureCallback(error);
                    }
                },
                eventContent: function(info) {
                    console.log("Event Info:", info);
                    // 이벤트 타입에 따라 렌더링 설정
                    if (info.event.extendedProps.type === "dot") {
                        return {
                            html: '<span style="font-size:12px;color:red;">•</span>' // 빨간 점
                        };
                    }

                    if (info.event.extendedProps.type === "line") {
                        return {
                            html: '<div class="custom-line"></div>' // 중간 라인 삽입
                        };
                    }

                    // 배경 이벤트는 null 반환 (렌더링하지 않음)
                    if (info.event.extendedProps.type === "background") {
                        return null;
                    }

                    return null;
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
			
			        // 데이터가 없는 경우 모달 열지 않음
			        if (!data || Object.keys(data).length === 0) { // 데이터가 비어 있으면 처리
			            console.log("No survey data for this date:", date);
			            alert("이날은 제출한 설문이 없습니다."); // 사용자 알림 추가
			            return; // 모달 열지 않고 종료
			        }
			
		        updateModalContent(data); // 데이터가 있을 때만 모달 업데이트
                showModal("survey-modal");
            })
            .catch(error => {
                console.error("Error fetching data:", error);
            }); // catch 블록 추가 및 체이닝 종료
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
            
            // 로그아웃 버튼 이벤트
            $("#logout-btn").click(function () {
                $.ajax({
                    url: "${pageContext.request.contextPath}/api/logout",
                    method: "POST",
                    success: function () {
                        alert("로그아웃이 완료되었습니다.");
                        window.location.href = "${pageContext.request.contextPath}/";
                    },
                    error: function (err) {
                        alert("로그아웃 중 오류가 발생했습니다.");
                        console.error(err);
                    }
                });
            });

            // 메인 페이지 이동 버튼 이벤트
            $("#main-page-btn").click(function () {
                window.location.href = "${pageContext.request.contextPath}/";
            });
            
            
        });
    </script>
</body>

</html>
