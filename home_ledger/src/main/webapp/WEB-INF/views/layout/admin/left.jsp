<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp" %>

<form name="menuForm" id="menuForm" method="post">
	<input type="hidden" id="menuUrl" name="menuUrl"/>
	<input type="hidden" id="menuId" name="menuId"/>
	<input type="hidden" id="menuPid" name="menuPid"/>
</form>
<h2>시스템관리</h2>
<ul>
	<c:forEach var="item" items="${leftAdminMenu}">
	<!-- 자식메뉴 분기처리 -->
		<c:choose>
			<c:when test="${empty item.children }">
				<li>
					<a href="javascript:void(0)" onclick="fn_goMenu('${item.menuUrl}', '${item.menuId }', '${item.menuPid }')" class="menu-link ${sessionScope.menuId eq item.menuId ? 'active' : ''}" data-menu-id="${item.menuId}" data-menu-pid="${item.menuPid}">
						<div class="menu-title">
							<i class="${item.menuIcon }"></i> <span>${item.menuNm }</span>
						</div>
					</a>
				</li>
			</c:when>
			<c:otherwise>
				<li class="has-submenu ${sessionScope.menuPid eq item.menuId ? 'open' : ''}" data-menu-id="${item.menuId}">
					<div class="menu-title">
						<i class="${item.menuIcon }"></i> <span>${item.menuNm }</span>
						<i class="fa-solid fa-chevron-right arrow"></i>
					</div>
					<ul class="submenu" style="display:${sessionScope.menuPid eq item.menuId ? 'block' : 'none'}">
						<c:forEach var="children" items="${item.children }">
							<a href="javascript:void(0)" onclick="fn_goMenu('${children.menuUrl}', '${children.menuId }', '${children.menuPid }')" class="menu-link ${sessionScope.menuId eq children.menuId ? 'active' : ''}" data-menu-id="${item.menuId}" data-menu-pid="${item.menuPid}">
								<li>${children.menuNm }</li>
							</a>
						</c:forEach>
					</ul>
				</li>
			</c:otherwise>
		</c:choose>
	</c:forEach>
</ul>

<!-- <div class="menu-title"><i class="fa-solid fa-chart-line"></i> <span>대시보드</span></div> -->
<!-- <div class="menu-title"><i class="fa-solid fa-file-alt"></i> <span>콘텐츠 관리</span></div> -->
<!-- <div class="menu-title"><i class="fa-solid fa-gear"></i> <span>설정</span></div> -->

<script>
$(function(){
	var menuId = "${sessionScope.menuId}";
    var menuPid = "${sessionScope.menuPid}";

	// 하위 메뉴 토글
    $(".has-submenu > .menu-title").off("click").on("click", function(e){
        var $parent = $(this).parent();
        $parent.toggleClass("open");
        $parent.find(".submenu").stop().slideToggle(300);
    });

//     if(menuId){
//         $(".menu-link[data-menu-id='" + menuId + "']").closest("li").addClass("active");
//     }

//     if(menuId){
//         var $active = $(".menu-link[data-menu-id='" + menuId + "']");
//         $active.addClass("active");
//     }

//     if(menuPid){
//         var $parent = $(".has-submenu[data-menu-id='" + menuPid + "']");
//         $parent.addClass("open");
//         $parent.children(".submenu").show();
//     }

});

// 메뉴 이동
function fn_goMenu(url, id, pid) {
	$("#menuForm #menuUrl").val(url);
	$("#menuForm #menuId").val(id);
	$("#menuForm #menuPid").val(pid);

	$("#menuForm").attr("action", url);
	$("#menuForm").submit();
}
</script>