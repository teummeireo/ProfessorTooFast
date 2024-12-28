package com.ptf.util;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;
import java.util.Timer;
import java.util.TimerTask;
import java.util.concurrent.ConcurrentHashMap;

@WebListener
public class IsSubmitScheduler implements ServletContextListener {

    private Timer timer;

    // 전역적으로 isSubmit 값을 저장하는 구조 (예: 캐싱)
    private static final ConcurrentHashMap<Integer, Boolean> isSubmitCache = new ConcurrentHashMap<>();

    public static void updateIsSubmit(int userId, boolean value) {
        isSubmitCache.put(userId, value);
    }

    public static boolean getIsSubmit(int userId) {
        return isSubmitCache.getOrDefault(userId, false);
    }

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        timer = new Timer(true);

        // 매일 자정 초기화 작업
        timer.scheduleAtFixedRate(new TimerTask() {
            @Override
            public void run() {
                System.out.println("자정 초기화 작업 실행");
                isSubmitCache.clear(); // 모든 사용자 isSubmit 초기화
            }
        }, getInitialDelay(), 24 * 60 * 60 * 1000); // 자정부터 24시간 간격 실행
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        if (timer != null) {
            timer.cancel();
        }
    }

    private long getInitialDelay() {
        // 현재 시각과 자정까지의 남은 시간을 계산
        long now = System.currentTimeMillis();
        long midnight = now + (24 * 60 * 60 * 1000 - (now % (24 * 60 * 60 * 1000)));
        return midnight - now;
    }
}
