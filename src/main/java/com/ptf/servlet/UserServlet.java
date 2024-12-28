package com.ptf.servlet;

import java.io.IOException;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.ptf.dao.PTFUserDAO;
import com.ptf.util.PasswordUtil;
import com.ptf.vo.PTFUserVO;

//@WebServlet("/api/users")
public class UserServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		ObjectMapper objectMapper = new ObjectMapper();
		Map<String, String> requestData;

		try {
			// JSON 요청 바디를 Map으로 역직렬화
			requestData = objectMapper.readValue(request.getInputStream(), Map.class);
		} catch (Exception e) {
			e.printStackTrace();
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST); // 400
			response.getWriter().write("요청 데이터를 처리하는 중 오류가 발생했습니다.");
			return;
		}

		String loginId = requestData.get("loginId");
		String plainPassword = requestData.get("password");
		String nickname = requestData.get("nickname");
		String joinCode = requestData.get("joinCode");

		// 필수 필드 확인
		if (loginId == null || plainPassword == null || nickname == null || joinCode == null) {
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST); // 400
			response.getWriter().write("모든 필드를 입력해주세요.");
			return;
		}
		// 입력값 길이 검사 (64자 제한)
		if (loginId.length() > 64) {
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST); // 400
			response.getWriter().write("로그인 ID는 64자 이하로 입력해주세요.");
			return;
		}

		if (plainPassword.length() > 64) {
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST); // 400
			response.getWriter().write("비밀번호는 64자 이하로 입력해주세요.");
			return;
		}

		if (nickname.length() > 64) {
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST); // 400
			response.getWriter().write("닉네임은 64자 이하로 입력해주세요.");
			return;
		}

		// 비밀번호 해싱
		String hashedPassword = PasswordUtil.hashPassword(plainPassword);

		// 해싱된 비밀번호 길이 검사
		if (hashedPassword.length() > 64) {
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR); // 500
			response.getWriter().write("서버 오류: 해싱된 비밀번호가 너무 깁니다.");
			return;
		}

		// DAO 객체 생성
		PTFUserDAO userDAO = new PTFUserDAO();

		try {
			// loginId 중복 확인
			if (userDAO.userSelect(loginId) != null) {
				response.setStatus(HttpServletResponse.SC_CONFLICT); // 409
				response.getWriter().write("이미 사용 중인 loginId입니다.");
				return;
			}

			// nickname 중복 확인
			if (!userDAO.userSelectByNickname(nickname)) {
				response.setStatus(HttpServletResponse.SC_CONFLICT); // 409
				response.getWriter().write("이미 사용 중인 nickname입니다.");
				return;
			}

			// joinCode를 통해 역할(Role) 조회
			PTFUserVO.Role role = userDAO.getRoleByJoinCode(joinCode);
			if (role == null) {
				response.setStatus(HttpServletResponse.SC_BAD_REQUEST); // 400
				response.getWriter().write("유효하지 않은 joinCode입니다.");
				return;
			}

			// 유저 정보 생성
			PTFUserVO uvo = new PTFUserVO();
			uvo.setRole(role); // joinCode를 통해 얻은 Role 설정
			uvo.setLoginId(loginId);
			uvo.setPassword(hashedPassword);
			uvo.setNickname(nickname);
			uvo.setJoinCode(joinCode);

			// 사용자 삽입
			int rowsInserted = userDAO.userInsert(uvo);
			if (rowsInserted == 1) {
				response.setStatus(HttpServletResponse.SC_CREATED); // 201
				response.getWriter().write("회원가입이 완료되었습니다.");
			} else {
				response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR); // 500
				response.getWriter().write("회원가입 중 문제가 발생했습니다.");
			}
		} catch (Exception e) {
			e.printStackTrace();
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR); // 500
			response.getWriter().write("서버 오류가 발생했습니다.");
		}
	}
}