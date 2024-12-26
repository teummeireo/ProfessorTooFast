package com.ptf.util;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public interface DBManager {
	public Connection connect();
	public void close(Connection conn, PreparedStatement pstmt, ResultSet rs);
	public void close(Connection conn, PreparedStatement pstmt);
	
}
