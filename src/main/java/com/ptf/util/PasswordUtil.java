
 
package com.ptf.util;

import org.mindrot.jbcrypt.BCrypt;

public class PasswordUtil {

    // 비밀번호 해싱 메서드
    public static String hashPassword(String plainPassword) {
        String salt = BCrypt.gensalt();
        return BCrypt.hashpw(plainPassword, salt);
    }

    // 비밀번호 검증 메서드
    public static boolean checkPassword(String plainPassword, String hashedPassword) {
        return BCrypt.checkpw(plainPassword, hashedPassword);
    }
}