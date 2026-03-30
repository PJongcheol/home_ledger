<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원정보</title>
<script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
<script src="https://code.jquery.com/ui/1.13.2/jquery-ui.min.js"></script>
<script src="/js/devel.js"></script>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<link rel="stylesheet" href="<c:url value='/css/devel.css'/>">
<link rel="stylesheet" href="https://code.jquery.com/ui/1.13.2/themes/base/jquery-ui.css">
<link href="/images/favicon.ico" id="favicon" rel="shortcut icon" sizes="64x64" type="image/x-icon">
<script type="text/javascript">
	var chk = "0";

	$(document).ready(function(){
		// 아이디 변경 시
		$("#memberId").on("input", function(){
			// 공백 제거
			var id = $(this).val().trim();
			$("#memberId").val(id);

			chk = "0";
		});
	});

	// 저장
	function fn_save() {

		// Name
		if($("#memberNm").val() == "") {
			alert("이름은 필수입니다.");
			$("#memberNm").focus();
			return false;
		}

		// Email
		if($("#memberEmail").val() == "") {
			alert("이메일은 필수입니다.");
			$("#memberEmail").focus();
			return false;
		} else if(!emailCheck($("#memberEmail").val())) {
			alert("유효한 이메일 형식이 아닙니다.");
			$("#memberEmail").focus();
			return false;
		}

		// Birth
		if($("#memberBrthdy").val() == "") {
			alert("생년월일은 필수입니다.");
			$("#memberBrthdy").focus();
			return false;
		}

		// Phone
		if($("#memberPhone").val() == "") {
			alert("핸드폰 번호는 필수입니다.");
			$("#memberPhone").focus();
			return false;
		} else if($("#memberPhone").val().length < 13) {
			alert("핸드폰 번호는 13자리 입니다.");
			return false;
		}

		// Addr
		if($("#memberPost").val() == "" || $("#memberAddr").val() == "") {
			alert("주소는 필수입니다.");
			return false;
		}

		var formData = new FormData($("#signUpForm")[0]);

		if(confirm("저장하시겠습니까?")) {
			$.ajax({
			  url: "/etc/updateProfile.do",
			  type: "POST",
			  processData: false,
			  contentType: false,
			  data: formData,
			  success: function(data) {
				  if(data.message == "ok") {
					  alert("정상적으로 처리되었습니다. 다시 로그인 해주세요.");
					  opener.parent.fn_sessionLogin();
					  window.close();
				  }
			  },
			  error: function(xhr, status, error){
				  console.log(xhr + ":" + status + ":" + error);
				  alert("처리 중 오류가 발생했습니다.");
				  return false;
			  }
			});
		}
	}

	// 취소
	function fn_close() {
		window.close();
	}
</script>
</head>
<body class="dev-page">
	<form name="signUpForm" id="signUpForm" method="post" action="/login.do">
		<input type="hidden" id="memberId" name="memberId" value="${detail.memberId }"/>
		<div class="dev-box">
		    <div class="dev-header">
		        <h1>회원정보</h1>
		    </div>

		    <div class="dev-body">
	            <label for="memberId">아이디</label>
	            <input type="text" id="id" name="id" value="${detail.memberId }" readonly/>

	            <label for="memberNm">이름</label>
	            <input type="text" id="memberNm" name="memberNm" placeholder="이름을 입력하세요" value="${detail.memberNm}" maxLength="50"/>

	            <label for="email">이메일</label>
	            <input type="text" id="memberEmail" name="memberEmail" placeholder="ex)xxxx@xxx.xxx 형식" value="${detail.memberEmail }" maxLength="40"/>

	            <label for="memberBrthdy">생년월일</label>
	            <input type="text" class="datepicker" id="memberBrthdy" name="memberBrthdy" value="${detail.memberBrthdy}" maxLength="20" readonly/>

	            <label for="memberPhone">핸드폰번호</label>
	            <input type="text" class="tel" id="memberPhone" name="memberPhone" value="${detail.memberPhone}" placeholder="핸드폰 번호를 입력하세요"/>

	            <label for="memberPost">우편번호</label>
	            <input type="text" class="btn-63" id="memberPost" name="memberPost" value="${detail.memberPost }" placeholder="" maxLength="8" readonly />
	            <button type="button" onclick="fn_juso()" class="btn-35">우편번호검색</button>

	            <label for="memberAddr">주소</label>
	            <input type="text" id="memberAddr" name="memberAddr" value="${detail.memberAddr }" placeholder="주소찾기 버튼을 클릭하세요" maxLength="255" readonly/>

	            <label for="memberAddrDetl">상세주소</label>
	            <input type="text" id="memberAddrDetl" name="memberAddrDetl" value="${detail.memberAddrDetl }" placeholder="상세주소를 입력하세요" maxLength="255" />

	            <button type="button" onclick="fn_save()" class="dev-btn">수정하기</button>
	            <button type="button" onclick="fn_close()" class="dev-btn-gray">닫기</button>
		    </div>

		    <div class="dev-footer">
		        © 2026 CMS Admin System
		    </div>
		</div>
	</form>
</body>
</html>