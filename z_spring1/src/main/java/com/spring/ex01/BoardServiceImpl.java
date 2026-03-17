package com.spring.ex01;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
//[서비스 클래스]인 [LoginServiceImpl 클래스] 선언
//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
	// [서비스 클래스]에는 @Service와 @Transactional을 붙인다.
	// -----------------------------------------------------------
	// @Service			=> [서비스 클래스]임을 지정하고, bean 태그로 자동 등록된다.
	// @Transactional	=> [서비스 클래스]의 메소드 내부에서 일어나는 모든 작업에는 [트랜잭션]이 걸린다.
//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
@Transactional
@Service
public class BoardServiceImpl implements BoardService {

	// ***********************************************************
	// 속성변수 boardDAO 선언하고, BoardDAO라는 인터페이스를 구현한 클래스를 객체화하여 저장
	// ***********************************************************
		// @Autowired이 붙은 속성변수에는 인터페이스 자료형을 쓰고,
		// 이 인터페이스를 구현한 클래스를 객체화하여 저장한다.
		// boardDAO 라는 인터페이스를 구현한 클래스의 이름은 몰라도 관계없다.
		// 1개 존재하기만 하면 된다.
	// ***********************************************************
	@Autowired
	private BoardDAO boardDAO;

	@Override
	public List<BoardDTO> getBoardList(BoardSearchDTO boardSearchDTO) {
		return this.boardDAO.getBoardList(boardSearchDTO);
	}

	@Override
	public int getBoardListCnt(BoardSearchDTO boardSearchDTO) {
		return this.boardDAO.getBoardListCnt(boardSearchDTO);
	}

	/*
	@Override
	public void updateBoardPrintUpCnt(BoardDTO boardDTO) {
		this.boardDAO.updateBoardPrintUpCnt(boardDTO);
	}
	*/

	@Override
	public int insertBoardRegReplyCnt(BoardDTO boardDTO) {
		if(boardDTO.getBNo() > 0) {
			this.boardDAO.updateBoardPrintUpCnt(boardDTO);
		}
		
		return this.boardDAO.insertBoardRegReplyCnt(boardDTO);
	}

	/*
	@Override
	public void updateBoardHit(int bNo) {
		this.boardDAO.updateBoardHit(bNo);
	}
	*/

	@Override
	public BoardDTO getBoard(int bNo, String flag) {
		// 1. 조회수 증가 (Update)
		if(flag.equals("content")) {
			this.boardDAO.updateBoardHit(bNo);
		}
		
		// 2. 상세 정보 조회 (Select)
		return this.boardDAO.getBoard(bNo);
	}

	@Override
	public int getSonBoardCnt(int bNo) {
		return this.boardDAO.getSonBoardCnt(bNo);
	}

	@Override
	public int boardUpDel(BoardDTO boardDTO) {
		int boardUpDelCnt = 0;
		if(boardDTO.getUpDel().equals("up")) {
			boardUpDelCnt = this.boardDAO.updateBoard(boardDTO);
		}
		else if(boardDTO.getUpDel().equals("del")) {
			boardUpDelCnt = this.boardDAO.deleteBoard(boardDTO);
		}
		
		return boardUpDelCnt;
	}

}
