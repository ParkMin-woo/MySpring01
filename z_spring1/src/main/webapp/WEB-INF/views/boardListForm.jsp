<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<!-- 현재 페이지에 /WEB-INF/views/common.jsp 파일 내의 소스 삽입 // directive -->
<!-- /, http로 시작하면 절대경로 -->
<!-- 그 외는 모두 상대경로 -->
<%@ include file="/WEB-INF/views/common2.jsp"%>

<html>
<head>
<meta charset="UTF-8">
<title>답변형 게시판</title>
</head>

<script>

	// ******************************************************
	// body 태그를 모두 실행한 후에 실행할 자스 코드 설정
	// ******************************************************
	$(document).ready(function() {
		// alert("loginProc.jsp 진입!!!");
		// ------------------------------------------------------------
		// 게시판 목록의 홀짝수 행의 배경색, 마우스를 대면 변하는 배경색 지정
		// ------------------------------------------------------------
		setTableTrBgColor("boardList", "white", "#EFEFEF", "#8F8F8F");
		// ------------------------------------------------------------
		// 한 페이지에서 보여줄 행의 개수를 조절하는 select 입력양식에 change 이벤트 발생 시 실행할 코드 설정
		// ------------------------------------------------------------
		$("[name=row_cnt_per_page]").change(function() {
			$("[name=select_page_no]").val("1");
			// document.boardListForm.submit();
			searchBoardList(1);
		});
		
		// ------------------------------------------------------------
		// [검색] 버튼 클릭 시 실행할 코드 설정
		// ------------------------------------------------------------
		$(".searchBoard").click(function() {
			var keyword = $("[name=keyword]").val().split(" ").join();
			// if( $("[name=keyword]").val().split(" ").join() == "" ) {
			if( keyword == "" ) {
				alert("[검색 키워드]를 입력해 주세요.");
				return;
			}
			alert("[검색 키워드]가 있는 댓글을 소유한 그룹이 모두 검색됩니다.");
			// document.boardListForm.submit();
			// searchBoardList( keyword );
			searchBoardList(1);
		});
		
		// ------------------------------------------------------------
		// [모두 검색] 버튼 클릭 시 실행할 코드 설정
		// ------------------------------------------------------------
		$(".searchBoardAll").click(function() {
			$("[name=keyword_content]").val("all");
			$("[name=keyword]").val("");
			// document.boardListForm.submit();
			searchBoardList(1);
		});

		
		// ------------------------------------------------------------
		// [한 페이지에서 보여줄 행의 개수], [검색 키워드], [검색 키워드 내용] 관련
		// 입력양식의 value 값에 파라미터값 삽입하기.
		// ------------------------------------------------------------
		// 만약 HttpServletRequest 객체가 소유한 rowCntPerPage라는 파라미터명에
		// 해당하는 파라미터값이 없으면(null값도 해당) name=rowCntPerPage를 가진 입력양식에 15을 넣어줘.
		<c:if test="${empty rowCntPerPage}">
			$("[name=row_cnt_per_page]").val( "15" );
		</c:if>
		// 만약 HttpServletRequest 객체가 소유한 rowCntPerPage라는 파라미터명에
		// 해당하는 파라미터값이 있으면 name=rowCntPerPage를 가진 입력양식에 파라미터값을 넣어줘.
		<c:if test="${!empty rowCntPerPage}">
			$("[name=row_cnt_per_page]").val( "${rowCntPerPage }" );
		</c:if>
		$("[name=keyword]").val( "${keyword==null ? '' : keyword }" );
		$("[name=keyword_content]").val( "${keywordContent }" );
	});
	
	// ******************************************************
	// [1개의 게시판 내용물]을 보여주는 화면으로 이동하는 함수 선언
	// ******************************************************
	function goBoardContentForm( b_no ) {
		
		console.log("b_no => " , b_no);
		// alert("상세보기 화면 개발중입니다.");
		
		$("[name=boardContentForm] [name=bNo]").val( b_no );
		$("[name=boardContentForm] [name=keyword]").val(
			$("[name=boardListForm] [name=keyword]").val()
		);
		$("[name=boardContentForm] [name=keywordContent]").val(
			$("[name=boardListForm] [name=keyword_content]").val()
		);
		$("[name=boardContentForm] [name=selectPageNo]").val(
			$("[name=boardListForm] [name=select_page_no]").val()
		);
		$("[name=boardContentForm] [name=rowCntPerPage]").val(
			$("[name=boardListForm] [name=row_cnt_per_page]").val()
		);
		
		// name = boardContentForm을 가진 form 태그 안의 action에 설정된 URL로 이동하기.
		// 이동 시 form 태그 안의 모든 입력 양식이 파라미터값으로 전송된다.
		document.boardContentForm.submit();
		
	}
	
	// ******************************************************
	// [새 글 작성]을 화면으로 이동하는 함수 선언
	// ******************************************************
	function goBoardRegReplyForm() {
		$("[name=boardRegReplyForm] [name=keyword]").val(
			$("[name=boardListForm] [name=keyword]").val()
		);
		$("[name=boardRegReplyForm] [name=keywordContent]").val(
			$("[name=boardListForm] [name=keyword_content]").val()
		);
		$("[name=boardRegReplyForm] [name=selectPageNo]").val(
			$("[name=boardListForm] [name=select_page_no]").val()
		);
		$("[name=boardRegReplyForm] [name=rowCntPerPage]").val(
			$("[name=boardListForm] [name=row_cnt_per_page]").val()
		);
		
		// console.log("boardRegForm의 selectPageNo => " , $("[name=boardRegReplyForm] [name=selectPageNo]").val());
		// console.log("boardRegForm의 rowCntPerPage => " , $("[name=boardRegReplyForm] [name=rowCntPerPage]").val());
		
		document.boardRegReplyForm.submit();
	}
	
	function showContent( contentN ) {
		/*
		alert("contentN => " + contentN);
		alert("contentN val => " + $("[name="+contentN+"]").val());
		return;
		*/
		var contentV = $("[name="+contentN+"]").val();
		$(".contentDiv").remove();
		$("body").append(
			"<div style='position:absolute;background-color:lightblue;width:200;height:200;padding:10;' class=contentDiv>"+contentV+"</div>"
		);
		$(".contentDiv").css({
			// mouseover 이벤트 발생 위치의 Y좌표 설정
			"top":event.clientY+10
			// mouseover 이벤트 발생 위치의 X좌표 설정
			, "left":event.clientX+10
		});
	}
	
	function hideContent() {
		$(".contentDiv").remove();
	}
	



	//**************************************************************
	// 검색화면에서 검색 결과물의 페이징 번호 출력 소스 리턴
	//**************************************************************
	function printPagingHtmlAjax(
		totRowCnt               // 검색 결과 총 행 개수
		, selectPageNo_str         // 선택된 현재 페이지 번호
		, rowCntPerPage_str     // 페이지 당 출력행의 개수
		, pageNoCntPerPage_str  // 페이지 당 출력번호 개수
		, jsCodeAfterClick      // 페이지 번호 클릭후 실행할 자스 코드
	) {
		console.log("printPagingHtmlAjax , 페이징 번호 클릭 시 ajax로 넘기기 위한 함수");
		
		/*
		$(document).ready(function( ){
			if( $('[name=select_page_no]').length==0 ){
				alert("name=nowPage 을 가진 hidden 태그가 있어야 가능함.');" );
			}
		});
		*/
		var arr = [];
		try{
			if( totRowCnt==0 ){	return ""; }	
			if( jsCodeAfterClick==null || jsCodeAfterClick.length==0){
				alert("printPagingHtml2(~) 함수의 5번째 인자는 존재하는 함수명이 와야 합니다");
				return "";
			}
			
			//--------------------------------------------------------------
			// 페이징 처리 관련 데이터 얻기
			//--------------------------------------------------------------
			if( selectPageNo_str==null || selectPageNo_str.length==0 ) { 
				selectPageNo_str="1";  // 선택한 현재 페이지 번호 저장
			} 
			if( rowCntPerPage_str==null || rowCntPerPage_str.length==0 ) { 
				rowCntPerPage_str="10";  // 선택한 현재 페이지 번호 저장
			}
			if( pageNoCntPerPage_str==null || pageNoCntPerPage_str.length==0 ) { 
				pageNoCntPerPage_str="10";  // 선택한 현재 페이지 번호 저장
			}
			//---
			var selectPageNo = parseInt(selectPageNo_str, 10);
			var rowCntPerPage = parseInt(rowCntPerPage_str,10);
			var pageNoCntPerPage = parseInt(pageNoCntPerPage_str,10);
			if( rowCntPerPage<=0 || pageNoCntPerPage<=0 ) { return; }
			
			//--------------------------------------------------------------
			//최대 페이지 번호 얻기
			//--------------------------------------------------------------
			var maxPageNo=Math.ceil( totRowCnt/rowCntPerPage );   
				if( maxPageNo<selectPageNo ) { selectPageNo = 1; }

			//--------------------------------------------------------------
			// 선택된 페이지번호에 따라 출력할 [시작 페이지 번호], [끝 페이지 번호] 얻기
			//--------------------------------------------------------------
			var startPageNo = Math.floor((selectPageNo-1)/pageNoCntPerPage)*pageNoCntPerPage+1;  // 시작 페이지 번호
			var endPageNo = startPageNo+pageNoCntPerPage-1;                                      // 끝 페이지 번호
				if( endPageNo>maxPageNo ) { endPageNo=maxPageNo; }

			//---
			var cursor = " style='cursor:pointer' ";
			
			//--------------------------------------------------------------
			// [처음] [이전] 출력하는 자바스크립트 소스 생성해 저장
			//--------------------------------------------------------------
			if( startPageNo>pageNoCntPerPage ) {
				// [처음] 클릭 시 1페이지 전달
				var clickCodeFirst = jsCodeAfterClick.replace("()", "(1)");
				arr.push( "<span "+cursor+" onclick="+clickCodeFirst+";>[처음]</span>" );
				// [이전] 클릭 시 (시작페이지-1) 전달
			    var clickCodePrev = jsCodeAfterClick.replace("()", "(" + (startPageNo - 1) + ")");
				arr.push( "<span "+cursor+" onclick="+clickCodePrev+";>[이전]</span>&nbsp;&nbsp;&nbsp;" );
			}
			//--------------------------------------------------------------
			// 페이지 번호 출력하는 자바스크립트 소스 생성해 저장
			//--------------------------------------------------------------
			//arr.push( "<td align=center>&nbsp;&nbsp;" );
			for( var i=startPageNo ; i<=endPageNo; ++i ){
				if(i>maxPageNo) {break;}
				if(i==selectPageNo || maxPageNo==1 ) {
					arr.push( "<b>"+i +"</b> " );
				}else{
					// [번호] 클릭 시 i값 전달
			        var clickCodeNo = jsCodeAfterClick.replace("()", "(" + i + ")");
					arr.push( "<span "+cursor+" onclick="+clickCodeNo+";>["+i+"]</span> " );
				}
			}
			//--------------------------------------------------------------
			// [다음] [마지막] 출력하는 자바스크립트 소스 생성해 저장
			//--------------------------------------------------------------
			//arr.push( "<td align=left width=110>&nbsp;&nbsp;" );
			if( endPageNo<maxPageNo ) {
				// [다음] 클릭 시 (끝페이지+1) 전달
			    var clickCodeNext = jsCodeAfterClick.replace("()", "(" + (endPageNo + 1) + ")");
				arr.push( "&nbsp;&nbsp;&nbsp;<span "+cursor+" onclick="+clickCodeNext+";>[다음]</span>" );
				// [마지막] 클릭 시 maxPageNo 전달
			    var clickCodeLast = jsCodeAfterClick.replace("()", "(" + maxPageNo + ")");
				arr.push( "<span "+cursor+" onclick="+clickCodeLast+";>[마지막]</span>" );
			}
			//arr.push( "</table>" );
			return arr.join( "  " );
		}catch(ex){
			alert("printPagingHtmlAjax(~) 메소드 호출 시 예외발생!");
			return "";
		}
	}
	
	function searchBoardList( pageNo ) {
		
	    if (pageNo) {
	        $("[name=boardListForm] [name=select_page_no]").val(pageNo);
	    }
		
		console.log("row_cnt_per_page val => " , $("[name=boardListForm] [name=row_cnt_per_page]").val());
		console.log("select_page_no => " , $("[name=boardListForm] [name=select_page_no]").val());// 페이징 클릭 시 넘어온 번호가 있다면 hidden 필드 갱신
		// console.log("param => " , param);
		
		var data = {
			"keyword" : $("[name=boardListForm] [name=keyword]").val() // param
			, "keyword_content" : $("[name=boardListForm] [name=keyword_content]").val()
			, "row_cnt_per_page" : $("[name=boardListForm] [name=row_cnt_per_page]").val() // 15
			, "select_page_no" : $("[name=boardListForm] [name=select_page_no]").val() // 1
			, "start_row_no" : ""
		};
		
		$.ajax({	// 비동기 방식을 사용
			// 서버의 호출 URL setting
			url : "${path1}/boardListAjax.do"
			, type : "post"
			, data : JSON.stringify(data)
			, contentType : "application/json;charset=utf-8"
			// -----------------------------------------------------------------------------
			// 서버가 응답한 html 소스 문자열을 현재 페이지의
			// body 태그 마지막에 html로 삽입하고, 실행하기.
			// -----------------------------------------------------------------------------
			, success : function(res) {
				// $("body").append(html);
				console.log("res => " , res);
				drawBoardList(res);
			}
			// 서버의 응답을 못받았을 경우 실행할 익명함수 설정.
			, error : function() {
				alert( "boardListForm.jsp 파일에 접근할 수 없음!" );
			}
		});
		
	}
	
	function drawBoardList( result ) {
		var boardList = result.boardList;
		
		// 2. 감독(F.E)이 교체 구역(tbody)만 싹 비우기
	    // 학원 코드처럼 그냥 table 전체를 건드리는 게 아니라 딱 '몸통'만 타격!
	    $("#boardTbody").empty();
		
	    var tbodyHtml = "";
	    
	    if (boardList && boardList.length > 0) {
	    	$.each(boardList, function(idx, board) {
	            // JSTL의 mariadbDescStartRowNo - loopStatus.index 와 동일한 로직
	            var currentNo = result.mariadbDescStartRowNo - idx;
	            // console.log("board => " , board);
	            
	            tbodyHtml += `
	                <tr align="center" style="cursor:pointer" onMouseover="showContent('content\${idx}');" onMouseout="hideContent();" onClick="goBoardContentForm('\${board.bNo}');">
	                    <td>\${currentNo}</td>
	                    <td align="left">\${board.subject}</td>
	                    <td>\${board.writer}</td>
	                    <td>\${board.registDate}</td>
	                    <td>\${board.modifyDate}</td>
	                    <td>\${board.hit}</td>
	                </tr>
	                <input type="hidden" name="content\${idx}" value="\${board.content}" />
	            `;
	        });
	    } else {
	    	tbodyHtml = "<tr><td colspan='6' align='center'>조회된 결과가 없습니다.</td></tr>";
	    }
	    
	    $("#boardTbody").append(tbodyHtml);
	    
		 // 2. [핵심] 페이징 번호 영역 새로 고침!
	    // 서버에서 받은 최신 데이터(result)를 사용해 페이징 HTML을 다시 생성합니다.
	    var pagingHtml = printPagingHtmlAjax(
	        result.boardListCnt          // 서버에서 준 총 개수
	        , result.selectPageNo        // 서버가 인식한 현재 페이지
	        , result.rowCntPerPage       // 서버가 인식한 행 개수
	        , "15"                       // 페이지 번호 개수
	        , "searchBoardList()"        // 클릭 시 호출할 함수
	    );
	 
	 	// 명시적으로 pagingNumberArea 부분  비우고(empty)
	    $("#pagingNumberArea").empty();
	    
	    // 페이징 그릇에 새로 만든 번호판 꽂기
	    $("#pagingNumberArea").html(pagingHtml);
	    
	    // 3. 조회 총 갯수 수정
	    $("#boardListCntArea").text(result.boardListCnt);
	}

</script>
<body>

	<!-- <form>
		<h2>게시판 화면입니다.</h2>
	</form> -->
	
	<center><br />
		<!-- mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm -->
		<!-- [게시판 목록]을 출력하는 form 태그 선언 -->
		<!-- mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm -->
		<form name="boardListForm" method="post">	<!--  action="${boardPath}/boardListForm.do" -->
			<!-- ******************************************** -->
			<!-- [전체 글 수], [글쓰기] 링크 글씨 출력 -->
			<!-- ******************************************** -->
			<table class="tbcss1" border=1 cellpadding=5 bordercolor="#FAFAFA">
				<tr>
					<th width=420>[게시판]</th>
					<th width=140>[조회된 게시글 수] : <span id="boardListCntArea" style="color: red;">${boardListCnt }</span></th>
					<%-- <th width=70><a href="${boardPath}/boardRegReplyForm.do">[새 글 작성]</a></th> --%>
					<th width=70><a href="javascript:goBoardRegReplyForm();">[새 글 작성]</a></th>
				</tr>
			</table>
			
			<!-- ******************************************** -->
			<!-- 자바스크립트 함수 호출로 [페이징 번호] 출력. [페이지당 보여줄 행의 개수] 출력 -->
			<!-- ******************************************** -->
			<table border=0 class="pagingNos">
				<tr>
					<td width=500 align=center id="pagingNumberArea">
						<script>
							document.write(
								printPagingHtmlAjax(
									"${boardListCnt }"               // 검색 결과 총 행 개수
									, "${selectPageNo}"         // 선택된 현재 페이지 번호
									, "${rowCntPerPage}"     // 페이지 당 출력행의 개수
									, "15"  // 페이지 당 출력번호 개수
									, "searchBoardList()"      // 페이지 번호 클릭후 실행할 자스 코드
									// , "document.boardListForm.submit()"
								)
							);
						</script>
					</td>
					<td width=90 align=right>
						<select name="row_cnt_per_page">
							<option value = "10">10</option>
							<option value = "15">15</option>
							<option value = "20">20</option>
							<option value = "25">25</option>
							<option value = "30">30</option>
							<option value = "35">35</option>
							<option value = "40">40</option>
						</select> 행보기
					</td>
				</tr>
			</table>
			
			<!-- ******************************************** -->
			<!-- [게시판 검색 결과물] 출력 -->
			<!-- ******************************************** -->
			<table class="tbcss2 boardList" border=1 cellpadding=3 bordercolor="#DDDDDD">
				<thead>
					<tr bgcolor=#C6C6C6>
						<!-- <th width = "10">index</th> -->
						<!-- <th width = "40">bNo</th> -->
						<th width = "40">번호</th>
						<th width = "250">제목</th>
						<th width = "100">작성자</th>
						<th width = "150">작성일</th>
						<th width = "150">수정일</th>
						<th width = "40">조회수</th>
					</tr>
				</thead>
				<!-- --------------------------------------------- -->
				<tbody id="boardTbody">
					<c:if test="${!boardList.isEmpty()}">
						<c:forEach var="board" items="${boardList}" varStatus="loopStatus">
							<!-- loopStatus.index 활용해야 합니다. -->
							<tr align=center style="cursor:pointer" onMouseover="showContent('content${loopStatus.index}');" onMouseout="hideContent();" onClick="goBoardContentForm('${board.bNo}');">
								<%-- <td align=left>${board.bNo }</td> --%>
								<td>${mariadbDescStartRowNo-loopStatus.index}</td>
								<td align=left>${board.subject }</td>
								<td>${board.writer }</td>
								<td>${board.registDate }</td>
								<td>${board.modifyDate }</td>
								<td>${board.hit }</td>
							</tr>
							<input type="hidden" name="content${loopStatus.index}" value="${board.content }" />
						</c:forEach>
					</c:if>
					<c:if test="${boardList.isEmpty()}">
						<tr align=center>
							<td colspan="6">게시판에 저장된 글이 없습니다.</td>
						</tr>
					</c:if>
				</tbody>
			</table>
			<!-- ******************************************** -->
			<table>
				<tr height=3>
					<td></td>
				</tr>
			</table>
			<select name="keyword_content">
				<option value="all">모두</option>
				<option value="subject">제목</option>
				<option value="content">내용</option>
				<option value="writer">작성자</option>
			</select>
			<input type="text" name="keyword" />
			<input type="button" value="검색" class="searchBoard" />&nbsp;
			<input type="button" value="모두 검색 / 새로 고침" class="searchBoardAll" />
			<!-- ******************************************** -->
			<!-- [hidden 입력양식] 선언 -->
			<!-- ******************************************** -->
			<input type="hidden" name="select_page_no" value="${selectPageNo }" />
		</form>
		
		<!-- mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm -->
		<!-- [선택한 1개 게시판 번호], [현재 페이징 번호], [한 화면에 보여줄 게시판 글 목록의 행의 개수] 관련 태그를 출력하고,  -->
		<!-- [선택한 1개 게시판] 내용을 보여주는 화면으로 이동하는 form 태그 선언  -->
		<!-- mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm -->
		<form name="boardContentForm" method="post" action="${path1}/boardContentForm.do">
			<input type="hidden" name="bNo" />
			<input type="hidden" name="keyword" />
			<input type="hidden" name="keywordContent" />
			<input type="hidden" name="selectPageNo" value="${selectPageNo }" />
			<input type="hidden" name="rowCntPerPage" value="${rowCntPerPage }" />
		</form>
		
		<!-- mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm -->
		<!-- [현재 페이징 번호], [한 화면에 보여줄 게시판 글 목록의 행의 개수] 관련 태그를 출력하고,  -->
		<!-- [새 글 작성] 화면으로 이동하는 form 태그 선언  -->
		<!-- mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm -->
		<form name="boardRegReplyForm" method="post" action="${path1}/boardRegReplyForm.do">
			<!-- <input type="hidden" name="bNo" /> -->		<!-- 새 글 작성에서는 bNo의 값이 필요하지는 않지만, 게시글 수정과 화면을 공유하므로 bNo 값을 hidden으로 넣어준다. -->
			<input type="hidden" name="keyword" />
			<input type="hidden" name="keywordContent" />
			<input type="hidden" name="selectPageNo" value="${selectPageNo }" />
			<input type="hidden" name="rowCntPerPage" value="${rowCntPerPage }" />
		</form>
	</center>

</body>
</html>