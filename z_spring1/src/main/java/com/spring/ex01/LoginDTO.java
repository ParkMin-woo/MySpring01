package com.spring.ex01;

import com.fasterxml.jackson.databind.PropertyNamingStrategies;
import com.fasterxml.jackson.databind.annotation.JsonNaming;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data	// Getter, Setter, RequiredArgsConstructor, ToString, EqualsAndHashCode 한 번에 해결
@NoArgsConstructor	// Jackson 이 객체를 생설할 때 필요한 default constructor를 생성해줌.
@JsonNaming(PropertyNamingStrategies.SnakeCaseStrategy.class)	// 클래스 단위로 스네이크케이스 적용
public class LoginDTO {
	
	private String loginId;
	private String pwd;
	private String isLogin;
	
	/*
	// 명시적으로 기본 생성자를 하나 만든다...
	public LoginDTO() {
		
	}

	public String getLoginId() {
		return loginId;
	}
	
	public void setLoginId(String loginId) {
		this.loginId = loginId;
	}
	
	public String getPwd() {
		return pwd;
	}
	
	public void setPwd(String pwd) {
		this.pwd = pwd;
	}
	*/

}
