<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>카테고리 관리 상세</title>
<script type="text/javascript">
	$(document).ready(function(){
		// 저장
		$("#btnSave").on("click", function(){
			// 카테고리 구분
			if($("#categoryCode").val() == "") {
				alert("카테고리 구분은 필수입니다.");
				$("#categoryCode").focus();
				return false;
			}

			// 카테고리 소분류명
			if($("#ciNm").val().trim() == "") {
				alert("카테고리 소분류명은 필수입니다.");
				$("#ciNm").focus();
				return false;
			}

			var formData = new FormData($("#categoryDetailForm")[0]);

			if(confirm("저장 하시겠습니까?")) {
				$.ajax({
				  url: "/user/settings/saveCategory.do",
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
			var formData = new FormData($("#categoryDetailForm")[0]);

			if(confirm("삭제하시겠습니까?")) {
				$.ajax({
				  url: "/user/settings/deleteCategory.do",
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
		$("#categoryForm").submit();
	}

</script>
</head>
<body class="common-page">
	<div class="menu-container">
	    <h2>카테고리 관리 상세</h2>
	    <div class="common_section">
	    	<form id="categoryForm" name="categoryForm" method="post" action="/user/settings/categoryList.do">
	    	</form>
            <form name="categoryDetailForm" id="categoryDetailForm">
	            <input type="hidden" id="ciSeq" name="ciSeq" value="${detail.ciSeq }" />
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
							                <option value="">카테고리 전체</option>
							                <c:forEach var="category" items="${categoryList }">
							                	<option value="${category.categoryCode }" ${detail.categoryCode eq category.categoryCode ? 'selected' : ''}>${category.categoryName }</option>
							                </c:forEach>
							            </select>
	                        		</c:otherwise>
	                        	</c:choose>
	                        </td>
	                        <th>소분류 카테고리명</th>
	                        <td><input type="text" id="ciNm" name="ciNm" value="${detail.ciNm }" maxlength="100"></td>
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