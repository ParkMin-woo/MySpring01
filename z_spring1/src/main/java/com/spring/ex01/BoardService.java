package com.spring.ex01;

import java.util.List;

public interface BoardService {

	public List<BoardDTO> getBoardList(BoardSearchDTO boardSearchDTO);

	public int getBoardListCnt(BoardSearchDTO boardSearchDTO);

	// public void updateBoardPrintUpCnt(BoardDTO boardDTO);

	public int insertBoardRegReplyCnt(BoardDTO boardDTO);

	// public void updateBoardHit(int bNo);

	public BoardDTO getBoard(int bNo, String flag);

	public int getSonBoardCnt(int bNo);

	public int boardUpDel(BoardDTO boardDTO);

}
