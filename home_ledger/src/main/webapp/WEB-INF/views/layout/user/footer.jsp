<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp" %>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<script>
	// 관리자 메뉴
	function fn_mng() {
		$("#mngForm").submit();
	}
</script>

<form name="mngForm" id="mngForm" method="post" action="/admin/main/index.do">
	<input type="hidden" id="menuUrl" name="menuUrl" value="/admin/main/index.do"/>
	<input type="hidden" id="menuId" name="menuId" value="2"/>
	<input type="hidden" id="menuPid" name="menuPid" value="1"/>
</form>
<footer>&copy; 2026 TongLog. All Rights Reserved.</footer>