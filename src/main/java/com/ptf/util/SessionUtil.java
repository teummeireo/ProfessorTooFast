package com.ptf.util;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

public class SessionUtil {

    private static final int SESSION_TIMEOUT = 3600; // 1시간 

    /**
     * 세션 유효시간을 갱신합니다.
     * 
     * @param request HttpServletRequest 객체
     */
    public static void refreshSessionTimeout(HttpServletRequest request) {
        HttpSession session = request.getSession(false); // 현재 세션 가져오기 (없으면 null)
        if (session != null) {
            session.setMaxInactiveInterval(SESSION_TIMEOUT); // 세션 유효시간 초기화
        }
    }
}