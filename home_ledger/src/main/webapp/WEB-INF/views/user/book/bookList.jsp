<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>가계부</title>
<script type="text/javascript">
	$(document).ready(function(){
		// 과소비 체크 시
		$("input[name=overSpendingYn]").change(function(){
			var aiSeq = $(this).data("ai");
			var hliSeq = $(this).data("hli");
			var overSpendingYn = "N";

			if($(this).is(":checked")) {
				overSpendingYn = "Y";
			}

			$.ajax({
				  url: "/user/book/updateOverSpendingYn.do",
				  type: "POST",
				  data: {
					   aiSeq : $(this).data("ai")
					  ,hliSeq : $(this).data("hli")
					  ,overSpendingYn : overSpendingYn
				  },
				  success: function(data) {
				  },
				  error: function(xhr, status, error){
					  console.log(xhr + ":" + status + ":" + error);
					  alert("처리 중 오류가 발생했습니다.");
					  return false;
				  }
			});
		});
	});

	// 조회
	function fn_search() {
		$("#bookForm #pageIndex").val("1");
		$("#bookForm #pageSize").val("10");

		$("#bookForm").submit();
	}

	// 초기화
	function fn_reset() {
		$("#bookForm #beginDe").val("${holder.resetBeginDe}");
		$("#bookForm #endDe").val("${holder.resetEndDe}");
		$("#bookForm #inoutType").val("");
		$("#bookForm #aiSe").val("");
		$("#bookForm #aiSeq").val("");
	}

	// 신규등록
	function fn_new() {
		$("#bookDetailForm #aiSeq").val("");
		$("#bookDetailForm").submit();
	}

	// 상세정보
	function fn_detail(aiSeq, hliSeq) {
		$("#bookDetailForm #aiSeq").val(aiSeq);
		$("#bookDetailForm #hliSeq").val(hliSeq);
		$("#bookDetailForm").submit();
	}

	// 페이징
	function fn_paging(idx) {
		$("#bookForm #pageIndex").val(idx);
		$("#bookForm").submit();
	}
</script>
</head>
<body class="common-page">
	<div class="menu-container">
	    <h2>가계부</h2>
	    <div class="common_section">
	    	<form id="bookDetailForm" name="bookDetailForm" method="post" action="/user/book/bookForm.do">
	    		<input type="hidden" id="aiSeq" name="aiSeq" />
	    		<input type="hidden" id="hliSeq" name="hliSeq" />
	    	</form>
	        <form id="bookForm" name="bookForm" method="post" action="/user/book/bookList.do">
				<input type="hidden" id="pageIndex" name="pageIndex" value="${holder.pageIndex }"/>
				<input type="hidden" id="pageSize" name="pageSize" value="${holder.pageSize }"/>
			    <div class="search-box">
					<div class="search-row">
			            <input type="text" id="beginDe" name="beginDe" value="${holder.beginDe}" class="search-input-small datepicker" placeholder="시작일" readonly> ~
			            <input type="text" id="endDe" name="endDe" value="${holder.endDe}" class="search-input-small datepicker" placeholder="종료일" readonly>
			        </div>

					<div class="search-row">
			            <select id="inoutType" name="inoutType">
			                <option value="">수입/지출 전체</option>
			                <option value="I" ${holder.inoutType eq 'I' ? 'selected' : ''}>수입</option>
			                <option value="E"  ${holder.inoutType eq 'E' ? 'selected' : ''}>지출</option>
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
			            <select id="aiSe" name="aiSe">
			                <option value="">타입 전체</option>
			                <option value="B" ${holder.aiSe eq 'B' ? 'selected' : ''}>통장</option>
			                <option value="C"  ${holder.aiSe eq 'C' ? 'selected' : ''}>카드</option>
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
			        <div class="search-row-right">
			            <button type="button" onclick="fn_new()" class="btn-search">신규등록</button>
			        </div>

			    </div>
			</form>
			<div class="summary-box">
			    <div class="summary-item income">
			        총 수입 <span>₩ ${!empty total.incomeTotalAmount ? total.incomeTotalAmount : '0'}</span>
			    </div>

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
	        			<col style="width:auto;">
	        		</c:forEach>
		        </colgroup>
	            <thead>
	                <tr>
	                	<c:forEach var="thead" items="${bookView }">
	                		<th>${thead.bcNm }</th>
	                	</c:forEach>
	                </tr>
	            </thead>
	            <tbody>
	            	<c:choose>
						<c:when test="${!empty list }">
							<c:forEach var="item" items="${list }">
								<tr>
									<c:forEach var="bodyItem" items="${bookView }" varStatus="status">
										<td>
											<c:choose>
												<c:when test="${bodyItem.colimnName eq 'event' }">
													<button onclick="fn_detail('${item.aiSeq}', '${item.hliSeq }')" class="tableBtn">보기</button>
												</c:when>
												<c:when test="${bodyItem.colimnName eq 'inoutType' }">
													<span class="${item[bodyItem.colimnName] eq '수입' ? 'text-color-blue' : 'text-color-red'}"><c:out value="${item[bodyItem.colimnName] }"/></span>
												</c:when>
												<c:when test="${bodyItem.colimnName eq 'amount' }">
													<span class="${item.inoutType eq '수입' ? 'text-color-blue' : 'text-color-red'}"><c:out value="${item[bodyItem.colimnName] }"/></span>
												</c:when>
												<c:when test="${bodyItem.colimnName eq 'overSpendingYn'}">
													<c:if test="${item.inoutType eq '지출' }">
														<input type="checkbox" id="overSpendingYn_${status.index }" name="overSpendingYn" value="Y" ${item.overSpendingYn eq 'Y' ? 'checked' : '' } data-ai="${item.aiSeq }" data-hli="${item.hliSeq }" />
													</c:if>
												</c:when>
												<c:otherwise>
													<c:out value="${item[bodyItem.colimnName] }"/>
												</c:otherwise>
											</c:choose>
										</td>
									</c:forEach>
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