package com.ptf.servlet;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

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



@WebServlet("/api/monthly-statistics")
public class MonthlyStatisticsServlet extends HttpServlet {
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

        // 쿼리 파라미터에서 month 값 가져오기
        String monthParam = request.getParameter("month");
        if (monthParam == null || monthParam.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"month 쿼리 파라미터를 제공해주세요.\"}");
            return;
        }

        Date month;
        try {
            // ISO 형식의 날짜 파싱
            month = new SimpleDateFormat("yyyy-MM-dd").parse(monthParam);
        } catch (java.text.ParseException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"month는 yyyy-MM-dd 형식이어야 합니다.\"}");
            return;
        }

        try {
            StatisticsDAO statisticsDAO = new StatisticsDAO();
            ArrayList<StatisticsVO> statisticsList = statisticsDAO.surveySelectByMonth(month);

            if (statisticsList.isEmpty()) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write("{\"message\": \"해당 월에 통계가 없습니다.\"}");
                return;
            }

            // 월 평균 계산
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

            // 결과 객체 생성
            StatisticsVO resultVO = new StatisticsVO();
            resultVO.setRecordDate(new SimpleDateFormat("yyyy-MM-dd").parse(monthParam));
            resultVO.setAvgDifficulty(finalAvgDifficulty);
            resultVO.setAvgSpeed(finalAvgSpeed);
            resultVO.setAvgMaterial(finalAvgMaterial);
            resultVO.setPopulation(totalPopulation);

            response.setStatus(HttpServletResponse.SC_OK);
            ObjectMapper objectMapper = new ObjectMapper();
            objectMapper.disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);
            response.getWriter().write(objectMapper.writeValueAsString(resultVO));

            SessionUtil.refreshSessionTimeout(request); // 세션 타임아웃 갱신
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"서버 오류가 발생했습니다.\"}");
        }
    }
}
