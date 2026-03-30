<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>통장/카드 관리 상세</title>
<script type="text/javascript">
	var bankList = [
	<c:forEach var="b" items="${bankList}">
	    { aiCode : "${b.bankCode}", aiName : "${b.bankName}" },
	</c:forEach>
	];

	var cardList = [
	<c:forEach var="c" items="${cardList}">
	    { aiCode : "${c.cardCode}", aiName : "${c.cardName}" },
	</c:forEach>
	];

	$(document).ready(function(){
		// 통장/카드 선택 시
		$("#aiSe").change(function(){
			var html = "<option value=\"\">선택</option>";
			var list = $(this).val() == "B" ? bankList : cardList;
			var cnt = 0;

			// 카드 신용/체크 show/hide
			if($(this).val() == "C") {
				$("#cardType").show();
			} else {
				$("#cardType").hide();
			}


			if($(this).val() != "") {
				for(i=0; i<list.length; i++) {
					html += "<option value=\""+list[i].aiCode+"\">"+list[i].aiName+"</option>";

					if(list[i].aiCode == "${detail.aiCode}") {
						cnt++;
					}
				}
			}

			$("#aiCode").children().remove();
			$("#aiCode").append(html);
			$("#aiCode").val(cnt > 0 ? "${detail.aiCode}" : "");
		});

		// 상세로 들어올시 트리거 이벤트
	    if($("#aiSe").val() != "") {
	 		setTimeout(function(){
	 		    $("#aiSe").trigger("change");
	 		}, 50);
		}

		// 저장
		$("#btnSave").on("click", function(){
			// 통장/카드 구분
			if($("#aiSe").val() == "") {
				alert("통장/카드 구분은 필수입니다.");
				$("#aiSe").focus();
				return false;
			}

			// 통장/카드명
			if($("#aiNm").val().trim() == "") {
				alert("통장/카드명은 필수입니다.");
				$("#aiNm").focus();
				return false;
			}

			// 통장/카드
			if($("#aiCode").val() == "") {
				alert("통장/카드 선택은 필수입니다.");
				$("#aiCode").focus();
				return false;
			} else if($("#aiCode").val() == "C" && $("#cardType").val() == "") {
				alert("카트 타입 선택은 필수입니다.");
				$("#aiCode").focus();
				return false;
			}

			// 소비기간 시작월
			if($("#spendBgnMtSe").val() == "") {
				alert("소비기간 시작월은 필수입니다.");
				$("#spendBgnMtSe").focus();
				return false;
			}

			// 소비기간 시작일
			if($("#spendBgnDay").val() == "") {
				alert("소비기간 시작일은 필수입니다.");
				$("#spendBgnDay").focus();
				return false;
			}

			// 소비기간 종료월
			if($("#spendEndMtSe").val() == "") {
				alert("소비기간 종료월은 필수입니다.");
				$("#spendEndMtSe").focus();
				return false;
			}

			// 소비기간 종료일
			if($("#spendEndDay").val() == "") {
				alert("소비기간 종료일은 필수입니다.");
				$("#spendEndDay").focus();
				return false;
			}

			// 사용여부
			if($("#useYn").val() == "") {
				alert("사용여부는 필수입니다.")
				$("#useYn").focus();
				return false;
			}

			var formData = new FormData($("#accountDetailForm")[0]);

			if(confirm("저장 하시겠습니까?")) {
				$.ajax({
				  url: "/user/settings/saveAccount.do",
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
			var formData = new FormData($("#accountDetailForm")[0]);

			if(confirm("삭제하시겠습니까?")) {
				$.ajax({
				  url: "/user/settings/deleteAccount.do",
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
		$("#accountForm").submit();
	}

</script>
</head>
<body class="common-page">
	<div class="menu-container">
	    <h2>통장/카드 관리 상세</h2>
	    <div class="common_section">
	    	<form id="accountForm" name="accountForm" method="post" action="/user/settings/accountList.do">
	    	</form>
            <form name="accountDetailForm" id="accountDetailForm">
	            <input type="hidden" id="aiSeq" name="aiSeq" value="${detail.aiSeq }" />
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
	                        	<select id="aiSe" name="aiSe">
									<option value="">선택</option>
									<option value="B" ${detail.aiSe eq 'B' ? 'selected' : '' }>통장</option>
									<option value="C" ${detail.aiSe eq 'C' ? 'selected' : '' }>카드</option>
								</select>
	                        </td>
	                    </tr>
	                    <tr>
	                    	<th>통장/카드명</th>
	                        <td><input type="text" id="aiNm" name="aiNm" value="${detail.aiNm }" maxlength="100"></td>
	                        <th>통장/카드</th>
	                        <td>
	                        	<select id="aiCode" name="aiCode"></select>
								<select id="cardType" name="cardType" style="display:none">
									<option value="">선택</option>
									<option value="C" ${detail.cardType eq 'C' ? 'selected' : '' }>신용카드</option>
									<option value="D" ${detail.cardType eq 'D' ? 'selected' : '' }>체크카드</option>
								</select>
	                        </td>
	                    </tr>
	                    <tr>
	                        <th>소비기간 시작일</th>
	                        <td>
	                        	<select id="spendBgnMtSe" name="spendBgnMtSe">
									<option value="">선택</option>
									<option value="1" ${detail.spendBgnMtSe eq '1' ? 'selected' : '' }>전월</option>
									<option value="2" ${detail.spendBgnMtSe eq '2' ? 'selected' : '' }>전전월</option>
								</select>
								<select id="spendBgnDay" name="spendBgnDay">
									<option value="">선택</option>
									<c:forEach var="strDay" begin="1" end="31">
										<option value="${strDay }" ${detail.spendBgnDay eq strDay ? 'selected' : '' }>${strDay }일</option>
									</c:forEach>
								</select>
	                        </td>
	                        <th>소비기간 종료일</th>
	                        <td>
	                        	<select id="spendEndMtSe" name="spendEndMtSe">
									<option value="">선택</option>
									<option value="1" ${detail.spendEndMtSe eq '1' ? 'selected' : '' }>전월</option>
									<option value="2" ${detail.spendEndMtSe eq '2' ? 'selected' : '' }>전전월</option>
								</select>
								<select id="spendEndDay" name="spendEndDay">
									<option value="">선택</option>
									<c:forEach var="endDay" begin="1" end="31">
										<option value="${endDay }" ${detail.spendEndDay eq endDay ? 'selected' : '' }>${endDay }일</option>
									</c:forEach>
								</select>
							</td>
	                    </tr>
	                    <tr>
	                        <th>사용여부</th>
	                        <td>
	                        	<select id="useYn" name="useYn">
									<option value="">선택</option>
									<option value="Y" ${detail.useYn eq 'Y' ? 'selected' : '' }>승인</option>
									<option value="N" ${detail.useYn eq 'N' ? 'selected' : '' }>미승인</option>
								</select>
	                        </td>
	                        <th>비고</th>
	                        <td><input type="text" id="aiRm" name="aiRm" value="${detail.aiRm }"></td>
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