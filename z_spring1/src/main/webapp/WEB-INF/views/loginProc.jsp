<!-- mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm -->
<!-- JSP 기술의 한 종류인 [Page Directive]를 이용하여 현  JSP 페이지 처리 방식 선언하기 -->
<!-- mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm -->
	<!-- 현재 이 JSP 페이지 실행 후 생성되는 문서는 HTML이고, 이 문서는 UTF-8 방식으로 인코딩 한다라고 설정함. -->
	<!-- 현재 이 JSP 페이지는 UTF-8 방식으로 인코딩한다. -->
	<!-- UTF-8 인코딩 방식은 한글을 포함 전 세계 모든 문자열을 부호화할 수 있는 방법이다. -->
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!-- mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm -->
<!-- JSP 기술의 한 종류인 [Include Directive]를 이용하여 현 common.jsp 파일 내의 소스를 삽입하기 -->
<!-- mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm -->
<%@ include file="/WEB-INF/views/common.jsp"%>

<!-- mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm -->
<!-- EL을 사용하여 HttpServletRequest 객체에 adminCnt라는 키값을 꺼내고 -->
<!-- 커스텀태그의 조건문을 이용하여 저장된 데이터가 1이면(즉, [아이디]가 DB에 존재하면) -->
<!-- 게시판 목록 화면으로 이동하고, 아니면 경고하는 자바스크립트코딩하기. -->
<!-- mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm -->
<script>

	<c:if test="${loginIdCnt == 1}">
		alert("로그인에 성공했습니다.\n답변형 게시판 화면으로 이동합니다.");
		location.replace("${path1}/boardListForm.do");
		
		// location.replace("${path1}/contactSearchForm.do");
		// location.replace 보다 ajax를 사용해야 될듯...;;;
		// location.href = "${path1}/boardListForm.do";
		
		/*
		var data = {
			"keyword" : ""
			, "keyword_content" : ""
			, "row_cnt_per_page" : 15
			, "select_page_no" : 1
			, "start_row_no" : ""
		};
		
		$.ajax({	// 비동기 방식을 사용
			// 서버의 호출 URL setting
			url : "${path1}/boardListForm.do"
			, type : "post"
			, data : JSON.stringify(data)
			, contentType : "application/json;charset=utf-8"
			// -----------------------------------------------------------------------------
			// 서버가 응답한 html 소스 문자열을 현재 페이지의
			// body 태그 마지막에 html로 삽입하고, 실행하기.
			// -----------------------------------------------------------------------------
			, success : function(html) {
				// $("body").append(html);
			}
			// 서버의 응답을 못받았을 경우 실행할 익명함수 설정.
			, error : function() {
				alert( "boardListForm.jsp 파일에 접근할 수 없음!" );
			}
		});
		*/
	</c:if>
	<c:if test="${loginIdCnt != 1}">
		alert("로그인에 실패했습니다.");
	</c:if>

</script>