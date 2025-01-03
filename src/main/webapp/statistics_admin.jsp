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
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/images/tomaico2.png">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/statistics_admin.css"> <!-- 스타일 경로 -->
    <link href="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.8/index.global.min.css" rel="stylesheet">
</head>
    <div id="notifications"></div>

    <script>
        const eventSource = new EventSource('/sse');

     	// 서버에서 메시지를 수신했을 때
        eventSource.onmessage = function(event) {
            console.log('알림:', event.data);
            showNotification(event.data);
        };

        // SSE 연결 에러 처리
        eventSource.onerror = function(event) {
            console.error("SSE 연결 에러:", event);
            eventSource.close();
        };

        // 알림 표시 함수
        function showNotification(message) {
            const notification = document.createElement('div');
            notification.className = 'notification';
            notification.innerText = message;

            document.getElementById('notifications').appendChild(notification);

            // 알림이 3초 후에 사라지도록 설정
            setTimeout(() => {
                notification.classList.add('hide');
                // 사라진 후 DOM에서 제거
                notification.addEventListener('transitionend', () => {
                    notification.remove();
                });
            }, 3000);
        }
        
    </script>

<body>
<jsp:include page = "${pageContext.request.contextPath}/check_session.jsp" />
<jsp:include page = "${pageContext.request.contextPath}/check_admin.jsp" />
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
                        // 1. 종료 날짜도 UI에 표시
                        updateSelectedDates();

                        console.log("fetchsurveyData 진입 직전 startDate = ", startDate);
                        // 2. 해당 일자 설문 데이터 요청
                        fetchSurveyData(startDate);                        
                        return; // 이후 동작 방지
                    }
                    //endDate = date;
                    updateSelectedDates();
                    calendar.removeAllEvents();
                    calendar.addEvent({
                        start: startDate,
                        end: new Date(new Date(endDate).getTime() + 86400000).toISOString().slice(0, 10),
                        display: "background",
                        color: "#ffa7d2",
                    });


                    //통계 모달 호출
                    if (startDate && endDate) {
                        console.log("Calling loadStatistics with:", startDate, endDate);
                        loadStatistics(startDate, endDate); // 명시적으로 값 전달
                        showModal("stats-modal");
                    }
                } else {
                    // 다시 새로운 날짜를 시작 날짜로 설정
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
				
				    const surveysUrl = "${pageContext.request.contextPath}/api/surveys?createAt=" + date;
				    const statsUrl = "${pageContext.request.contextPath}/api/daily-statistics?createAt=" + date;
				
				    console.log(surveysUrl);
				    console.log(statsUrl);
				
				    try {
				        // 일별 설문 데이터 API 호출
				        const surveysResponse = await fetch(surveysUrl, {
				            method: "GET",
				            credentials: "include",
				            headers: {
				                Accept: "application/json",
				                Cookie: `SESSIONID=${token}`, // 명세에 맞게 쿠키 헤더 포함
				            },
				        });
				
				        if (!surveysResponse.ok) {
				            console.error(`Surveys fetch failed with status: ${surveysResponse.status}`);
				            throw new Error(`Surveys fetch error: ${surveysResponse.status}`);
				        }
				
				        // JSON 데이터로 변환
				        const surveysData = await surveysResponse.json();
				        console.log("Surveys Data:", surveysData);
				
				        // `/api/daily-statistics` API 호출
				        const statsResponse = await fetch(statsUrl, {
				            method: "GET",
				            credentials: "include",
				            headers: {
				                Accept: "application/json",
				                Cookie: `SESSIONID=${token}`, // 명세에 맞게 쿠키 헤더 포함
				            },
				        });
				
				        if (!statsResponse.ok) {
				            console.error(`Statistics fetch failed with status: ${statsResponse.status}`);
				            throw new Error(`Statistics fetch error: ${statsResponse.status}`);
				        }
				
				        // JSON 데이터로 변환
				        const statsData = await statsResponse.json();
				        console.log("Statistics Data:", statsData);
				
				        // UI 업데이트 함수 호출
				        showSurveyResults(surveysData, statsData);
				
				    } catch (error) {
				        console.error("Failed to fetch survey data:", error);
				        document.getElementById("stats-content").innerHTML = `
				            <div class="error">
				                <p>데이터를 불러오는 중 오류가 발생했습니다: ${error.message}</p>
				            </div>
				        `;
				    }
				}

            // 설문 결과를 UI에 표시 (옵션)
			function showSurveyResults(surveysData, statsData) {
			    const statsContent = document.getElementById("stats-content");
			
			    console.log("가져온 Surveys Data:", surveysData);
			    console.log("가져온 Statistics Data:", statsData);
			
			    // 질문과 코멘트 리스트 초기화
			    let questionsList = "";
			    let commentsList = "";
			
			    // 통계 계산 준비
			    let totalDifficulty = 0;
			    let totalSpeed = 0;
			    
			    console.log("Number of surveys:", surveysData.length); // 데이터 개수 확인
			
			    surveysData.forEach((item,index) => {
			    	console.log("각항목 로딩 ")
			        console.log(`Processing item ${index}:`, item); // 각 항목 로깅
			        
		
			        //questionsList += `<li>${item.questions != null ? item.questions : "질문 없음"}</li>`;
			        //commentsList += `<li>${item.comments != null ? item.comments : "코멘트 없음"}</li>`;
		            questionsList += "<li>" + (item.questions != null ? item.questions : "질문 없음") + "</li>";
				    commentsList += "<li>" + (item.comments != null ? item.comments : "코멘트 없음") + "</li>";

			        totalDifficulty += item.difficulty || 0;
			        totalSpeed += item.speed || 0;
			    });
			
			    const totalCount = surveysData.length;
			    const avgDifficulty = totalCount > 0 ? (totalDifficulty / totalCount).toFixed(2) : 0;
			    const avgSpeed = totalCount > 0 ? (totalSpeed / totalCount).toFixed(2) : 0;
			    
			    
			    
			    console.log("Generated Lists:", {
			        questionsList,
			        commentsList,
			        avgDifficulty,
			        avgSpeed
			    });
			    
			
			    statsContent.innerHTML =
			        "<div class='survey-results-container'>" +
			        "    <div class='survey-column'>" +
			        "        <h3>질문 답변</h3>" +
			        "        <ul class='survey-list'>" + questionsList + "</ul>" +
			        "    </div>" +
			        "    <div class='survey-column'>" +
			        "        <h3>코멘트</h3>" +
			        "        <ul class='survey-list'>" + commentsList + "</ul>" +
			        "    </div>" +
			        "</div>" +
			        "<div>" +
			        "    <p><strong>참여자 수:</strong> " + (statsData.population || 0) + "명</p>" +
			        "    <p><strong>평균 난이도:</strong> " + avgDifficulty + "</p>" +
			        "    <p><strong>평균 속도:</strong> " + avgSpeed + "</p>" +
			        "    <p><strong>평균 자료 만족도:</strong> " + (statsData.avgMaterial || 0) + "</p>" +
			        "</div>";

			
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

                //const token = "C38C112FEB5D43B89364CE7637156922";
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
					const url = '${pageContext.request.contextPath}/api/period-statistics?startDate=' + startDate + '&endDate=' + endDate;

					console.log("Generated URL:", url);

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