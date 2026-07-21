<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>예산 상세</title>
<script type="text/javascript">
	$(document).ready(function(){
		// 저장
		$("#btnSave").on("click", function(){
			// 미용
			if($("#beauAmount").val() == "") {
				alert("미용 금액은 필수입니다.");
				$("#beauAmount").focus();
				return false;
			}

			// 교육
			if($("#eduAmount").val().trim() == "") {
				alert("교육 금액은 필수입니다.");
				$("#eduAmount").focus();
				return false;
			}

			// 기타
			if($("#etcAmount").val().trim() == "") {
				alert("기타 금액은 필수입니다.");
				$("#etcAmount").focus();
				return false;
			}

			// 미용
			if($("#eventAmount").val() == "") {
				alert("경조사 금액은 필수입니다.");
				$("#eventAmount").focus();
				return false;
			}

			// 식비
			if($("#foodAmount").val().trim() == "") {
				alert("식비 금액은 필수입니다.");
				$("#foodAmount").focus();
				return false;
			}

			// 건강/문화
			if($("#healAmount").val().trim() == "") {
				alert("건강/문화 금액은 필수입니다.");
				$("#healAmount").focus();
				return false;
			}

			// 주거/통신
			if($("#homeAmount").val() == "") {
				alert("주거/통신 금액은 필수입니다.");
				$("#homeAmount").focus();
				return false;
			}

			// 교통
			if($("#tranAmount").val().trim() == "") {
				alert("교통 금액은 필수입니다.");
				$("#tranAmount").focus();
				return false;
			}

			var formData = new FormData($("#budgetDetailForm")[0]);

			if(confirm("저장 하시겠습니까?")) {
				$.ajax({
				  url: "/user/budget/saveBudget.do",
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

		// 삭제
		$("#btnDelete").on("click", function(){
			var formData = new FormData($("#budgetDetailForm")[0]);

			if(confirm("삭제하시겠습니까?")) {
				$.ajax({
				  url: "/user/budget/deleteBudget.do",
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

		// 전월 예산 불러오기
		$("#btnPrev").on("click", function(){
			var formData = new FormData($("#budgetDetailForm")[0]);

			if(confirm("전월 예산으로 등록하시겠습니까?")) {
				$.ajax({
				  url: "/user/budget/prevBudget.do",
				  type: "POST",
				  processData: false,
				  contentType: false,
				  data: formData,
				  success: function(data) {
					  if(data.message == "ok") {
						  alert("정상적으로 처리되었습니다.");
						  fn_back();
					  } else if(data.message == "none") {
						  alert("전월 예산이 등록되어있지 않았습니다.");
						  return false;
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
		$("#budgetForm").submit();
	}

</script>
</head>
<body class="common-page">
	<div class="menu-container">
	    <h2>예산 상세</h2>
	    <div class="common_section">
	    	<form id="budgetForm" name="budgetForm" method="post" action="/user/budget/budgetList.do">
	    	</form>
            <form name="budgetDetailForm" id="budgetDetailForm">
	            <input type="hidden" id="biSeq" name="biSeq" value="${detail.biSeq }" />
	            <input type="hidden" id="mode" name="mode" value="${empty detail ? 'I' : 'U'}" />
	            <table class="form-table">
	            	<colgroup>
	            		<col style="width:15%">
	            		<col style="width:35%">
	            		<col style="width:15%">
	            		<col style="width:35%">
	            	</colgroup>
	                <tbody class="no-hover">
	                    <tr>
	                        <th>예산 년월</th>
	                        <td colspan="3">
	                        	<c:out value="${holder.yearMonth }"/>
	                        	<input type="hidden" id="biYearMonth" name="biYearMonth" value="${holder.yearMonth }" />
	                        </td>
	                    </tr>
	                    <tr>
	                    	<th>미용<span class="required-label"></span></th>
	                        <td><input type="text" id="beauAmount" name="beauAmount" value="${detail.beauAmount }" class="input-small only_number_comma"></td>
	                        <th>교육<span class="required-label"></span></th>
	                        <td><input type="text" id="eduAmount" name="eduAmount" value="${detail.eduAmount }" class="input-small only_number_comma"></td>
	                    </tr>
	                    <tr>
	                    	<th>기타<span class="required-label"></span></th>
	                        <td><input type="text" id="etcAmount" name="etcAmount" value="${detail.etcAmount }" class="input-small only_number_comma"></td>
	                        <th>경조사<span class="required-label"></span></th>
	                        <td><input type="text" id="eventAmount" name="eventAmount" value="${detail.eventAmount }" class="input-small only_number_comma"></td>
	                    </tr>
	                    <tr>
	                    	<th>식비<span class="required-label"></span></th>
	                        <td><input type="text" id="foodAmount" name="foodAmount" value="${detail.foodAmount }" class="input-small only_number_comma"></td>
	                        <th>건강/문화<span class="required-label"></span></th>
	                        <td><input type="text" id="healAmount" name="healAmount" value="${detail.healAmount }" class="input-small only_number_comma"></td>
	                    </tr>
	                    <tr>
	                    	<th>주거/통신<span class="required-label"></span></th>
	                        <td><input type="text" id="homeAmount" name="homeAmount" value="${detail.homeAmount }" class="input-small only_number_comma"></td>
	                        <th>교통<span class="required-label"></span></th>
	                        <td><input type="text" id="tranAmount" name="tranAmount" value="${detail.tranAmount }" class="input-small only_number_comma"></td>
	                    </tr>
	                </tbody>
	            </table>
			</form>
            <div class="btn-form">
                <button id="btnSave" class="btn blue">저장</button>
                <c:choose>
                	<c:when test="${!empty detail }">
	                	<button id="btnDelete" class="btn red">삭제</button>
	                </c:when>
	                <c:otherwise>
	                	<button id="btnPrev" class="btn green">전월 예산 불러오기</button>
	                </c:otherwise>
                </c:choose>

                <button class="btn gray" onclick="fn_back()">목록</button>
            </div>

        </div>
	</div>
</body>
</html>