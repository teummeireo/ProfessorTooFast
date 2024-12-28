package com.ptf.servlet;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.ptf.dao.PTFUserDAO;
import com.ptf.util.PasswordUtil;
import com.ptf.vo.PTFUserVO;

@WebServlet("/api/login")
public class LoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		ObjectMapper objectMapper = new ObjectMapper();
		Map<String, String> requestData;

		try {

			requestData = objectMapper.readValue(request.getInputStream(), Map.class);
		} catch (Exception e) {
			e.printStackTrace();
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST); // 400 
			response.getWriter().write("요청 데이터를 처리하는 중 오류가 발생했습니다.");
			return;
		}

		// 요청 데이터에서 loginId와 password 추출
		String loginId = requestData.get("loginId");
		String plainPassword = requestData.get("password");

		// 필수 필드 확인
		if (loginId == null || plainPassword == null) {
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST); // 400 
			response.getWriter().write("로그인 ID와 비밀번호를 입력해주세요.");
			return;
		}


		PTFUserDAO userDAO = new PTFUserDAO();
		PTFUserVO user = userDAO.userSelect(loginId);
		System.out.println(user);

		if (user == null) {

			response.setStatus(HttpServletResponse.SC_UNAUTHORIZED); // 401 
			response.getWriter().write("아이디가 일치하지 않습니다.");
			return;
		}

		// 비밀번호 검증
		if (!PasswordUtil.checkPassword(plainPassword, user.getPassword())) {
			// 비밀번호 불일치
			response.setStatus(HttpServletResponse.SC_UNAUTHORIZED); // 401
			response.getWriter().write("비밀번호가 일치하지 않습니다.");
			return;
		}

		 // 세션 생성 및 사용자 정보 저장
        HttpSession session = request.getSession(true);
        session.setAttribute("userId", user.getUserId());
        session.setAttribute("loginId", user.getLoginId());
        session.setAttribute("nickname", user.getNickname());
        session.setAttribute("role", user.getRole());

        // 세션 ID를 클라이언트 쿠키로 저장
        Cookie sessionCookie = new Cookie("SESSIONID", session.getId());
        sessionCookie.setHttpOnly(true); // 클라이언트 스크립트에서 접근 불가
        sessionCookie.setPath("/"); // 루트 경로에 대해 유효
        sessionCookie.setMaxAge(60 * 60); // 1시간
        response.addCookie(sessionCookie);

        // 응답 데이터 생성
        Map<String, Object> responseData = new HashMap<>();
        responseData.put("userId", user.getUserId());
        responseData.put("loginId", user.getLoginId());
        responseData.put("nickname", user.getNickname());
        responseData.put("role", user.getRole().name().toLowerCase());

        response.setContentType("application/json; charset=UTF-8");
        response.setStatus(HttpServletResponse.SC_OK); // 200 OK
        objectMapper.writeValue(response.getWriter(), responseData);
        
	}
}