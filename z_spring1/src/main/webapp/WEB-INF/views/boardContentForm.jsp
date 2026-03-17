<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<!-- 현재 페이지에 common2.jsp 파일 내의 소스 삽입 // directive -->
<%@ include file="common3.jsp"%>

<html>
<head>
<meta charset="UTF-8">
<title>게시판 상세글</title>
</head>

<script>

	function goBoardUpDelForm(b_no) {
		console.log("b_no, goBoardUpDelForm => " , b_no);
		// alert("수정/삭제 화면 개발중");
		
		$.ajax({	// 비동기 방식을 사용
			// 서버의 호출 URL setting
			url : "${path1 }/checkSonBoardCnt.do"
			
			// form Tag 안의 데이터를 보내는 방법 지정
			, type : "post"
			
			// 서버에 보낼 파라미터명과 파라미터값을 설정
			, data : JSON.stringify({"b_no" : b_no})
			, contentType : "application/json;charset=utf-8"
			
			, success : function( result ) {
				
				console.log("result , goBoardUpDelForm => " , result);
				if( result > 0 ) {
					alert("댓글을 가지고 있는 글은 수정 / 삭제가 불가능합니다.");
					return;
				}
				else {
					// alert("수정 / 삭제 화면 이동");
					document.boardContentForm.action="${path1}/boardUpDelForm.do";
					document.boardContentForm.submit();
				}
			}
			
			// 서버의 응답을 못받았을 경우 실행할 익명함수 설정.
			, error : function() {
				alert( "서버와 비동기 방식 통신 실패!" );
			}
		});
	}
	
	function goBoardRegReplyForm() {
		// alert("답글 작성 화면 개발중");
		document.boardContentForm.action="${path1}/boardRegReplyForm.do";
		document.boardContentForm.submit();
	}

	function goBoardListForm() {
		document.boardListForm.submit();
	}

</script>

<body>

	<%-- <h3>게시판 상세글 화면입니다.</h3>
	<span>${bNo }</span> --%>
	
	<center><br />
		<!-- ****************************************************** -->
		<!-- [1개의 게시판 글]을 출력하는 form 태그 선언 -->
		<!-- ****************************************************** -->
		<form name="boardContentForm" class="boardContentForm" method="post">
			<table class="tbcss1" width="500" border="1" bordercolor="#DDDDDD" cellpadding="5" align="center">
				<tr align="center">
					<th bgcolor=#C6C6C6 width=60>
						글번호
					</th>
					<td width=150>
						${bNo }
					</td>
					<th bgcolor=#C6C6C6 width=60>
						조회수
					</th>
					<td width=150>
						${board.hit }
					</td>
				</tr>
				<tr align="center">
					<th bgcolor=#C6C6C6 width = 60>
						작성자
					</th>
					<td width=150>
						${board.writer }
					</td>
					<th bgcolor=#C6C6C6 width = 60>
						등록일
					</th>
					<td width=150>
						<%-- 날짜 포맷팅 출력 --%>
						<fmt:formatDate value="${board.registDate }" pattern="yyyy-MM-dd HH:mm:ss" />
					</td>
				</tr>
				<tr>
					<th bgcolor=#C6C6C6>
						제목
					</th>
					<td colspan="3">
						${board.subject }
					</td>
				</tr>
				<tr>
					<th bgcolor=#C6C6C6>
						내용
					</th>
					<td colspan="3">
						${board.content }
					</td>
				</tr>
			</table>
			
			<input type="hidden" name="bNo" value="${bNo }" />
			<input type="hidden" name="selectPageNo" value="${selectPageNo}" />
			<input type="hidden" name="rowCntPerPage" value="${rowCntPerPage}" />
			<input type="hidden" name="keyword" value="${keyword }" />
			<input type="hidden" name="keywordContent" value="${keywordContent }" />
			
			<c:if test="${board.writer == sessionScope.loginId}">
				<input type="button" value="수정/삭제" onClick="goBoardUpDelForm(${bNo })" />&nbsp;
			</c:if>
			<input type="button" value="댓글작성" onClick="goBoardRegReplyForm()" />&nbsp;
			<input type="button" value="목록보기" onClick="javascript:goBoardListForm();" />
		</form>
		
		<!-- mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm -->
		<!-- "z_jsp1/view/boardListForm.jsp 페이지, 즉 [게시판 목록] 화면으로 이동하는 form 태그 선언 -->
		<!-- mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm -->
		<form name="boardListForm" method="post" action="${path1 }/boardListForm.do">
			<input type="hidden" name="keyword" value="${keyword }" />
			<input type="hidden" name="keywordContent" value="${keywordContent }" />
			<input type="hidden" name="selectPageNo" value="${selectPageNo }" />
			<input type="hidden" name="rowCntPerPage" value="${rowCntPerPage}" />
		</form>
	</center>

</body>
</html>