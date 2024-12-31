package com.ptf.servlet;

import com.ptf.dao.SurveyDAO;
import com.ptf.util.AuthenticationUtil;
import com.ptf.util.SessionUtil;
import com.ptf.vo.SurveyVO;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

@WebServlet("/api/mysurveys")
public class MySurveyServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// 세션과 쿠키 인증
		if (!AuthenticationUtil.isAuthenticated(request, response)) {
			return; // 인증 실패 시 요청 중단
		}
	    // USER 권한 확인
	    if (!AuthenticationUtil.checkRole(request, response, "USER")) {
	        return; // 권한 부족 시 요청 중단
	    }
		
		response.setContentType("application/json; charset=UTF-8");
		
		String userIdParam = request.getParameter("userId");

		if (userIdParam == null || userIdParam.isEmpty()) {
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
			response.getWriter().write("{\"error\": \"userId 쿼리 파라미터를 제공해주세요.\"}");
			return;
		}

		int userId;
		try {
			userId = Integer.parseInt(userIdParam);
		} catch (NumberFormatException e) {
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
			response.getWriter().write("{\"error\": \"userId는 숫자여야 합니다.\"}");
			return;
		}

		// 세션에서 userId 가져오기
		HttpSession session = request.getSession();
		Integer sessionUserId = (Integer) session.getAttribute("userId");

		if (sessionUserId == null || !sessionUserId.equals(userId)) {
			response.setStatus(HttpServletResponse.SC_FORBIDDEN);
			response.getWriter().write("{\"error\": \"로그인한 ID와 요청한 ID가 일치하지 않습니다.\"}");
			return;
		}

		// createAt 파라미터 처리
		String createAtParam = request.getParameter("createAt");
		SurveyDAO surveyDAO = new SurveyDAO();

		try {
			if (createAtParam == null || createAtParam.isEmpty()) {
				// createAt 파라미터가 없는 경우 기존 작업 수행
				ArrayList<SurveyVO> mySurveys = surveyDAO.surveySelect(userId);
				
				if (mySurveys.isEmpty()) {
					response.setStatus(HttpServletResponse.SC_NOT_FOUND);
					response.getWriter().write("{\"message\": \"작성한 설문 데이터가 없습니다.\"}");
					return;
				}

				response.setStatus(HttpServletResponse.SC_OK); // 200 OK
				ObjectMapper objectMapper = new ObjectMapper();
				objectMapper.disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);
				response.getWriter().write(objectMapper.writeValueAsString(mySurveys));
			} else {
				// createAt 파라미터가 있는 경우 특정 날짜 설문 조회
				Date createAt;
				try {
					createAt = new SimpleDateFormat("yyyy-MM-dd").parse(createAtParam);
				} catch (java.text.ParseException e) {
					response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
					response.getWriter().write("{\"error\": \"날짜는 yyyy-MM-dd 형식이어야 합니다.\"}");
					return;
				}

				SurveyVO survey = surveyDAO.surveySelect(userId, createAt);

				if (survey == null) {
					response.setStatus(HttpServletResponse.SC_NOT_FOUND);
					response.getWriter().write("{\"message\": \"해당 날짜의 설문 데이터가 없습니다.\"}");
					return;
				}

				response.setStatus(HttpServletResponse.SC_OK); // 200 OK
				ObjectMapper objectMapper = new ObjectMapper();
				objectMapper.disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);
				response.getWriter().write(objectMapper.writeValueAsString(survey));
			}

			SessionUtil.refreshSessionTimeout(request);
		} catch (Exception e) {
			e.printStackTrace();
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			response.getWriter().write("{\"error\": \"서버 오류가 발생했습니다.\"}");
		}
	}
}

