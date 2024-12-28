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


    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String nickname = request.getParameter("nickname");

        if (nickname == null || nickname.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("nickname을 입력해주세요.");
            return;
        }

        PTFUserDAO userDAO = new PTFUserDAO();
        boolean isNicknameUnique = userDAO.userSelectByNickname(nickname);

        // JSON 응답 생성
        Map<String, Boolean> responseData = new HashMap<>();
        responseData.put("isNicknameUnique", isNicknameUnique);


        response.setContentType("application/json; charset=UTF-8");

        ObjectMapper objectMapper = new ObjectMapper();
        response.getWriter().write(objectMapper.writeValueAsString(responseData));
    }
}
