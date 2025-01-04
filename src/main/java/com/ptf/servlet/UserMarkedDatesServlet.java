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
 * Servlet implementation class UserMarkedDatesServlet
 */
@WebServlet("/api/user-marked-dates")
public class UserMarkedDatesServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json; charset=UTF-8");

        try {
            // 쿼리 파라미터에서 사용자 ID 추출
            String userIdParam = request.getParameter("userId");
            if (userIdParam == null || userIdParam.isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\": \"userId가 필요합니다.\"}");
                return;
            }

            int userId = Integer.parseInt(userIdParam);

            StatisticsDAO statisticsDAO = new StatisticsDAO();
            // 사용자 전용 마킹된 날짜 가져오기
            ArrayList<Date> markedDates = statisticsDAO.getUserMarkedDates(userId);

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
