package com.spring.ex01;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class BoardController {

	// ***********************************************************
	// 속성변수 boardService 선언하고, BoardService라는 인터페이스를 구현한 클래스를 객체화하여 저장
	// ***********************************************************
		// @Autowired이 붙은 속성변수에는 인터페이스 자료형을 쓰고,
		// 이 인터페이스를 구현한 클래스를 객체화하여 저장한다.
		// boardService 라는 인터페이스를 구현한 클래스의 이름은 몰라도 관계없다.
		// 1개 존재하기만 하면 된다.
	// ***********************************************************
	@Autowired
	private BoardService boardService;
	
	private static final Logger logger = LoggerFactory.getLogger(BoardController.class);
	
	// boardListForm.do 라는 가상 URL 주소에 접근했을 시
	// 즉, 로그인 성공 이후 [게시판 조회] 화면에 처음 접근 시
	// GET 방식으로 통신할 수 있도록
	// BoardSearchDTO 객체 내에 들어있는 field값을
	// 필요에 따라 수정해주는 작업을 합니다.
	@RequestMapping(value="/boardListForm.do" , method={RequestMethod.GET, RequestMethod.POST} /* , method=RequestMethod.GET */ /* , method=RequestMethod.POST */ )
	public ModelAndView boardListForm(
		// @RequestBody BoardSearchDTO boardSearchDTO
		// 스프링이 Bean DTO 객체를 자동으로 생성해서 넣어줍니다 (기본값 전략)
		BoardSearchDTO boardSearchDTO
	) {
		// -----------------------------
		// ModelAndView 객체 생성
		// -----------------------------
		ModelAndView mav = new ModelAndView();
		
		try {
			
			logger.info("================ boardListForm Start ================");
			
			// GET 진입 시 필수 기본값을 강제 세팅
			if(boardSearchDTO.getRowCntPerPage() == 0) boardSearchDTO.setRowCntPerPage(15);
			if(boardSearchDTO.getSelectPageNo() == 0) boardSearchDTO.setSelectPageNo(1);
			
			// ------------------------------------
			// BoardDAO 객체의 메소드를 호출하여 페이지 번호에 맞는 검색 결과물을 얻어 List<BoardDTO> 객체에 저장
			// ------------------------------------
			List<BoardDTO> boardList = this.boardService.getBoardList(boardSearchDTO);
			// ------------------------------------
			// BoardDAO 객체의 메소드를 호출하여 검색 결과물의 총개수를 얻어 int 객체에 저장
			// ------------------------------------
			int boardListCnt = this.boardService.getBoardListCnt(boardSearchDTO);
			
			// *******************************************************************
			// 출력되는 다수의 게시판 글에 붙는 출력번호를 생성하여 변수에 저장	
			// *******************************************************************
			// 페이지 번호에 대응하는 mariaDB 검색 행의 오름차순 시작번호 얻기
			// int mariadbAscStartRowNo = Integer.parseInt(selectPageNo) * Integer.parseInt(rowCntPerPage) - Integer.parseInt(rowCntPerPage) + 1;
			int mariadbAscStartRowNo = boardSearchDTO.getSelectPageNo() * boardSearchDTO.getRowCntPerPage() - boardSearchDTO.getRowCntPerPage() + 1;
			
			if(boardListCnt < mariadbAscStartRowNo) {
				boardSearchDTO.setSelectPageNo( 1 );
				mariadbAscStartRowNo = 1;
			}
			
			// JSP 페이지에 출력할 내림차순 출력번호의 시작 번호 얻기
			int mariadbDescStartRowNo = boardListCnt - mariadbAscStartRowNo + 1;
			logger.info("================ 22222222222222222222222 ================");
			
			String keywordContent = boardSearchDTO.getKeywordContent();
			keywordContent = (keywordContent==null || keywordContent.equals("")) ? "all" : keywordContent;
			
			mav.addObject("boardListCnt" , boardListCnt);
			mav.addObject("selectPageNo" , boardSearchDTO.getSelectPageNo());
			mav.addObject("rowCntPerPage" , boardSearchDTO.getRowCntPerPage());
			mav.addObject("keywordContent" , keywordContent);
			mav.addObject("mariadbDescStartRowNo" , mariadbDescStartRowNo);
			mav.addObject("boardList" , boardList);
			logger.info("================ 33333333333333333333333333333 ================");
			
		} catch(Exception ex) {
			// System.out.println("BoardController.getBoardList(~) 메소드 호출 시 에러발생");
			logger.error("BoardController.getBoardList(~) 메소드 호출 시 에러발생 => {}" , ex.getMessage());
		}
		
		// mav.addObject("boardListCnt" , boardListCnt);
		
		mav.setViewName("boardListForm");
		
		return mav;
	}
	
	@RequestMapping(value="/boardListAjax.do" , method=RequestMethod.POST )
	@ResponseBody // <-- "화면(JSP) 말고 데이터(JSON)를 보낼게!"라는 선언
	public Map<String, Object> boardListAjax(
		@RequestBody BoardSearchDTO boardSearchDTO
	) {
		
		logger.info("boardSearchDTO => {} " , boardSearchDTO);
		
		// 2. 여러 데이터를 담기 위해 Map 사용 (바구니 준비)
	    Map<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
			// F.E.에서 값만 담아준다면 큰 문제는 없어서 주석 처리 하겠음.
			// String keywordContent = boardSearchDTO.getKeywordContent();
			// keywordContent = (keywordContent==null || keywordContent.equals("")) ? "all" : keywordContent;
			// boardSearchDTO.setKeywordContent(keywordContent);
			
			
			List<BoardDTO> boardList = this.boardService.getBoardList(boardSearchDTO);
			int boardListCnt = this.boardService.getBoardListCnt(boardSearchDTO);
			int mariadbAscStartRowNo = boardSearchDTO.getSelectPageNo() * boardSearchDTO.getRowCntPerPage() - boardSearchDTO.getRowCntPerPage() + 1;
			int mariadbDescStartRowNo = boardListCnt - mariadbAscStartRowNo + 1;
			
			resultMap.put("boardList", boardList);
			resultMap.put("boardListCnt", boardListCnt);
			resultMap.put("mariadbDescStartRowNo", mariadbDescStartRowNo);
			resultMap.put("selectPageNo", boardSearchDTO.getSelectPageNo());
			resultMap.put("rowCntPerPage", boardSearchDTO.getRowCntPerPage());
			// resultMap.put("keywordContent", keywordContent);
		}
		catch(Exception ex) {
			// System.out.println("BoardController.getBoardList(~) 메소드 호출 시 에러발생");
			logger.error("BoardController.boardListAjax(~) 메소드 호출 시 에러발생 => {}" , ex.getMessage());
		}
		
		// 3. Map 객체를 리턴하면 자동으로 { "boardList": [...], "boardListCnt": 100 } 형태의 JSON이 됩니다.
	    return resultMap;
	}
	
	@RequestMapping(value="/boardRegReplyForm.do" , method=RequestMethod.POST )
	public ModelAndView boardRegReplyForm(
		// @RequestBody BoardSearchDTO boardSearchDTO
		// 스프링이 Bean DTO 객체를 자동으로 생성해서 넣어줍니다 (기본값 전략)
		BoardSearchDTO boardSearchDTO
		, BoardDTO boardDTO
	) {
		// -----------------------------
		// ModelAndView 객체 생성
		// -----------------------------
		ModelAndView mav = new ModelAndView();
		
		logger.info("boardSearchDTO => {} " , boardSearchDTO);
		logger.info("boardDTO => {} " , boardDTO);
		String title = boardDTO.getBNo() == 0 ? "새 글 작성" : "답글 작성";
		
		// mav.addObject에 담은 값들은 <목록보기>를 눌러서 boardListForm.jsp로 돌아갈때 필요한 값들이다.
		// 새 글 등록 할 때는 딱히 필요가 없음...;;;
		mav.addObject("bNo" , boardDTO.getBNo());
		mav.addObject("title" , title);
		mav.addObject("keyword" , boardSearchDTO.getKeyword());
		mav.addObject("keywordContent" , boardSearchDTO.getKeywordContent());
		mav.addObject("rowCntPerPage" , boardSearchDTO.getRowCntPerPage());
		mav.addObject("selectPageNo" , boardSearchDTO.getSelectPageNo());
		
		mav.setViewName("boardRegReplyForm");
		
		return mav;
	}
	
	@RequestMapping(value="/boardRegReplyProc.do" , method=RequestMethod.POST )
	@ResponseBody // <-- "화면(JSP) 말고 데이터(JSON)를 보낼게!"라는 선언
	public int boardRegReplyProc(
		@RequestBody BoardDTO boardDTO
	) {
		
		logger.info("boardDTO => {} " , boardDTO);
		
		int boardRegReplyCnt = 0;
		
		try {
			
			boardRegReplyCnt = this.boardService.insertBoardRegReplyCnt(boardDTO);
			
			/*
			if(boardDTO.getBNo() > 0) {
				// int boardPrintUpCnt = this.boardService.updateBoardPrintUpCnt(boardDTO);
				this.boardService.updateBoardPrintUpCnt(boardDTO);
			}
			
			boardRegReplyCnt = this.boardService.insertBoardRegReplyCnt(boardDTO);
			*/
		}
		catch(Exception ex) {
			logger.error("BoardController.boardRegReplyProc(~) 메소드 호출 시 에러발생 => {}" , ex.getMessage());
		}
		
		return boardRegReplyCnt;
		
	}
	
	@RequestMapping(value="/boardContentForm.do" , method=RequestMethod.POST )
	public ModelAndView boardContentForm(
		// @RequestBody BoardSearchDTO boardSearchDTO
		// 스프링이 Bean DTO 객체를 자동으로 생성해서 넣어줍니다 (기본값 전략)
		BoardSearchDTO boardSearchDTO
		, BoardDTO boardDTO
	) {
		// -----------------------------
		// ModelAndView 객체 생성
		// -----------------------------
		ModelAndView mav = new ModelAndView();
		
		int bNo = boardDTO.getBNo();
		String flag = "content";
		
		// this.boardService.updateBoardHit(bNo);
		BoardDTO board = this.boardService.getBoard(bNo, flag);
		
		mav.addObject("bNo" , bNo);
		mav.addObject("keyword" , boardSearchDTO.getKeyword());
		mav.addObject("keywordContent" , boardSearchDTO.getKeywordContent());
		mav.addObject("rowCntPerPage" , boardSearchDTO.getRowCntPerPage());
		mav.addObject("selectPageNo" , boardSearchDTO.getSelectPageNo());
		mav.addObject("board" , board);
		
		mav.setViewName("boardContentForm");
		
		return mav;
		
	}
	
	@RequestMapping(value="/checkSonBoardCnt.do" , method=RequestMethod.POST )
	@ResponseBody // <-- "화면(JSP) 말고 데이터(JSON)를 보낼게!"라는 선언
	public int checkSonBoardCnt(
		@RequestBody BoardDTO boardDTO
	) {
		
		logger.info("boardDTO.getBNo() in checkSonBoardCnt => {} " , boardDTO.getBNo());
		
		int sonBoardCnt = 0;
		
		try {
			sonBoardCnt = this.boardService.getSonBoardCnt(boardDTO.getBNo());
		}
		catch(Exception ex) {
			logger.error("BoardController.boardRegReplyProc(~) 메소드 호출 시 에러발생 => {}" , ex.getMessage());
		}
		
		return sonBoardCnt;
		
	}
	
	@RequestMapping(value="/boardUpDelForm.do" , method=RequestMethod.POST )
	public ModelAndView boardUpDelForm(
		// @RequestBody BoardSearchDTO boardSearchDTO
		// 스프링이 Bean DTO 객체를 자동으로 생성해서 넣어줍니다 (기본값 전략)
		BoardSearchDTO boardSearchDTO
		, BoardDTO boardDTO
	) {
		// -----------------------------
		// ModelAndView 객체 생성
		// -----------------------------
		ModelAndView mav = new ModelAndView();
		
		/*
		logger.info("boardDTO.getBNo() in boardUpDelForm => {} " , boardDTO.getBNo());
		logger.info("boardSearchDTO in boardUpDelForm => {} " , boardSearchDTO);
		*/
		
		int bNo = boardDTO.getBNo();
		String flag = "upDel";
		
		BoardDTO board = this.boardService.getBoard(bNo, flag);
		
		mav.addObject("bNo" , bNo);
		mav.addObject("keyword" , boardSearchDTO.getKeyword());
		mav.addObject("keywordContent" , boardSearchDTO.getKeywordContent());
		mav.addObject("rowCntPerPage" , boardSearchDTO.getRowCntPerPage());
		mav.addObject("selectPageNo" , boardSearchDTO.getSelectPageNo());
		mav.addObject("board" , board);
		
		mav.setViewName("boardUpDelForm");
		
		return mav;
		
	}
	
	@RequestMapping(value="/boardUpDelProc.do" , method=RequestMethod.POST )
	@ResponseBody // <-- "화면(JSP) 말고 데이터(JSON)를 보낼게!"라는 선언
	public int boardUpDelProc(
		@RequestBody BoardDTO boardDTO
	) {
		
		logger.info("boardDTO in boardUpDelProc => {} " , boardDTO);
		
		int boardUpDelCnt = 0;
		
		try {
			
			boardUpDelCnt = this.boardService.boardUpDel(boardDTO);
			
		}
		catch(Exception ex) {
			logger.error("BoardController.boardRegReplyProc(~) 메소드 호출 시 에러발생 => {}" , ex.getMessage());
		}
		
		return boardUpDelCnt;
		
	}
	
}
