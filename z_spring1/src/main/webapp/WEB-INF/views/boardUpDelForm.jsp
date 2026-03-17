<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<!-- 현재 페이지에 common2.jsp 파일 내의 소스 삽입 // directive -->
<%@ include file="common3.jsp"%>

<html>
<head>
<meta charset="UTF-8">
<title>게시글 수정/삭제</title>
</head>

<script>

	// mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
	// [게시판 수정 / 삭제 화면]에 입력된 데이터의 유효성 체크 함수 선언.
	// mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
	function checkBoardUpDelForm( upDel ) {
		// 만약 삭제모드라면 암호 입력 여부를 체크하고,
		// name = upDel을 가진 hidden 태그에 del을 담아라.
		if(upDel=="del") {
			var password = $("[name=password]").val();
			if( password.split(" ").join("") == "") {
				alert( "암호를 입력해 주십시오." );
				$("[name=password]").focus();
				return;
			}
			document.boardUpDelForm.upDel.value = "del";
			if( confirm(" 정말 삭제하시겠습니까?") == false) {
				return;
			}
		}
		// 만약 수정모드라면 게시판 모든 내용의 유효성을 체크하기
		else if( upDel == "up" ) {
			document.boardUpDelForm.upDel.value = "up";
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
			
			if( confirm("정말 수정하시겠습니까?") == false ) {
				return;
			}
			
			// console.log("data, checkBoardRegForm => " , $("[name=boardRegForm]").serialize());
		}
		
		var data = {
			  "b_no" : $("[name=b_no]").val()
			, "writer" : $("[name=writer]").val()
			, "subject" : $("[name=subject]").val()
			, "email" : $("[name=email]").val()
			, "content" : $("[name=content]").val()
			, "b_password" : $("[name=password]").val()
			, "up_del" : upDel
		};
		
		// ============================================================================
		// [게시판 입력 행 적용 개수]가 있는 html 소스를 받기
		$.ajax({	// 비동기 방식을 사용
			// 서버의 호출 URL setting
			url : "${path1 }/boardUpDelProc.do"
			
			// form Tag 안의 데이터를 보내는 방법 지정
			, type : "post"
			
			// 서버에 보낼 파라미터명과 파라미터값을 설정
			, data : JSON.stringify(data)
			, contentType : "application/json;charset=utf-8"
			
			// -----------------------------------------------------------------------------
			// 서버가 응답한 html 소스 문자열을 현재 페이지의
			// body 태그 마지막에 html로 삽입하고, 실행하기.
			// -----------------------------------------------------------------------------
			, success : function( result ) {
				
				console.log("result , boardUpDelForm => " , result);
				
				if( result > 0 ) {
					// alert("게시판 글 수정 성공!");
					
					if( document.boardUpDelForm.upDel.value == "del" ) {
						alert( "게시글 삭제 성공!" );
					}
					else if( document.boardUpDelForm.upDel.value == "up" ) {
						alert( "게시글 수정 성공!" );
					}
					
					// name = boardListForm을 가진 form 태그 안의 action에 설정된 URL로 이동하기
					// 이동 시 form 태그 안의 모든 입력 양식이 파라미터값으로 전송된다.
					$("[name=boardListForm] [name=keyword]").val("all");
					$("[name=boardListForm] [name=keywordContent]").val("");
					$("[name=boardListForm] [name=selectPageNo]").val(1);
					$("[name=boardListForm] [name=rowCntPerPage]").val(15);
					document.boardListForm.submit();
				}
				// 암호가 틀리면 경고한 후, 암호를 비우고, 커서 들여놓기.
				else if( result == 0 ) {
					alert( "암호가 틀립니다. 재입력 바람!" );
					$("[name=password]").val("");
					$("[name=password]").focus();
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

	function goBoardListForm() {
		document.boardListForm.submit();
	}

</script>

<body>
	
	<center><br />
		<!-- mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm -->
		<!-- [게시판 등록] 화면을 출력하는 form 태그 선언 -->
		<!-- mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm -->
		<form name="boardUpDelForm" method="post">
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
						<input type="text" size="40" maxlength="50" name="subject" value="${board.subject }" />
					</td>
				</tr>
				<tr>
					<th bgcolor=#C6C6C6>
						이메일
					</th>
					<td>
						<input type="text" size="40" maxlength="50" name="email" value="${board.email }" />
					</td>
				</tr>
				<tr>
					<th bgcolor=#C6C6C6>
						내용
					</th>
					<td>
						<textarea name="content" rows="13" cols="40">${board.content }</textarea>
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
			<input type="hidden" name="upDel" value="up" />
			
			<!-- 추가 요구사항 대비 -->
			<%-- <input type="hidden" name="rowCntPerPage" value="${rowCntPerPage }" /> --%>
	
			<input type="button" value="수정" onClick="checkBoardUpDelForm('up')">
			<input type="button" value="삭제" onClick="checkBoardUpDelForm('del')">
			<input type="button" value="목록보기" onClick="javascript:goBoardListForm();">
		</form>
		
		<!-- mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm -->
		<!-- [선택한 페이지번호]를 저장한 hidden 태그를 선언하고 [게시판 목록] 화면으로 이동하는 form 태그 선언 -->
		<!-- mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm -->
		<form name="boardListForm" method="post" action="${path1 }/boardListForm.do">
			<input type="hidden" name="keyword" value="${keyword }" />
			<input type="hidden" name="keywordContent" value="${keywordContent }" />
			<input type="hidden" name="selectPageNo" value="${selectPageNo }" />
			<input type="hidden" name="rowCntPerPage" value="${rowCntPerPage }" />
		</form>
	</center>

</body>
</html>