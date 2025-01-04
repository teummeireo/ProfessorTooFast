
package com.ptf.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;

import com.ptf.util.DBManager;
import com.ptf.util.OracleDBManager;
import com.ptf.vo.StatisticsVO;

public class StatisticsDAO {

	// ---------------------------------upsert-------------------
	public int statisticsUpsert(int difficulty, int speed, int material) {
		DBManager dbm = OracleDBManager.getInstance();
		Connection conn = dbm.connect();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int statisticsId = -1;

		try {
			conn.setAutoCommit(false);
			java.sql.Date today = new java.sql.Date(System.currentTimeMillis());

			// 오늘 날짜에 해당하는 통계가 존재하는지 확인
			String selectSql = "SELECT * FROM Statistics WHERE record_date = ?";
			pstmt = conn.prepareStatement(selectSql);
			pstmt.setDate(1, today);
			rs = pstmt.executeQuery();

			if (rs.next()) {
				statisticsId = rs.getInt("statistics_id");
				int population = rs.getInt("population") + 1;
				float newAvgDifficulty = (rs.getFloat("avg_difficulty") * rs.getInt("population") + difficulty)
						/ population;
				float newAvgSpeed = (rs.getFloat("avg_speed") * rs.getInt("population") + speed) / population;
				float newAvgMaterial = (rs.getFloat("avg_material") * rs.getInt("population") + material) / population;

				String updateSql = "UPDATE Statistics SET avg_difficulty = ?, avg_speed = ?, avg_material = ?, population = ? WHERE statistics_id = ?";
				pstmt = conn.prepareStatement(updateSql);
				pstmt.setFloat(1, newAvgDifficulty);
				pstmt.setFloat(2, newAvgSpeed);
				pstmt.setFloat(3, newAvgMaterial);
				pstmt.setInt(4, population);
				pstmt.setInt(5, statisticsId);
				pstmt.executeUpdate();
			} else {
				String insertSql = "INSERT INTO Statistics(statistics_id, record_date, avg_difficulty, avg_speed, avg_material, population) "
						+ "VALUES(SEQ_STATISTICS_ID.NEXTVAL, ?, ?, ?, ?, 1)";
				pstmt = conn.prepareStatement(insertSql, new String[]{"STATISTICS_ID"});
				pstmt.setDate(1, today);
				pstmt.setFloat(2, difficulty);
				pstmt.setFloat(3, speed);
				pstmt.setFloat(4, material);			
				pstmt.executeUpdate();
				
	            rs = pstmt.getGeneratedKeys();
				if (rs.next()) {
					statisticsId = rs.getInt(1);
				}
			}
			conn.commit();
		} catch (SQLException e) {
			e.printStackTrace();
			try {
				if (conn != null)
					conn.rollback();
			} catch (SQLException rollbackEx) {
				rollbackEx.printStackTrace();
			}
		} finally {
			dbm.close(conn, pstmt, rs);
		}

		return statisticsId;
	}

	// --------------------------------- select by recordDate
	// ---------------------------------------------
	public StatisticsVO statisticsSelectByDate(Date recordDate) {
		DBManager dbm = OracleDBManager.getInstance();
		Connection conn = dbm.connect();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		StatisticsVO statistics = null;

		try {
			String sql = "SELECT * FROM Statistics WHERE TRUNC(record_date) = TRUNC(?)"; // 날짜 비교
			pstmt = conn.prepareStatement(sql);
			pstmt.setDate(1, new java.sql.Date(recordDate.getTime()));
			rs = pstmt.executeQuery();

			if (rs.next()) { // 결과가 존재하는 경우
				statistics = new StatisticsVO();
				statistics.setStatisticsId(rs.getInt("statistics_id"));
				statistics.setRecordDate(rs.getDate("record_date"));
				statistics.setAvgDifficulty(rs.getFloat("avg_difficulty"));
				statistics.setAvgSpeed(rs.getFloat("avg_speed"));
				statistics.setAvgMaterial(rs.getFloat("avg_material"));
				statistics.setPopulation(rs.getInt("population"));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			dbm.close(conn, pstmt, rs);
		}

		return statistics;
	}

	// ---------------------------------select by month-------------------
	public ArrayList<StatisticsVO> surveySelectByMonth(Date month) {
		ArrayList<StatisticsVO> statisticsList = new ArrayList<>();
		DBManager dbm = OracleDBManager.getInstance();
		Connection conn = dbm.connect();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		// 월의 첫 날과 마지막 날을 계산
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(month);
		calendar.set(Calendar.DAY_OF_MONTH, 1);
		java.sql.Date firstDayOfMonth = new java.sql.Date(calendar.getTimeInMillis());

		calendar.set(Calendar.DAY_OF_MONTH, calendar.getActualMaximum(Calendar.DAY_OF_MONTH));
		java.sql.Date lastDayOfMonth = new java.sql.Date(calendar.getTimeInMillis());

		try {
			String sql = "SELECT * FROM Statistics WHERE record_date BETWEEN ? AND ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setDate(1, firstDayOfMonth);
			pstmt.setDate(2, lastDayOfMonth);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				StatisticsVO statistics = new StatisticsVO();
				statistics.setStatisticsId(rs.getInt("statistics_id"));
				statistics.setRecordDate(rs.getDate("record_date"));
				statistics.setAvgDifficulty(rs.getFloat("avg_difficulty"));
				statistics.setAvgSpeed(rs.getFloat("avg_speed"));
				statistics.setAvgMaterial(rs.getFloat("avg_material"));
				statistics.setPopulation(rs.getInt("population"));

				statisticsList.add(statistics);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			dbm.close(conn, pstmt, rs);
		}

		return statisticsList; // 결과 리스트 반환
	}

	// ---------------------------------select by period-------------------
	public ArrayList<StatisticsVO> surveySelectByPeriod(Date startDate, Date endDate) {
		ArrayList<StatisticsVO> statisticsList = new ArrayList<>();
		DBManager dbm = OracleDBManager.getInstance();
		Connection conn = dbm.connect();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		java.sql.Date sqlStartDate = new java.sql.Date(startDate.getTime());
		java.sql.Date sqlEndDate = new java.sql.Date(endDate.getTime());

		try {
			String sql = "SELECT * FROM Statistics WHERE record_date BETWEEN ? AND ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setDate(1, sqlStartDate);
			pstmt.setDate(2, sqlEndDate);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				StatisticsVO statistics = new StatisticsVO();
				statistics.setStatisticsId(rs.getInt("statistics_id"));
				statistics.setRecordDate(rs.getDate("record_date"));
				statistics.setAvgDifficulty(rs.getFloat("avg_difficulty"));
				statistics.setAvgSpeed(rs.getFloat("avg_speed"));
				statistics.setAvgMaterial(rs.getFloat("avg_material"));
				statistics.setPopulation(rs.getInt("population"));

				statisticsList.add(statistics); // 리스트에 추가
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			dbm.close(conn, pstmt, rs);
		}

		return statisticsList; // 결과 리스트 반환
	}
	
	
	
	//-----------------------------marked-dates---------------------------------
	
	public ArrayList<Date> getMarkedDates() throws SQLException {
	    ArrayList<Date> markedDates = new ArrayList<>();
	    String query = "SELECT DISTINCT record_date FROM statistics";
		DBManager dbm = OracleDBManager.getInstance();
		Connection conn = dbm.connect();

	    try (
	         PreparedStatement pstmt = conn.prepareStatement(query);
	         ResultSet rs = pstmt.executeQuery()) {

	        while (rs.next()) {
	            markedDates.add(rs.getDate("record_date"));
	        }
	    }
	    return markedDates;
	}


}
