
package com.ptf.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.ptf.util.DBManager;
import com.ptf.util.OracleDBManager;
import com.ptf.vo.PTFUserVO;
import com.ptf.vo.PTFUserVO.Role;


public class PTFUserDAO {

	// -------------------------------insert------------------------
	public int userInsert(PTFUserVO uvo) {
		DBManager dbm = OracleDBManager.getInstance();
		Connection conn = dbm.connect();
		PreparedStatement pstmt = null;
		int rows = 0;
		try {
			conn.setAutoCommit(false);

			String sql = "INSERT INTO ptfuser(user_id, role, login_id, password, nickname, join_code) "
	                   + "VALUES(seq_ptfuser_id.nextval, ?, ?, ?, ?, ?)";
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
	public PTFUserVO userSelect(int userId) {
		PTFUserVO uvo = null; // 초기값을 null로 설정

		DBManager dbm = OracleDBManager.getInstance();
		Connection conn = dbm.connect();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			String sql = "select * from ptfuser where user_id=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, userId);
			rs = pstmt.executeQuery();

			if (rs.next()) { 
				uvo = new PTFUserVO(); 
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
	public PTFUserVO userSelect(String loginId) {
		PTFUserVO uvo = null; // 초기값을 null로 설정

		DBManager dbm = OracleDBManager.getInstance();
		Connection conn = dbm.connect();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			// 
			String sql = "select * from ptfuser where login_id=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, loginId);
			rs = pstmt.executeQuery();

			if (rs.next()) { 
				uvo = new PTFUserVO();
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
	        String sql = "SELECT COUNT(*) FROM ptfuser WHERE nickname = ?";
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
