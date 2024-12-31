
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
	    DBManager dbm = OracleDBManager.getInstance();
	    int rows = 0;

	    try (Connection conn = dbm.connect();
	         PreparedStatement pstmt = conn.prepareStatement(
	             "INSERT INTO survey(survey_id, user_id, statistics_id, difficulty, speed, material, questions, comments, create_at) "
	           + "VALUES(seq_survey_id.nextval, ?, ?, ?, ?, ?, ?, ?, ?)"
	         )) {

	        conn.setAutoCommit(false);
	        pstmt.setInt(1, svo.getUserId());
	        pstmt.setInt(2, svo.getStatisticsId());
	        pstmt.setInt(3, svo.getDifficulty());
	        pstmt.setInt(4, svo.getSpeed());
	        pstmt.setInt(5, svo.getMaterial());
	        pstmt.setString(6, svo.getQuestions());
	        pstmt.setString(7, svo.getComments());
	        pstmt.setDate(8, new java.sql.Date(System.currentTimeMillis()));

	        rows = pstmt.executeUpdate();

	        if (rows > 0) conn.commit();
	        else conn.rollback();
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }

	    return rows;
	}
	
	//------------------------------select by userId---------------------------------
	public ArrayList<SurveyVO> surveySelect(int userId) {
	    ArrayList<SurveyVO> surveyList = new ArrayList<>();
	    DBManager dbm = OracleDBManager.getInstance();

	    String sql = "SELECT * FROM survey WHERE user_id = ?";

	    try (Connection conn = dbm.connect();
	         PreparedStatement pstmt = conn.prepareStatement(sql)) {

	        pstmt.setInt(1, userId);

	        try (ResultSet rs = pstmt.executeQuery()) {
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
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }

	    return surveyList;
	}
	
	//------------------------------select by userId and createAt---------------------------------
	public SurveyVO surveySelect(int userId, Date createAt) {
	    SurveyVO survey = null;
	    DBManager dbm = OracleDBManager.getInstance();

	    String sql = "SELECT * FROM survey WHERE user_id = ? AND create_at BETWEEN ? AND ?";

	    try (Connection conn = dbm.connect();
	         PreparedStatement pstmt = conn.prepareStatement(sql)) {

	        // 자정 계산
	        java.sql.Date startDate = new java.sql.Date(createAt.getTime());
	        java.sql.Date endDate = new java.sql.Date(createAt.getTime() + 86400000 - 1); // 자정 + 하루 - 1밀리초

	        pstmt.setInt(1, userId);
	        pstmt.setDate(2, startDate);
	        pstmt.setDate(3, endDate);

	        try (ResultSet rs = pstmt.executeQuery()) {
	            if (rs.next()) {
	                survey = new SurveyVO();
	                survey.setSurveyId(rs.getInt("survey_id"));
	                survey.setUserId(rs.getInt("user_id"));
	                survey.setStatisticsId(rs.getInt("statistics_id"));
	                survey.setDifficulty(rs.getInt("difficulty"));
	                survey.setSpeed(rs.getInt("speed"));
	                survey.setMaterial(rs.getInt("material"));
	                survey.setQuestions(rs.getString("questions"));
	                survey.setComments(rs.getString("comments"));
	                survey.setCreateAt(rs.getDate("create_at"));
	            }
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }

	    return survey;
	}


	
	//------------------------------select by createAt---------------------------------
	public ArrayList<SurveyVO> surveySelectByCreateAt(Date createAt) {
	    ArrayList<SurveyVO> surveyList = new ArrayList<>();
	    DBManager dbm = OracleDBManager.getInstance();

	    String sql = "SELECT * FROM survey WHERE create_at BETWEEN ? AND ?";

	    try (Connection conn = dbm.connect();
	         PreparedStatement pstmt = conn.prepareStatement(sql)) {

	        // 자정 계산
	        java.sql.Date startDate = new java.sql.Date(createAt.getTime());
	        java.sql.Date endDate = new java.sql.Date(createAt.getTime() + 86400000 - 1); // 자정 + 하루 - 1밀리초

	        pstmt.setDate(1, startDate);
	        pstmt.setDate(2, endDate);

	        try (ResultSet rs = pstmt.executeQuery()) {
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
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }

	    return surveyList;
	}



}
