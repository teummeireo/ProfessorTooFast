package com.ptf.servlet;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.CopyOnWriteArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/sse")
public class SseServlet extends HttpServlet {
	private static final List<HttpServletResponse> adminClients = new CopyOnWriteArrayList<>();

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	    response.setContentType("text/event-stream");
	    response.setCharacterEncoding("UTF-8");
	    response.setHeader("Pragma", "no-cache");
	    response.setHeader("Cache-Control", "no-cache");
	    response.setHeader("Expires", "0");
	    response.setHeader("Connection", "keep-alive");
	    response.setHeader("Access-Control-Allow-Origin", "*");
	    response.setHeader("Access-Control-Allow-Credentials", "true");

	    synchronized (adminClients) {
	        adminClients.add(response);
	    }

	    try {
	        while (true) {
	            Thread.sleep(15000); // 15초마다
	            response.getWriter().write("event: heartbeat\n\n");
	            response.getWriter().flush();
	        }
	    } catch (IOException | InterruptedException e) {
	        adminClients.remove(response); // 에러 발생 시 클라이언트 제거
	        e.printStackTrace();
	    }
	}

	public static void sendNotification(String message) {
	    synchronized (adminClients) {
	        List<HttpServletResponse> invalidClients = new ArrayList<>();
	        for (HttpServletResponse client : adminClients) {
	        	System.out.println("클라이언트 상태: " + client.isCommitted());

	        	try {
	        		System.out.println("SSE 메시지 전송 시도: " + message);
	        	    client.getWriter().write("data: " + message + "\n\n");
	        	    client.getWriter().flush();
	        	} catch (IOException e) {
	        	    invalidClients.add(client); // 클라이언트를 제거 리스트에 추가
	        	    e.printStackTrace();
	        	}
	        }
	        // 무효화된 클라이언트 제거
	        adminClients.removeAll(invalidClients);

	        // 디버깅 로그
	        System.out.println("알림 전송: " + message);
	        System.out.println("현재 유효한 클라이언트 수: " + adminClients.size());
	    }
	}

}