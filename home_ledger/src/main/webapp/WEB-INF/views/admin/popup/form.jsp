<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>팝업관리</title>
<script type="text/javascript">
	$(document).ready(function(){
		// 팝업 타입 변경 시
		$("#popupTy").change(function(){
			var popupTy = $(this).val();

			if(popupTy == "L") {
				$("tr[name=popupTyL]").show();
				$("tr[name=popupTyC]").hide();
			} else if(popupTy == "C") {
				$("tr[name=popupTyL]").hide();
				$("tr[name=popupTyC]").show();
			} else {
				$("tr[name=popupTyL]").hide();
				$("tr[name=popupTyC]").hide();
			}

		});

		// 저장
		$("#btnSave").on("click", function(){
			// 제목
			if($("#popupSj").val().trim() == "") {
				alert("제목은 필수입니다.");
				$("#popupSj").focus();
				return false;
			}

			// 팝업 화면
			if($("#siteCode").val() == "") {
				alert("팝업 화면은 필수입니다.");
				$("#siteCode").focus();
				return false;
			}

			// 팝업 타입
			if($("#popupTy").val() == "") {
				alert("팝업 타입은 필수입니다.");
				$("#popupTy").focus();
				return false;
			} else if($("#popupTy").val() == "L") {
				if($("#file").val() == "") {
					alert("이미지 첨부파일은 필수입니다.");
					return false;
				}
			}

			// 팝업 구분
			if($("#popupSe").val() == "") {
				alert("팝업 구분은 필수입니다.");
				return false;
			}

			// 팝업가로위치
			if($("#popupWidthLc").val() == "") {
				alert("팝업가로위치는 필수입니다.");
				$("#popupWidthLc").focus();
				return false;
			}

			// 팝업세로위치
			if($("#popupHeightLc").val() == "") {
				alert("팝업세로위치는 필수입니다.");
				$("#popupHeightLc").focus();
				return false;
			}

			// 팝업Width
			if($("#popupWidth").val() == "") {
				alert("팝업Width는 필수입니다.");
				$("#popupWidth").focus();
				return false;
			}

			// 팝업height
			if($("#popupHeight").val() == "") {
				alert("팝업height는 필수입니다.");
				$("#popupHeight").focus();
				return false;
			}

			$("#popupCn").val(editor.getData());

			var formData = new FormData($("#adminPopupDetailForm")[0]);

			if(confirm("저장하시겠습니까?")) {
				$.ajax({
				  url: "/admin/popup/savePopup.do",
				  type: "POST",
				  processData: false,
				  contentType: false,
				  data: formData,
				  success: function(data) {
					  if(data.message == "ok") {
						  alert("정상적으로 처리되었습니다.");
						  fn_back();
					  }
				  },
				  error: function(xhr, status, error){
					  console.log(xhr + ":" + status + ":" + error);
					  alert("처리 중 오류가 발생했습니다.");
					  return false;
				  }
				});
			}
		});

		// 삭제
		$("#btnDel").on("click", function(){
			var popupSeq = $("#popupSeq").val();

			if(confirm("삭제하시겠습니까?")) {
				$.ajax({
				  url: "/admin/popup/deletePopup.do",
				  type: "POST",
				  data: {
					  popupSeq : popupSeq
				  },
				  success: function(data) {
					  if(data.message == "ok") {
						  alert("정상적으로 처리되었습니다.");
						  fn_back();
					  }
				  },
				  error: function(xhr, status, error){
					  console.log(xhr + ":" + status + ":" + error);
					  alert("처리 중 오류가 발생했습니다.");
					  return false;
				  }
				});
			}
		});
	});

	// 목록
	function fn_back() {
		$("#adminPopupForm").submit();
	}

</script>
</head>
<body class="common-page">
	<div class="menu-container">
	    <h2>팝업관리</h2>
	    <div class="common_section">
	    	<form id="adminPopupForm" name="adminPopupForm" method="post" action="/admin/popup/list.do">
	    	</form>
            <form name="adminPopupDetailForm" id="adminPopupDetailForm" enctype="multipart/form-data">
	            <input type="hidden" id="popupSeq" name="popupSeq" value="${detail.popupSeq }" />
	            <input type="hidden" id="mode" name="mode" value="${empty detail ? 'I' : 'U' }" />
	            <input type="hidden" id="atchfileno" name="atchfileno" value="${detail.atchfileno }" />
	            <table class="form-table">
	            	<colgroup>
	            		<col style="width:15%">
	            		<col style="width:35%">
	            		<col style="width:15%">
	            		<col style="width:35%">
	            	</colgroup>
	                <tbody class="no-hover">
	                    <tr>
	                        <th>팝업 제목</th>
	                        <td><input type="text" id="popupSj" name="popupSj" value="${detail.popupSj }" maxlength="255"></td>
	                        <th>팝업 화면(사이트 구분)</th>
	                        <td>
	                        	<select id="siteCode" name="siteCode">
	                        		<option value="">선택</option>
	                        		<option value="admin" ${detail.siteCode eq 'admin' ? 'selected' : '' }>Admin</option>
	                        		<option value="user" ${detail.siteCode eq 'user' ? 'selected' : '' }>User</option>
	                        	</select>
	                        </td>
	                    </tr>
	                    <tr>
	                    	<th>팝업 타입</th>
	                        <td>
	                        	<select id="popupTy" name="popupTy">
	                        		<option value="">선택</option>
	                        		<option value="L" ${detail.popupTy eq 'L' ? 'selected' : '' }>이미지링크형</option>
	                        		<option value="C" ${detail.popupTy eq 'C' ? 'selected' : '' }>에디터기반입력형</option>
	                        	</select>
	                        </td>
	                    	<th>팝업 구분</th>
	                        <td>
	                        	<select id="popupSe" name="popupSe">
	                        		<option value="">선택</option>
	                        		<option value="P" ${detail.popupSe eq 'P' ? 'selected' : '' }>윈도우 팝업</option>
	                        		<option value="D" ${detail.popupSe eq 'D' ? 'selected' : '' }>DIV레이어 팝업</option>
	                        	</select>
	                        </td>
	                    </tr>
	                    <tr name="popupTyL" ${detail.popupTy eq 'L' ? '' : 'style=display:none' }>
	                    	<th>팝업 URL</th>
	                        <td colspan="3"><input type="text" id="popupUrl" name="popupUrl" value="${detail.popupUrl }" maxlength="255"></td>
	                    </tr>
	                    <tr name="popupTyL" ${detail.popupTy eq 'L' ? '' : 'style=display:none' }>
	                    	<th>이미지</th>
	                        <td colspan="3">
	                        	<div id="fileDiv">
		                        	<c:choose>
		                        		<c:when test="${empty fileList }">
		                        			<input type="file" id="file" name="files">
		                        		</c:when>
		                        		<c:otherwise>
		                        			<c:forEach var="file" items="${fileList }">
		                        				<div class="file-item">
			                        				<a href="javascript:void(0)" onclick="fn_fileDownload('${file.atchfileno}', '${file.fileord }')"><span>${file.orgfilenm }</span></a>
													<button type="button" onclick="fn_fileDel('${file.atchfileno}', '${file.fileord }')">삭제</button>
												</div>
		                        			</c:forEach>
		                        		</c:otherwise>
		                        	</c:choose>
								</div>
	                        </td>
	                    </tr>
	                    <tr name="popupTyC" ${detail.popupTy eq 'C' ? '' : 'style=display:none' }>
	                    	<th>내용</th>
	                        <td colspan="3"><textarea id="popupCn" name="popupCn" class="commonCn">${detail.popupCn}</textarea></td>
	                    </tr>
	                    <tr>
	                        <th>팝업 가로위치</th>
	                        <td><input type="text" id="popupWidthLc" name="popupWidthLc" value="${detail.popupWidthLc }" class="only_number" maxlength="20" placeholder="px"></td>
	                        <th>팝업 세로위치</th>
	                        <td><input type="text" id="popupHeightLc" name="popupHeightLc" value="${detail.popupHeightLc }" class="only_number" maxlength="20" placeholder="px"></td>
	                    </tr>
	                    <tr>
	                        <th>팝업 Width</th>
	                        <td><input type="text" id="popupWidth" name="popupWidth" value="${detail.popupWidth }" class="only_number" maxlength="20" placeholder="px"></td>
	                        <th>팝업 Height</th>
	                        <td><input type="text" id="popupHeight" name="popupHeight" value="${detail.popupHeight }" class="only_number" maxlength="20" placeholder="px"></td>
	                    </tr>
	                    <tr>
	                        <th>게시일</th>
	                        <td>
	                        	<input type="text" class="half-width datepicker" id="bgndeDe" name="bgndeDe" value="${detail.bgndeDe }" placeholder="게시시작일" readonly>
	                        	<input type="text" class="half-width datepicker" id="endDe" name="endDe" value="${detail.endDe }" placeholder="게시종료일" readonly>
	                        </td>
	                        <th>사용여부</th>
	                        <td>
	                        	<select id="useYn" name="useYn">
	                        		<option value="">선택</option>
	                        		<option value="Y" ${detail.useYn eq 'Y' ? 'selected' : '' }>사용</option>
	                        		<option value="N" ${detail.useYn eq 'N' ? 'selected' : '' }>미사용</option>
	                        	</select>
	                        </td>
	                    </tr>
	                    <tr>
	                        <th>등록자ID</th>
	                        <td><c:out value="${detail.regId }"/></td>
	                        <th>등록일시</th>
	                        <td><c:out value="${detail.regDt }"/></td>
	                    </tr>
	                    <tr>
	                        <th>수정자ID</th>
	                        <td><c:out value="${detail.updId }"/></td>
	                        <th>수정일시</th>
	                        <td><c:out value="${detail.updDt }"/></td>
	                    </tr>
	                </tbody>
	           </table>
	        </form>

            <div class="btn-form">
                <button id="btnSave" class="btn blue">저장</button>
                <button id="btnDel" class="btn red">삭제</button>
                <button class="btn gray" onclick="fn_back()">목록</button>
            </div>
        </div>
	</div>
</body>
</html>