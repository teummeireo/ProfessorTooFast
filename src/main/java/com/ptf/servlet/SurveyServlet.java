package com.ptf.servlet;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.ptf.dao.PTFUserDAO;
import com.ptf.dao.StatisticsDAO;
import com.ptf.dao.SurveyDAO;
import com.ptf.util.AuthenticationUtil;
import com.ptf.util.SessionUtil;
import com.ptf.vo.SurveyVO;
import com.ptf.vo.PTFUserVO;;

@WebServlet("/api/surveys")
public class SurveyServlet extends HttpServlet {
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
			response.getWriter().write("{\"error\": \"날짜 파라미터를 제공해주세요.\"}");
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
			SurveyDAO surveyDAO = new SurveyDAO();
			ArrayList<SurveyVO> surveysByDate = surveyDAO.surveySelectByCreateAt(createAt);

			if (surveysByDate.isEmpty()) {
				response.setStatus(HttpServletResponse.SC_NOT_FOUND);
				response.getWriter().write("{\"message\": \"해당 날짜에 설문 데이터가 없습니다.\"}");
				return;
			}

			response.setStatus(HttpServletResponse.SC_OK);
			ObjectMapper objectMapper = new ObjectMapper();
			objectMapper.disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);
			response.getWriter().write(objectMapper.writeValueAsString(surveysByDate));
			SessionUtil.refreshSessionTimeout(request); // 세션 타임아웃 갱신
		} catch (Exception e) {
			e.printStackTrace();
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			response.getWriter().write("{\"error\": \"서버 오류가 발생했습니다.\"}");
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// 세션과 쿠키 인증
		if (!AuthenticationUtil.isAuthenticated(request, response)) {
			return;
		}

		// USER 권한 확인
		if (!AuthenticationUtil.checkRole(request, response, "USER")) {
			return; // 권한 부족 시 요청 중단
		}

		ObjectMapper objectMapper = new ObjectMapper();
		Map<String, String> requestData;

		try {
			requestData = objectMapper.readValue(request.getInputStream(), Map.class);
		} catch (Exception e) {
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
			response.getWriter().write("요청 데이터를 처리하는 중 오류가 발생했습니다.");
			return;
		}

		try {
			// 요청 데이터 파싱
			String difficultyStr = requestData.get("difficulty");
			String speedStr = requestData.get("speed");
			String materialStr = requestData.get("material");

			// 필수 설문 문항 확인
			if (difficultyStr == null || difficultyStr.isEmpty() || speedStr == null || speedStr.isEmpty()
					|| materialStr == null || materialStr.isEmpty()) {
				response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
				response.getWriter().write("필수 설문 문항에 모두 답해주세요.");
				return;
			}

			int userId = Integer.parseInt(requestData.get("userId"));
			int difficulty = Integer.parseInt(difficultyStr);
			int speed = Integer.parseInt(speedStr);
			int material = Integer.parseInt(materialStr);
			String questions = requestData.get("questions");
			String comments = requestData.get("comments");

			HttpSession session = request.getSession();
			Integer sessionUserId = (Integer) session.getAttribute("userId");

			if (sessionUserId == null || !sessionUserId.equals(userId)) {
				response.setStatus(HttpServletResponse.SC_FORBIDDEN);
				response.getWriter().write("로그인한 ID와 요청한 ID가 일치하지 않습니다.");
				return;
			}

			// 오늘자 제출한 설문이 있는지 백엔드에서도 다시 확인
			SurveyDAO surveyDAO = new SurveyDAO();
			ArrayList<SurveyVO> todaySurveys = surveyDAO.surveySelectByCreateAt(new Date());
			boolean isSubmit = todaySurveys.stream().anyMatch(survey -> survey.getUserId() == userId);
			if (isSubmit) {
				response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
				response.getWriter().write("오늘자 설문을 이미 제출했습니다");
				return;
			}

			// 통계 업데이트 및 설문 저장
			StatisticsDAO statisticsDAO = new StatisticsDAO();
			int statisticsId = statisticsDAO.statisticsUpsert(difficulty, speed, material);

			if (statisticsId == -1) {
				response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
				response.getWriter().write("통계 데이터를 저장하는 중 오류가 발생했습니다.");
				return;
			}

			SurveyVO survey = new SurveyVO();
			survey.setUserId(userId);
			survey.setStatisticsId(statisticsId);
			survey.setDifficulty(difficulty);
			survey.setSpeed(speed);
			survey.setMaterial(material);
			survey.setQuestions(questions);
			survey.setComments(comments);

			int rowsInserted = surveyDAO.surveyInsert(survey);

			if (rowsInserted == 1) {
				response.setStatus(HttpServletResponse.SC_CREATED);
				response.getWriter().write("설문이 성공적으로 제출되었습니다.");
				SessionUtil.refreshSessionTimeout(request);

				// ADMIN 사용자에게 알림 전송
				PTFUserDAO userDAO = new PTFUserDAO();
				ArrayList<PTFUserVO> adminUsers = userDAO.selectAllAdmins(); // 새 메서드 필요
				String notificationMessage = "새로운 설문이 제출되었습니다.";

				for (PTFUserVO admin : adminUsers) {
					SseServlet.sendNotification(notificationMessage);
				}
				SessionUtil.refreshSessionTimeout(request);

			} else {
				response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
				response.getWriter().write("설문 데이터를 저장하는 중 오류가 발생했습니다.");
				SessionUtil.refreshSessionTimeout(request);
			}
		} catch (Exception e) {
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			response.getWriter().write("서버 오류가 발생했습니다.");
			e.printStackTrace();
		}
	}

}
