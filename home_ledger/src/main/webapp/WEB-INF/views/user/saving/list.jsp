<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>적금 현황</title>
<script type="text/javascript">
	$(document).ready(function(){

	});

	// 조회
	function fn_search() {
		$("#savingForm #pageIndex").val("1");
		$("#savingForm #pageSize").val("10");

		$("#savingForm").submit();
	}

	// 초기화
	function fn_reset() {
		$("#savingForm #siSj").val("");
	}

	// 신규등록
	function fn_new() {
		$("#savingDetailForm #siSeq").val("");
		$("#savingDetailForm #mode").val("I");
		$("#savingDetailForm").submit();
	}

	// 상세정보
	function fn_detail(siSeq) {
		$("#savingDetailForm #siSeq").val(siSeq);
		$("#savingDetailForm #mode").val("U");
		$("#savingDetailForm").submit();
	}

	// 페이징
	function fn_paging(idx) {
		$("#savingForm #pageIndex").val(idx);
		$("#savingForm").submit();
	}
</script>
</head>
<body class="common-page">
	<div class="menu-container">
	    <h2>적금 현황</h2>
	    <div class="common_section">
	    	<div class="info-box">
			    <ul>
			        <li>납입중인 적금을 등록할 수 있는 페이지입니다.</li>
			        <li>납입 횟수는 매달 납입일 자정에 자동으로 늘어나며, 가계부에 등록은 고정 수입/지출 관리에서 등록해주세요.</li>
			        <li>적금 현황 그림은 검색조건에 맞는 총 적금에 대한 상황을 보여줍니다.</li>
			        <li>납입중인 적금을 신규등록 시 적금 시작일로부터 계산하여 납입 횟수가 늘어납니다.</li>
			    </ul>
			</div>
	    	<form id="savingDetailForm" name="savingDetailForm" method="post" action="/user/saving/form.do">
	    		<input type="hidden" id="siSeq" name="siSeq" />
	    		<input type="hidden" id="mode" name="mode" />
	    	</form>
	        <form id="savingForm" name="savingForm" method="post" action="/user/saving/list.do">
				<input type="hidden" id="pageIndex" name="pageIndex" value="${holder.pageIndex }"/>
				<input type="hidden" id="pageSize" name="pageSize" value="${holder.pageSize }"/>
			    <div class="search-box">
			        <div class="search-row">
			            <input type="text" id="siSj" name="siSj" value="${holder.siSj}" placeholder="적금명을 입력해주세요.">
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
					<col style="width:10%">
		        	<col style="width:10%">
		        	<col style="width:10%">
		        	<col style="width:10%">
		        	<col style="width:5%">
		        	<col style="width:10%">
		        	<col style="width:5%">
		        	<col style="width:20%">
		        </colgroup>
	            <thead>
	                <tr>
	                	<th>적금명</th>
	                	<th>적금 시작일</th>
	                	<th>적금 만료일</th>
	                	<th>적금 목표 금액</th>
	                	<th>월 납입 금액</th>
	                	<th>납입횟수</th>
	                	<th>누적 납입 금액</th>
	                	<th>납입일</th>
	                	<th>적금 납입(%)</th>
	                </tr>
	            </thead>
	            <tbody>
	            	<c:choose>
						<c:when test="${!empty list }">
							<c:forEach var="item" items="${list }">
								<tr>
									<td>
										<a href="javascript:void(0)" class="a-decoration-non" onclick="fn_detail('${item.siSeq }')">
											<span class="text-color-blue-bold"><c:out value="${item.siSj }"/></span>
										</a>
									</td>
									<td><c:out value="${item.beginDe }"/></td>
									<td><c:out value="${item.endDe }"/></td>
									<td><fmt:formatNumber value="${item.siTotalAmount }" pattern="#,###" /></td>
									<td><fmt:formatNumber value="${item.monthlyPaymentAmount }" pattern="#,###" /></td>
									<td><c:out value="${item.payCnt }"/></td>
									<td><fmt:formatNumber value="${item.payAmount }" pattern="#,###" /></td>
									<td><c:out value="${item.tranDay }"/></td>
									<td>
									    <c:choose>
									        <c:when test="${item.siTotalAmount > 0}">
									            <c:set var="percent" value="${(item.payAmount / item.siTotalAmount) * 100}" />

									            <c:if test="${percent > 100}">
									                <c:set var="percent" value="100" />
									            </c:if>

									            <div class="progress-container">
									                <div class="progress-bar-wrap">
									                    <div class="progress-bar" style="width: ${percent}%;"></div>
									                </div>
									                <span class="progress-text">
									                    <fmt:formatNumber value="${(item.payAmount / item.siTotalAmount) * 100}" pattern="0.0"/>%
									                </span>
									            </div>
									        </c:when>
									        <c:otherwise>
									            <span class="progress-text">0.0%</span>
									        </c:otherwise>
									    </c:choose>
									</td>
								</tr>
							</c:forEach>
						</c:when>
						<c:otherwise>
							<tr>
								<td colspan="8">데이터가 존재하지 않습니다.</td>
							</tr>
						</c:otherwise>
	            	</c:choose>
	            </tbody>
	        </table>
	        <jsp:include page="/WEB-INF/views/common/paging.jsp">
			    <jsp:param name="pageIndexName" value="userPageIndex" />
			</jsp:include>
	    </div>
	</div>
</body>
</html>