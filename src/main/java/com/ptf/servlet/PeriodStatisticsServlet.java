package com.ptf.servlet;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.ptf.dao.StatisticsDAO;
import com.ptf.util.AuthenticationUtil;
import com.ptf.util.SessionUtil;
import com.ptf.vo.StatisticsVO;


@WebServlet("/api/period-statistics")
public class PeriodStatisticsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 세션과 쿠키 인증
        if (!AuthenticationUtil.isAuthenticated(request, response)) {
            return; // 인증 실패 시 요청 중단
        }

        response.setContentType("application/json; charset=UTF-8");

        // ADMIN 권한 확인
        if (!AuthenticationUtil.checkRole(request, response, "ADMIN")) {
            return; // 권한 부족 시 요청 중단
        }

        // 쿼리 파라미터에서 startDate와 endDate 값 가져오기
        String startDateParam = request.getParameter("startDate");
        String endDateParam = request.getParameter("endDate");

        if (startDateParam == null || endDateParam == null || startDateParam.isEmpty() || endDateParam.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"startDate와 endDate 쿼리 파라미터를 제공해주세요.\"}");
            return;
        }

        Date startDate, endDate;
        try {
            // ISO 형식의 날짜 파싱
            startDate = new SimpleDateFormat("yyyy-MM-dd").parse(startDateParam);
            endDate = new SimpleDateFormat("yyyy-MM-dd").parse(endDateParam);
        } catch (java.text.ParseException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"startDate와 endDate는 yyyy-MM-dd 형식이어야 합니다.\"}");
            return;
        }

        if (startDate.after(endDate)) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"startDate는 endDate보다 이전이어야 합니다.\"}");
            return;
        }

        try {
            StatisticsDAO statisticsDAO = new StatisticsDAO();
            ArrayList<StatisticsVO> statisticsList = statisticsDAO.surveySelectByPeriod(startDate, endDate);

            if (statisticsList.isEmpty()) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write("{\"message\": \"해당 기간에 통계가 없습니다.\"}");
                return;
            }

            // 기간 평균 계산
            float totalAvgDifficulty = 0;
            float totalAvgSpeed = 0;
            float totalAvgMaterial = 0;
            int totalPopulation = 0;

            for (StatisticsVO stat : statisticsList) {
                totalAvgDifficulty += stat.getAvgDifficulty() * stat.getPopulation();
                totalAvgSpeed += stat.getAvgSpeed() * stat.getPopulation();
                totalAvgMaterial += stat.getAvgMaterial() * stat.getPopulation();
                totalPopulation += stat.getPopulation();
            }

            float finalAvgDifficulty = totalPopulation > 0 ? totalAvgDifficulty / totalPopulation : 0;
            float finalAvgSpeed = totalPopulation > 0 ? totalAvgSpeed / totalPopulation : 0;
            float finalAvgMaterial = totalPopulation > 0 ? totalAvgMaterial / totalPopulation : 0;

     
            Map<String, Object> responseMap = new HashMap<>();
            responseMap.put("startDate", startDateParam);
            responseMap.put("endDate", endDateParam);
            responseMap.put("avgDifficulty", finalAvgDifficulty);
            responseMap.put("avgSpeed", finalAvgSpeed);
            responseMap.put("avgMaterial", finalAvgMaterial);
            responseMap.put("population", totalPopulation);

            ObjectMapper objectMapper = new ObjectMapper();
            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write(objectMapper.writeValueAsString(responseMap));
            SessionUtil.refreshSessionTimeout(request); // 세션 타임아웃 갱신
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"서버 오류가 발생했습니다.\"}");
        }
    }
}

