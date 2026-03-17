package com.spring.ex01;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class BoardDAOImpl implements BoardDAO {
	
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
	
	private static final String NAMESPACE = "com.spring.ex01.BoardDAO";
	
	@Override
	public List<BoardDTO> getBoardList(BoardSearchDTO boardSearchDTO) {
		return this.sqlSessionTemplate.selectList(
			NAMESPACE + ".getBoardList"
			, boardSearchDTO
		);
	}

	@Override
	public int getBoardListCnt(BoardSearchDTO boardSearchDTO) {
		return this.sqlSessionTemplate.selectOne(
			NAMESPACE + ".getBoardListCnt"
			, boardSearchDTO
		);
	}

	@Override
	public void updateBoardPrintUpCnt(BoardDTO boardDTO) {
		this.sqlSessionTemplate.update(
			NAMESPACE + ".updateBoardPrintUpCnt"
			, boardDTO
		);
	}

	@Override
	public int insertBoardRegReplyCnt(BoardDTO boardDTO) {
		return this.sqlSessionTemplate.insert(
			NAMESPACE + ".insertBoardRegReplyCnt"
			, boardDTO
		);
	}

	@Override
	public void updateBoardHit(int bNo) {
		this.sqlSessionTemplate.update(
			NAMESPACE + ".updateBoardHit"
			, bNo
		);
	}

	@Override
	public BoardDTO getBoard(int bNo) {
		return this.sqlSessionTemplate.selectOne(
			NAMESPACE + ".getBoard"
			, bNo
		);
	}

	@Override
	public int getSonBoardCnt(int bNo) {
		return this.sqlSessionTemplate.selectOne(
			NAMESPACE + ".getSonBoardCnt"
			, bNo
		);
	}

	@Override
	public int updateBoard(BoardDTO boardDTO) {
		return this.sqlSessionTemplate.update(
			NAMESPACE + ".updateBoard"
			, boardDTO
		);
	}

	@Override
	public int deleteBoard(BoardDTO boardDTO) {
		return this.sqlSessionTemplate.delete(
			NAMESPACE + ".deleteBoard"
			, boardDTO
		);
	}

}
