package com.ptf.servlet;

import java.io.IOException;
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

        synchronized (adminClients) {
            adminClients.add(response);
        }

        try {
            while (true) {
                Thread.sleep(1000);
                if (response.isCommitted()) {
                    break;
                }
            }
        } catch (Exception e) {
            adminClients.remove(response);
        }
    }

    public static void sendNotification(String message) {
        synchronized (adminClients) {
            for (HttpServletResponse client : adminClients) {
                try {
                    client.getWriter().write("data: " + message + "\n\n");
                    client.getWriter().flush();
                } catch (IOException e) {
                    adminClients.remove(client);
                }
            }
        }
    }
}