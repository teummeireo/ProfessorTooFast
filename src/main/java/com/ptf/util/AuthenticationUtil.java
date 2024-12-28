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
}
