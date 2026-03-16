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
<footer class="footer">
    <div class="footer-inner">
        <div class="footer-left">
            <p class="company">
                메인페이지
            </p>
            <p>
                해당 페이지는 cms 진입 전 메인보드 페이지 입니다.</br>
                Tel. 010-8983-2348
            </p>
            <c:if test="${sessionScope.LoginVO.getMasterCode() eq '9' or sessionScope.LoginVO.getMasterCode() eq '10'}">
	            <p class="copyright">
	                <a href="javascript:void(0)" onclick="fn_mng()" class="footer-admin-btn">SYSTEM</a>
	            </p>
            </c:if>
        </div>
    </div>
</footer>
