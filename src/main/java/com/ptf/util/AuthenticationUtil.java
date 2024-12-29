package com.ptf.util;

import javax.servlet.http.*;

import java.io.IOException;
import java.util.Optional;

public class AuthenticationUtil {

    /**
     * 세션과 쿠키를 검증하여 인증 상태를 확인합니다.
     * 
     * @param request  HttpServletRequest 객체
     * @param response HttpServletResponse 객체
     * @return 인증된 경우 true, 인증되지 않은 경우 false
     */
    public static boolean isAuthenticated(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);

        if (session == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("로그인이 필요합니다.");
            
            return false;
        }

        Cookie[] cookies = Optional.ofNullable(request.getCookies()).orElse(new Cookie[0]);
        for (Cookie cookie : cookies) {
            if ("SESSIONID".equals(cookie.getName())) {
                String sessionId = (String) session.getId();
                if (cookie.getValue().equals(sessionId)) {
                    return true; // 인증 성공
                }
            }
        }
        // 인증 실패
        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
        response.getWriter().write("로그인이 필요합니다.");
        
        return false;
    }
    
    /**
     * Checks if the user's role matches the required role.
     * @param request HTTP request object.
     * @param response HTTP response object.
     * @param requiredRole The role required to access the resource (e.g., "ADMIN" or "USER").
     * @return true if the user's role matches the required role, false otherwise.
     * @throws IOException If an error occurs while writing the response.
     */
    public static boolean checkRole(HttpServletRequest request, HttpServletResponse response, String requiredRole) throws IOException {
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("role");

        if (role == null || !role.equals(requiredRole)) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            response.setContentType("application/json; charset=UTF-8");
            response.getWriter().write(String.format("{\"error\": \"해당 API는 %s만 접근할 수 있습니다.\"}", requiredRole.equals("ADMIN") ? "관리자" : "일반 사용자"));
            return false;
        }
        return true;
    }
}
