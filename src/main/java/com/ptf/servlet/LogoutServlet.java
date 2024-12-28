package com.ptf.servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/api/logout")
public class LogoutServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

	}


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// 현재 세션 가져오기 (없으면 null 반환)
        HttpSession session = request.getSession(false);

        if (session != null) {
            session.invalidate();
        }

        // 세션 쿠키 제거
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("SESSIONID".equals(cookie.getName())) {
                    // 쿠키 삭제 설정s
                    cookie.setValue("");
                    cookie.setPath("/");
                    cookie.setMaxAge(0); // 즉시 만료
                    response.addCookie(cookie);
                }
            }
        }

        response.setStatus(HttpServletResponse.SC_OK); // 200 OK
        response.getWriter().write("로그아웃이 완료되었습니다.");
    }

}
