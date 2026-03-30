<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>CMS</title>
<script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
<script src="https://code.jquery.com/ui/1.13.2/jquery-ui.min.js"></script>
<script src="/js/devel.js"></script>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<link rel="stylesheet" href="<c:url value='/css/devel.css'/>">
<link rel="stylesheet" href="https://code.jquery.com/ui/1.13.2/themes/base/jquery-ui.css">
<link href="/images/favicon.ico" id="favicon" rel="shortcut icon" sizes="64x64" type="image/x-icon">
<script type="text/javascript">

	$(document).ready(function(){

	});

	// 아이디 찾기
	function fn_searchUserId() {
		var formData = new FormData($("#searchIdForm")[0]);

		$.ajax({
		  url: "/login/searchUserId.do",
		  type: "POST",
		  processData: false,
		  contentType: false,
		  data: formData,
		  success: function(data) {
			  if(data.message == "ok") {
				  if(data.detail == null) {
					  alert("조회된 데이터가 없습니다.\n관리자에게 문의하세요.");
				  } else {
					  alert("조회된 아이디는 ["+data.detail.memberId+"]입니다.\n비밀번호 찾기는 관리자에게 문의하세요.");
				  }
			  }
		  },
		  error: function(xhr, status, error){
			  console.log(xhr + ":" + status + ":" + error);
			  alert("처리 중 오류가 발생했습니다.");
			  return false;
		  }
		});
	}

	// 취소
	function fn_back() {
		location.href = "/login.do";
	}
</script>
</head>
<body class="dev-page">
	<form name="searchIdForm" id="searchIdForm" method="post">
		<div class="dev-box">
		    <div class="dev-header">
		        <h1>회원가입</h1>
		    </div>

		    <div class="dev-body">
	            <label for="memberNm">이름</label>
	            <input type="text" id="memberNm" name="memberNm" placeholder="이름을 입력하세요" />

	            <label for="email">이메일</label>
	            <input type="text" id="memberEmail" name="memberEmail" placeholder="ex)xxxx@xxx.xxx 형식" />

	            <label for="memberBrthdy">생년월일</label>
	            <input type="text" class="datepicker" id="memberBrthdy" name="memberBrthdy" readonly/>

	            <label for="memberPhone">핸드폰번호</label>
	            <input type="text" class="tel" id="memberPhone" name="memberPhone" placeholder="핸드폰 번호를 입력하세요" />

	            <button type="button" onclick="fn_searchUserId()" class="dev-btn">아이디 찾기</button>
	            <button type="button" onclick="fn_back()" class="dev-btn-gray">취소</button>
		    </div>

		    <div class="dev-footer">
		        © 2026 CMS Admin System
		    </div>
		</div>
	</form>
</body>
</html>