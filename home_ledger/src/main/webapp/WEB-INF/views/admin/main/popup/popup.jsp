<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>팝업</title>
<link rel="stylesheet" href="<c:url value='/css/popup.css'/>">
<link href="/images/favicon.ico" id="favicon" rel="shortcut icon" sizes="64x64" type="image/x-icon">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="<c:url value='/js/devel.js'/>"></script>
<script>
function closePopup(seq) {
	// 1주일 체크 확인 후 쿠키 등록
	if($("#weekClose").is(":checked")) {
		setCookie("popup_"+seq, "done", 7);
	}
	window.close();
}
</script>
</head>
<body>

<div class="popup-wrapper">
    <c:choose>
    	<c:when test="${popup.popupTy eq 'L' }">
    		<a href="${popup.popupUrl }" target="_blank">
    			<img src="${uploadUrl}popup/${popup.svfilenm}" style="width:100%">
    		</a>
    	</c:when>
    	<c:otherwise>
			${popup.popupCn }
    	</c:otherwise>
    </c:choose>
</div>

<div class="popup-footer">
    <label>
        <input type="checkbox" id="weekClose">
        1주일 동안 열지 않음
    </label>
    <button onclick="closePopup('${popup.popupSeq}')">닫기</button>
</div>

</body>
</html>