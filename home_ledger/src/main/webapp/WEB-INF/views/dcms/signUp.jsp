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
	var chk = "0";

	$(document).ready(function(){
		// alert messgae
		if("${message}" != "") {
			alert('<c:out value="${message}" />');
		}

		// 아이디 변경 시
		$("#memberId").on("input", function(){
			// 공백 제거
			var id = $(this).val().trim();
			$("#memberId").val(id);

			chk = "0";
		});
	});

	// 아이디 중복검사
	function checkDup(){
		var memberId = $("#memberId").val();

		$.ajax({
		  url: "/login/checkId.do",
		  type: "POST",
		  data: {
			  memberId: memberId
		  },
		  success: function(data) {

			  console.log(data);
			  if(data.message == "ok") {
				  alert("사용 가능한 아이디입니다.");
				  chk = "1";
			  } else if(data.message == "dup") {
				  alert("이미 등록된 아이디입니다.");
				  chk = "0";
			  }

		  },
		  error: function(xhr, status, error){
			  console.log(xhr + ":" + status + ":" + error);
			  alert("처리 중 오류가 발생했습니다.");
			  return false;
		  }
		});
	}

	// 저장
	function fn_save() {
		// ID
		if($("#memberId").val() == "") {
			alert("아이디는 필수입니다.");
			$("#memberId").focus();
			return false;
		} else if($("#memberId").val().length < 4) {
			alert("아이디는 최소 4자리입니다.");
			$("#memberId").focus();
			return false;
		} else if(chk == "0") {
			alert("아이디 중복검사는 필수입니다.");
			$("#memberId").focus();
			return false;
		}

		// PassWord
		if($("#memberPw").val() == "" || $("#memberPw2").val() == "") {
			alert("비밀번호는 필수입니다.");
			return false;
		} else if($("#memberPw").val().length < 4) {
			alert("비밀번호는 최소 4자리입니다.");
			return false;
		} else if($("#memberPw").val() != $("#memberPw2").val()) {
			alert("비밀번호가 일치하지 않습니다.");
			$("#memberPw2").focus();
			return false;
		}

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

		// agree
		if(!$("#agreeYn").is(":checked")) {
			alert("개인정보 동의는 필수입니다.");
			return false;
		}

		var formData = new FormData($("#signUpForm")[0]);

		if(confirm("저장하시겠습니까?")) {
			$.ajax({
			  url: "/login/signUpSave.do",
			  type: "POST",
			  processData: false,
			  contentType: false,
			  data: formData,
			  success: function(data) {
				  if(data.message == "ok") {
// 					  alert("정상적으로 처리되었습니다.\n관리자의 승인 후 이용 가능합니다.");
					  alert("정상적으로 처리되었습니다.");
					  location.href = "/login.do";
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
	function fn_back() {
		location.href = "/login.do";
	}
</script>
</head>
<body class="dev-page">
	<form name="signUpForm" id="signUpForm" method="post" action="/login.do">
		<div class="dev-box">
		    <div class="dev-header">
		        <h1>회원가입</h1>
		    </div>

		    <div class="dev-body">
	            <label for="memberId">아이디</label>
	            <input type="text" class="btn-63" id="memberId" name="memberId" placeholder="영문 또는 숫자 4자리" maxLength="100" />
	            <button type="button" onclick="checkDup()" class="btn-35">중복검사</button>

	            <label for="memberPw">비밀번호</label>
	            <input type="password" id="memberPw" name="memberPw" placeholder="4자리 이상" />

	            <label for="memberPw2">비밀번호 확인</label>
	            <input type="password" id="memberPw2" name="memberPw2" placeholder="동일한 비밀번호를 입력하세요"/>

	            <label for="memberNm">이름</label>
	            <input type="text" id="memberNm" name="memberNm" placeholder="이름을 입력하세요" maxLength="50" />

	            <label for="email">이메일</label>
	            <input type="text" id="memberEmail" name="memberEmail" placeholder="ex)xxxx@xxx.xxx 형식" maxLength="40"/>

	            <label for="memberBrthdy">생년월일</label>
	            <input type="text" class="datepicker" id="memberBrthdy" name="memberBrthdy" maxLength="20" readonly/>

	            <label for="memberPhone">핸드폰번호</label>
	            <input type="text" class="tel" id="memberPhone" name="memberPhone" placeholder="핸드폰 번호를 입력하세요" />

	            <label for="memberPost">우편번호</label>
	            <input type="text" class="btn-63" id="memberPost" name="memberPost" placeholder="" maxLength="8" readonly />
	            <button type="button" onclick="fn_juso()" class="btn-35">우편번호검색</button>

	            <label for="memberAddr">주소</label>
	            <input type="text" id="memberAddr" name="memberAddr" placeholder="주소찾기 버튼을 클릭하세요" maxLength="255" readonly/>

	            <label for="memberAddrDetl">상세주소</label>
	            <input type="text" id="memberAddrDetl" name="memberAddrDetl" placeholder="상세주소를 입력하세요" maxLength="255" />

	            <div class="agree-box">
				    <label>
				        <input type="checkbox" id="agreeYn" name="agreeYn" value="Y">
				        <span>
				            개인정보 수집 및 이용에 동의합니다.
				        </span>
				    </label>
				</div>

	            <button type="button" onclick="fn_save()" class="dev-btn">저장하기</button>
	            <button type="button" onclick="fn_back()" class="dev-btn-gray">취소</button>
		    </div>

		    <div class="dev-footer">
		        © 2026 CMS Admin System
		    </div>
		</div>
	</form>
</body>
</html>