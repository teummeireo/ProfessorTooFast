package com.ptf.servlet;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.ptf.dao.StatisticsDAO;
import com.ptf.util.AuthenticationUtil;
import com.ptf.util.SessionUtil;
import com.ptf.vo.StatisticsVO;

@WebServlet("/api/daily-statistics")
public class DailyStatisticsServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// 세션과 쿠키 인증
		if (!AuthenticationUtil.isAuthenticated(request, response)) {
			return; // 인증 실패 시 요청 중단
		}

		response.setContentType("application/json; charset=UTF-8");

		// 세션에서 role 확인
		HttpSession session = request.getSession();
		String role = (String) session.getAttribute("role");

		// ADMIN 권한 확인
		if (!AuthenticationUtil.checkRole(request, response, "ADMIN")) {
			return; // 권한 부족 시 요청 중단
		}

		String createAtParam = request.getParameter("createAt");

		if (createAtParam == null || createAtParam.isEmpty()) {
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
			response.getWriter().write("{\"error\": \"날짜 쿼리 파라미터를 제공해주세요.\"}");
			return;
		}
		
		Date createAt;
	    try {
	        // ISO 형식의 날짜 파싱
	        createAt = new SimpleDateFormat("yyyy-MM-dd").parse(createAtParam);
	    } catch (java.text.ParseException e) {
	        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
	        response.getWriter().write("{\"error\": \"날짜는 yyyy-MM-dd 형식이어야 합니다.\"}");
	        return;
	    }
	    
	    try {
	    	StatisticsDAO statisticsDAO = new StatisticsDAO();
	    	StatisticsVO svo = statisticsDAO.statisticsSelectByDate(createAt);
	    	
	    	if (svo == null) {
	    		response.setStatus(HttpServletResponse.SC_NOT_FOUND);
	            response.getWriter().write("{\"message\": \"해당 날짜에 통계가 없습니다.\"}");
	            return;
	    	}

	        response.setStatus(HttpServletResponse.SC_OK);
	        ObjectMapper objectMapper = new ObjectMapper();
	        objectMapper.disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);
	        response.getWriter().write(objectMapper.writeValueAsString(svo));
	        SessionUtil.refreshSessionTimeout(request); // 세션 타임아웃 갱신
	    } catch (Exception e) {
	        e.printStackTrace();
	        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
	        response.getWriter().write("{\"error\": \"서버 오류가 발생했습니다.\"}");
	    }
	    
	}

}
