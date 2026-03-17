package com.spring.ex01;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class LoginDAOImpl implements LoginDAO {
	
	// ****************************************************
	// 속성변수 sqlSession 선언하고, SqlSessionTemplate라는 인터페이스를 구현한 클래스를 객체화하여 저장
	// ****************************************************
		// @Autowired이 붙은 속성변수에는 인터페이스 자료형을 쓰고,
		// 이 인터페이스를 구현한 클래스를 객체화하여 저장한다.
		// SqlSessionTemplate라는 인터페이스를 구현한 클래스의 이름은 몰라도 관계없다.
		// 1개 존재하기만 하면 된다.
	// ***********************************************************
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	private static final String NAMESPACE = "com.spring.ex01.LoginDAO";

	@Override
	public int getLoginIdCnt(LoginDTO loginDTO) {
		
		// ------------------------------------------------------
		// SqlSessionTemplate 객체의 selectOne 메소드 호출로 [로그인 아이디, 암호의 존재 개수] 리턴
		// ------------------------------------------------------
		// selectOne( "com.spring.ex01.LoginDAO.getAdminCnt" , loginDTO );의 의미
		// ------------------------------------------------------
			// MyBatis SQL 구문 설정 XML 파일( = mapper_contact.xml )에서
			// <mapper namespace="com.spring.ex01.LoginDAO"> 태그 내부의
			// <select id="getLoginIdCnt" ~ > 태그 내부의
			// [1행 리턴 select 쿼리문]을 실행하고, 얻은 데이터를 int로 리턴한다.
			// 2번째 인자는 [select 쿼리문]에 삽입될 데이터이다.
			// 리턴 자료형은 무조건 int이다.
		// ------------------------------------------------------
		return this.sqlSessionTemplate.selectOne(
			NAMESPACE + ".getLoginIdCnt"
			, loginDTO
		);
	}

}
