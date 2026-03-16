<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp" %>

<script type="text/javascript">
	// 회원정보 수정 윈도우 팝업
	function fn_profile(){
		window.open("/etc/memberProfile.do", "profile", "width=500,height=500,top=300,left=800");
	}
</script>
<header>

    <div class="logo">
    	<a href="javascript:void(0)" onclick="fn_goMenu('/admin/main/index.do', '2', '1')" class="a-decoration-color-non">
        	<i class="fa-solid fa-cogs"></i> CMS Dashboard
        </a>
    </div>

    <c:if test="${not empty sessionScope.LoginVO}">
        <div class="user">
        	<a href="/user/main/index.do" class="a-decoration-color-non"><i class="fa-solid fa-house"></i></a>

            <a href="javascript:void(0)" onclick="fn_profile()" class="a-decoration-color-non">
	            <i class="fa-solid fa-user"></i>
	            <span class="user-name">
	                ${sessionScope.LoginVO.memberNm}
	            </span>
            </a>

            <a href="/login/logout.do" class="btn-logout">로그아웃</a>
        </div>
    </c:if>
</header>
