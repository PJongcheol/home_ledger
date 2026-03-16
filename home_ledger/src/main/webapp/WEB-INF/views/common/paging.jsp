<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp" %>
<c:set var="paging" value="${holder}" />
<c:set var="pageBlockSize" value="5" />
<c:set var="pageIndexName" value="${empty pageIndexName ? 'pageIndex' : pageIndexName }" />
<c:set var="totalPage" value="${paging.totalPage}" />
<c:set var="pageIndex" value="${paging.pageIndex}" />

<!-- 소수점 이슈로 인한 절사 -->
<c:set var="dicimalNum" value="${(pageIndex - 1) / pageBlockSize}"/>
<c:set var="intNum" value="${fn:substringBefore(dicimalNum, '.')}" />
<c:set var="startPage" value="${intNum * pageBlockSize + 1}" />

<c:set var="endPage" value="${startPage + pageBlockSize - 1}" />

<c:if test="${endPage > totalPage}">
    <c:set var="endPage" value="${totalPage}" />
</c:if>

<div class="paging">
	<c:if test="${paging.pageIndex > 1 && startPage > 1}">
		<a href="javascript:void(0)" onclick="fn_paging('1')">«</a>
		<a href="javascript:void(0)" onclick="fn_paging('${startPage - 1}')">‹</a>
	</c:if>

	<c:forEach var="i" begin="${startPage}" end="${endPage}">
		<c:choose>
			<c:when test="${i == paging.pageIndex }">
				<strong>${i}</strong>
			</c:when>
			<c:otherwise>
				<a href="javascript:void(0)" onclick="fn_paging('${i}')">${i }</a>
			</c:otherwise>
		</c:choose>
	</c:forEach>

	<c:if test="${paging.pageIndex < totalPage && (totalPage - startPage) > 5}">
		<a href="javascript:void(0)" onclick="fn_paging('${startPage + 5}')">›</a>
		<a href="javascript:void(0)" onclick="fn_paging('${totalPage}')">»</a>
	</c:if>
</div>
