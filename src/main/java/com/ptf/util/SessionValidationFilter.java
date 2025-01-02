package com.ptf.util;

import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;



@WebFilter("/*")
public class SessionValidationFilter implements Filter {
	
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // 필터 초기화 작업 (필요하면 구현)
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) 
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        // 캐시 제어 헤더 추가
        httpResponse.setHeader("Cache-Control", "private, no-cache, no-store, must-revalidate"); //정적 리소스는 캐싱 가능, 민감한 데이터는 캐싱 비활성화.
        httpResponse.setHeader("Expires", "0");
        httpResponse.setHeader("Pragma", "no-cache");
//        // 세션 검증
//        HttpSession session = httpRequest.getSession(false);
//        if (session == null || session.getAttribute("userId") == null) {
//        	// 세션이 없거나 사용자 정보가 없으면 로그인 페이지로 리다이렉트
//            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
//            return; // 필터 체인 중단
//        }

        // 다음 필터 또는 서블릿으로 요청 전달
        chain.doFilter(request, response);
    }


    @Override
    public void destroy() {
    }
}
