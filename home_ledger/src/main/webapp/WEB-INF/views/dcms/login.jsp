<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>CMS</title>
<link rel="stylesheet" href="<c:url value='/css/devel.css'/>">
<script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
<script type="text/javascript">
	$(document).ready(function(){
		// 메세지
		if("${message}" != "") {
			alert('<c:out value="${message}" />');
		}

		// 엔터키 이벤트
		$(".input").on("keyup", function(key){
			if(key.keyCode == 13) {
				fn_login();
			}
		});
	});

	// 로그인
	function fn_login() {
		if($("#memberId").val().trim() == "") {
			alert("아이디는 필수입니다.");
			$("#memberId").focus();
			return false;
		}

		if($("#memberPw").val().trim() == "") {
			alert("비밀번호는 필수입니다.");
			$("#memberPw").focus();
			return false;
		}

		$("#loginForm").submit();
	}

	// 회원가입
	function fn_signUp() {
		location.href = "/login/signUp.do";
	}

	// 아이디 찾기
	function fn_searchId() {
		location.href = "/login/searchId.do";
	}
</script>
</head>
<body class="dev-page">
	<form name="loginForm" id="loginForm" method="post" action="/login/actionLogin.do">
		<div class="dev-box">
		    <div class="dev-header">
		        <h1>CMS ADMIN</h1>
		    </div>

		    <div class="dev-body">
	            <label for="userId">아이디</label>
	            <input class="input" type="text" id="memberId" name="memberId" placeholder="아이디를 입력하세요" />

	            <label for="password">비밀번호</label>
	            <input class="input" type="password" id="memberPw" name="memberPw" placeholder="비밀번호를 입력하세요" />

	            <button type="button" onclick="fn_login()" class="dev-btn">로그인</button>

	            <div class="sns-wrap">
				    <a href="/api/social/login/oauth.do?sns=kakao" class="sns-btn">
				        <img src="/images/kakao_login.png" alt="카카오 로그인">
				    </a>
				    <a href="/api/social/login/oauth.do?sns=naver" class="sns-btn">
				        <img src="/images/naver_login.png" alt="네이버 로그인">
				    </a>
				</div>

	            <button type="button" onclick="fn_signUp()" class="dev-btn-gray-50">회원가입</button>
	            <button type="button" onclick="fn_searchId()" class="dev-btn-gray-50">아이디찾기</button>
		    </div>
		    <div class="dev-footer">
		        © 2026 CMS Admin System
		    </div>
		</div>
	</form>
</body>
</html>