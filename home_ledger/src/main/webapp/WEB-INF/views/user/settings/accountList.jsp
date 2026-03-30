<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>통장/카드 관리</title>
<script type="text/javascript">
	$(document).ready(function(){

	});

	// 조회
	function fn_search() {
		$("#accountForm #pageIndex").val("1");
		$("#accountForm #pageSize").val("10");

		$("#accountForm").submit();
	}

	// 초기화
	function fn_reset() {
		$("#accountForm #aiSe").val("");
		$("#accountForm #cardType").val("");
		$("#accountForm #useYn").val("");
		$("#accountForm #aiNm").val("");
	}

	// 신규등록
	function fn_new() {
		$("#accountDetailForm #aiSeq").val("");
		$("#accountDetailForm").submit();
	}

	// 상세정보
	function fn_detail(aiSeq) {
		$("#accountDetailForm #aiSeq").val(aiSeq);
		$("#accountDetailForm").submit();
	}

	// 페이징
	function fn_paging(idx) {
		$("#accountForm #pageIndex").val(idx);
		$("#accountForm").submit();
	}
</script>
</head>
<body class="common-page">
	<div class="menu-container">
	    <h2>통장/카드 관리</h2>
	    <div class="common_section">
	    	<form id="accountDetailForm" name="accountDetailForm" method="post" action="/user/settings/accountForm.do">
	    		<input type="hidden" id="aiSeq" name="aiSeq" />
	    	</form>
	        <form id="accountForm" name="accountForm" method="post" action="/user/settings/accountList.do">
				<input type="hidden" id="pageIndex" name="pageIndex" value="${holder.pageIndex }"/>
				<input type="hidden" id="pageSize" name="pageSize" value="${holder.pageSize }"/>
			    <div class="search-box">
					<div class="search-row">
			            <select id="aiSe" name="aiSe">
			                <option value="">타입전체</option>
			                <option value="B" ${holder.aiSe eq 'B' ? 'selected' : ''}>통장</option>
			                <option value="C"  ${holder.aiSe eq 'C' ? 'selected' : ''}>카드</option>
			            </select>
			        </div>

			        <div class="search-row">
			            <select id="cardType" name="cardType">
			                <option value="">카드타입전체</option>
			                <option value="C" ${holder.cardType eq 'C' ? 'selected' : ''}>신용카드</option>
			                <option value="D"  ${holder.cardType eq 'D' ? 'selected' : ''}>체크카드</option>
			            </select>
			        </div>

			        <div class="search-row">
			            <select id="useYn" name="useYn">
			                <option value="">사용여부전체</option>
			                <option value="Y" ${holder.useYn eq 'Y' ? 'selected' : ''}>사용</option>
			                <option value="N" ${holder.useYn eq 'N' ? 'selected' : ''}>미사용</option>
			            </select>
			        </div>

			        <div class="search-row">
			            <input type="text" id="aiNm" name="aiNm" value="${holder.aiNm}" placeholder="통장/카드명을 입력해주세요.">
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
		        	<col style="width:30%">
		        	<col style="width:5%">
		        	<col style="width:10%">
		        	<col style="width:10%">
		        	<col style="width:5%">
		        	<col style="width:5%">
		        	<col style="width:5%">
		        	<col style="width:5%">
		        	<col style="width:10%">
		        	<col style="width:20%">
		        </colgroup>
	            <thead>
	                <tr>
	                	<th rowspan="2">통장/카드명</th>
	                	<th rowspan="2">타입</th>
	                	<th rowspan="2">통장/카드</th>
	                	<th rowspan="2">신용/체크 구분</th>
	                	<th colspan="4">소비기간</th>
	                	<th rowspan="2">사용여부</th>
	                	<th rowspan="2">등록일</th>
	                </tr>
	                <tr>
	                	<th>시작월</th>
	                	<th>시작일</th>
	                	<th>종료월</th>
	                	<th>종료일</th>
	                </tr>
	            </thead>
	            <tbody>
	            	<c:choose>
						<c:when test="${!empty list }">
							<c:forEach var="item" items="${list }">
								<tr>
									<td>
										<a href="javascript:void(0)" class="a-decoration-non" onclick="fn_detail('${item.aiSeq }')">
											<span class="text-color-blue-bold"><c:out value="${item.aiNm }"/></span>
										</a>
									</td>
									<td><c:out value="${item.aiSe eq 'B' ? '통장' : '카드' }"/></td>
									<td><c:out value="${item.aiCode }"/></td>
									<td>
										<c:choose>
											<c:when test="${item.aiSe eq 'C' && item.cardType eq 'C'}">신용카드</c:when>
											<c:when test="${item.aiSe eq 'C' && item.cardType eq 'D'}">체크카드</c:when>
										</c:choose>
									</td>
									<td>
										<c:choose>
											<c:when test="${item.spendBgnMtSe eq '1'}">전월</c:when>
											<c:when test="${item.spendBgnMtSe eq '2'}">전전월</c:when>
										</c:choose>
									</td>
									<td><c:out value="${item.spendBgnDay }"/></td>
									<td>
										<c:choose>
											<c:when test="${item.spendEndMtSe eq '1'}">전월</c:when>
											<c:when test="${item.spendEndMtSe eq '2'}">전전월</c:when>
										</c:choose>
									</td>
									<td><c:out value="${item.spendEndDay }"/></td>
									<td>
										<c:choose>
											<c:when test="${item.useYn eq 'Y' }">
												<span class="text-color-blue">사용</span>
											</c:when>
											<c:otherwise>
												<span class="text-color-red">미사용</span>
											</c:otherwise>
										</c:choose>
									</td>
									<td><c:out value="${item.regDt }"/></td>
								</tr>
							</c:forEach>
						</c:when>
						<c:otherwise>
							<tr>
								<td colspan="10">데이터가 존재하지 않습니다.</td>
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