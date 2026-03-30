<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>고정지출 관리 상세</title>
<script type="text/javascript">
	$(document).ready(function(){
		// 카테고리 변경 시
		$("#categoryCode").change(function(){
			var html = "<option value=\"\" >선택</option>";

			$("#ciSeq").children().remove();

			if($(this).val() == "") {
				$("#ciSeq").append(html);
			} else {
				$.ajax({
				  url: "/user/settings/selectCategory.do",
				  type: "POST",
				  data: {
					categoryCode : $(this).val()
				  },
				  success: function(data) {
					  if(data.message == "ok") {
					  	for(i=0; i<data.list.length; i++) {
					  		if(data.list[i].ciSeq == "${detail.ciSeq}") {
					  			html += "<option value=\""+data.list[i].ciSeq+"\" selected>"+data.list[i].ciNm+"</option>";
					  		} else {
					  			html += "<option value=\""+data.list[i].ciSeq+"\">"+data.list[i].ciNm+"</option>";
					  		}

					  	}
					  	$("#ciSeq").append(html);
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

		// 상세로 들어올시 트리거 이벤트
	    if($("#categoryCode").val() != "") {
	 		setTimeout(function(){
	 		    $("#categoryCode").trigger("change");
	 		}, 50);
		}

		// 저장
		$("#btnSave").on("click", function(){
			// 통장/카드 구분
			if($("#aiSeq").val() == "") {
				alert("통장/카드 구분은 필수입니다.");
				$("#aiSeq").focus();
				return false;
			}

			// 카테고리 구분
			if($("#categoryCode").val() == "") {
				alert("카테고리 구분은 필수입니다.");
				$("#categoryCode").focus();
				return false;
			}

			// 카테고리 소분류 구분
			if($("#ciSeq").val() == "") {
				alert("카테고리 소분류 구분은 필수입니다.");
				$("#ciSeq").focus();
				return false;
			}

			// 카테고리 소분류 구분
			if($("#inoutType").val() == "") {
				alert("수입/지출 구분은 필수입니다.");
				$("#inoutType").focus();
				return false;
			}

			// 금액
			if($("#amount").val().trim() == "") {
				alert("금액은 필수입니다.");
				$("#amount").focus();
				return false;
			}

			// 거래일
			if($("#tranDay").val() == "") {
				alert("거래일은 필수입니다.");
				$("#tranDay").focus();
				return false;
			}



			var formData = new FormData($("#fixedExpenseDetailForm")[0]);

			if(confirm("저장 하시겠습니까?")) {
				$.ajax({
				  url: "/user/settings/saveFixedExpense.do",
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
			var formData = new FormData($("#fixedExpenseDetailForm")[0]);

			if(confirm("삭제하시겠습니까?")) {
				$.ajax({
				  url: "/user/settings/deleteFixedExpense.do",
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
		$("#fixedExpenseForm").submit();
	}

</script>
</head>
<body class="common-page">
	<div class="menu-container">
	    <h2>고정지출 관리 상세</h2>
	    <div class="common_section">
	    	<form id="fixedExpenseForm" name="fixedExpenseForm" method="post" action="/user/settings/fixedExpenseList.do">
	    	</form>
            <form name="fixedExpenseDetailForm" id="fixedExpenseDetailForm">
	            <input type="hidden" id="feiSeq" name="feiSeq" value="${detail.feiSeq }" />
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
	                        <th>통장/카드 구분</th>
	                        <td colspan="3">
	                        	<c:choose>
	                        		<c:when test="${!empty detail }">
	                        			<c:forEach var="account" items="${accountList }">
		                        			<c:if test="${detail.aiSeq eq account.aiSeq }">
	                        					<input type="hidden" id="aiSeq" name="aiSeq" value="${detail.aiSeq }" />
	                        					[${account.aiCode eq 'B' ? '통장' : '카드'}]-${account.aiNm}
	                        				</c:if>
                        				</c:forEach>
	                        		</c:when>
	                        		<c:otherwise>
	                        			<select id="aiSeq" name="aiSeq">
							                <option value="">선택</option>
							                <c:forEach var="account" items="${accountList }">
							                	<option value="${account.aiSeq }" ${detail.aiSeq eq account.aiSeq ? 'selected' : ''}>[${account.aiCode eq 'B' ? '통장' : '카드'}]-${account.aiNm}</option>
							                </c:forEach>
							            </select>
	                        		</c:otherwise>
	                        	</c:choose>
	                        </td>
	                    </tr>
	                    <tr>
	                        <th>카테고리 구분</th>
	                        <td>
	                        	<c:choose>
	                        		<c:when test="${!empty detail }">
	                        			<c:forEach var="category" items="${categoryList }">
	                        				<c:if test="${detail.categoryCode eq category.categoryCode }">
	                        					<input type="hidden" id="categoryCode" name="categoryCode" value="${category.categoryCode }" />
	                        					<c:out value="${category.categoryName }"/>
	                        				</c:if>
	                        			</c:forEach>
	                        		</c:when>
	                        		<c:otherwise>
										<select id="categoryCode" name="categoryCode">
							                <option value="">선택</option>
							                <c:forEach var="category" items="${categoryList }">
							                	<option value="${category.categoryCode }" ${detail.categoryCode eq category.categoryCode ? 'selected' : ''}>${category.categoryName }</option>
							                </c:forEach>
							            </select>
	                        		</c:otherwise>
	                        	</c:choose>
	                        </td>
	                        <th>소분류 카테고리 구분</th>
	                        <td>
	                        	<select id="ciSeq" name="ciSeq">
	                        		<option value="">선택</option>
	                        	</select>
	                        </td>
	                    </tr>
	                    <tr>
	                        <th>수입/지출 구분</th>
	                        <td>
	                        	<select id="inoutType" name="inoutType">
	                        		<option value="">선택</option>
	                        		<option value="I" ${detail.inoutType eq 'I' ? 'selected' : '' }>수입</option>
	                        		<option value="E" ${detail.inoutType eq 'E' ? 'selected' : '' }>지출</option>
	                        	</select>
	                        </td>
	                        <th>금액</th>
	                        <td><input type="text" id="amount" name="amount" class="input-small only_number_comma" value="${detail.amount }" /></td>
	                    </tr>
	                    <tr>
	                        <th>거래일</th>
	                        <td>
	                        	<select id="tranDay" name="tranDay">
									<option value="">선택</option>
									<c:forEach var="day" begin="1" end="31">
										<option value="${day }" ${detail.tranDay eq day ? 'selected' : '' }>${day }일</option>
									</c:forEach>
	                        	</select>
	                        <th>비고(적요)</th>
	                        <td><input type="text" id="remark" name="remark" value="${detail.remark }"/></td>
	                    </tr>
	                    <tr>
	                        <th>등록자</th>
	                        <td><c:out value="${detail.regId }"/></td>
	                        <th>등록일시</th>
	                        <td><c:out value="${detail.regDt }"/></td>
	                    </tr>
	                    <tr>
	                        <th>수정자</th>
	                        <td><c:out value="${detail.updId }"/></td>
	                        <th>수정일시</th>
	                        <td><c:out value="${detail.updDt }"/></td>
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