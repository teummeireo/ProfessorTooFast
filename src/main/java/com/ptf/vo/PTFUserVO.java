
package com.ptf.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;


@Data
@AllArgsConstructor
@NoArgsConstructor
public class PTFUserVO {
	private int userId;
	private Role role; 
	private String loginId;
	private String password;
	private String nickname;
	private String joinCode;
	
	
	public enum Role {
		ADMIN,
		USER
	}
}



