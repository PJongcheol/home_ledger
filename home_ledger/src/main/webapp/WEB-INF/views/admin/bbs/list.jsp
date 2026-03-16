<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title><c:out value="${menuDetail.menuNm }"/></title>
<script type="text/javascript">
	$(document).ready(function(){
		$("#nttPassword").on("keypress", function(e){
			if(e.which === 13){
				e.preventDefault(); // 기본 submit 막기
				checkPassword();
			}
		});
	});

	// 조회
	function fn_search() {
		$("#adminBbsBoardForm #pageIndex").val("1");
		$("#adminBbsBoardForm #pageSize").val("10");

		$("#adminBbsBoardForm").submit();
	}

	// 초기화
	function fn_reset() {
		$("#adminBbsBoardForm #bbsNm").val("");
	}

	// 페이징
	function fn_paging(idx) {
		$("#adminBbsBoardForm #pageIndex").val(idx);
		$("#adminBbsBoardForm").submit();
	}

	// 신규등록
	function fn_new() {
		$("#adminBbsBoardDetailForm #mode").val("N");
		$("#adminBbsBoardDetailForm").submit();
	}

	// view
	function fn_view(bbsSeq, nttSeq, secretYn) {
		if(secretYn == "Y") {
			$("#adminBbsPassword #bbsSeq").val(bbsSeq);
			$("#adminBbsPassword #nttSeq").val(nttSeq);
			openPasswordLayer();
		} else {
			$("#adminBbsBoardViewForm #bbsSeq").val(bbsSeq);
			$("#adminBbsBoardViewForm #nttSeq").val(nttSeq);
			$("#adminBbsBoardViewForm").submit();
		}
	}

	// 패스워드 layer 열기
	function openPasswordLayer(){
	    $("#layerDim").addClass("open");
	    $("#passwordLayer").addClass("open");

	    setTimeout(function(){
	        $("#nttPassword").focus();
	    },200);
	}

	// 패스워드 layer 닫기
	function closePasswordLayer(){
	    $("#layerDim").removeClass("open");
	    $("#passwordLayer").removeClass("open");
	}

	// 패스워드 체크
	function checkPassword() {
		var bbsSeq = $("#adminBbsPassword #bbsSeq").val();
		var nttSeq = $("#adminBbsPassword #nttSeq").val();
		var nttPassword = $("#adminBbsPassword #nttPassword").val();

		if(nttPassword == "") {
			alert("비밀번호는 필수입니다.");
			$("#nttPassword").focus();
			return false;
		}

		$.ajax({
			  url: "/admin/bbs/board/bbsPassword.do",
			  type: "POST",
			  data: {
				   bbsSeq : bbsSeq
				  ,nttSeq : nttSeq
				  ,nttPassword : nttPassword
			  },
			  success: function(data) {
				  if(data.cnt == "0") {
					  alert("비밀번호가 틀립니다.");
					  return false;
				  } else {
					  $("#adminBbsBoardViewForm #bbsSeq").val(bbsSeq);
					  $("#adminBbsBoardViewForm #nttSeq").val(nttSeq);
					  $("#adminBbsBoardViewForm").submit();
				  }
			  },
			  error: function(xhr, status, error){
				  console.log(xhr + ":" + status + ":" + error);
				  alert("처리 중 오류가 발생했습니다.");
				  return false;
			  }
		});
	}
</script>
</head>
<body class="common-page">
	<div class="menu-container">
	    <h2><c:out value="${menuDetail.menuNm }"/></h2>
	    <div class="common_section">
	    	<form id="adminBbsBoardDetailForm" name="adminBbsBoardDetailForm" method="post" action="/admin/bbs/board/form.do">
				<input type="hidden" id="mode" name="mode"/>
				<input type="hidden" id="mId" name="mId" value="${holder.mId }"/>
				<input type="hidden" id="mPid" name="mPid" value="${holder.mPid }"/>
				<input type="hidden" id="menuNm" name="menuNm" value="${menuDetail.menuNm }"/>
				<input type="hidden" id="bbsSeq" name="bbsSeq" value="${menuDetail.bbsSeq }" />
	    	</form>
	    	<form id="adminBbsBoardViewForm" name="adminBbsBoardViewForm" method="post" action="/admin/bbs/board/view.do">
				<input type="hidden" id="mId" name="mId" value="${holder.mId }"/>
				<input type="hidden" id="mPid" name="mPid" value="${holder.mPid }"/>
				<input type="hidden" id="bbsSeq" name="bbsSeq" />
				<input type="hidden" id="nttSeq" name="nttSeq" />
				<input type="hidden" id="menuNm" name="menuNm" value="${menuDetail.menuNm }" />
	    	</form>
	        <form id="adminBbsBoardForm" name="adminBbsBoardForm" method="post" action="/admin/bbs/board/list.do">
				<input type="hidden" id="mId" name="mId" value="${holder.mId }"/>
				<input type="hidden" id="mPid" name="mPid" value="${holder.mPid }"/>
			    <div class="search-box">
			        <div class="search-row">
			            <input type="text" id="nttSj" name="nttSj" value="${holder.nttSj}" placeholder="제목을 입력해주세요.">
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
		        	<col style="width:60%">
		        	<c:if test="${menuDetail.nttRdcntYn eq 'Y' }">
		        		<col style="width:10%">
		        	</c:if>
		        	<col style="width:10%">
		        	<col style="width:20%">
		        </colgroup>
	            <thead>
	                <tr>
	                	<th>제목</th>
	                	<c:if test="${menuDetail.nttRdcntYn eq 'Y'}">
	                		<th>조회수</th>
	                	</c:if>
	                	<th>등록자</th>
	                	<th>등록일</th>
	                </tr>
	            </thead>
	            <tbody>
	            	<c:choose>
						<c:when test="${!empty list }">
							<c:forEach var="item" items="${list }" varStatus="status">
								<input type="hidden" id="bbsSeq_${status.index}" name="bbsSeq" value="${item.bbsSeq }"/>
								<tr>
									<td>
										<a href="javascript:void(0)" class="a-decoration-non" onclick="fn_view('${item.bbsSeq}', '${item.nttSeq }', '${item.secretYn }')">
											<span class="text-color-blue-bold">
												<c:if test="${item.secretYn eq 'Y'}">
													<i class="fa-solid fa-lock"></i>
												</c:if>
												<c:out value="${item.nttSj }"/>
											</span>
										</a>
									</td>
									<c:if test="${menuDetail.nttRdcntYn eq 'Y' }">
										<td><fmt:formatNumber value="${item.nttRdcnt }" pattern="#,###" /></td>
									</c:if>
									<td><c:out value="${item.regId }"/></td>
									<td><c:out value="${item.regDt }"/></td>
								</tr>
							</c:forEach>
						</c:when>
						<c:otherwise>
							<tr>
								<td colspan="4">데이터가 존재하지 않습니다.</td>
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
	<!-- dim -->
	<div id="layerDim" class="layer-dim"></div>

	<!-- 비밀번호 레이어 -->
	<div id="passwordLayer" class="password-layer">

	    <h3>비밀번호 입력</h3>
		<form id="adminBbsPassword" name="adminBbsPassword">
			<input type="hidden" id="bbsSeq" name="bbsSeq"/>
			<input type="hidden" id="nttSeq" name="nttSeq"/>
			<input type="password" id="nttPassword" class="password-input" placeholder="비밀번호를 입력하세요">

		    <div class="password-actions">
		        <button type="button" class="btn gray" onclick="closePasswordLayer()">취소</button>
		        <button type="button" class="btn blue" onclick="checkPassword()">확인</button>
		    </div>
		</form>


	</div>
</body>
</html>