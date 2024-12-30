<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="c" 	uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" 	uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" 	uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="x" 	uri="http://java.sun.com/jsp/jstl/xml" %>
<%@ taglib prefix="sql" 	uri="http://java.sun.com/jsp/jstl/sql" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Calendar with Statistics and Surveys</title>
    <link href="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.8/index.global.min.css" rel="stylesheet">

    <style>
        /* 전체 레이아웃 */
        #calendar {
            max-width: 800px;
            margin: 20px auto;
            border-radius: 15px;
            overflow: hidden;
            background-color: #ffffff;
            box-shadow: 0px 4px 12px rgba(0, 0, 0, 0.1);
        }

        /* 날짜 셀 스타일 */
        .fc-daygrid-day {
            font-size: 18px;
            text-align: center;
            vertical-align: middle;
            height: 50px;
            line-height: 50px;
            /* 날짜 정렬 간소화 */
            border: none;
        }

        /* 오늘 날짜 */
        .fc-day-today {
            background-color: #fff4f6;
            border-radius: 50%;
            border: 2px solid #ff91ac;
            font-weight: bold;
            color: #ff4b6e;
            height: auto;
            /* 크기 자동 조정 */

        }

        /* 선택된 날짜 */
        .fc-highlight {
            background-color: #ff91ac !important;
            /* FullCalendar의 highlight 스타일 */
            color: white;
            font-weight: bold;
            border-radius: 50%;
            transition: all 0.3s ease-in-out;
        }

        /* 툴바 버튼 */
        .fc-button {
            background-color: #ff91ac !important;
            color: white;
            border: none;
            font-size: 14px;
            border-radius: 10px;
            padding: 8px 16px;
            cursor: pointer;

        }

        .fc-button:hover {
            background-color: #ff7fa4 !important;
        }

        .fc-toolbar-title {
            font-size: 22px;
            color: #ff4b6e;
            font-weight: bold;
        }

        /* 선택된 날짜 정보 */
        #selected-dates {
            text-align: center;
            font-size: 18px;
            margin: 20px;
            background-color: #ffffff;
            border: 1px solid #ff91ac;
            border-radius: 10px;
            padding: 15px;
            color: #ff4b6e;
            box-shadow: 0px 2px 6px rgba(0, 0, 0, 0.1);
        }

        .button-container {
            display: flex;
            justify-content: center;
            align-items: center;
            width: 100%;
            /* 달력 너비와 동일 */
            max-width: 800px;
            /* 달력의 max-width와 동일 */
            margin: 0 auto;
            /* 가운데 정렬 */
            box-shadow: 0px 4px 12px rgba(0, 0, 0, 0.1);
            /* 달력과 동일한 그림자 */
            border-radius: 15px;
            /* 달력과 동일한 둥근 모서리 */
            overflow: hidden;
            background-color: #ffffff;
            /* 달력 배경색과 동일 */
        }

        .action-button {
            flex: 1;
            /* 버튼이 컨테이너 너비를 채우도록 */
            padding: 15px 0;
            /* 버튼의 높이 조정 */
            font-size: 18px;
            /* 텍스트 크기 */
            background-color: #ff91ac;
            color: white;
            border: none;
            cursor: pointer;
            border-right: 1px solid #fff;
            /* 버튼 사이의 구분선 */
            text-align: center;
            /* 텍스트 중앙 정렬 */
        }

        .action-button:last-child {
            border-right: none;
            /* 마지막 버튼은 구분선 제거 */
        }

        .action-button:hover {
            background-color: #ff7fa4;
        }

        /* 게이지 바 스타일 */
        .bar-container {
            margin: 20px 0;
            background-color: #f4f4f4;
            border-radius: 10px;
            height: 30px;
            overflow: hidden;
            position: relative;
        }

        .bar {
            height: 100%;
            width: 0;
            background-color: #ff7fa4;
            border-radius: 10px;
            transition: width 1.5s ease-in-out;
        }

        .bar-label {
            position: absolute;
            width: 100%;
            text-align: center;
            line-height: 30px;
            font-weight: bold;
            color: #fff;
            text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.5);
        }

        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            z-index: 1000;
            /* 충분히 높은 z-index */
        }

        .modal-content {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background-color: white;
            padding: 20px;
            width: 70%;
            max-width: 700px;
            border-radius: 5px;
            z-index: 1001;
            /* 모달 배경보다 앞에 표시 */
        }

        label {
            font-size: 16px;
            margin-right: 10px;
        }

        select {
            font-size: 16px;
            padding: 5px 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
            margin-bottom: 20px;
        }


        /* 툴팁 전환 애니메이션 */
        #tooltip-content {
            transition: opacity 0.3s ease-in-out, transform 0.3s ease-in-out;
            opacity: 0;
            pointer-events: none;
        }

        #tooltip-content.active {
            display: block;
            /* 추가 */
            opacity: 1;
            pointer-events: auto;
            transform: translateX(-50%) translateY(0);
        }

        #tooltip-btn {
            position: relative;
            /* 필요한 경우 조정 */
            z-index: 10;
            pointer-events: auto;
            /* 클릭 가능하도록 설정 */
        }

        #selected-dates {
            text-align: center;
            font-size: 18px;
            margin: 20px auto;
            /* 가운데 정렬 */
            background-color: #ffffff;
            border: 1px solid #ff91ac;
            border-radius: 10px;
            padding: 15px;
            color: #ff4b6e;
            box-shadow: 0px 2px 6px rgba(0, 0, 0, 0.1);
            width: 100%;
            /* 달력과 동일한 너비 */
            max-width: 800px;
            /* 달력의 max-width와 동일 */
        }

        /* 선택된 날짜 섹션 스타일 */
        .dates-container {
            display: flex;
            /* 가로로 나열 */
            justify-content: space-around;
            /* 간격 균등 분배 */
            align-items: center;
            /* 수직 중앙 정렬 */
            margin: 20px auto;
            /* 상하 여백 및 가운데 정렬 */
            padding: 15px;
            max-width: 800px;
            background-color: #ffffff;
            border: 1px solid #ff91ac;
            border-radius: 10px;
            box-shadow: 0px 2px 6px rgba(0, 0, 0, 0.1);
        }

        .date-box {
            text-align: center;
            padding: 10px 20px;
            border: 1px solid #ff91ac;
            border-radius: 8px;
            background-color: #fff4f6;
            color: #ff4b6e;
            font-size: 16px;
            flex: 1;
            /* 동일한 크기로 확장 */
            margin: 0 10px;
            /* 박스 간 여백 */
        }

        .date-label {
            font-weight: bold;
            display: block;
            /* 줄바꿈 */
            margin-bottom: 5px;
            font-size: 14px;
            color: #ff4b6e;
        }

        .survey-results-container {
            display: flex;
            gap: 20px;
            margin: 20px 0;
        }

        .survey-column {
            flex: 1;
            background-color: #fff4f6;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .survey-column h3 {
            color: #ff4b6e;
            margin-bottom: 15px;
            text-align: center;
            font-size: 18px;
            padding-bottom: 10px;
            border-bottom: 2px solid #ff91ac;
        }

        .survey-list {
            list-style: none;
            padding: 0;
            margin: 0;
            max-height: 300px;
            /* 최대 높이 설정 */
            overflow-y: auto;
            /* 스크롤 활성화 */
            border: 1px solid #ff91ac;
            /* 테두리 추가 */
            border-radius: 8px;
            /* 둥근 모서리 */
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
        }

        .survey-list li {
            background-color: white;
            margin-bottom: 10px;
            padding: 12px 15px;
            border-radius: 8px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            font-size: 14px;
            line-height: 1.4;
            color: #333;
            border-left: 3px solid #ff91ac;
        }

        .survey-list li:last-child {
            margin-bottom: 0;
        }

        .survey-list li:hover {
            transform: translateY(-2px);
            transition: transform 0.2s ease;
        }
    </style>
</head>

<body>
    <div id="calendar"></div>
    <!-- <p id="selected-dates">선택된 날짜: 없음</p> -->
    <!-- 선택된 날짜 섹션 -->
    <div id="selected-dates" class="dates-container">
        <div class="date-box">
            <span class="date-label">시작 날짜:</span>
            <span id="start-date">없음</span>
        </div>
        <div class="date-box">
            <span class="date-label">종료 날짜:</span>
            <span id="end-date">없음</span>
        </div>
    </div>


    <!-- 통계 모달 -->
    <div id="stats-modal" class="modal">
        <div class="modal-content">
            <span class="close-button" onclick="closeModal('stats-modal')">&times;</span>
            <h2>통계</h2>
            <div id="stats-content">
                <div>
                    <h3>기간: <span id="date-range"></span></h3>
                </div>
                <div>
                    <div>평균 난이도</div>
                    <div class="bar-container">
                        <div class="bar" id="difficulty-bar"></div>
                        <div class="bar-label" id="difficulty-label"></div>
                    </div>
                </div>
                <div>
                    <div>평균 속도</div>
                    <div class="bar-container">
                        <div class="bar" id="speed-bar"></div>
                        <div class="bar-label" id="speed-label"></div>
                    </div>
                </div>
                <div>
                    <div>평균 자료 만족도</div>
                    <div class="bar-container">
                        <div class="bar" id="material-bar"></div>
                        <div class="bar-label" id="material-label"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- //todo 툴팁 관련 추후-->
    <!-- <div style="position: relative; display: inline-block;">
        <button id="tooltip-btn" style="padding: 5px 10px; background: #ff91ac; color: #fff; border: none; border-radius: 5px;">
            연/월 선택
        </button>
        <div id="tooltip-content" style="display: none; position: absolute; top: 40px; left: 50%; transform: translateX(-50%); background: #fff; border: 1px solid #ddd; border-radius: 5px; padding: 10px; box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1);">
            <label for="tooltip-year" style="font-size: 12px; margin-right: 5px;">연도:</label>
            <select id="tooltip-year" style="font-size: 12px; margin-bottom: 10px;"></select>
            <br>
            <label for="tooltip-month" style="font-size: 12px; margin-right: 5px;">월:</label>
            <select id="tooltip-month" style="font-size: 12px;"></select>
            <br>
            <button id="confirm-btn" style="margin-top: 10px; padding: 5px 10px; font-size: 12px; background: #ff91ac; color: #fff; border: none; border-radius: 5px;">
                확인
            </button>
        </div>
    </div> -->




    <script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.8/index.global.min.js"></script>
    <script>
    console.log(document.cookie);



        document.addEventListener("DOMContentLoaded", () => {



            let startDate = null;
            let endDate = null;

            const calendarEl = document.getElementById("calendar");
            //const selectedDatesEl = document.getElementById("selected-dates");
            

            const calendar = new FullCalendar.Calendar(calendarEl, {
                initialView: "dayGridMonth",
                locale: "ko",
                selectable: true,
                dateClick: function (info) {
                    const clickedDate = new Date(info.dateStr);
                    const today = new Date();

                    if (clickedDate > today) {
                        alert("미래 날짜는 선택할 수 없습니다.");
                        return;
                    }
                    handleDateClick(info.dateStr);
                },
            });


            // 캘린더 객체를 DOM에 저장하여 툴팁과 연동
            document.getElementById("calendar")._fullCalendar = calendar;

            // 캘린더 렌더링
            calendar.render();

            function handleDateClick(date) {
            	
                
                if (!startDate) {
                    startDate = date;
                    endDate = null;
                    updateSelectedDates();
                    calendar.removeAllEvents();
                    calendar.addEvent({
                        start: startDate,
                        end: startDate,
                        display: "background",
                        color: "#ffa7d2",
                    });
                } else if (!endDate) {
                    endDate = date;
                    const startDateObj = new Date(startDate);
                    const endDateObj = new Date(endDate);

                    if (startDateObj > endDateObj) {
                        alert("종료 날짜는 시작 날짜보다 이후여야 합니다.");
                        endDate = null;
                        return;
                    }

                    // 같은 날짜 클릭 시 API 호출
                    if (startDate === endDate) {
                        fetchSurveyData(startDate); // API 호출
                        return; // 이후 동작 방지
                    }
                    endDate = date;
                    updateSelectedDates();
                    calendar.removeAllEvents();
                    calendar.addEvent({
                        start: startDate,
                        end: new Date(new Date(endDate).getTime() + 86400000).toISOString().slice(0, 10),
                        display: "background",
                        color: "#ffa7d2",
                    });


                    if (startDate && endDate) {
                        console.log("Calling loadStatistics with:", startDate, endDate);
                        loadStatistics(startDate, endDate); // 명시적으로 값 전달
                        showModal("stats-modal");
                    }
                } else {
                    startDate = date;
                    endDate = null;
                    updateSelectedDates();
                    calendar.removeAllEvents();
                    calendar.addEvent({
                        start: startDate,
                        end: startDate,
                        display: "background",
                        color: "#ffa7d2",
                    });
                }

                console.log("Selected Start Date:", startDate);
                console.log("Selected End Date:", endDate);
                
            }

            // API 요청 함수 추가
            async function fetchSurveyData(date) {
            	
                if (!date) {
                    console.error("The createAt parameter is missing.");
                    alert("날짜를 선택해주세요.");
                    return;
                }

                //const token = getSessionId();
                const token = "C38C112FEB5D43B89364CE7637156922";

                

                try {
                    // 일별 설문 데이터 API 호출
                    const response = await fetch(`/api/daily-statistics?createAt=${date}`, {
                        method: "GET",
                        credentials: 'include', // 쿠키 포함 설정

                        headers: {
                            'Accept': 'application/json',
                            "Cookie": `SESSIONID=${token}`
                        }
                    });
            
                    if (!response.ok) {
                        throw new Error(`HTTP error! Status: ${response.status}`);
                    }
            
                    const data = await response.json();
                    
                    // 기존 showSurveyResults 함수 호출
                    showSurveyResults(data);
            
                } catch (error) {
                    console.error("Failed to fetch survey data:", error);
                    document.getElementById('stats-content').innerHTML = `
                        <div class="error">
                            <p>데이터를 불러오는 중 오류가 발생했습니다: ${error.message}</p>
                        </div>
                    `;
                }

            }

            // 설문 결과를 UI에 표시 (옵션)
            function showSurveyResults(data) {
                const statsContent = document.getElementById('stats-content');

                // 질문과 코멘트 리스트 초기화
                let questionsList = "";
                let commentsList = "";

                // 통계 계산 준비
                let totalDifficulty = 0;
                let totalSpeed = 0;

                data.forEach((item) => {
                    questionsList += `<li>${item.questions}</li>`;
                    commentsList += `<li>${item.comments}</li>`;
                    totalDifficulty += item.difficulty;
                    totalSpeed += item.speed;
                });

                const totalCount = data.length;
                const avgDifficulty = (totalCount > 0) ? (totalDifficulty / totalCount).toFixed(2) : 0;
                const avgSpeed = (totalCount > 0) ? (totalSpeed / totalCount).toFixed(2) : 0;

                statsContent.innerHTML = `
                    <div class="survey-results-container">
                        <div class="survey-column">
                            <h3>질문 답변</h3>
                            <ul class="survey-list">${questionsList}</ul>
                        </div>
                        <div class="survey-column">
                            <h3>코멘트</h3>
                            <ul class="survey-list">${commentsList}</ul>
                        </div>
                    </div>
                    <div>
                        <p><strong>참여자 수:</strong> ${totalCount}명</p>
                        <p><strong>평균 난이도:</strong> ${avgDifficulty}</p>
                        <p><strong>평균 속도:</strong> ${avgSpeed}</p>
                    </div>
                `;

                showModal("stats-modal");
            }

            function updateSelectedDates() {
                const startDateEl = document.getElementById("start-date");
                const endDateEl = document.getElementById("end-date");


                if (startDate) {
                    startDateEl.textContent = startDate;
                } else {
                    startDateEl.textContent = "없음";
                }

                if (endDate) {
                    endDateEl.textContent = endDate;
                } else {
                    endDateEl.textContent = "없음";
                }
            }

            function loadStatistics(startDate, endDate) {
                if (!startDate || !endDate) {
                    console.error("Missing startDate or endDate.");
                    alert("유효한 날짜를 선택하세요.");
                    return;
                }
                // 원하시는 바대로 한 줄씩 따로도 찍을 수 있습니다.
                console.log("endDate:", endDate);
                console.log("startDate:", startDate);
                const params = new URLSearchParams({ startDate, endDate });
                console.log("params.toString = ", params.toString()); 
                console.log("query = ",`/api/period-statistics?startDate=${startDate}&endDate=${endDate}`);

                const token = "C38C112FEB5D43B89364CE7637156922";
                //const token = getSessionToken(); // Implement this function based on your auth strategy
                  
                // 먼저 모달 내용 초기화 및 생성
                const statsContent = document.getElementById('stats-content');
                statsContent.innerHTML = `
                    <div>
                        <h3 id="date-range"></h3>
                        <div class="stat-item">
                            <div class="stat-title">평균 난이도</div>
                            <div class="bar-container">
                                <div class="bar" id="difficulty-bar"></div>
                                <div class="bar-label" id="difficulty-label"></div>
                            </div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-title">평균 속도</div>
                            <div class="bar-container">
                                <div class="bar" id="speed-bar"></div>
                                <div class="bar-label" id="speed-label"></div>
                            </div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-title">평균 자료</div>
                            <div class="bar-container">
                                <div class="bar" id="material-bar"></div>
                                <div class="bar-label" id="material-label"></div>
                            </div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-title">총 인원</div>
                            <div id="population" style="font-size: 1.2em; text-align: center;"></div>
                        </div>
                    </div>
                `;
            
                                
                	console.log("fetch log = ", `/api/period-statistics?${params.toString()}`)
                    // Make the API call

					console.log("fetch URL:", `/api/period-statistics?startDate=${startDate}&endDate=${endDate}`);
					const url = '/api/period-statistics?startDate=' + startDate + '&endDate=' + endDate;

					console.log("Generated URL:", url);
					//fetch(`/api/period-statistics?startDate=${startDate}&endDate=${endDate}`, {
					//fetch('/api/period-statistics?startDate=2024-12-01&endDate=2024-12-27', {

					fetch(url, {
                        method: 'GET',
                        headers: {
                            'Accept': 'application/json',
                            Cookie: `SESSIONID=${token}`, // 명세에 맞게 쿠키 헤더 포함
                        },    
                        	credentials: 'include', // 쿠키 포함

                    })
                    .then(response => {
                        if (!response.ok) {
                            throw new Error(`HTTP error! Status: ${response.status}`);
                        }
                        return response.json();
                    })
                    .then(data => {  
                        console.log("Fetched data:", data);

                    
                        // 통계 데이터 표시 업데이트
                        document.getElementById("date-range").textContent = 
                            //`Period: ${data.startDate} ~ ${data.endDate}`;
                            "Period: " + (data.startDate || "N/A") + " ~ " + (data.endDate || "N/A");

                            console.log("data.startDate $ 입력 체크 = ", `${data.startDate}`);
                            console.log("data.startDate 그냥 입력 체크 = ", startDate, endDate);
                            console.log("data.startDate 기본값 체크 = " + (data.startDate || "N/A"));
                            console.log("data.startDate 기본값으로 직접 연결 = " + (startDate || "N/A") + " ~ " + (endDate || "N/A"));

                
                        updateBar("difficulty-bar", "difficulty-label", data.avgDifficulty || 0);
                        updateBar("speed-bar", "speed-label", data.avgSpeed || 0);
                        updateBar("material-bar", "material-label", data.avgMaterial || 0);
                
                        const populationElement = document.getElementById("population");
                        if (populationElement && data.totalCount != null) {
                            populationElement.textContent = `${data.totalCount}명`;
                        }

                        showModal("stats-modal"); // 1208수정


                    })
                    .catch(error => {
                        console.error("Failed to fetch statistics:", error);
                        document.getElementById('stats-content').innerHTML = `
                            <div class="error-message">
                                <p>Failed to load statistics: ${error.message}</p>
                            </div>
                        `;
                    });
                
                

    

                // Helper function to get session token
                function getSessionToken() {
                // Try to get token from cookie
                const cookies = document.cookie.split(';');
                const sessionCookie = cookies.find(cookie => cookie.trim().startsWith('SESSIONID='));
                if (sessionCookie) {
                    return sessionCookie.split('=')[1].trim();
                }

                // Fallback to localStorage if using that approach
                const localToken = localStorage.getItem('sessionToken');
                if (localToken) {
                    return localToken;
                }

                throw new Error('No authentication token found');
                }
            }
            

            function showModal(modalId) {
                const modal = document.getElementById(modalId);
                modal.style.display = "block";
            }

            function closeModal(modalId) {
                const modal = document.getElementById(modalId);
                modal.style.display = "none";
            }

            window.addEventListener("keydown", (e) => {
                if (e.key === "Escape") {
                    document.querySelectorAll(".modal").forEach(modal => modal.style.display = "none");
                }
            });

            window.addEventListener("click", (e) => {
                document.querySelectorAll(".modal").forEach(modal => {
                    if (e.target === modal) {
                        modal.style.display = "none";
                    }
                });
            });


            document.querySelectorAll(".close-button").forEach(button => {
                button.addEventListener("click", (e) => {
                    const modalId = e.target.closest(".modal").id;
                    closeModal(modalId);
                });
            });


        });

        function updateBar(barId, labelId, value) {
            const bar = document.getElementById(barId);
            const label = document.getElementById(labelId);


            // 초기화
            bar.style.width = '0%';

            // 애니메이션 시작
            setTimeout(() => {
                const percentage = (value / 10) * 100;
                bar.style.width = percentage + "%";
                label.textContent = (value || 0).toFixed(1) + " / 10";
            }, 100);
        }

        function getSessionToken() {
            const cookies = document.cookie.split(';');
            const sessionCookie = cookies.find(cookie => cookie.trim().startsWith('SESSIONID='));
            if (sessionCookie) {
                return sessionCookie.split('=')[1].trim();
            } else {
                console.error("SESSIONID 쿠키가 없습니다.");
                return null;
            }
        }
       



    </script>
</body>

</html>