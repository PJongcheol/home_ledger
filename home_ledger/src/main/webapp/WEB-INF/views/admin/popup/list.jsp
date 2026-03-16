<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>팝업관리</title>
<script type="text/javascript">
	$(document).ready(function(){

	});

	// 조회
	function fn_search() {
		$("#adminPopupForm #pageIndex").val("1");
		$("#adminPopupForm #pageSize").val("10");

		$("#adminPopupForm").submit();
	}

	// 초기화
	function fn_reset() {
		$("#adminPopupForm #popupTy").val("");
		$("#adminPopupForm #popupSe").val("");
		$("#adminPopupForm #siteCode").val("");
		$("#adminPopupForm #useYn").val("");
		$("#adminPopupForm #popupSj").val("");
	}

	// 폼 이동
	function fn_form(seq) {
		var mode = "";

		// 신규인지 상세인지
		if(seq == "") {
			mode = "N";
		} else {
			mode = "D";
		}

		$("#adminPopupDetailForm #popupSeq").val(seq);
		$("#adminPopupDetailForm #mode").val(mode);
		$("#adminPopupDetailForm").submit();
		$("#adminPopupDetailForm #popupSeq").val("");
	}

	// 페이징
	function fn_paging(idx) {
		$("#adminPopupForm #pageIndex").val(idx);
		$("#adminPopupForm").submit();
	}
</script>
</head>
<body class="common-page">
	<div class="menu-container">
	    <h2>팝업관리</h2>
	    <div class="common_section">
	    	<form id="adminPopupDetailForm" name="adminPopupDetailForm" method="post" action="/admin/popup/form.do">
	    		<input type="hidden" id="mode" name="mode" />
	    		<input type="hidden" id="popupSeq" name="popupSeq" />
	    	</form>
	        <form id="adminPopupForm" name="adminPopupForm" method="post" action="/admin/popup/list.do">
				<input type="hidden" id="pageIndex" name="pageIndex" value="${holder.pageIndex }"/>
				<input type="hidden" id="pageSize" name="pageSize" value="${holder.pageSize }"/>
			    <div class="search-box">
					<div class="search-row">
			            <select id="popupTy" name="popupTy">
			                <option value="">타입구분</option>
			                <option value="L" ${holder.popupTy eq 'L' ? 'selected' : ''}>이미지링크</option>
			                <option value="C"  ${holder.popupTy eq 'C' ? 'selected' : ''}>에디터기반</option>
			            </select>
			        </div>

			        <div class="search-row">
			            <select id="popupSe" name="popupSe">
			                <option value="">타입구분</option>
			                <option value="P" ${holder.popupSe eq 'P' ? 'selected' : ''}>윈도우</option>
			                <option value="D"  ${holder.popupSe eq 'D' ? 'selected' : ''}>DIV레이어</option>
			            </select>
			        </div>

			        <div class="search-row">
			            <select id="siteCode" name="siteCode">
			                <option value="">사이트구분</option>
			                <option value="admin" ${holder.siteCode eq 'admin' ? 'selected' : ''}>Admin</option>
			                <option value="user" ${holder.siteCode eq 'user' ? 'selected' : ''}>User</option>
			            </select>
			        </div>

			        <div class="search-row">
			            <select id="useYn" name="useYn">
			                <option value="">사용여부</option>
			                <option value="Y" ${holder.useYn eq 'Y' ? 'selected' : ''}>사용</option>
			                <option value="N" ${holder.useYn eq 'N' ? 'selected' : ''}>미사용</option>
			            </select>
			        </div>

			        <div class="search-row">
			            <input type="text" id="popupSj" name="popupSj" value="${holder.popupSj}" placeholder="제목을 입력해주세요.">
			        </div>

			        <div class="search-row">
			            <button type="button" onclick="fn_search()" class="btn-search">조회</button>
			            <button type="button" onclick="fn_reset()" class="btn-reset">초기화</button>
			        </div>
			        <div class="search-row-right">
			            <button type="button" onclick="fn_form('')" class="btn-search">신규등록</button>
			        </div>

			    </div>
			</form>
	        <table class="table-hover">
	        	<colgroup>
		        	<col style="width:24%">
		        	<col style="width:8%">
		        	<col style="width:8%">
		        	<col style="width:8%">
		        	<col style="width:6%">
		        	<col style="width:10%">
		        	<col style="width:13%">
		        	<col style="width:10%">
		        	<col style="width:13%">
		        </colgroup>
	            <thead>
	                <tr>
	                	<th>제목</th>
	                	<th>사이트구분</th>
	                	<th>콘텐츠타입</th>
	                	<th>팝업구분</th>
	                	<th>사용여부</th>
	                	<th>등록자ID</th>
	                	<th>등록일시</th>
	                	<th>수정자ID</th>
	                	<th>수정일시</th>
	                </tr>
	            </thead>
	            <tbody>
	            	<c:choose>
						<c:when test="${!empty list }">
							<c:forEach var="item" items="${list }">
								<tr>
									<td>
										<a href="javascript:void(0)" class="a-decoration-non" onclick="fn_form('${item.popupSeq}')">
											<span class="text-color-blue-bold"><c:out value="${fn:length(item.popupSj) > 16 ? fn:substring(item.popupSj, 0, 16).concat('...') : item.popupSj }"/></span>
										</a>
									</td>
									<td>
										<c:choose>
											<c:when test="${item.siteCode eq 'admin'}">
												Admin
											</c:when>
											<c:when test="${item.siteCode eq 'user'}">
												User
											</c:when>
										</c:choose>
									</td>
									<td>
										<c:choose>
											<c:when test="${item.popupTy eq 'L'}">
												이미지 링크
											</c:when>
											<c:when test="${item.popupTy eq 'C'}">
												에디터 기반
											</c:when>
										</c:choose>
									</td>
									<td>
										<c:choose>
											<c:when test="${item.popupSe eq 'P' }">
												윈도우
											</c:when>
											<c:when test="${item.popupSe eq 'D'}">
												DIV레이어
											</c:when>
										</c:choose>
									</td>
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
									<td><c:out value="${item.regId }"/></td>
									<td><c:out value="${item.regDt }"/></td>
									<td><c:out value="${item.updId }"/></td>
									<td><c:out value="${item.updDt }"/></td>
								</tr>
							</c:forEach>
						</c:when>
						<c:otherwise>
							<tr>
								<td colspan="9">데이터가 존재하지 않습니다.</td>
							</tr>
						</c:otherwise>
	            	</c:choose>
	            </tbody>
	        </table>
	        <jsp:include page="/WEB-INF/views/common/paging.jsp">
			    <jsp:param name="pageIndexName" value="popupPageIndex" />
			</jsp:include>
	    </div>
	</div>
</body>
</html>