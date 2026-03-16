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
		var memberId = $("#adminUserLogForm #memberId").val().trim();
		var memberNm = $("#adminUserLogForm #memberNm").val().trim();

		$("#adminUserLogForm #memberId").val(memberId);
		$("#adminUserLogForm #memberNm").val(memberNm);

		$("#adminUserLogForm #pageIndex").val("1");
		$("#adminUserLogForm #pageSize").val("10");

		$("#adminUserLogForm").submit();
	}

	// 초기화
	function fn_reset() {
		$("#adminUserLogForm #startDate").val("");
		$("#adminUserLogForm #endDate").val("");
		$("#adminUserLogForm #memberId").val("");
		$("#adminUserLogForm #memberNm").val("");
	}

	// 페이징
	function fn_paging(idx) {
		$("#adminUserLogForm #pageIndex").val(idx);
		$("#adminUserLogForm").submit();
	}

</script>
</head>
<body class="common-page">
	<div class="menu-container">
	    <h2>로그인이력</h2>
	    <div class="common_section">
	        <form id="adminUserLogForm" name="adminUserLogForm" method="post" action="/admin/user/logList.do">
				<input type="hidden" id="pageIndex" name="pageIndex" value="${holder.pageIndex }"/>
				<input type="hidden" id="pageSize" name="pageSize" value="${holder.pageSize }"/>
			    <div class="search-box">
					<div class="search-row">
			            <input type="text" class="datepicker" id="startDate" name="startDate" value="${holder.startDate }" placeholder="로그인 시작일시" readonly>
			            ~
			            <input type="text" class="datepicker" id="endDate" name="endDate" value="${holder.endDate }" placeholder="로그인 종료일시" readonly>
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
		        	<col style="width:16%">
		        	<col style="width:15%">
		        	<col style="width:12%">
		        	<col style="width:14%">
		        	<col style="width:11%">
		        	<col style="width:11%">
		        	<col style="width:21%">
		        </colgroup>
	            <thead>
	                <tr>
	                	<th>회원 ID</th>
	                	<th>이름</th>
	                	<th>생년월일</th>
	                	<th>핸드폰번호</th>
	                	<th>이메일</th>
	                	<th>IP</th>
	                	<th>로그인일시</th>
	                </tr>
	            </thead>
	            <tbody>
	            	<c:choose>
						<c:when test="${!empty list }">
							<c:forEach var="item" items="${list }">
								<tr>
									<td><c:out value="${item.memberId }"/></td>
									<td><c:out value="${item.memberNm }"/></td>
									<td><c:out value="${item.memberBrthdy }"/></td>
									<td><c:out value="${item.memberPhone }"/></td>
									<td><c:out value="${item.memberEmail }"/></td>
									<td><c:out value="${item.loginIp }"/></td>
									<td><c:out value="${item.loginDt }"/></td>
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