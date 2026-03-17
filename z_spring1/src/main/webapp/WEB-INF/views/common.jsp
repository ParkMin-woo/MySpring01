<!-- 현재 JSP 페이지의 처리 방식 설정 -->
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- JSP 페이지에서 사용할 [사용자 정의 태그]인 [JSTL의 C코어 태그] 선언 // 이거 때문에 custom Tag를 사용할 수 있었다. -->
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!-- JSP 페이지에서 사용할 [사용자 정의 태그]인 [spring form 태그] 선언 -->
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<!-- JSP 페이지에서 사용할 [CSS 파일] 수입 -->
<link href = "${pageContext.request.contextPath}/resources/style1.css" rel = "stylesheet" type = "text/css">

<!-- JSP 페이지에서 사용할 [JQuery 파일] 수입 -->
<!-- <script src = "/z_jsp2/resources/jquery-1.11.0.min.js" type = "text/javascript"></script> -->
<script
	src="https://code.jquery.com/jquery-4.0.0.js"
	integrity="sha256-9fsHeVnKBvqh3FB2HYu7g2xseAZ5MlN6Kz/qnkASV8U="
	crossorigin="anonymous">
</script>

<!-- JSP 페이지에서 사용할 [공유 자바스크립트 소스] 수입 -->
<script src = "${pageContext.request.contextPath}/resources/common.js" type = "text/javascript"></script>

<!-- 요청메시지 안의 문자셋을 지정 -->
<%
	request.setCharacterEncoding( "UTF-8" );
%>

<!-- JSTL 커스텀 태그를 사용하여 path1라는 자바 변수를 선언하고 Context Path EL 데이터 저장하기 -->
<!-- JSTL 커스텀 태그를 사용하여 선언한 자바 변수는 EL을 사용하여 -->
<!-- 달러표시(변수명)으로 꺼낼 수 있다. -->
<c:set var="path1" value="${pageContext.request.contextPath}"/>