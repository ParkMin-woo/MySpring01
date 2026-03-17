<!-- 현재 JSP 페이지의 처리 방식 설정 -->
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>	<!-- 모든 JSP 페이지에서 나오는 필수요소 -->

<!-- 현재 페이지에 common.jsp 파일 내의 소스 삽입하기. -->
<%@ include file="common2.jsp"%>

<!-- 현재 페이지를 get 방식으로 호출하면 경고하고, 로그인 화면으로 튕겨내기. -->
<%
	// 웹브라우저가 웹서버에 접근하는 방식(post 또는 get)을 얻어내어 변수에 저장하기.
	String method = request.getMethod();
	// 만약 GET방식이라면 경고하고, 로그인 화면으로 튕겨내기
	if ( method.equals("GET") ) {
		out.print( "<script>" );
		out.print( "alert('URL 뒤에 데이터를 달아 전송할 수 없습니다.');" );
		out.print( "location.replace('${path1}/loginForm.do');" );
		out.print( "</script>" );
	}
%>