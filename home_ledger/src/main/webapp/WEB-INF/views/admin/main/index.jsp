<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>대시보드</title>
</head>
<script type="text/javascript">
	$(document).ready(function(){
		<c:forEach var="popup" items="${popupList}">
			if("${popup.popupSe}" == "P") { // 윈도우 팝업
				if(getCookie("popup_${popup.popupSeq}") != "done") {
					window.open(
						 '/admin/main/windowPopup.do?popupSeq=${popup.popupSeq}'
						,'_blank'
						,'toolbar=yes,scrollbars=yes,resizable=yes,top=${popup.popupHeightLc},left=${popup.popupWidthLc},width=${popup.popupWidth},height=${popup.popupHeight}'
					);
				};
			} else { // 레이어팝업
				if("${popup.popupTy}" == "L")  { // 이미지 기반
					createLayerPop(
						 '${popup.popupSeq}'
						,'${popup.popupSj}'
						,'${uploadUrl}popup/${popup.svfilenm}'
						,'${popup.popupWidth}'
						,'${popup.popupHeight}'
						,'${popup.popupWidthLc}'
						,'${popup.popupHeightLc}'
						,'image'
					);
				} else { // 에디터 기반
					createLayerPop(
						 '${popup.popupSeq}'
						,'${popup.popupSj}'
						,'${popup.popupCn}'
						,'${popup.popupWidth}'
						,'${popup.popupHeight}'
						,'${popup.popupWidthLc}'
						,'${popup.popupHeightLc}'
						,'editor'
					);
				}
			}
		</c:forEach>
	});
</script>
<body>
	<main class="main">
        <div class="cards">
            <div class="card blue"><h3>오늘 방문</h3><p><fmt:formatNumber value="${top.logCnt }" pattern="#,###" /></p></div>
            <div class="card green"><h3>총 회원</h3><p><fmt:formatNumber value="${top.userCnt }" pattern="#,###" /></p></div>
            <div class="card orange"><h3>총 게시물</h3><p><fmt:formatNumber value="${top.boardCnt }" pattern="#,###" /></p></div>
            <div class="card purple"><h3>총 팝업</h3><p><fmt:formatNumber value="${top.popupCnt }" pattern="#,###" /></p></div>
        </div>

        <div class="dashboard-grid">
		    <!-- 회원 목록 -->
		    <div class="dashboard-box">
		        <div class="dashboard-box-header">
		            <h3>회원 목록</h3>
		            <a href="javascript:void(0)" onclick="fn_goMenu('/admin/user/userList.do', '11', '10')" class="dashboard-more">더보기</a>
		        </div>

		        <div class="dashboard-box-body">
		            <table>
		            	<colgroup>
				        	<col style="width:25%">
				        	<col style="width:25%">
				        	<col style="width:20">
				        	<col style="width:20%">
				        	<col style="width:10%">
				        </colgroup>
		                <thead>
		                    <tr>
		                        <th>회원 ID</th>
		                        <th>이름</th>
		                        <th>권한</th>
		                        <th>가입일</th>
		                        <th>상태</th>
		                    </tr>
		                </thead>
		                <tbody>
		                    <c:choose>
		                        <c:when test="${!empty userList}">
		                            <c:forEach var="user" items="${userList}" begin="0" end="4">
		                                <tr>
		                                    <td>
		                                        <c:out value="${fn:length(user.memberId) > 13 ? fn:substring(user.memberId, 0, 13).concat('...') : user.memberId }"/>
		                                    </td>
		                                    <td><c:out value="${user.memberNm}"/></td>
		                                    <td>
		                                        <c:choose>
		                                            <c:when test="${user.masterCode eq '10'}">시스템관리자</c:when>
		                                            <c:when test="${user.masterCode eq '9'}">관리자</c:when>
		                                            <c:when test="${user.masterCode eq '1'}">일반사용자</c:when>
		                                        </c:choose>
		                                    </td>
		                                    <td><c:out value="${user.joinDe}"/></td>
		                                    <td class="${user.useYn eq 'Y' ? 'text-color-blue' : 'text-color-red'}"><c:out value="${user.useYn eq 'Y' ? '활성' : '비활성'}"/></td>
		                                </tr>
		                            </c:forEach>
		                        </c:when>
		                        <c:otherwise>
		                            <tr>
		                                <td colspan="5">조회된 데이터가 없습니다.</td>
		                            </tr>
		                        </c:otherwise>
		                    </c:choose>
		                </tbody>
		            </table>
		        </div>
		    </div>


		    <!-- 공지사항 -->
		    <div class="dashboard-box">
		        <div class="dashboard-box-header">
		            <h3>공지사항</h3>
		            <a href="javascript:void(0)" onclick="fn_goMenu('/admin/bbs/board/list.do?mId=15&mPid=1', '15', '1')" class="dashboard-more">더보기</a>
		        </div>

		        <div class="dashboard-box-body">
		            <table>
		            	<colgroup>
				        	<col style="width:80%">
				        	<col style="width:20%">
				        </colgroup>
		                <thead>
		                    <tr>
		                        <th>제목</th>
		                        <th>등록일</th>
		                    </tr>
		                </thead>
		                <tbody>
		                    <c:choose>
		                        <c:when test="${!empty noticeList}">
		                            <c:forEach var="notice" items="${noticeList}" begin="0" end="4">
		                                <tr>
		                                    <td class="left-align">
		                                    	<c:out value="${fn:length(notice.nttSj) > 13 ? fn:substring(notice.nttSj, 0, 13).concat('...') : notice.nttSj }"/>
		                                    </td>
		                                    <td><c:out value="${notice.regDt}"/></td>
		                                </tr>
		                            </c:forEach>
		                        </c:when>
		                        <c:otherwise>
		                            <tr>
		                                <td colspan="2">조회된 데이터가 없습니다.</td>
		                            </tr>
		                        </c:otherwise>
		                    </c:choose>
		                </tbody>
		            </table>
		        </div>
		    </div>
		</div>
    </main>
</body>
</html>