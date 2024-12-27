
package com.ptf.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.ptf.util.DBManager;
import com.ptf.util.OracleDBManager;
import com.ptf.vo.UserVO;
import com.ptf.vo.UserVO.Role;


public class UserDAO {

	// -------------------------------insert------------------------
	public int userInsert(UserVO uvo) {
		DBManager dbm = OracleDBManager.getInstance();
		Connection conn = dbm.connect();
		PreparedStatement pstmt = null;
		int rows = 0;
		try {
			conn.setAutoCommit(false);

			String sql = "INSERT INTO user(user_id, role, login_id, password, nickname, join_code) "
	                   + "VALUES(seq_user_id.nextval, ?, ?, ?, ?, ?)";
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, uvo.getRole().name());
	        pstmt.setString(2, uvo.getLoginId());
	        pstmt.setString(3, uvo.getPassword());
	        pstmt.setString(4, uvo.getNickname());
	        pstmt.setString(5, uvo.getJoinCode());
			rows = pstmt.executeUpdate();
			if (rows == 1) {
				conn.commit();
			} else {
				conn.rollback();
			}
	    } catch (SQLException e) {
	        e.printStackTrace();
	        try {
	            if (conn != null) conn.rollback(); 
	        } catch (SQLException rollbackEx) {
	            rollbackEx.printStackTrace();
	        }
	    } finally {
	        dbm.close(conn, pstmt);
	    }
	    return rows;
	}
	
//-------------------------------select by userId------------------------	
	public UserVO userSelect(int userId) {
		UserVO uvo = null; // 초기값을 null로 설정

		DBManager dbm = OracleDBManager.getInstance();
		Connection conn = dbm.connect();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			String sql = "select * from myboard where user_id=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, userId);
			rs = pstmt.executeQuery();

			if (rs.next()) { 
				uvo = new UserVO(); 
				uvo.setLoginId(rs.getString("login_id"));
				uvo.setNickname(rs.getString("nickname"));
				uvo.setRole(Role.valueOf(rs.getString("role")));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			dbm.close(conn, pstmt, rs);
		}
		return uvo;
	}

	// -------------------------------select by loginId------------------------
	public UserVO userSelect(String loginId) {
		UserVO uvo = null; // 초기값을 null로 설정

		DBManager dbm = OracleDBManager.getInstance();
		Connection conn = dbm.connect();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			// 
			String sql = "select * from myboard where login_id=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, loginId);
			rs = pstmt.executeQuery();

			if (rs.next()) { 
				uvo = new UserVO();
				uvo.setUserId(rs.getInt("user_id"));
				uvo.setNickname(rs.getString("nickname"));
				uvo.setRole(Role.valueOf(rs.getString("role")));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			dbm.close(conn, pstmt, rs);
		}
		return uvo;
	}
	
	public boolean userSelectByNickname(String nickname) {
	    DBManager dbm = OracleDBManager.getInstance();  
	    Connection conn = dbm.connect();
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    boolean isNicknameUnique = true; 

	    try {
	        String sql = "SELECT COUNT(*) FROM myboard WHERE nickname = ?";
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, nickname); 
	        rs = pstmt.executeQuery();  

	        if (rs.next()) {
	            int count = rs.getInt(1);
	            if (count != 0)
	            	isNicknameUnique = false;
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    } finally {
	        dbm.close(conn, pstmt, rs);
	    }
	    return isNicknameUnique; // 닉네임이 유일하면 true, 중복되면 false 반환
	}

}
