<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title><c:out value="${holder.menuNm }"/></title>
<script type="text/javascript">
	$(document).ready(function(){

	});

	// 목록
	function fn_back() {
		$("#adminBbsBoardForm").submit();
	}

	// form
	function fn_form(bbsSeq, nttSeq) {
		$("#adminBbsBoardDetailForm #bbsSeq").val(bbsSeq);
		$("#adminBbsBoardDetailForm #nttSeq").val(nttSeq);
		$("#adminBbsBoardDetailForm").submit();
	}

</script>
</head>
<body class="common-page">
    <div class="menu-container">
	    <!-- 게시글 제목 -->
	    <h2 class="bbs-title">${holder.menuNm}</h2>
	    <div class="bbs-content">
	    	<form id="adminBbsBoardForm" name="adminBbsBoardForm" method="post" action="/admin/bbs/board/list.do">
	    		<input type="hidden" id="mId" name="mId" value="${holder.mId }"/>
	    		<input type="hidden" id="mPid" name="mPid" value="${holder.mPid }"/>
	    	</form>
	    	<form id="adminBbsBoardDetailForm" name="adminBbsBoardDetailForm" method="post" action="/admin/bbs/board/form.do">
				<input type="hidden" id="mode" name="mode" value="D"/>
				<input type="hidden" id="mId" name="mId" value="${holder.mId }"/>
				<input type="hidden" id="mPid" name="mPid" value="${holder.mPid }"/>
				<input type="hidden" id="menuNm" name="menuNm" value="${holder.menuNm }"/>
				<input type="hidden" id="bbsSeq" name="bbsSeq" />
				<input type="hidden" id="nttSeq" name="nttSeq" />
	    	</form>
		    <!-- 게시글 정보 -->
		    <table class="form-table">
		        <colgroup>
		            <col style="width:120px;">
		            <col style="width:auto;">
		            <col style="width:120px;">
		            <col style="width:auto;">
		        </colgroup>
				<c:if test="${field.NTT_SJ.useYn eq 'Y' && field.NTT_SJ.detailYn eq 'Y' }">
			        <tr>
			            <th>제목</th>
			            <td colspan="3">${detail.nttSj}</td>
			        </tr>
		        </c:if>

		        <tr>
		            <th>조회수</th>
		            <td colspan="3"><fmt:formatNumber value="${detail.nttRdcnt}" pattern="#,###" /></td>
		        </tr>
				<c:if test="${field.NTT_CN.useYn eq 'Y' && field.NTT_CN.detailYn eq 'Y' }">
			        <tr>
			            <th>내용</th>
			            <td colspan="3">

			                <!-- 에디터 내용 -->
			                <div class="bbs-text">
			                    ${detail.nttCn}
			                </div>

			            </td>
			        </tr>
		        </c:if>

		        <!-- 첨부파일 -->
		        <c:if test="${boardMst.fileAtchYn eq 'Y' && field.FILE.useYn eq 'Y' && field.FILE.detailYn eq 'Y'}">
					<tr>
			            <th>첨부파일</th>
			            <td colspan="3">
			                <c:forEach var="file" items="${fileList }">
                       			<div class="file-item">
                        			<a href="javascript:void(0)" onclick="fn_fileDownload('${file.atchfileno}', '${file.fileord }')"><span>${file.orgfilenm }</span></a>
								</div>
                       		</c:forEach>
			            </td>
			        </tr>
		        </c:if>
		        <c:if test="${field.ID.useYn eq 'Y' && field.ID.detailYn eq 'Y'}">
		        	<tr>
			            <th>등록자</th>
			            <td>${detail.regId}</td>
			            <th>수정자</th>
			            <td>${detail.updId}</td>
			        </tr>
		        </c:if>
		        <c:if test="${field.DT.useYn eq 'Y' && field.DT.detailYn eq 'Y'}">
		        	<tr>
			            <th>등록일시</th>
			            <td>${detail.regDt}</td>
			            <th>수정일시</th>
			            <td>${detail.updDt}</td>
			        </tr>
		        </c:if>
		    </table>
		    <div class="btn-form">
           		<c:if test="${boardMst.insertYn eq 'Y'}">
           			<c:if test="${sessionScope.LoginVO.memberId eq detail.regId || sessionScope.LoginVO.masterCode eq '10'}">
           				<button onclick="fn_form('${holder.bbsSeq}', '${holder.nttSeq }')" class="btn blue">수정</button>
           			</c:if>
           		</c:if>
                <button class="btn gray" onclick="fn_back()">목록</button>
            </div>
		</div>
	</div>
</body>
</html>