package com.ptf.servlet;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.ptf.dao.PTFUserDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/api/users/check-duplicate-nickname")
public class CheckNicknameServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String NICKNAME_REGEX = "^[가-힣a-z0-9A-Z]{2,16}$";


    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String nickname = request.getParameter("nickname");

        if (nickname == null || nickname.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("닉네임을 입력해주세요.");
            return;
        }
        
		if (!nickname.matches(NICKNAME_REGEX)) {
		    response.setStatus(HttpServletResponse.SC_BAD_REQUEST); // 400
		    response.getWriter().write("닉네임: 2~16자의 한글, 숫자, 영문 대/소문자를 사용해 주세요. (특수기호, 공백 사용 불가)");
		    return;
		}

        PTFUserDAO userDAO = new PTFUserDAO();
        boolean isNicknameUnique = userDAO.userSelectByNickname(nickname);

        // JSON 응답 생성
        Map<String, Boolean> responseData = new HashMap<>();
        responseData.put("isNicknameUnique", isNicknameUnique);


        response.setContentType("application/json; charset=UTF-8");
        response.setStatus(HttpServletResponse.SC_OK); // 200 OK
        ObjectMapper objectMapper = new ObjectMapper();
        response.getWriter().write(objectMapper.writeValueAsString(responseData));
    }
}
