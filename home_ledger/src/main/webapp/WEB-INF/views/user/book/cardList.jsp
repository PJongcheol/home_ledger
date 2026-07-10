<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>카드 사용 내역</title>
<script type="text/javascript">
	$(document).ready(function(){
	});

	// 조회
	function fn_search() {
		$("#cardForm #pageIndex").val("1");
		$("#cardForm #pageSize").val("10");

		$("#cardForm").submit();
	}

	// 초기화
	function fn_reset() {
		var now = new Date();
		var yearMonth = now.getFullYear() + "-" + String(now.getMonth() + 1).padStart(2, "0");

		$("#cardForm #yearMonth").val(yearMonth);
		$("#cardForm #osYn").val("");
		$("#cardForm #aiSeq").val("");
	}

	// 페이징
	function fn_paging(idx) {
		$("#cardForm #pageIndex").val(idx);
		$("#cardForm").submit();
	}

</script>
</head>
<body class="common-page">
	<div class="menu-container">
	    <h2>카드 사용 내역</h2>
	    <div class="common_section">
	        <form id="cardForm" name="cardForm" method="post" action="/user/book/cardList.do">
				<input type="hidden" id="pageIndex" name="pageIndex" value="${holder.pageIndex }"/>
				<input type="hidden" id="pageSize" name="pageSize" value="${holder.pageSize }"/>
				<div class="info-box">
				    <ul>
				        <li>카드 사용 내역만 조회됩니다.</li>
				        <li>카드 사용 내역은 통장/카드관리에 등록된 카드의 소비기간 시작일~종료일 기준으로 조회됩니다</li>
				    </ul>
				</div>
			    <div class="search-box">
					<div class="search-row">
			            <select id="yearMonth" name="yearMonth">
			            	<c:forEach var="ym" items="${yearMonthList }">
			            		<option value="${ym.yearMonth }" ${holder.yearMonth eq ym.yearMonth ? 'selected' : '' }>${ym.yearMonth }</option>
			            	</c:forEach>
			            </select>
			        </div>

			        <div class="search-row">
			            <select id="osYn" name="osYn">
			                <option value="">과소비 전체</option>
			                <option value="Y" ${holder.osYn eq 'Y' ? 'selected' : ''}>Y</option>
			                <option value="N"  ${holder.osYn eq 'N' ? 'selected' : ''}>N</option>
			            </select>
			        </div>

			        <div class="search-row">
			            <select id="aiSeq" name="aiSeq">
			                <option value="">통장/카드명 전체</option>
			                <c:forEach var="account" items="${accountList }">
			                	<option value="${account.aiSeq }" ${holder.aiSeq eq account.aiSeq ? 'selected' : '' }>${account.aiNm }</option>
			                </c:forEach>
			            </select>
			        </div>

			        <div class="search-row">
			            <button type="button" onclick="fn_search()" class="btn-search">조회</button>
			            <button type="button" onclick="fn_reset()" class="btn-reset">초기화</button>
			        </div>
			    </div>
			</form>
			<div class="summary-box">
			    <div class="summary-item expense">
			        총 지출 <span>₩ ${!empty total.expendituretotalamount ? total.expendituretotalamount : '0'}</span>
			    </div>

			    <div class="summary-item count">
			        총 건수 <span>${!empty total.cnt ? total.cnt : '0'} 건</span>
			    </div>
			</div>
	        <table class="table-hover">
	        	<colgroup>
	        		<c:forEach var="colgroup" items="${bookView }">
	        			<c:if test="${colgroup.colimnName ne 'event' }">
	        				<col style="width:auto;">
	        			</c:if>
	        		</c:forEach>
		        </colgroup>
	            <thead>
	                <tr>
	                	<c:forEach var="thead" items="${bookView }">
	                		<c:if test="${thead.colimnName ne 'event' }">
	                			<th>${thead.bcNm }</th>
	                		</c:if>
	                	</c:forEach>
	                </tr>
	            </thead>
	            <tbody>
	            	<c:choose>
						<c:when test="${!empty list }">
							<c:forEach var="item" items="${list }">
								<tr>
									<c:forEach var="bodyItem" items="${bookView }" varStatus="status">
										<c:if test="${bodyItem.colimnName ne 'event' }">
											<td>
												<c:choose>
													<c:when test="${bodyItem.colimnName eq 'inoutType' }">
														<span class="${item[bodyItem.colimnName] eq '수입' ? 'text-color-blue' : 'text-color-red'}"><c:out value="${item[bodyItem.colimnName] }"/></span>
													</c:when>
													<c:when test="${bodyItem.colimnName eq 'amount' }">
														<span class="${item.inoutType eq '수입' ? 'text-color-blue' : 'text-color-red'}"><c:out value="${item[bodyItem.colimnName] }"/></span>
													</c:when>
													<c:when test="${bodyItem.colimnName eq 'overSpendingYn'}">
														<c:if test="${item.inoutType eq '지출' }">
															<c:if test="${item.overSpendingYn eq 'Y' }">
																✓
															</c:if>
														</c:if>
													</c:when>
													<c:otherwise>
														<c:out value="${item[bodyItem.colimnName] }"/>
													</c:otherwise>
												</c:choose>
											</td>
										</c:if>
									</c:forEach>
								</tr>
							</c:forEach>
						</c:when>
						<c:otherwise>
							<tr>
								<td colspan="${bookView.size() -1 }">데이터가 존재하지 않습니다.</td>
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