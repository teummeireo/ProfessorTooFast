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
import com.ptf.dao.StatisticsDAO;

/**
 * Servlet implementation class MarkedDatesServlet
 */
@WebServlet("/api/admin-marked-dates")
public class MarkedDatesServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json; charset=UTF-8");

        try {
            StatisticsDAO statisticsDAO = new StatisticsDAO();
            // 데이터베이스에서 통계가 존재하는 모든 날짜 가져오기
            ArrayList<Date> markedDates = statisticsDAO.getMarkedDates();

            // 날짜 리스트를 JSON 배열로 변환
            ArrayList<String> markedDateStrings = new ArrayList<>();
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            for (Date date : markedDates) {
                markedDateStrings.add(dateFormat.format(date));
            }

            ObjectMapper objectMapper = new ObjectMapper();
            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write(objectMapper.writeValueAsString(markedDateStrings));
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"서버 오류가 발생했습니다.\"}");
        }
    }

}
