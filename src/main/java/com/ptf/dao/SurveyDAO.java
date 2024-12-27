
package com.ptf.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;

import com.ptf.util.DBManager;
import com.ptf.util.OracleDBManager;
import com.ptf.vo.SurveyVO;

public class SurveyDAO {
	
	//------------------------------insert---------------------------------
	public int surveyInsert(SurveyVO svo) {
	    DBManager dbm  = OracleDBManager.getInstance();
	    Connection conn = dbm.connect();
	    PreparedStatement pstmt = null;
	    int rows = 0;

	    try {   
	        conn.setAutoCommit(false);

	        String sql = "INSERT INTO survey(survey_id, user_id, statistics_id, difficulty, speed, material, questions, comments) "
	                   + "VALUES(seq_survey_id.nextval, ?, ?, ?, ?, ?, ?, ?)";
	        pstmt = conn.prepareStatement(sql);

	        pstmt.setInt(1, svo.getUserId());
	        pstmt.setInt(2, svo.getStatisticsId());
	        pstmt.setInt(3, svo.getDifficulty());
	        pstmt.setInt(4, svo.getSpeed());
	        pstmt.setInt(5, svo.getMaterial());
	        pstmt.setString(6, svo.getQuestions());
	        pstmt.setString(7, svo.getComments());

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
	
	//------------------------------select by userId---------------------------------
	public ArrayList<SurveyVO> surveySelect(int userId) {
	    ArrayList<SurveyVO> surveyList = new ArrayList<>();
	    DBManager dbm = OracleDBManager.getInstance();
	    Connection conn = dbm.connect();
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    try {
	        String sql = "SELECT * FROM survey WHERE user_id = ?";
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setInt(1, userId); 
	        rs = pstmt.executeQuery();

	        while (rs.next()) { 
	            SurveyVO svo = new SurveyVO();
	            svo.setSurveyId(rs.getInt("survey_id"));
	            svo.setUserId(rs.getInt("user_id"));
	            svo.setStatisticsId(rs.getInt("statistics_id"));
	            svo.setDifficulty(rs.getInt("difficulty"));
	            svo.setSpeed(rs.getInt("speed"));
	            svo.setMaterial(rs.getInt("material"));
	            svo.setQuestions(rs.getString("questions"));
	            svo.setComments(rs.getString("comments"));
	            svo.setCreateAt(rs.getDate("create_at")); 

	            surveyList.add(svo);
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    } finally {
	        dbm.close(conn, pstmt, rs);
	    }

	    return surveyList;
	}
	
	//------------------------------select by createAt---------------------------------
	public ArrayList<SurveyVO> surveySelectByCreateAt(Date createAt) {
	    ArrayList<SurveyVO> surveyList = new ArrayList<>();
	    DBManager dbm = OracleDBManager.getInstance();
	    Connection conn = dbm.connect();
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    try {
	        String sql = "SELECT * FROM survey WHERE TRUNC(create_at) = TRUNC(?)"; // 날짜 비교
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setDate(1, new java.sql.Date(createAt.getTime())); 
	        rs = pstmt.executeQuery();

	        while (rs.next()) { 
	            SurveyVO svo = new SurveyVO();
	            svo.setSurveyId(rs.getInt("survey_id"));
	            svo.setUserId(rs.getInt("user_id"));
	            svo.setStatisticsId(rs.getInt("statistics_id"));
	            svo.setDifficulty(rs.getInt("difficulty"));
	            svo.setSpeed(rs.getInt("speed"));
	            svo.setMaterial(rs.getInt("material"));
	            svo.setQuestions(rs.getString("questions"));
	            svo.setComments(rs.getString("comments"));
	            svo.setCreateAt(rs.getDate("create_at"));

	            surveyList.add(svo); 
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    } finally {
	        dbm.close(conn, pstmt, rs);
	    }

	    return surveyList;
	}


}
