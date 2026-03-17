package com.spring.ex01;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
//[서비스 클래스]인 [LoginServiceImpl 클래스] 선언
//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
	// [서비스 클래스]에는 @Service와 @Transactional을 붙인다.
	// -----------------------------------------------------------
	// @Service			=> [서비스 클래스]임을 지정하고, bean 태그로 자동 등록된다.
	// @Transactional	=> [서비스 클래스]의 메소드 내부에서 일어나는 모든 작업에는 [트랜잭션]이 걸린다.
//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm

@Service
public class LoginServiceImpl implements LoginService {

	// ****************************************************
	// 속성변수 loginDAO 선언하고, loginDAO라는 인터페이스를 구현한 클래스를 객체화하여 저장
	// ****************************************************
		// @Autowired이 붙은 속성변수에는 인터페이스 자료형을 쓰고,
		// 이 인터페이스를 구현한 클래스를 객체화하여 저장한다.
		// loginDAO라는 인터페이스를 구현한 클래스의 이름은 몰라도 관계없다.
		// 1개 존재하기만 하면 된다.
	// ***********************************************************
	@Autowired
	private LoginDAO loginDAO;
	
	@Override
	public int getLoginIdCnt(LoginDTO loginDTO) {
		return this.loginDAO.getLoginIdCnt(loginDTO);
	}

}
