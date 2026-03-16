<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>사용자관리</title>
<script type="text/javascript">
	$(document).ready(function(){
		// 저장
		$("#btnSave").on("click", function(){
			// 이름
			if($("#memberNm").val().trim() == "") {
				alert("이름은 필수입니다.");
				$("#memberNm").focus();
				return false;
			}

			// 마스터코드
			if($("#masterCode").val() == "") {
				alert("마스터코드는 필수입니다.");
				$("#masterCode").focus();
				return false;
			}

			// 이메일
			if($("#memberEmail").val().trim() == "") {
				alert("이메일은 필수입니다.");
				$("#memberEmail").focus();
				return false;
			} else if(!emailCheck($("#memberEmail").val())) {
				alert("유효한 이메일 형식이 아닙니다.");
				$("#memberEmail").focus();
				return false;
			}

			// 생년월일
			if($("#memberBrthdy").val() == "") {
				alert("생년월일은 필수입니다.");
				$("#memberBrthdy").focus();
				return false;
			}

			// 휴대폰번호
			if($("#memberPhone").val() == "") {
				alert("핸드폰 번호는 필수입니다.");
				$("#memberPhone").focus();
				return false;
			} else if($("#memberPhone").val().length < 13) {
				alert("핸드폰 번호는 13자리 입니다.");
				return false;
			}

			// 주소
			if($("#memberPost").val() == "" || $("#memberAddr").val() == "") {
				alert("주소는 필수입니다.");
				return false;
			}

			// 승인여부
			if($("#confmYn").val() == "") {
				alert("승인여부는 필수입니다.")
				$("#confmYn").focus();
				return false;
			}

			// 사용여부
			if($("#useYn").val() == "") {
				alert("사용여부는 필수입니다.")
				$("#useYn").focus();
				return false;
			}

			var formData = new FormData($("#adminUserDetailForm")[0]);

			if(confirm("저장하시겠습니까?")) {
				$.ajax({
				  url: "/admin/user/saveUser.do",
				  type: "POST",
				  processData: false,
				  contentType: false,
				  data: formData,
				  success: function(data) {
					  if(data.message == "ok") {
						  alert("정상적으로 처리되었습니다.");
						  fn_back();
					  }
				  },
				  error: function(xhr, status, error){
					  console.log(xhr + ":" + status + ":" + error);
					  alert("처리 중 오류가 발생했습니다.");
					  return false;
				  }
				});
			}
		});
	});

	// 목록
	function fn_back() {
		$("#adminUserForm").submit();
	}

	// 로그인 실패 카운트 초기화
	function fn_reset(memberId) {
		if(confirm("로그인 실패 카운트 초기화를 하시겠습니까?")) {
			$.ajax({
			  url: "/admin/user/loginCountReset.do",
			  type: "POST",
			  data: {
			  	memberId : memberId
			  },
			  success: function(data) {
				  if(data.message == "ok") {
					  alert("정상적으로 처리되었습니다.");
					  location.reload(true);
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

</script>
</head>
<body class="common-page">
	<div class="menu-container">
	    <h2>사용자 상세</h2>
	    <div class="common_section">
	    	<form id="adminUserForm" name="adminUserForm" method="post" action="/admin/user/userList.do">
	    	</form>
            <form name="adminUserDetailForm" id="adminUserDetailForm">
	            <input type="hidden" id="memberId" name="memberId" value="${detail.memberId }" />
	            <table>
	            	<colgroup>
	            		<col style="width:15%">
	            		<col style="width:35%">
	            		<col style="width:15%">
	            		<col style="width:35%">
	            	</colgroup>
	                <tbody class="no-hover">
	                    <tr>
	                        <th>아이디 (가입일)</th>
	                        <td><c:out value="${detail.memberId }"/> (<c:out value="${detail.joinDe }"/>)</td>
	                        <th>로그인실패카운트</th>
	                        <td>
	                        	<c:out value="${detail.failCnt }"/>
	                        	<button type="button" onclick="fn_reset('${detail.memberId }')" class="btn gray">초기화</button>
	                        </td>

	                    </tr>
	                    <tr>
	                        <th>이름</th>
	                        <td><input type="text" id="memberNm" name="memberNm" value="${detail.memberNm }" maxlength="50"></td>
	                        <th>마스터코드</th>
	                        <td>
								<select id="masterCode" name="masterCode">
									<option value="">선택</option>
									<option value="10" ${detail.masterCode eq '10' ? 'selected' : '' }>최고관리자</option>
									<option value="9" ${detail.masterCode eq '9' ? 'selected' : '' }>관리자</option>
									<option value="1" ${detail.masterCode eq '1' ? 'selected' : '' }>일반사용자</option>
								</select>
	                        </td>
	                    </tr>
	                    <tr>
	                        <th>이메일</th>
	                        <td><input type="text" id="memberEmail" name="memberEmail" value="${detail.memberEmail }" maxlength="40"></td>
	                        <th>생년월일</th>
	                        <td><input type="text" class="datepicker" id="memberBrthdy" name="memberBrthdy" value="${detail.memberBrthdy }" readonly></td>
	                    </tr>
	                    <tr>
	                        <th>휴대폰번호</th>
	                        <td><input type="text" class="tel" id="memberPhone" name="memberPhone" value="${detail.memberPhone }"></td>
	                        <th>우편번호</th>
	                        <td>
	                        	<input type="text" id="memberPost" name="memberPost" value="${detail.memberPost }" readonly>
	                        	<button type="button" onclick="fn_juso()" class="btn gray">우편번호검색</button>
	                        </td>
	                    </tr>
	                    <tr>
	                        <th>주소</th>
	                        <td><input type="text" id="memberAddr" name="memberAddr" value="${detail.memberAddr }" readonly></td>
	                        <th>상세주소</th>
	                        <td><input type="text" id="memberAddrDetl" name="memberAddrDetl" value="${detail.memberAddrDetl }" maxlength="255"></td>
	                    </tr>
	                    <tr>
	                        <th>승인여부</th>
	                        <td>
	                        	<select id="confmYn" name="confmYn">
									<option value="">선택</option>
									<option value="Y" ${detail.confmYn eq 'Y' ? 'selected' : '' }>승인</option>
									<option value="N" ${detail.confmYn eq 'N' ? 'selected' : '' }>미승인</option>
								</select>
	                        </td>
	                        <th>사용여부</th>
	                        <td>
	                        	<select id="useYn" name="useYn">
									<option value="">선택</option>
									<option value="Y" ${detail.useYn eq 'Y' ? 'selected' : '' }>승인</option>
									<option value="N" ${detail.useYn eq 'N' ? 'selected' : '' }>미승인</option>
								</select>
	                        </td>
	                    </tr>
	                    <tr>
	                        <th>수정자ID</th>
	                        <td>${detail.updId }</td>
	                        <th>수정일시</th>
	                        <td>${detail.updDt }</td>
	                    </tr>
	                </tbody>
	            </table>
			</form>
            <div class="btn-form">
                <button id="btnSave" class="btn blue">저장</button>
                <button class="btn gray" onclick="history.back()">목록</button>
            </div>

        </div>
	</div>
</body>
</html>