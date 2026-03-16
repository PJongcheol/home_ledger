<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시판관리</title>
<script type="text/javascript">
	$(document).ready(function(){

	});

	// 조회
	function fn_search() {
		$("#adminBbsForm #pageIndex").val("1");
		$("#adminBbsForm #pageSize").val("10");

		$("#adminBbsForm").submit();
	}

	// 초기화
	function fn_reset() {
		$("#adminBbsForm #startDate").val("");
		$("#adminBbsForm #endDate").val("");
		$("#adminBbsForm #memberId").val("");
		$("#adminBbsForm #memberNm").val("");
	}

	// 페이징
	function fn_paging(idx) {
		$("#adminBbsForm #pageIndex").val(idx);
		$("#adminBbsForm").submit();
	}

	// 신규등록
	function fn_new() {
		$("#adminBbsDetailForm #mode").val("N");
		$("#adminBbsDetailForm #bbsSeq").val("");
		$("#adminBbsDetailForm").submit();
	}

	// 상세
	function fn_detail(bbsSeq) {
		$("#adminBbsDetailForm #mode").val("D");
		$("#adminBbsDetailForm #bbsSeq").val(bbsSeq);
		$("#adminBbsDetailForm").submit();
	}
</script>
</head>
<body class="common-page">
	<div class="menu-container">
	    <h2>게시판관리</h2>
	    <div class="common_section">
	    	<form id="adminBbsDetailForm" name="adminBbsDetailForm" method="post" action="/admin/bbs/form.do">
				<input type="hidden" id="mode" name="mode"/>
				<input type="hidden" id="bbsSeq" name="bbsSeq"/>
	    	</form>
	        <form id="adminBbsForm" name="adminBbsForm" method="post" action="/admin/bbs/list.do">
				<input type="hidden" id="pageIndex" name="pageIndex" value="${holder.pageIndex }"/>
				<input type="hidden" id="pageSize" name="pageSize" value="${holder.pageSize }"/>
			    <div class="search-box">
			        <div class="search-row">
			            <select id="bbsType" name="bbsType">
			                <option value="">게시판종류전체</option>
			                <option value="DEFAULT" ${holder.bbsType eq 'DEFAULT' ? 'selected' : ''}>기본</option>
			                <option value="MOVIE" ${holder.bbsType eq 'MOVIE' ? 'selected' : ''}>동영상</option>
			            </select>
			        </div>
			        <div class="search-row">
			            <select id="siteCode" name="siteCode">
			                <option value="">사이트구분전체</option>
			                <option value="admin" ${holder.siteCode eq 'admin' ? 'selected' : ''}>Admin</option>
			                <option value="user" ${holder.siteCode eq 'user' ? 'selected' : ''}>User</option>
			            </select>
			        </div>
			        <div class="search-row">
			            <input type="text" id="bbsNm" name="bbsNm" value="${holder.bbsNm}" placeholder="게시판명을 입력해주세요.">
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
		        	<col style="width:18%">
		        	<col style="width:9%">
		        	<col style="width:9%">
		        	<col style="width:11%">
		        	<col style="width:21%">
		        	<col style="width:11%">
		        	<col style="width:21%">
		        </colgroup>
	            <thead>
	                <tr>
	                	<th>게시판명</th>
	                	<th>게시판종류</th>
	                	<th>사이트구분</th>
	                	<th>등록자</th>
	                	<th>등록일시</th>
	                	<th>수정자</th>
	                	<th>수정일시</th>
	                </tr>
	            </thead>
	            <tbody>
	            	<c:choose>
						<c:when test="${!empty list }">
							<c:forEach var="item" items="${list }" varStatus="status">
								<input type="hidden" id="bbsSeq_${status.index}" name="bbsSeq" value="${item.bbsSeq }"/>
								<tr>
									<td>
										<a href="javascript:void(0)" class="a-decoration-non" onclick="fn_detail('${item.bbsSeq}')">
											<span class="text-color-blue-bold"><c:out value="${item.bbsNm }"/></span>
										</a>
									</td>
									<td>
										<c:choose>
											<c:when test="${item.bbsType eq 'DEFAULT' }">일반</c:when>
											<c:when test="${item.bbsType eq 'MOVIE' }">동영상</c:when>
										</c:choose>
									</td>
									<td><c:out value="${item.siteCode eq 'admin' ? 'Admin' : 'User' }"/></td>
									<td><c:out value="${item.regId }"/></td>
									<td><c:out value="${item.regDt }"/></td>
									<td><c:out value="${item.updId }"/></td>
									<td><c:out value="${item.updDt }"/></td>
								</tr>
							</c:forEach>
						</c:when>
						<c:otherwise>
							<tr>
								<td colspan="7">데이터가 존재하지 않습니다.</td>
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