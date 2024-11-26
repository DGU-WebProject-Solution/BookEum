package dao.model;

import java.sql.*;
import java.util.*;
import java.io.*;

import dao.bean.*;

public class userDAO {
	private static userDAO instance;
	private userDAO( ) {}
	
	private Connection conn = null;
	private Properties props = new Properties();
	private Statement stmt = null;
	private PreparedStatement pstmt = null;
    private ResultSet rs = null;
    
    // 파일 읽어서 값 가져온 뒤 DB 연결
    private void dbConnection(String propertiesPath) {
    	
    	try {
			// 설정 파일 읽기
		    FileInputStream fis = new FileInputStream(propertiesPath);
		    props.load(fis);
	
		    // 설정 파일에서 값 가져오기
		    String jdbcUrl = props.getProperty("jdbc.url");
		    String username = props.getProperty("jdbc.username");
		    String password = props.getProperty("jdbc.password");
	
		    Class.forName("com.mysql.jdbc.Driver");
		    conn = DriverManager.getConnection(jdbcUrl, username, password);
    	} catch (ClassNotFoundException e) {
            System.out.println("JDBC 드라이버를 찾을 수 없습니다: " + e.getMessage());
            e.printStackTrace();
        } catch (SQLException e) {
            System.out.println("데이터베이스 연결 오류: " + e.getMessage());
            e.printStackTrace();
        } catch (IOException e) {
            System.out.println("설정 파일 읽기 오류: " + e.getMessage());
            e.printStackTrace();
        }
    }
	
	public static userDAO getInstance() {
		if(instance == null) instance = new userDAO();
		return instance;
	}
	
	public boolean isIdExist(String id, String propertiesPath) {
		boolean isExist = false;
		
		try {
			dbConnection(propertiesPath);
			String sql = "select * from User where emailId = '" + id + "';";
	        pstmt = conn.prepareStatement(sql);
	        
	        rs = pstmt.executeQuery(sql);
	        
	        if(rs.next()) {
	        	isExist = true;
				try {
					   if (pstmt != null) pstmt.close();
					   if (conn != null) {
						   conn.close();
						   conn = null;
					   }
				   }
				   catch (Exception e) {
					   throw new RuntimeException(e.getMessage());
				   }

			} else isExist = false;

		  }
		   catch (Exception e) {
			   e.printStackTrace();
		       throw new RuntimeException("Error fetching user info: " + e.getMessage());
		   }
		   finally {
			   try {
				   if (pstmt != null) pstmt.close();
				   if (conn != null) {
					   conn.close();
					   conn = null;
				   }
			   }
			   catch (Exception e) {
				   e.printStackTrace();
		           throw new RuntimeException("Error closing resources: " + e.getMessage());
			   }
		   }
        return isExist;
		
	}
	
	// 회원 가입
	public void signup(Userbean bean, String propertiesPath) {
		   
		   try {
			dbConnection(propertiesPath);

		    String maxIdSql = "SELECT MAX(id) FROM User";
	        pstmt = conn.prepareStatement(maxIdSql);
	        rs = pstmt.executeQuery();

	        int newId = 0; // 기본값 

	        if (rs.next()) {
	            newId = rs.getInt(1) + 1;  // 새로운 id: MAX 값 + 1
	        }
	        
	        conn.setAutoCommit(false);
		    
		    String query = "INSERT INTO User (id, password, name, birth, addressCity, addressGu, emailId) VALUES (?, ?, ?, ?, ?, ?, ?)";
		    PreparedStatement pstm = conn.prepareStatement(query);
		    
		    pstm.setInt(1, newId); // id 
            pstm.setString(2, bean.getPw());    // 비밀번호
            pstm.setString(3, bean.getName());        // 이름
            pstm.setString(4, bean.getBirth());       // 생년월일
            pstm.setString(5, bean.getAddressCity()); // 주소(시/군)
            pstm.setString(6, bean.getAddressGu());   // 주소(구)
            pstm.setString(7, bean.getEmailId());     // 이메일
		    
		    pstm.executeUpdate();
		    
		    conn.commit();
		  }
		   catch (Exception sqle) {
			   try {
				   conn.rollback();
			   }
			   catch(SQLException e) {
				   e.printStackTrace();
			   }
			   throw new RuntimeException(sqle.getMessage());
		   }
		   finally {
			   try {
				   if (pstmt != null) pstmt.close();
				   if (conn != null) {
					   conn.close();
					   conn = null;
				   }
			   }
			   catch (Exception e) {
				   throw new RuntimeException(e.getMessage());
			   }
		   }
		}
	
	// 로그인 함수 
	public Userbean logIn(Userbean user, String id, String pw, String propertiesPath) {
		try {
			dbConnection(propertiesPath);
		    String sql = "SELECT * FROM User WHERE emailId = '" + id + "' and password = '" + pw + "';";
	        pstmt = conn.prepareStatement(sql);
	        
	        rs = pstmt.executeQuery(sql);
	        
	        if (rs.next()) {
	        	user = new Userbean();
	            user.setId(rs.getString("id"));
	            user.setPw(rs.getString("password"));
	            user.setName(rs.getString("name"));
	            user.setBirth(rs.getString("birth"));
	            user.setAddressCity(rs.getString("addressCity"));
	            user.setAddressGu(rs.getString("addressGu"));
	            user.setEmailId(rs.getString("emailId"));
	            user.setStarRate(rs.getString("starRate"));
	        } else {
	        	user = null;
	        }

		  }
		   catch (Exception e) {
			   e.printStackTrace();
		       throw new RuntimeException("Error fetching user info: " + e.getMessage());
		   }
		   finally {
			   try {
				   if (pstmt != null) pstmt.close();
				   if (conn != null) {
					   conn.close();
					   conn = null;
				   }
			   }
			   catch (Exception e) {
				   e.printStackTrace();
		           throw new RuntimeException("Error closing resources: " + e.getMessage());
			   }
		   }
        return user;
	}
	
	// 회원 탈퇴 
	public boolean unRegister(String id, String pw, String propertiesPath) {
	    boolean success = false;  // 탈퇴 성공 여부를 추적할 변수

	    try {
	        // 데이터베이스 연결
	        dbConnection(propertiesPath);

	        // 사용자 ID와 비밀번호로 해당 사용자가 존재하는지 확인
	        String sql = "SELECT * FROM User WHERE emailId = ? AND password = ?";
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, id);
	        pstmt.setString(2, pw);
	        System.out.println("id: " + id);
	        System.out.println("pw: "+ pw);

	        rs = pstmt.executeQuery();

	        if (rs.next()) {
	            // 사용자가 존재하면 탈퇴 처리
	            String deleteSql = "DELETE FROM User WHERE emailId = '" + id + "';";
	            pstmt = conn.prepareStatement(deleteSql);
	           // pstmt.setString(1, id);
	            int rowsAffected = pstmt.executeUpdate();

	            if (rowsAffected > 0) {
	                success = true;  // 탈퇴 성공
	                System.out.println("탈퇴: "+ success);
	            } else {
	                success = false; // 탈퇴 실패
	                System.out.println("탈퇴: "+ success);
	            }
	        } else {
	            // 사용자가 존재하지 않으면 실패 처리
	            success = false;
	            System.out.println("탈퇴실패 : 사용자 미존재 ");
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	        throw new RuntimeException("Error while unregistering user: " + e.getMessage());
	    } finally {
	        try {
	            if (rs != null) rs.close();
	            if (pstmt != null) pstmt.close();
	            if (conn != null) {
	                conn.close();
	            }
	        } catch (Exception e) {
	            e.printStackTrace();
	            throw new RuntimeException("Error closing resources: " + e.getMessage());
	        }
	    }
	    return success;  // 탈퇴 성공 여부 반환
	}

	
	// 회원 정보 받아오는 함수 -> 그냥 로그인 할 때 한번에 처리하고 세션에 저장 
	public Userbean getUserInfo(Userbean user, String id, String propertiesPath) {
		try {
			dbConnection(propertiesPath);
		    String sql = "SELECT * FROM User WHERE emailId = '" + id + "';";
	        pstmt = conn.prepareStatement(sql);
	        
	        rs = pstmt.executeQuery(sql);
	        
	        if (rs.next()) {
	            user = new Userbean();
	            user.setId(rs.getString("id"));
	            user.setPw(rs.getString("password"));
	            user.setName(rs.getString("name"));
	            user.setBirth(rs.getString("birth"));
	            user.setAddressCity(rs.getString("addressCity"));
	            user.setAddressGu(rs.getString("addressGu"));
	            user.setEmailId(rs.getString("emailId"));
	            
	        }

		  }
		   catch (Exception e) {
			   e.printStackTrace();
		       throw new RuntimeException("Error fetching user info: " + e.getMessage());
		   }
		   finally {
			   try {
				   if (pstmt != null) pstmt.close();
				   if (conn != null) {
					   conn.close();
					   conn = null;
				   }
			   }
			   catch (Exception e) {
				   e.printStackTrace();
		           throw new RuntimeException("Error closing resources: " + e.getMessage());
			   }
		   }
        return user;
	}
}

