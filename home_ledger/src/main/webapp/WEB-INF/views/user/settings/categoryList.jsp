<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>카테고리 관리</title>
<script type="text/javascript">
	$(document).ready(function(){

	});

	// 조회
	function fn_search() {
		$("#categoryForm").submit();
	}

	// 초기화
	function fn_reset() {
		$("#categoryForm #categoryCode").val("");
	}

	// 신규등록
	function fn_new() {
		$("#categoryDetailForm #ciSeq").val("");
		$("#categoryDetailForm #categoryCode").val("");
		$("#categoryDetailForm").submit();
	}

	// 상세정보
	function fn_detail(ciSeq, categoryCode) {
		$("#categoryDetailForm #ciSeq").val(ciSeq);
		$("#categoryDetailForm #categoryCode").val(categoryCode);
		$("#categoryDetailForm").submit();
	}

</script>
</head>
<body class="common-page">
	<div class="menu-container">
	    <h2>카테고리 관리</h2>
	    <div class="common_section">
	    	<form id="categoryDetailForm" name="categoryDetailForm" method="post" action="/user/settings/categoryForm.do">
	    		<input type="hidden" id="ciSeq" name="ciSeq" />
	    		<input type="hidden" id="categoryCode" name="categoryCode" />
	    	</form>
	        <form id="categoryForm" name="categoryForm" method="post" action="/user/settings/categoryList.do">
			    <div class="search-box">
					<div class="search-row">
			            <select id="categoryCode" name="categoryCode">
			                <option value="">카테고리 전체</option>
			                <c:forEach var="category" items="${categoryList }">
			                	<option value="${category.categoryCode }" ${holder.categoryCode eq category.categoryCode ? 'selected' : ''}>${category.categoryName }</option>
			                </c:forEach>
			            </select>
			        </div>
			        <div class="search-row">
			            <button type="button" onclick="fn_search()" class="btn-search">조회</button>
			            <button type="button" onclick="fn_reset()" class="btn-reset">초기화</button>
			        </div>
			        <div class="search-row-right">
			            <button type="button" onclick="fn_new()" class="btn-search">신규등록</button>
			        </div>

			    </div>
			</form>
	        <table class="table-hover">
	        	<colgroup>
		        	<col style="width:20%">
		        	<col style="width:70%">
		        	<col style="width:10%">
		        </colgroup>
	            <thead>
	                <tr>
	                	<th>카테고리</th>
	                	<th>소분류</th>
	                	<th>등록일</th>
	                </tr>
	            </thead>
	            <tbody>
					<c:forEach var="item" items="${list }" varStatus="status">
							<c:choose>
								<c:when test="${!empty item.subCategory }">
									<c:forEach var="subItem" items="${item.subCategory }" varStatus="status">
										<tr>
											<c:if test="${status.index eq '0' }">
												<td rowspan="${item.subCategory.size() }"><c:out value="${item.categoryName }"/></td>
											</c:if>
											<td>
												<a href="javascript:void(0)" class="a-decoration-non" onclick="fn_detail('${subItem.ciSeq }', '${subItem.categoryCode }')">
													<span class="text-color-blue-bold"><c:out value="${subItem.ciNm }"/></span>
												</a>
											</td>
											<td><c:out value="${subItem.regDt }"/></td>
										</tr>
									</c:forEach>
								</c:when>
								<c:otherwise>
									<tr>
										<td><c:out value="${item.categoryName }"/></td>
										<td colspan="2">등록된 소분류 카테고리가 없습니다.</td>
									</tr>

								</c:otherwise>
							</c:choose>

					</c:forEach>
	            </tbody>
	        </table>
	    </div>
	</div>
</body>
</html>