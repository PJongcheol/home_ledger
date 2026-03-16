<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp" %>

<script type="text/javascript">
	// 회원정보 수정 윈도우 팝업
	function fn_profile(){
		window.open("/etc/memberProfile.do", "profile", "width=500,height=500,top=300,left=800");
	}

	// 메뉴 이동
	function fn_goMenu(url, id, pid) {
		$("#menuForm #menuUrl").val(url);
		$("#menuForm #menuId").val(id);
		$("#menuForm #menuPid").val(pid);

		$("#menuForm").attr("action", url);
		$("#menuForm").submit();
	}
</script>

<form name="menuForm" id="menuForm" method="get">
	<input type="hidden" id="menuUrl" name="menuUrl"/>
	<input type="hidden" id="menuId" name="menuId"/>
	<input type="hidden" id="menuPid" name="menuPid"/>
</form>

<header class="header">
    <div class="header-inner">
    	<a href="/user/main/index.do" class="a-decoration-color-non">
        	<div class="logo">CMS PORTAL</div>
        </a>
		<nav class="nav">
			<ul>
				<c:forEach var="item" items="${userMenu}">
				<!-- 자식메뉴 분기처리 -->
					<c:choose>
						<c:when test="${empty item.children }">
							<li>
								<a href="javascript:void(0)" onclick="fn_goMenu('${item.menuUrl}', '${item.menuId }', '${item.menuPid }')" class="a-decoration-color-non" data-menu-id="${item.menuId}" data-menu-pid="${item.menuPid}">
									<c:out value="${item.menuNm }"/>
								</a>
							</li>
						</c:when>
						<c:otherwise>
							<li>
							<c:out value="${item.menuNm }"/>
								<ul class="submenu">
									<c:forEach var="children" items="${item.children }">
										<li>
											<a href="javascript:void(0)" onclick="fn_goMenu('${children.menuUrl}', '${children.menuId }', '${children.menuPid }')" class="a-decoration-color-non" data-menu-id="${item.menuId}" data-menu-pid="${item.menuPid}">
												<c:out value="${children.menuNm }"/>
											</a>
										</li>
									</c:forEach>
								</ul>
							</li>
						</c:otherwise>
					</c:choose>
				</c:forEach>
			</ul>
		</nav>
		<c:if test="${not empty sessionScope.LoginVO}">
	        <div class="user">
	            <a href="javascript:void(0)" onclick="fn_profile()" class="a-decoration-color-non">
		            <i class="fa-solid fa-user"></i>
		            <span class="user-name">
		                ${sessionScope.LoginVO.memberNm}
		            </span>
	            </a>

	            <a href="/login/logout.do" class="btn-logout">로그아웃</a>
	        </div>
	    </c:if>
    </div>
</header>