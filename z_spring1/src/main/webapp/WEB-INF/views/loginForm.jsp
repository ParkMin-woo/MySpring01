<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!-- JSP 실행 후 생성되는 문서는 HTML이고, UTF-8 방식으로 인코딩 한다라고 설정함 -->
<!-- JSP 페이지는 UTF-8 방식으로 인코딩한다. -->
<!-- UTF-8 인코딩 방식은 한글을 포함 전 세계 모든 문자열을 부호화 할 수 있는 방법이다. -->
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<!-- 현재 페이지에 /WEB-INF/views/common.jsp 파일 내의 소스 삽입 // directive -->
<!-- /, http로 시작하면 절대경로 -->
<!-- 그 외는 모두 상대경로 -->
<%@ include file="/WEB-INF/views/common.jsp"%>

<html>
<head>
<meta charset="UTF-8">
<title>로그인</title>
</head>

<script>

//body 태그 안의 소스를 모두 실행한 후에 실행할 자스 코드 설정
$(document).ready(function() {
	// alert("alert checking");
	// class="login" 을 가진 태그에 click 이벤트 발생 시 실행할 코드 설정하기
	$("[name=loginForm] .login").click(function() {
		// alert("[로그인] 버튼 클릭");
		checkLoginForm();
	});
	
	console.log("loginIdCookie 값 => ", "${loginIdCookie}");
	console.log("pwdCookie 값 => ", "${pwdCookie}");
	
	$('[name=login_id]').val('${cookie.loginId.value}');
	$('[name=password]').val('${cookie.pwd.value}');
	<c:if test="${!empty cookie.loginId.value}">
		$('[name=is_login]').prop( "checked", true);
	</c:if>
	
	// 로그인 정보 유효성을 체크하고,
	// 비동기(Async) 방식으로 서버와 통신하여
	// 로그인 아이디와 비밀번호가 맞으면 게시판 목록 화면으로 이동하기.
	function checkLoginForm() {
		// 웹브라우저에서 입력한 [아이디]를 가져와 변수에 저장
		var login_id = $("[name=login_id]").val();
		// 웹브라우저에서 입력한 [비밀번호]를 가져와 변수에 저장
		var pwd = $("[name=password]").val();
		// var is_login = $("[name=is_login]").val();
		// Ajax 요청을 보내기 직전의 checkbox value 부분
		var isLoginChecked = $("input[name='is_login']").is(":checked") ? "Y" : "N";
		
		// [아이디]를 입력하지 않았으면 경고하고 멈추기
		if(login_id.split(" ").join() == "") {
			alert("[아이디]를 입력해 주세요.");
			$("[name=login_id]").val("");
			return;
		}
		
		// [비밀번호]를 입력하지 않았으면 경고하고 멈추기
		if(pwd.split(" ").join() == "") {
			alert("[비밀번호]를 입력해 주세요.");
			$("[name=password]").val("");
			return;
		}
		
		var data = {
			"login_id" : login_id
			, "pwd" : pwd
			, "is_login" : isLoginChecked
		};
		
		console.log("JSON.stringify 데이터 => " , JSON.stringify(data));
		
		// 현재 화면에서 페이지 이동이 없이(= 비동기 방식으로) 서버쪽 "/ex01/loginProc.do"를 호출하여
		// [아이디의 존재 개수] 문자열을 응답 받아 존재 개수가 1이면 [게시판 목록 화면(boardListForm.jsp)]으로 이동한다.
		$.ajax({	// 비동기 방식을 사용
			// 서버의 호출 URL setting
			url : "${path1}/loginProc.do"
			
			// form Tag 안의 데이터를 보내는 방법 지정
			, type : "post"
			// , dataType : "json"
			// 서버에 보낼 파라미터명과 파라미터 값을 설정
			// , data : {'login_id' : login_id, 'password' : pwd, 'is_login' : $("[name=is_login]").val()}
				// 오른쪽도 가능.	, data : "login_id = " + login_id + "&password = " + pwd
			// , data : $("[name = loginForm]").serialize()
			, data : JSON.stringify(data)
			// 요청 파라미터를 JSON 형태로 내도록 처리
			// , data : JSON.stringify($("[name = loginForm]").serialize())
			
			, contentType : "application/json;charset=utf-8"
			// -----------------------------------------------------------------------------
			// 서버가 응답한 html 소스 문자열을 현재 페이지의
			// body 태그 마지막에 html로 삽입하고, 실행하기.
			// -----------------------------------------------------------------------------
			, success : function(html) {
				/*
				// 서버가 응답해준 html 소스를 실행하여 출력되는 문자열에서
				// 공백을 제거하고, 변수에 저장된다.
				// 즉, 아이디, 암호 존재 개수가 저장된다.
				// alert("투표는 기호2번!");
				var idCnt = $(data).text().split(" ").join("");
				alert("로그인 아이디 존재 개수 => " + idCnt + "\n" + "길이 => " + idCnt.length);
				return;
				// alert(idCnt);
				// return;
				// 아이디, 암호가 존재하면 /ex01/loginProc.jsp로 페이지 이동하기
				if (idCnt == "1"){
					alert( "로그인 성공! ");
					location.replace("${path1}/boardListForm.jsp");
				}
				// 아이디, 암호가 존재하지 않으면 경고하기
				else {
					alert( "로그인 실패!" );
				}
				*/
				// ------------------
				// 서버가 응답한 html 소스 문자열을 현재 페이지의
				// body 태그 마지막에서 html로 삽입하고 실행하기.
				// ------------------
				$("body").append(html);
			}
			// 서버의 응답을 못받았을 경우 실행할 익명함수 설정.
			, error : function() {
				alert( "서버 접속 실패!" );
			}
		});
	}
});

</script>

<body>
	<!-- <h3>로그인 화면 개발 진행중입니다.</h3> -->
	
	<center><br /><br /><br />
		<!-- [로그인 정보 입력 양식]을 내포한 form 태그 선언 -->
		<form name="loginForm" method="post">
			<table class="tbcss1" border=1 cellpadding=20 cellspacing=20 bordercolor="gray">
				<tr>
					<th>
						<b>[로그인]</b>
					</th>
					<div style="height:6"></div>
				</tr>
				<table border=1 cellpadding=5 cellspacing=0 bordercolor="gray" class="tbcss1">
					<tr>
						<th bgcolor="#E1E1E1" align=center>
							아이디
						</th>
						<td>
							<input type="text" name="login_id" class="login_id" size="20" />
						</td>
					</tr>
					<tr>
						<th bgcolor="#E1E1E1" align=center>
							비밀번호
						</th>
						<td>
							<input type="password" name="password" class="password" size="22" />
						</td>
					</tr>
				</table>
				<div style="height:6"></div>
				<input type="button" value="로그인" class="login" />
				<input type="checkbox" name="is_login" />아이디, 비밀번호 기억 
				<div style="height:6"></div>
			</table>
		</form>
	
	</center>
</body>
</html>