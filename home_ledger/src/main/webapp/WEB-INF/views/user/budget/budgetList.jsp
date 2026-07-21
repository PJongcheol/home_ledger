<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>예산 목록</title>
<script type="text/javascript">
	$(document).ready(function(){

	});

	// 조회
	function fn_search() {
		$("#budgetForm #pageIndex").val("1");
		$("#budgetForm #pageSize").val("10");

		$("#budgetForm").submit();
	}

	// 초기화
	function fn_reset() {
		var now = new Date();
		$("#budgetForm #year").val(now.getFullYear());
	}

	// 상세정보
	function fn_detail(biSeq, yearMonth) {
		var mode = biSeq == "" ? "I" : "U";

		$("#budgetDetailForm #biSeq").val(biSeq);
		$("#budgetDetailForm #yearMonth").val(yearMonth);
		$("#budgetDetailForm #mode").val(mode);
		$("#budgetDetailForm").submit();
	}

</script>
</head>
<body class="common-page">
	<div class="menu-container">
	    <h2>예산 목록</h2>
	    <div class="common_section">
	    	<div class="info-box">
			    <ul>
			        <li>월 단위로 예산 등록이 가능하며, 등록 페이지에서 전월 예산 불러오기 시 전월에 등록된 예산과 동일하게 등록됩니다.</li>
			        <li>전월 예산 불러오기는 신규 등록 시 사용할 수 있으며, 전월 예산이 등록되어있지 않다면 사용할 수 없습니다.</li>
			    </ul>
			</div>
	    	<form id="budgetDetailForm" name="budgetDetailForm" method="post" action="/user/budget/budgetForm.do">
	    		<input type="hidden" id="biSeq" name="biSeq" />
	    		<input type="hidden" id="yearMonth" name="yearMonth" />
	    		<input type="hidden" id="mode" name="mode" />
	    	</form>
	        <form id="budgetForm" name="budgetForm" method="post" action="/user/budget/budgetList.do">
				<input type="hidden" id="pageIndex" name="pageIndex" value="${holder.pageIndex }"/>
				<input type="hidden" id="pageSize" name="pageSize" value="${holder.pageSize }"/>
			    <div class="search-box">
					<div class="search-row">
			            <select id="year" name="year">
			                <c:forEach var="year" items="${yearList }">
			                	<option value="${year.dummyYear }" ${year.dummyYear eq holder.year ? 'selected' : ''}>${year.dummyYear }년</option>
			                </c:forEach>
			            </select>
			        </div>
			        <div class="search-row">
			            <button type="button" onclick="fn_search()" class="btn-search">조회</button>
			            <button type="button" onclick="fn_reset()" class="btn-reset">초기화</button>
			        </div>
			    </div>
			</form>
	        <table class="table-hover">
	        	<colgroup>
		        	<col style="width:20%">
		        	<col style="width:10%">
		        	<col style="width:10%">
		        	<col style="width:10%">
		        	<col style="width:10%">
		        	<col style="width:10%">
		        	<col style="width:10%">
		        	<col style="width:10%">
		        	<col style="width:10%">
		        </colgroup>
	            <thead>
	                <tr>
	                	<th rowspan="2">년월</th>
	                	<th colspan="8">예산</th>
	                </tr>
	                <tr>
	                	<th>미용</th>
	                	<th>교육</th>
	                	<th>기타</th>
	                	<th>경조사</th>
	                	<th>식비</th>
	                	<th>건강/문화</th>
	                	<th>주거/통신</th>
	                	<th>교통</th>
	                </tr>
	            </thead>
	            <tbody>
					<c:forEach var="item" items="${list }">
						<tr>
							<td>
								<a href="javascript:void(0)" class="a-decoration-non" onclick="fn_detail('${item.biSeq }', '${item.yearMonth }')">
									<span class="text-color-blue-bold"><c:out value="${item.yearMonth }"/></span>
								</a>
							</td>
							<c:choose>
								<c:when test="${!empty item.biSeq }">
									<td><c:out value="${item.beauAmount }"/></td>
									<td><c:out value="${item.eduAmount }"/></td>
									<td><c:out value="${item.etcAmount }"/></td>
									<td><c:out value="${item.eventAmount }"/></td>
									<td><c:out value="${item.foodAmount }"/></td>
									<td><c:out value="${item.healAmount }"/></td>
									<td><c:out value="${item.homeAmount }"/></td>
									<td><c:out value="${item.tranAmount }"/></td>
								</c:when>
								<c:otherwise>
									<td colspan="8">예산을 등록해주세요</td>
								</c:otherwise>
							</c:choose>
						</tr>
					</c:forEach>
	            </tbody>
	        </table>
	    </div>
	</div>
</body>
</html>