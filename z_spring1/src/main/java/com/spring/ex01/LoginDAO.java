package com.spring.ex01;

public interface LoginDAO {

	// ******************************************************
	// [로그인 아이디, 암호 존재 개수] 검색 메소드 선언
	// ******************************************************
	public int getLoginIdCnt(LoginDTO loginDTO);

}
