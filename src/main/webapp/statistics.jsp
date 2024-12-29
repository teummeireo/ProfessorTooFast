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
    line-height: 50px; /* 날짜 정렬 간소화 */
    border: none;
}

/* 오늘 날짜 */
.fc-day-today {
    background-color: #fff4f6;
    border-radius: 50%;
    border: 2px solid #ff91ac;
    font-weight: bold;
    color: #ff4b6e;
    height: auto; /* 크기 자동 조정 */

}

/* 선택된 날짜 */
.fc-highlight {
    background-color: #ff91ac !important; /* FullCalendar의 highlight 스타일 */
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
    width: 100%; /* 달력 너비와 동일 */
    max-width: 800px; /* 달력의 max-width와 동일 */
    margin: 0 auto; /* 가운데 정렬 */
    box-shadow: 0px 4px 12px rgba(0, 0, 0, 0.1); /* 달력과 동일한 그림자 */
    border-radius: 15px; /* 달력과 동일한 둥근 모서리 */
    overflow: hidden;
    background-color: #ffffff; /* 달력 배경색과 동일 */
}

.action-button {
    flex: 1; /* 버튼이 컨테이너 너비를 채우도록 */
    padding: 15px 0; /* 버튼의 높이 조정 */
    font-size: 18px; /* 텍스트 크기 */
    background-color: #ff91ac;
    color: white;
    border: none;
    cursor: pointer;
    border-right: 1px solid #fff; /* 버튼 사이의 구분선 */
    text-align: center; /* 텍스트 중앙 정렬 */
}

.action-button:last-child {
    border-right: none; /* 마지막 버튼은 구분선 제거 */
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
    text-shadow: 1px 1px 2px rgba(0,0,0,0.5);
}
.modal {
    display: none;
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background-color: rgba(0, 0, 0, 0.5);
    z-index: 1000; /* 충분히 높은 z-index */
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
    z-index: 1001; /* 모달 배경보다 앞에 표시 */
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
    display: block; /* 추가 */
    opacity: 1;
    pointer-events: auto;
    transform: translateX(-50%) translateY(0);
}
#tooltip-btn {
    position: relative; /* 필요한 경우 조정 */
    z-index: 10;
    pointer-events: auto; /* 클릭 가능하도록 설정 */
}
#selected-dates {
    text-align: center;
    font-size: 18px;
    margin: 20px auto; /* 가운데 정렬 */
    background-color: #ffffff;
    border: 1px solid #ff91ac;
    border-radius: 10px;
    padding: 15px;
    color: #ff4b6e;
    box-shadow: 0px 2px 6px rgba(0, 0, 0, 0.1);
    width: 100%; /* 달력과 동일한 너비 */
    max-width: 800px; /* 달력의 max-width와 동일 */
}


    </style>
</head>
<body>
    <div id="calendar"></div>
    <p id="selected-dates">선택된 날짜: 없음</p>

    <!-- <div class="button-container">
        <button class="action-button" id="show-stats">통계 보기</button>
        <button class="action-button" id="show-surveys">설문 리스트</button>
    </div> -->

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

    <div style="position: relative; display: inline-block;">
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
    </div>
    
    


    <script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.8/index.global.min.js"></script>
    <script>

        document.addEventListener("DOMContentLoaded", () => {



            let startDate = null;
            let endDate = null;
        
            const calendarEl = document.getElementById("calendar");
            const selectedDatesEl = document.getElementById("selected-dates");
        
            const calendar = new FullCalendar.Calendar(calendarEl, {
                initialView: "dayGridMonth",
                locale: "ko",
                selectable: true,
                dateClick: function(info) {
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
        
                    updateSelectedDates();
                    calendar.removeAllEvents();
                    calendar.addEvent({
                        start: startDate,
                        end: new Date(new Date(endDate).getTime() + 86400000).toISOString().slice(0, 10),
                        display: "background",
                        color: "#ffa7d2",
                    });
        
                    if (startDate && endDate) {
                        loadStatistics();
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
            }
        
            function updateSelectedDates() {
                if (startDate && endDate) {
                    selectedDatesEl.textContent = `시작: ${startDate}, 종료: ${endDate}`;
                } else if (startDate) {
                    selectedDatesEl.textContent = `시작 날짜: ${startDate}`;
                } else {
                    selectedDatesEl.textContent = "선택된 날짜: 없음";
                }
            }
        
            async function loadStatistics() {
                try {
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
                        // 통계 데이터 샘플
                        const data = {
                            startDate: startDate || "시작 날짜 없음",
                            endDate: endDate || "종료 날짜 없음",
                            avgDifficulty: 5.54,
                            avgSpeed: 6.52,
                            avgMaterial: 4.74,
                            population: 60
                        };

                        // 통계 데이터를 업데이트
                        document.getElementById("date-range").textContent = 
                            `기간: ${data.startDate} ~ ${data.endDate}`;
                        updateBar("difficulty-bar", "difficulty-label", data.avgDifficulty);
                        updateBar("speed-bar", "speed-label", data.avgSpeed);
                        updateBar("material-bar", "material-label", data.avgMaterial);
                    } catch (error) {
                        console.error("Error loading statistics:", error);
                        document.getElementById('stats-content').innerHTML = `
                            <div class="error">
                                <p>오류가 발생했습니다: ${error.message}</p>
                            </div>
                        `;
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

            window.addEventListener("click", (e) => {
                console.log(e.target); // 어떤 요소가 클릭되었는지 확인
                if (!tooltipContent.contains(e.target) && e.target !== tooltipBtn) {
                    tooltipContent.classList.remove("active");
                }
            });
            
        
            document.querySelectorAll(".close-button").forEach(button => {
                button.addEventListener("click", (e) => {
                    const modalId = e.target.closest(".modal").id;
                    closeModal(modalId);
                });
            });

            
        <!-- 미니 툴팁 관련 코드 -->
 
        const tooltipBtn = document.getElementById("tooltip-btn");
        const tooltipContent = document.getElementById("tooltip-content");
        const yearSelect = document.getElementById("tooltip-year");
        const monthSelect = document.getElementById("tooltip-month");
        const confirmBtn = document.getElementById("confirm-btn");
    
        if (!tooltipBtn) {
            console.error("tooltip-btn 요소를 찾을 수 없습니다.");
            return;
        }
        // 툴팁 열기/닫기
        tooltipBtn.addEventListener("click", (e) => {
            console.log("툴팁 버튼 클릭됨");
            e.stopPropagation();
            const tooltipContent = document.getElementById("tooltip-content");
            tooltipContent.classList.toggle("active");
        });

        // 툴팁 외부 클릭 시 닫기
        window.addEventListener("click", (e) => {
            if (!tooltipContent.contains(e.target) && e.target !== tooltipBtn) {
                tooltipContent.classList.remove("active");
            }
        });
    
        // 연/월 데이터 채우기
        const currentYear = new Date().getFullYear();
        const currentMonth = new Date().getMonth() + 1;
    
        for (let i = currentYear - 10; i <= currentYear + 10; i++) {
            const yearOption = document.createElement("option");
            yearOption.value = i;
            yearOption.textContent = i;
            if (i === currentYear) yearOption.selected = true;
            yearSelect.appendChild(yearOption);
        }
    
        for (let i = 1; i <= 12; i++) {
            const monthOption = document.createElement("option");
            monthOption.value = i;
            monthOption.textContent = `${i}월`;
            if (i === currentMonth) monthOption.selected = true;
            monthSelect.appendChild(monthOption);
        }
    
        // 확인 버튼 클릭 이벤트
        confirmBtn.addEventListener("click", () => {
            const selectedYear = yearSelect.value;
            const selectedMonth = monthSelect.value;
    
            console.log(`선택된 연도: ${selectedYear}, 월: ${selectedMonth}`);
    
            // FullCalendar의 날짜 갱신
            const calendar = document.getElementById("calendar")._fullCalendar;
            if (calendar) {
                calendar.gotoDate(`${selectedYear}-${String(selectedMonth).padStart(2, "0")}-01`);
            }
    
            // 툴팁 닫기
            tooltipContent.classList.remove("active");
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
                bar.style.width = `${percentage}%`;
                label.textContent = `${value.toFixed(1)} / 10`;
            }, 100);
        }
        

        
        
    </script>
</body>
</html>