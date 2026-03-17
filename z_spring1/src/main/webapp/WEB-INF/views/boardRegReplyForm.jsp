<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<!-- 현재 페이지에 common2.jsp 파일 내의 소스 삽입 // directive -->
<%@ include file="common2.jsp"%>

<html>
<head>
<meta charset="UTF-8">
<title>${title }</title>
</head>

<script>

	// **********************************************************************
	// [게시판 등록 화면]에 입력된 데이터의 유효성 체크 함수 선언
	// **********************************************************************
	function checkBoardRegForm() {
		/*
		// 이름은 세션에 저장된 login_id값을 이용하므로
		// 여기서는 별도의 유효성 체크는 필요없다.
		// 보통 실무에서 게시판 관련된 부분은
		// 이름이나 직번을 입력하지 않고,
		// hidden이나 session, DB 호출로 불러온 값들로
		// 이름을 자동으로 insert한다.
		var writer = $("[name=writer]").val();
		if( writer.split(" ").join("") == "" ) {
			alert("작성자를 입력해 주세요.");
			$("[name=writer]").focus();
			return;
		}
		*/
		
		var subject = $("[name=subject]").val();
		if( subject.split(" ").join("") == "" ) {
			alert("제목을 입력해 주세요.");
			$("[name=subject]").focus();
			return;
		}
		
		var email = $("[name=email]").val();
		var regExp = new RegExp(/^([0-9a-zA-Z_-]+)@([0-9a-zA-Z_-]+)(\.[0-9a-zA-Z_-]+){1,2}$/);
		var flag = regExp.test(email);
		if( !flag ) {
			alert("이메일 형식으로 구성되어 있지 않습니다.\n재입력 해주세요!");
			$("[name=email]").val("");
			$("[name=email]").focus();
			return;
		}
		
		var content = $("[name=content]").val();
		if( content.split(" ").join("") == "" ) {
			alert("내용을 입력해 주세요.");
			$("[name=content]").focus();
			return;
		}
		
		var password = $("[name=password]").val();
		if( password.split(" ").join("") == "" ) {
			alert("비밀번호를 입력해 주세요.");
			$("[name=password]").focus();
			return;
		}
		
		if( confirm("정말 저장하시겠습니까?") == false ) {
			return;
		}
		
		var data = {
			"b_no" : ${bNo}
			, "writer" : $("[name=writer]").val()
			, "subject" : subject
			, "email" : email
			, "content" : content
			, "b_password" : password
		};
		
		// console.log("data, checkBoardRegForm => " , $("[name=boardRegForm]").serialize());
		
		// ============================================================================
		// [게시판 입력 행 적용 개수]가 있는 html 소스를 받기
		$.ajax({	// 비동기 방식을 사용
			// 서버의 호출 URL setting
			url : "${path1 }/boardRegReplyProc.do"
			
			// form Tag 안의 데이터를 보내는 방법 지정
			, type : "post"
			
			// 서버에 보낼 파라미터명과 파라미터값을 설정
			, data : JSON.stringify(data)
			, contentType : "application/json;charset=utf-8"
			
			, success : function( result ) {
				
				console.log("result , boardRegReplyForm => " , result);
				if( result == 1 ) {
					alert("게시판 글 입력 성공!");
					// name = boardListForm을 가진 form 태그 안의 action에 설정된 URL로 이동하기
					// 이동 시 form 태그 안의 모든 입력 양식이 파라미터값으로 전송된다.
					$("[name=boardListForm] [name=keyword]").val("all");
					$("[name=boardListForm] [name=keywordContent]").val("");
					$("[name=boardListForm] [name=selectPageNo]").val(1);
					$("[name=boardListForm] [name=rowCntPerPage]").val(15);
					document.boardListForm.submit();
				}
				else {
					alert("관리자에게 문의 바람!");
				}
			}
			
			// 서버의 응답을 못받았을 경우 실행할 익명함수 설정.
			, error : function() {
				alert( "서버와 비동기 방식 통신 실패!" );
			}
		});
	}

	function goBoardRegForm() {
		document.boardListForm.submit();
	}

</script>

<body>

	<!-- <h1>게시글 작성/수정 화면 개발중입니다.</h1> -->
	
	<center><br />
		<!-- mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm -->
		<!-- [게시판 등록] 화면을 출력하는 form 태그 선언 -->
		<!-- mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm -->
		<form name="boardRegForm" method="post">
		
			<c:choose>
				<c:when test="${bNo == '0'}">
					<b>[새 글 작성]</b>
				</c:when>
				<c:otherwise>
					<b>[답글 작성]</b>
				</c:otherwise>
			</c:choose>
			
			<!-- -------------------------------------------------------------------------- -->
			<table align="center" class="tbcss1" border="1" cellpadding="5" cellspacing="0" bordercolor=gray>
				<tr>
					<th bgcolor=#C6C6C6>
						작성자
					</th>
					<td>
						<input type="text" size="10" name="writer" class="writer" value="${sessionScope.loginId }" readonly="readonly" />
					</td>
				</tr>
				<tr>
					<th bgcolor=#C6C6C6>
						제목
					</th>
					<td>
						<input type="text" size="40" maxlength="50" name="subject" />
					</td>
				</tr>
				<tr>
					<th bgcolor=#C6C6C6>
						이메일
					</th>
					<td>
						<input type="text" size="40" maxlength="50" name="email" />
					</td>
				</tr>
				<tr>
					<th bgcolor=#C6C6C6>
						내용
					</th>
					<td>
						<textarea name="content" rows="13" cols="40"></textarea>
					</td>
				</tr>
				<tr>
					<th bgcolor=#C6C6C6>
						비밀번호
					</th>
					<td>
						<input type="password" size="15" maxlength="20" name="password" />
					</td>
				</tr>
			</table>
			
			<table>
				<tr height=4></tr>
			</table>
			
			<input type="hidden" name="b_no" value="${bNo }" />
			<input type="button" value="저장" onClick="checkBoardRegForm()" />
			<input type="reset" value="다시작성" />
			<input type="button" value="목록보기" onClick="javascript:goBoardRegForm();" />
		</form>
		
		<!-- mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm -->
		<!-- [선택한 페이지번호]를 저장한 hidden 태그를 선언하고 [게시판 목록] 화면으로 이동하는 form 태그 선언 -->
		<!-- mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm -->
		<form name="boardListForm" method="post" action="${path1}/boardListForm.do">
			<input type="hidden" name="keyword" value="${keyword }" />
			<input type="hidden" name="keywordContent" value="${keywordContent }" />
			<input type="hidden" name="rowCntPerPage" value="${rowCntPerPage }" />
			<input type="hidden" name="selectPageNo" value="${selectPageNo }" />
		</form>
	</center>

</body>
</html>