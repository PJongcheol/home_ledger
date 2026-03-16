<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시판관리</title>
<script type="text/javascript">
	$(document).ready(function(){
		// 게시판유형 변경 시
		$("#bbsType").change(function(){
			var bbsType = $("#bbsType").val();

			if(bbsType == "DEFAULT") {
				$("#fieldTb").show();
			} else {
				$("#fieldTb").hide();
			}

		});

		// 저장
		$("#btnSave").on("click", function(){
			var bbs = {};
			var bbsList = [];
			var bbsType = $("#bbsType").val();

			// 게시판명
			if($("#bbsNm").val().trim() == "") {
				alert("게시판명은 필수입니다.");
				$("#bbsNm").focus();
				return false;
			}

			// 사이트 구분
			if($("#siteCode").val() == "") {
				alert("사이트구분은 필수입니다.");
				$("#siteCode").focus();
				return false;
			}

			// 페이지목록
			if($("#pageListCo").val() == "") {
				alert("페이지목록은 필수입니다.");
				$("#pageListCo").focus();
				return false;
			}

			// 뷰어 사용여부
// 			if($("#viewerYn").val() == "") {
// 				alert("뷰어 사용여부는 필수입니다.");
// 				$("#viewerYn").focus();
// 				return false;
// 			}

			// 에디터 사용여부
			if($("#editrYn").val() == "") {
				alert("에디터 사용여부는 필수입니다.");
				$("#editrYn").focus();
				return false;
			}

			// 게시판유형
			if($("#bbsType").val() == "") {
				alert("게시판유형은 필수입니다.");
				$("#bbsType").focus();
				return false;
			}

			// 사용여부
			if($("#useYn").val() == "") {
				alert("사용여부는 필수입니다.");
				$("#useYn").focus();
				return false;
			}

			// 게시글상위고정
// 			if($("#fixingYn").val() == "") {
// 				alert("게시글 상위고정은 필수입니다.");
// 				$("#fixingYn").focus();
// 				return false;
// 			}

			// 댓글사용
// 			if($("#replyYn").val() == "") {
// 				alert("댓글사용은 필수입니다.");
// 				$("#replyYn").focus();
// 				return false;
// 			}

			// 첨부파일
			if($("#fileAtchYn").val() == "") {
				alert("첨부파일사용은 필수입니다.");
				$("#fileAtchYn").focus();
				return false;
			} else if($("#fileAtchYn").val() == "Y" && $("#fileAtchCo").val() == "") {
				alert("첨부파일사용 시 갯수는 필수입니다.");
				$("#fileAtchCo").focus();
				return false;
			}

			// 파일제한용량
			if($("#fileLmttSize").val().trim() == "") {
				alert("파일용량제한은 필수입니다.");
				$("#fileLmttSize").focus();
				return false;
			}

			// 파일확장자필터
			if($("#fileExtFlter").val().trim() == "") {
				alert("파일확장자필터는 필수입니다.");
				$("#fileExtFlter").focus();
				return false;
			}

			// 금지어
			if($("#prhibtWrd").val().trim() == "") {
				alert("금지어는 필수입니다.");
				$("#prhibtWrd").focus();
				return false;
			}

			// 필드 데이터 Json 작업 (게시판 유형이 기본인 경우에만)
			if(bbsType == "DEFAULT") {
				$("tr[id^=tr]").each(function(i, v){
					var idx = i + 1;

					bbs = {
						 seq		: $("#seq_"+idx).val()
						,columnNm 	: $("#columnNm_"+idx).val()
						,columnSj 	: $("#columnSj_"+idx).val()
						,fieldSize 	: $("#fieldSize_"+idx).val()
						,listOrdr 	: $("#listOrdr_"+idx).val()
						,useYn 		: ($("#useYn_"+idx).is(":checked") ? 'Y' : 'N')
						,essntlYn 	: ($("#essntlYn_"+idx).is(":checked") ? 'Y' : 'N')
						,detailYn 	: ($("#detailYn_"+idx).is(":checked") ? 'Y' : 'N')
						,listYn 	: ($("#listYn_"+idx).is(":checked") ? 'Y' : 'N')
						,searchYn 	: ($("#searchYn_"+idx).is(":checked") ? 'Y' : 'N')
					}

					bbsList.push(bbs);
				});
			}

			var formData = new FormData($("#adminBbsDetailForm")[0]);
			formData.append("jsonData", JSON.stringify(bbsList));

			if(confirm("저장하시겠습니까?")) {
				$.ajax({
				  url: "/admin/bbs/saveBbs.do",
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
			var bbsSeq = $("#bbsSeq").val();

			if(confirm("삭제하시겠습니까?")) {
				$.ajax({
				  url: "/admin/bbs/deleteBbs.do",
				  type: "POST",
				  data: {
						bbsSeq : bbsSeq
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
		$("#adminBbsForm").submit();
	}

</script>
</head>
<body class="common-page">
	<div class="menu-container">
	    <h2>게시판관리</h2>
	    <div class="common_section">
	    	<form id="adminBbsForm" name="adminBbsForm" method="post" action="/admin/bbs/list.do">
	    	</form>
            <form name="adminBbsDetailForm" id="adminBbsDetailForm">
	            <input type="hidden" id="bbsSeq" name="bbsSeq" value="${detail.bbsSeq }" />
	            <input type="hidden" id="mode" name="mode" value="${empty detail ? 'I' : 'U' }" />
	            <table class="form-table">
	            	<colgroup>
	            		<col style="width:15%">
	            		<col style="width:35%">
	            		<col style="width:15%">
	            		<col style="width:35%">
	            	</colgroup>
	                <tbody class="no-hover">
	                    <tr>
							<th>게시판명</th>
	                        <td colspan="3"><input type="text" id="bbsNm" name="bbsNm" value="${detail.bbsNm }" maxlength="150"></td>
	                    </tr>
	                    <tr>
	                    	<th>사이트구분</th>
	                        <td>
								<select id="siteCode" name="siteCode">
									<option value="">선택</option>
									<option value="admin" ${detail.siteCode eq 'admin' ? 'selected' : '' }>admin</option>
									<option value="user" ${detail.siteCode eq 'user' ? 'selected' : '' }>user</option>
								</select>
							</td>
	                        <th>페이지목록</th>
	                        <td>
								<select id="pageListCo" name="pageListCo">
									<option value="">선택</option>
									<option value="8" ${detail.pageListCo eq '8' ? 'selected' : '' }>8</option>
									<option value="10" ${detail.pageListCo eq '10' ? 'selected' : '' }>10</option>
									<option value="12" ${detail.pageListCo eq '12' ? 'selected' : '' }>12</option>
									<option value="20" ${detail.pageListCo eq '20' ? 'selected' : '' }>20</option>
									<option value="50" ${detail.pageListCo eq '50' ? 'selected' : '' }>50</option>
									<option value="100" ${detail.pageListCo eq '100' ? 'selected' : '' }>100</option>
								</select>
	                        </td>
	                    </tr>
	                    <tr>
<!-- 	                        <th>뷰어 사용여부</th> -->
<!-- 	                        <td> -->
<!-- 								<select id="viewerYn" name="viewerYn"> -->
<!-- 									<option value="">선택</option> -->
<%-- 									<option value="Y" ${detail.viewerYn eq 'Y' ? 'selected' : '' }>사용</option> --%>
<%-- 									<option value="N" ${detail.viewerYn eq 'N' ? 'selected' : '' }>미사용</option> --%>
<!-- 								</select> -->
<!-- 	                        </td> -->
	                        <th>에디터 사용여부</th>
	                        <td>
								<select id="editrYn" name="editrYn">
									<option value="">선택</option>
									<option value="Y" ${detail.editrYn eq 'Y' ? 'selected' : '' }>사용</option>
									<option value="N" ${detail.editrYn eq 'N' ? 'selected' : '' }>미사용</option>
								</select>
	                        </td>
	                        <th>게시판유형</th>
	                        <td>
								<select id="bbsType" name="bbsType">
									<option value="">선택</option>
									<option value="DEFAULT" ${detail.bbsType eq 'DEFAULT' ? 'selected' : '' }>기본</option>
									<option value="MOVIE" ${detail.bbsType eq 'MOVIE' ? 'selected' : '' }>동영상</option>
								</select>
	                        </td>
	                    </tr>
	                    <tr>
	                        <th>사용여부</th>
	                        <td>
								<select id="useYn" name="useYn">
									<option value="">선택</option>
									<option value="Y" ${detail.useYn eq 'Y' ? 'selected' : '' }>사용</option>
									<option value="N" ${detail.useYn eq 'N' ? 'selected' : '' }>미사용</option>
								</select>
	                        </td>
	                        <th>첨부파일사용</th>
	                        <td>
								<select id="fileAtchYn" name="fileAtchYn">
									<option value="">선택</option>
									<option value="Y" ${detail.fileAtchYn eq 'Y' ? 'selected' : '' }>사용</option>
									<option value="N" ${detail.fileAtchYn eq 'N' ? 'selected' : '' }>미사용</option>
								</select>
								<select id="fileAtchCo" name="fileAtchCo">
									<option value="0">선택</option>
									<c:forEach var="filei" begin="1" end="10">
										<option value="${filei }" ${detail.fileAtchCo eq filei ? 'selected' : '' }>${filei }</option>
									</c:forEach>
								</select>
	                        </td>
	                    </tr>
<!-- 	                    <tr> -->
<!-- 	                        <th>게시글상위고정</th> -->
<!-- 	                        <td> -->
<!-- 								<select id="fixingYn" name="fixingYn"> -->
<!-- 									<option value="">선택</option> -->
<%-- 									<option value="Y" ${detail.fixingYn eq 'Y' ? 'selected' : '' }>사용</option> --%>
<%-- 									<option value="N" ${detail.fixingYn eq 'N' ? 'selected' : '' }>미사용</option> --%>
<!-- 								</select> -->
<!-- 	                        </td> -->
<!-- 	                        <th>댓글사용</th> -->
<!-- 	                        <td> -->
<!-- 								<select id="replyYn" name="replyYn"> -->
<!-- 									<option value="">선택</option> -->
<%-- 									<option value="Y" ${detail.replyYn eq 'Y' ? 'selected' : '' }>사용</option> --%>
<%-- 									<option value="N" ${detail.replyYn eq 'N' ? 'selected' : '' }>미사용</option> --%>
<!-- 								</select> -->
<!-- 	                        </td> -->
<!-- 	                    </tr> -->
	                    <tr>

	                        <th>파일제한용량</th>
							<td><input type="text" id="fileLmttSize" name="fileLmttSize" value="${detail.fileLmttSize }" maxlength="20" placeholder="MB"></td>
							<th>파일확장자필터</th>
	                        <td><input type="text" id="fileExtFlter" name="fileExtFlter" value="${detail.fileExtFlter }" maxlength="255" placeholder="ex) jpg,jpeg,png"></td>
	                    </tr>
	                    <tr>
	                        <th>금지어</th>
	                        <td colspan="3"><input type="text" id="prhibtWrd" name="prhibtWrd" value="${detail.prhibtWrd }"  maxlength="1500" placeholder="ex) 바보,멍청이,말미잘"></td>
	                    </tr>
	                    <tr>
	                        <th>활성화여부</th>
	                        <td colspan="3">
	                        	<input type="checkbox" id="insertYn" name="insertYn" value="Y" class="normal_check" ${detail.insertYn eq 'Y' ? 'checked' : '' }>등록
	                        	<input type="checkbox" id="updateYn" name="updateYn" value="Y" class="normal_check" ${detail.updateYn eq 'Y' ? 'checked' : '' }>수정
	                        	<input type="checkbox" id="deleteYn" name="deleteYn" value="Y" class="normal_check" ${detail.deleteYn eq 'Y' ? 'checked' : '' }>삭제
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

            <table id="fieldTb" class="bbs-table" ${detail.bbsType eq 'DEFAULT' ? '' : 'style=display:none;' }>
            	<colgroup>
            		<col style="width:15%">
            		<col style="width:35%">
            		<col style="width:15%">
            		<col style="width:35%">
            	</colgroup>
                <tbody class="no-hover">
                    <c:forEach var="field" items="${fieldList }" varStatus="fieldStatus">
	                    <tr id="tr_${fieldStatus.count }">
	                        <th>${field.columnSj }</th>
							<td colspan="3">
								<input type="hidden" id="seq_${fieldStatus.count }" name="seq" value="${field.seq }" />
								<input type="hidden" id="columnNm_${fieldStatus.count }" name="columnNm" value="${field.columnNm }" />
								<input type="text" id="columnSj_${fieldStatus.count }" name="columnSj" value="${field.columnSj }" maxlength="50" readonly>
<%-- 								<input type="text" id="fieldSize_${fieldStatus.count }" name="fieldSize" value="${field.fieldSize }" maxlength="200" placeholder="px"> --%>
<%-- 								<input type="text" id="listOrdr_${fieldStatus.count }" name="listOrdr" value="${field.listOrdr }" class="only_number" placeholder="목록순서"> --%>
								<input type="checkbox" id="useYn_${fieldStatus.count }" name="useYn" value="Y" class="normal_check" ${field.essentialYn eq 'Y' ? 'checked onclick="return false"' : '' } ${field.useYn eq 'Y' ? 'checked' : '' }>사용
								<input type="checkbox" id="essntlYn_${fieldStatus.count }" name="essntlYn" value="Y" class="normal_check" ${field.essentialYn eq 'Y' ? 'checked onclick="return false"' : '' } ${field.essntlYn eq 'Y' ? 'checked' : '' }>필수
								<input type="checkbox" id="detailYn_${fieldStatus.count }" name="detailYn" value="Y" class="normal_check" ${field.essentialYn eq 'Y' ? 'checked onclick="return false"' : '' } ${field.detailYn eq 'Y' ? 'checked' : '' }>보기
<%-- 								<input type="checkbox" id="listYn_${fieldStatus.count }" name="listYn" value="Y" class="normal_check" ${field.listYn eq 'Y' ? 'checked' : '' }>목록 --%>
<%-- 								<input type="checkbox" id="searchYn_${fieldStatus.count }" name="searchYn" value="Y" class="normal_check" ${field.searchYn eq 'Y' ? 'checked' : '' }>검색 --%>
							</td>
	                    </tr>
                    </c:forEach>
                </tbody>
            </table>

            <div class="btn-form">
                <button id="btnSave" class="btn blue">저장</button>
                <button id="btnDel" class="btn red">삭제</button>
                <button class="btn gray" onclick="history.back()">목록</button>
            </div>
        </div>
	</div>
</body>
</html>