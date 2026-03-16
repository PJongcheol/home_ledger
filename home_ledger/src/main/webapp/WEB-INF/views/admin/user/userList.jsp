<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>사용자관리</title>
<script type="text/javascript">
	$(document).ready(function(){

	});

	// 조회
	function fn_search() {
		var memberId = $("#adminUserForm #memberId").val().trim();
		var memberNm = $("#adminUserForm #memberNm").val().trim();

		$("#adminUserForm #memberId").val(memberId);
		$("#adminUserForm #memberNm").val(memberNm);

		$("#adminUserForm #pageIndex").val("1");
		$("#adminUserForm #pageSize").val("10");

		$("#adminUserForm").submit();
	}

	// 초기화
	function fn_reset() {
		$("#adminUserForm #masterCode").val("");
		$("#adminUserForm #confmYn").val("");
		$("#adminUserForm #useYn").val("");
		$("#adminUserForm #memberId").val("");
		$("#adminUserForm #memberNm").val("");
	}

	// 상세정보
	function fn_detail(memberId) {
		$("#adminUserDetailForm #memberId").val(memberId);
		$("#adminUserDetailForm").submit();
	}

	// 페이징
	function fn_paging(idx) {
		$("#adminUserForm #pageIndex").val(idx);
		$("#adminUserForm").submit();
	}
</script>
</head>
<body class="common-page">
	<div class="menu-container">
	    <h2>사용자관리</h2>
	    <div class="common_section">
	    	<form id="adminUserDetailForm" name="adminUserDetailForm" method="post" action="/admin/user/userDetail.do">
	    		<input type="hidden" id="memberId" name="memberId" />
	    	</form>
	        <form id="adminUserForm" name="adminUserForm" method="post" action="/admin/user/userList.do">
				<input type="hidden" id="pageIndex" name="pageIndex" value="${holder.pageIndex }"/>
				<input type="hidden" id="pageSize" name="pageSize" value="${holder.pageSize }"/>
			    <div class="search-box">
					<div class="search-row">
			            <select id="masterCode" name="masterCode">
			                <option value="">권한전체</option>
			                <option value="10" ${holder.masterCode eq '10' ? 'selected' : ''}>최고관리자</option>
			                <option value="9"  ${holder.masterCode eq '9' ? 'selected' : ''}>관리자</option>
			                <option value="1"  ${holder.masterCode eq '1' ? 'selected' : ''}>일반사용자</option>
			            </select>
			        </div>

			        <div class="search-row">
			            <select id="confmYn" name="confmYn">
			                <option value="">승인여부전체</option>
			                <option value="Y" ${holder.confmYn eq 'Y' ? 'selected' : ''}>승인</option>
			                <option value="N"  ${holder.confmYn eq 'N' ? 'selected' : ''}>미승인</option>
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
			            <input type="text" id="memberId" name="memberId" value="${holder.memberId}" placeholder="회원ID를 입력해주세요.">
			        </div>

			        <div class="search-row">
			            <input type="text" id="memberNm" name="memberNm" value="${holder.memberNm}" placeholder="이름을 입력해주세요.">
			        </div>

			        <div class="search-row">
			            <button type="button" onclick="fn_search()" class="btn-search">조회</button>
			            <button type="button" onclick="fn_reset()" class="btn-reset">초기화</button>
			        </div>

			    </div>
			</form>
	        <table class="table-hover">
	        	<colgroup>
		        	<col style="width:17%">
		        	<col style="width:15%">
		        	<col style="width:12%">
		        	<col style="width:15%">
		        	<col style="width:13%">
		        	<col style="width:13%">
		        	<col style="width:15%">
		        </colgroup>
	            <thead>
	                <tr>
	                	<th>회원 ID</th>
	                	<th>이름</th>
	                	<th>권한</th>
	                	<th>핸드폰번호</th>
	                	<th>승인여부</th>
	                	<th>사용여부</th>
	                	<th>가입일</th>
	                </tr>
	            </thead>
	            <tbody>
	            	<c:choose>
						<c:when test="${!empty list }">
							<c:forEach var="item" items="${list }">
								<tr>
									<td>
										<a href="javascript:void(0)" class="a-decoration-non" onclick="fn_detail('${item.memberId}')">
											<span class="text-color-blue-bold"><c:out value="${item.memberId }"/></span>
										</a>
									</td>
									<td><c:out value="${item.memberNm }"/></td>
									<td>
										<c:choose>
											<c:when test="${item.masterCode eq '10'}">
												최고관리자
											</c:when>
											<c:when test="${item.masterCode eq '9'}">
												관리자
											</c:when>
											<c:when test="${item.masterCode eq '1'}">
												일반사용자
											</c:when>
										</c:choose>
									</td>
									<td><c:out value="${item.memberPhone }"/></td>
									<td>
										<c:choose>
											<c:when test="${item.confmYn eq 'Y' }">
												<span class="text-color-blue">승인</span>
											</c:when>
											<c:otherwise>
												<span class="text-color-red">미승인</span>
											</c:otherwise>
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
									<td><c:out value="${item.joinDe }"/></td>
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