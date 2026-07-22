<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>적금 현황 상세</title>
<script type="text/javascript">
	$(document).ready(function(){

		// 저장
		$("#btnSave").on("click", function(){
			// 적금명
			if($("#siSj").val().trim() == "") {
				alert("적금명은 필수입니다.");
				$("#siSj").focus();
				return false;
			}

			// 적금 시작일
			if($("#beginDe").val().trim() == "") {
				alert("적금 시작일은 필수입니다.");
				$("#beginDe").focus();
				return false;
			} else if($("#beginDe").val().length != 10) {
				alert("형식은 0000-00-00입니다.");
				$("#beginDe").focus();
				return false;
			}

			// 적금 만료일
			if($("#endDe").val().trim() == "") {
				alert("적금 만료일은 필수입니다.");
				$("#endDe").focus();
				return false;
			} else if($("#endDe").val().length != 10) {
				alert("형식은 0000-00-00입니다.");
				$("#endDe").focus();
				return false;
			}

			// 적금 목표 금액
			if($("#siTotalAmount").val().trim() == "") {
				alert("적금 목표 금액은 필수입니다.");
				$("#siTotalAmount").focus();
				return false;
			}

			// 월 출금 금액
			if($("#monthlyPaymentAmount").val().trim() == "") {
				alert("월 출금 금액은 필수입니다.");
				$("#monthlyPaymentAmount").focus();
				return false;
			}

			var formData = new FormData($("#savingDetailForm")[0]);

			if(confirm("저장 하시겠습니까?")) {
				$.ajax({
				  url: "/user/saving/saveSaving.do",
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
			var formData = new FormData($("#savingDetailForm")[0]);

			if(confirm("삭제하시겠습니까?")) {
				$.ajax({
				  url: "/user/saving/deleteSaving.do",
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
		$("#savingForm").submit();
	}

</script>
</head>
<body class="common-page">
	<div class="menu-container">
	    <h2>적금 현황 상세</h2>
	    <div class="common_section">
	    	<form id="savingForm" name="savingForm" method="post" action="/user/saving/list.do">
	    	</form>
            <form name="savingDetailForm" id="savingDetailForm">
	            <input type="hidden" id="siSeq" name="siSeq" value="${detail.siSeq }" />
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
	                        <th>적금명<span class="required-label"></span></th>
	                        <td colspan="3"><input type="text" id="siSj" name="siSj" value="${detail.siSj }" maxlength="255"></td>
	                    </tr>
	                    <tr>
	                    	<th>적금 시작일<span class="required-label"></span></th>
	                        <td><input type="text" id="beginDe" name="beginDe" value="${detail.beginDe }" class="only_date input-small datepicker" maxlength="10"></td>
	                        <th>적금 만료일<span class="required-label"></span></th>
	                        <td><input type="text" id="endDe" name="endDe" value="${detail.endDe }" class="only_date input-small datepicker" maxlength="10"></td>
	                    </tr>
	                    <tr>
	                    	<th>적금 목표 금액<span class="required-label"></span></th>
	                        <td><input type="text" id="siTotalAmount" name="siTotalAmount" value="${detail.siTotalAmount }" class="input-small only_number_comma"></td>
	                        <th>월 출금 금액<span class="required-label"></span></th>
	                        <td><input type="text" id="monthlyPaymentAmount" name="monthlyPaymentAmount" value="${detail.monthlyPaymentAmount }" class="input-small only_number_comma"></td>
	                    </tr>
	                    <tr>
	                    	<th>출금일<span class="required-label"></span></th>
	                        <td>
	                        	<select id="tranDay" name="tranDay">
	                        		<c:forEach var="day" begin="1" end="31">
	 									<option value="${day }" ${detail.tranDay eq day ? 'selected' : ''}>${day }</option>
	                        		</c:forEach>
	                        	</select>
	                        </td>
	                        <th>납입 횟수</th>
	                        <td><c:out value="${detail.payCnt }"/></td>
	                    </tr>
	                    </tr>
	                </tbody>
	            </table>
			</form>
            <div class="btn-form">
                <button id="btnSave" class="btn blue">저장</button>
                <c:if test="${!empty detail }">
                	<button id="btnDelete" class="btn red">삭제</button>
                </c:if>
                <button class="btn gray" onclick="fn_back()">목록</button>
            </div>

        </div>
	</div>
</body>
</html>