<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>유저 설문 페이지</title>
    <link href="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.8/index.global.min.css" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/statistics_admin.css"> <!-- 스타일 경로 -->
    
   <style>
        body {
            font-family: 'Comic Sans MS', Arial, sans-serif;
            background-color: #F5F9FA;
            margin: 0;
            padding: 0;
            color: #444;
        }

        #calendar {
            max-width: 800px;
            margin: 20px auto;
            background: #FFFFFF;
            border-radius: 15px;
            box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);
            padding: 20px;
            border: 2px solid #f8bfce;
        }

        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.3);
            z-index: 1000;
        }

        .modal-content {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background-color: #FAFAFA;
            padding: 25px;
            border-radius: 10px;
            width: 70%;
            max-width: 500px;
            box-shadow: 0px 6px 12px rgba(0, 0, 0, 0.15);
            border: 1px solid #f8bfce;
        }

        .modal-content h2 {
            margin-top: 0;
            font-size: 22px;
		    color: #000; /* 검은색으로 변경 */
		    font-weight: bold; /* 굵게 설정 */
        }

        .close-button {
            float: right;
            font-size: 24px;
            font-weight: bold;
            cursor: pointer;
            color: #0000001a;
        }

        .survey-data {
            display: flex;
            flex-direction: column;
            gap: 15px;
            margin-top: 20px;
        }

        .survey-item {
            padding: 12px;
            border: 1px solid #f8bfce;
            color: #292727;
            border-radius: 10px;
            background-color: #ffeef2;
        }

        .survey-item strong {
            display: block;
            margin-bottom: 5px;
            color: #464141;
        }

        .progress-bar-container {
            width: 100%;
            height: 12px;
            background-color: #fff4f6;
            border-radius: 6px;
            overflow: hidden;
            margin: 5px 0;
        }

        .progress-bar {
            height: 100%;
            background-color: #ff4b6e;
            transition: width 0.3s ease;
        }

        #selected-dates {
            max-width: 800px;
            margin: 20px auto;
            padding: 10px;
            border: 1px solid #ff91ac;
            border-radius: 10px;
            background: #EAF4F8;
            text-align: center;
        }

        .date-box {
            font-size: 18px;
            color: #ff7fa4;
        }

        .date-label {
            font-weight: bold;
            color: #ff7fa4;
        }

        .action-button {
            margin-top: 15px;
            background-color: #ff7fa4;
            border: none;
            color: white;
            padding: 10px 20px;
            font-size: 16px;
            font-weight: bold;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        .action-button:hover {
            background-color: #ff7fa4;
        }
    </style>
</head>

<body>
<jsp:include page = "${pageContext.request.contextPath}/check_session.jsp" />
<jsp:include page = "${pageContext.request.contextPath}/check_user.jsp" />
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
                const url = '/api/mysurveys?userId=' + userId + '&createAt=' + date;
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
