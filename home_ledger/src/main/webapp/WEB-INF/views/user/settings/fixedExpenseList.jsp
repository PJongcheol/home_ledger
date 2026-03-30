<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>고정지출 관리</title>
<script type="text/javascript">
	$(document).ready(function(){

	});

	// 조회
	function fn_search() {
		$("#fixedExpenseForm").submit();
	}

	// 초기화
	function fn_reset() {
		$("#fixedExpenseForm #categoryCode").val("");
	}

	// 신규등록
	function fn_new() {
		$("#fixedExpenseDetailForm #aiSeq").val("");
		$("#fixedExpenseDetailForm #feiSeq").val("");
		$("#fixedExpenseDetailForm").submit();
	}

	// 상세정보
	function fn_detail(aiSeq, feiSeq) {
		$("#fixedExpenseDetailForm #aiSeq").val(aiSeq);
		$("#fixedExpenseDetailForm #feiSeq").val(feiSeq);
		$("#fixedExpenseDetailForm").submit();
	}

</script>
</head>
<body class="common-page">
	<div class="menu-container">
	    <h2>고정지출 관리</h2>
	    <div class="common_section">
	    	<form id="fixedExpenseDetailForm" name="fixedExpenseDetailForm" method="post" action="/user/settings/fixedExpenseForm.do">
	    		<input type="hidden" id="aiSeq" name="aiSeq" />
	    		<input type="hidden" id="feiSeq" name="feiSeq" />
	    	</form>
	        <form id="fixedExpenseForm" name="fixedExpenseForm" method="post" action="/user/settings/fixedExpenseList.do">
			    <div class="search-box">
<!-- 					<div class="search-row"> -->
<!-- 			            <select id="categoryCode" name="categoryCode"> -->
<!-- 			                <option value="">카테고리 전체</option> -->
<%-- 			                <c:forEach var="category" items="${categoryList }"> --%>
<%-- 			                	<option value="${category.categoryCode }" ${holder.categoryCode eq category.categoryCode ? 'selected' : ''}>${category.categoryName }</option> --%>
<%-- 			                </c:forEach> --%>
<!-- 			            </select> -->
<!-- 			        </div> -->
<!-- 			        <div class="search-row"> -->
<!-- 			            <button type="button" onclick="fn_search()" class="btn-search">조회</button> -->
<!-- 			            <button type="button" onclick="fn_reset()" class="btn-reset">초기화</button> -->
<!-- 			        </div> -->
			        <div class="search-row-right">
			            <button type="button" onclick="fn_new()" class="btn-search">신규등록</button>
			        </div>

			    </div>
			</form>
	        <table class="table-hover">
	        	<colgroup>
		        	<col style="width:10%">
		        	<col style="width:20%">
		        	<col style="width:10%">
		        	<col style="width:10%">
		        	<col style="width:10%">
		        	<col style="width:20%">
		        	<col style="width:10%">
		        </colgroup>
	            <thead>
	                <tr>
	                	<th>카드/통장</th>
	                	<th>카드/통장명</th>
	                	<th>수입/지출 구분</th>
	                	<th>금액</th>
	                	<th>거래일</th>
	                	<th>비고</th>
	                	<th>등록일시</th>
	                </tr>
	            </thead>
	            <tbody>
	            	<c:choose>
	            		<c:when test="${!empty list }">
	            			<c:forEach var="item" items="${list }" varStatus="status">
								<c:choose>
									<c:when test="${!empty item.fixedExpense }">
										<c:forEach var="subItem" items="${item.fixedExpense }" varStatus="status">
											<tr>
												<c:if test="${status.index eq '0' }">
													<td rowspan="${item.fixedExpense.size() }"><c:out value="${item.aiSe eq 'B' ? '통장' : '카드' }"/></td>
													<td rowspan="${item.fixedExpense.size() }"><c:out value="${item.aiNm }"/></td>
												</c:if>
												<td><c:out value="${subItem.inoutType eq 'I' ? '수입' : '지출' }"/></td>
												<td>
													<a href="javascript:void(0)" class="a-decoration-non" onclick="fn_detail('${subItem.aiSeq }', '${subItem.feiSeq }')">
														<span class="text-color-blue-bold"><fmt:formatNumber value="${subItem.amount }" pattern="#,###" /></span>
													</a>
												</td>
												<td><c:out value="${subItem.tranDay }"/>일</td>
												<td><c:out value="${fn:length(subItem.remark) > 13 ? fn:substring(subItem.remark, 0, 13).concat('...') : subItem.remark }"/></td>
												<td><c:out value="${subItem.regDt }"/></td>
											</tr>
										</c:forEach>
									</c:when>
									<c:otherwise>
										<tr>
											<td><c:out value="${item.aiSe eq 'B' ? '통장' : '카드' }"/></td>
											<td><c:out value="${item.aiNm }"/></td>
											<td colspan="5">등록된 고정지출이 없습니다.</td>
										</tr>
									</c:otherwise>
								</c:choose>
							</c:forEach>
	            		</c:when>
	            		<c:otherwise>
	            			<td colspan="7">등록된 통장/카드가 없습니다.</td>
	            		</c:otherwise>
	            	</c:choose>
	            </tbody>
	        </table>
	    </div>
	</div>
</body>
</html>