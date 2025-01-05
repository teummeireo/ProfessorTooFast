package com.ptf.util;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Properties;

public class PostgreDBManager implements DBManager {

	private String DB_URL;
	private String DB_ID;
	private String DB_PW;
	
	private static PostgreDBManager instance;
	private PostgreDBManager() {}
	 
	public static synchronized PostgreDBManager getInstance() {
		if (instance == null) {
		    instance = new PostgreDBManager();
		}
		return instance;
	}
	 
	@Override
	public Connection connect() {
		Connection conn = null;
		try {
			Class.forName("org.postgresql.Driver");
			
			//------------- DB 설정(properties) 읽어오기 -----------------------
			Properties props = new Properties();
			props.load(PostgreDBManager.class.getClassLoader().getResourceAsStream("mypostgre.properties"));
			DB_URL = props.getProperty("postgre.url");
			DB_ID  = props.getProperty("postgre.id");
			DB_PW  = props.getProperty("postgre.pw");
			System.err.println("resources/mypostgre.properties 로드........" + DB_URL);
			
			conn = DriverManager.getConnection(DB_URL, DB_ID, DB_PW);
			
			if(conn != null)
				System.out.println("postgreSQL 연결성공");
			else
				System.out.println("postgreSQL 연결실패");
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return conn;
	}
	
	@Override
	public void close(Connection conn, PreparedStatement pstmt, ResultSet rs) {
		try {
			if(rs != null) 		rs.close();
			if(pstmt != null)   pstmt.close();
			if(conn != null)    conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	@Override
	public void close(Connection conn, PreparedStatement pstmt) {
		try {
			if(pstmt != null)   pstmt.close();
			if(conn != null)    conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	

}
