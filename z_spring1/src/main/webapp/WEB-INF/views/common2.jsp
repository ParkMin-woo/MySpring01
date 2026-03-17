<!-- 현재 JSP 페이지의 처리 방식 설정 -->
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>	<!-- 모든 JSP 페이지에서 나오는 필수요소 -->

<!-- 현재 페이지에 common.jsp 파일 내의 소스 삽입하기. -->
<%@ include file="common.jsp"%>

<!-- [JSTL 커스텀 태그]와 EL을 사용하여 -->
<!-- HttpSession 객체에 로그인 아이디가 없으면 경고하고, -->
<!-- 로그인 화면으로 이동시키는 자바 소스 선언 -->
<c:if test="${empty sessionScope.loginId}">
	<script>
		alert('로그인 요망!');
		location.replace('${path1}/loginForm.do');
	</script>
</c:if>

<script>

	// ++++++++++++++++++++++++++++++++++++++++++++++++++++
	// body 태그 안의 소스를 모두 실행한 후에 실행할 자스 코드 설정
	// ++++++++++++++++++++++++++++++++++++++++++++++++++++
	$(document).ready(function() {
		
		// ----------------------------------------------------
		// form 태그 마지막에 button 태그 삽입		
		// ----------------------------------------------------
		$("form:eq(0)").append(
			"<input type='button' value='로그아웃' onClick='location.replace(\"${path1}/loginForm.do\")'>"
		);
	});

</script>