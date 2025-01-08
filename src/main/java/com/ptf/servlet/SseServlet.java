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
        response.setHeader("Cache-Control", "no-cache");
        response.setHeader("Connection", "keep-alive");

        synchronized (adminClients) {
            adminClients.add(response);
        }

        try {
            while (!Thread.interrupted() && !response.isCommitted()) {
                Thread.sleep(1000);
            }
        } catch (Exception e) {
            // 예외 처리 후 리스트에서 제거
        } finally {
            synchronized (adminClients) {
                adminClients.remove(response);
            }
        }
    }
    
    public static void sendNotification(String message) {
        synchronized (adminClients) {
            List<HttpServletResponse> invalidClients = new ArrayList<>();
            for (HttpServletResponse client : adminClients) {
                try {
                    if (!client.isCommitted()) {
                        client.getWriter().write("data: " + message + "\n\n");
                        client.getWriter().flush();
                    } else {
                        invalidClients.add(client);
                    }
                } catch (IOException e) {
                    invalidClients.add(client);
                }
            }
            adminClients.removeAll(invalidClients);
        }
    }
}