<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title><c:out value="${holder.menuNm }"/></title>
<script type="text/javascript">
	$(document).ready(function(){
		// 저장
		$("#btnSave").on("click", function(){
			// 제목
			if("${field.NTT_SJ.useYn}" == "Y" && "${field.NTT_SJ.detailYn}" == "Y" && "${field.NTT_SJ.essntlYn}" == "Y") {
				if($("#nttSj").val().trim() == "") {
					alert("제목은 필수입니다.");
					$("#nttSj").focus();
					return false;
				}
			}

			// 사이트코드
			if($("#siteCode").val() == "") {
				alert("사이트코드는 필수입니다.");
				$("#siteCode").focus();
				return false;
			}

			// 비밀글 여부
			if("${field.OTHBC_YN.useYn}" == "Y" && "${field.OTHBC_YN.detailYn}" == "Y" && "${field.OTHBC_YN.essntlYn}" == "Y") {
				if($("#secretYn").val() == "") {
					alert("비밀글 여부는 필수입니다.");
					$("#secretYn").focus();
					return false;
				} else if($("#secretYn").val() == "Y" && $("#nttPassword").val().trim() == "") {
					alert("게시글 비밀번호는 필수입니다.");
					$("#nttPassword").focus();
					return false;
				}
			}

			// 에디터 사용 유무가 Y라면 nttCn에 넣어주고
			if("${boardMst.editrYn}" == "Y") {
				$("#nttCn").val(editor.getData());
			}

			// 내용
			if("${field.NTT_CN.useYn}" == "Y" && "${field.NTT_CN.detailYn}" == "Y" && "${field.NTT_CN.essntlYn}" == "Y") {
				if($("#nttCn").val() == "") {
					alert("내용은 필수입니다.");
					$("#nttCn").focus();
					return false;
				}

				var prhibtWrd = "${boardMst.prhibtWrd}".split();

				if(!checkPrhibt(prhibtWrd)) {
					alert("내용에 금지어가 포함되어 있습니다.\n'${boardMst.prhibtWrd}'");
					return false;
				}
			}

			// 파일 첨부된게 몇개인지 카운트
			var fileCnt = 0;
			$("input[name=files]").each(function(){
				if(this.files.length > 0) {
					fileCnt ++;
				}
			});

			// 파일첨부
			if("${field.FILE.useYn}" == "Y" && "${field.FILE.detailYn}" == "Y" && "${field.FILE.essntlYn}" == "Y") {
				if(fileCnt == 0) {
					alert("첨부파일은 필수입니다.");
					return false;
				}
			}

			// 게시 시작/종료일
			if("${field.NTT_DE.useYn}" == "Y" && "${field.NTT_DE.detailYn}" == "Y" && "${field.NTT_DE.essntlYn}" == "Y") {
				if($("#bgnde").val() == "") {
					alert("게시 시작일은 필수입니다.");
					$("#bgnde").focus();
					return false;
				} else if($("#endde").val() == "") {
					alert("게시 종료일은 필수입니다.");
					$("#endde").focus();
					return false;
				}
			}

			// 사용여부
			if($("#useYn").val() == "") {
				alert("사용여부는 필수입니다.");
				$("#useYn").focus();
				return false;
			}

			var formData = new FormData($("#adminBbsBoardDetailForm")[0]);

			if(confirm("저장하시겠습니까?")) {
				$.ajax({
				  url: "/admin/bbs/board/saveBoard.do",
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
			var bbsSeq = $("#adminBbsBoardDetailForm #bbsSeq").val();
			var nttSeq = $("#adminBbsBoardDetailForm #nttSeq").val();

			if(confirm("삭제하시겠습니까?")) {
				$.ajax({
				  url: "/admin/bbs/board/deleteBoard.do",
				  type: "POST",
				  data: {
					   bbsSeq : bbsSeq
					  ,nttSeq : nttSeq
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
		$("#adminBbsBoardForm").submit();
	}

	// 파일 업로드 체크
	function fileUploadcheck(obj) {
		var fileDot = obj.value.split(".");
		var fileExtFlter = "${boardMst.fileExtFlter}".toLowerCase();

		var file = obj.files[0];
		var fileLmttSize = Number("${boardMst.fileLmttSize}");
		var maxSize = fileLmttSize * 1024 * 1024;

		// 확장자 체크
		if(fileExtFlter.indexOf(fileDot[fileDot.length -1]) < 0) {
			alert("확장자는 " + fileExtFlter + "만 가능합니다.");
			$(obj).val("");
			return false;
		}

		// 용량 체크
		if(file.size > maxSize) {
			alert("파일 용량은 최대 ${boardMst.fileLmttSize}MB 입니다.");
			$(obj).val("");
			return false;
		}
	}

	// 금지어 체크
	function checkPrhibt(prhibtWrd) {
		var nttCdn = $("#nttCn").val();

		for(i=0; i<prhibtWrd.length; i++) {
			if(nttCdn.indexOf(prhibtWrd[i]) > -1) {
				return false;
			}
		}
		return true;
	}

</script>
</head>
<body class="common-page">
	<div class="menu-container">
	    <h2><c:out value="${holder.menuNm }"/></h2>
	    <div class="common_section">
	    	<form id="adminBbsBoardForm" name="adminBbsBoardForm" method="post" action="/admin/bbs/board/list.do">
	    		<input type="hidden" id="mId" name="mId" value="${holder.mId }"/>
	    		<input type="hidden" id="mPid" name="mPid" value="${holder.mPid }"/>
	    	</form>
            <form name="adminBbsBoardDetailForm" id="adminBbsBoardDetailForm" enctype="multipart/form-data">
	            <input type="hidden" id="bbsSeq" name="bbsSeq" value="${holder.bbsSeq }" />
	            <input type="hidden" id="nttSeq" name="nttSeq" value="${detail.nttSeq }" />
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
	                	<c:if test="${field.NTT_SJ.useYn eq 'Y' && field.NTT_SJ.detailYn eq 'Y' }">
		                    <tr>
		                        <th>게시글 제목</th>
		                        <td colspan="3"><input type="text" id="nttSj" name="nttSj" value="${detail.nttSj }" maxlength="255"></td>
		                    </tr>
	                    </c:if>
	                    <c:if test="${field.OTHBC_YN.useYn eq 'Y' && field.OTHBC_YN.detailYn eq 'Y' }">
		                    <tr>
		                        <th>비밀글 여부</th>
		                        <td>
		                        	<select id="secretYn" name="secretYn">
		                        		<option value="">선택</option>
		                        		<option value="Y" ${detail.secretYn eq 'Y' ? 'selected' : '' }>예</option>
		                        		<option value="N" ${detail.secretYn eq 'N' ? 'selected' : '' }>아니오</option>
		                        	</select>
		                        </td>
		                        <th>게시글 비밀번호</th>
		                        <td><input type="password" id="nttPassword" name="nttPassword" value="${detail.nttPassword }" maxlength="255"></td>
		                    </tr>
	                    </c:if>
	                    <c:if test="${field.NTT_CN.useYn eq 'Y' && field.NTT_CN.detailYn eq 'Y' }">
		                    <tr>
		                    	<th>내용</th>
		                        <td colspan="3">
		                        	<c:choose>
		                        		<c:when test="${boardMst.editrYn eq 'Y'}">
		                        			<textarea id="nttCn" name="nttCn" class="commonCn">${detail.nttCn}</textarea>
		                        		</c:when>
		                        		<c:otherwise>
		                        			<input type="text" id="nttCn" name="nttCn" class="commonCn" value="${detail.nttCn}"/>
		                        		</c:otherwise>
		                        	</c:choose>
		                        </td>
		                    </tr>
	                    </c:if>
	                    <c:if test="${boardMst.fileAtchYn eq 'Y' && field.FILE.useYn eq 'Y' && field.FILE.detailYn eq 'Y'}">
		                    <tr>
		                    	<th>첨부파일</th>
		                        <td colspan="3">
		                        	<div id="fileDiv">
			                        	<c:choose>
			                        		<c:when test="${empty fileList }">
			                        			<c:forEach var="file" begin="1" end="${boardMst.fileAtchCo }">
			                        				<input type="file" name="files" class="bbs_file" onchange="fileUploadcheck(this)"></br>
			                        			</c:forEach>
			                        		</c:when>
			                        		<c:otherwise>
			                        			<c:forEach var="file" items="${fileList }">
			                        				<div class="file-item">
				                        				<a href="javascript:void(0)" onclick="fn_fileDownload('${file.atchfileno}', '${file.fileord }')"><span>${file.orgfilenm }</span></a>
														<button type="button" onclick="fn_fileDel('${file.atchfileno}', '${file.fileord }')">삭제</button>
													</div>
			                        			</c:forEach>
			                        			<script>
			                        				var html = "";

			                        				for(i=$(".file-item").length; i < "${boardMst.fileAtchCo}"; i++) {
														html += "<input type=\"file\" name=\"files\" class=\"bbs_file\"></br>";
			                        				}

			                        				$("#fileDiv").append(html);

			                        			</script>
			                        		</c:otherwise>
			                        	</c:choose>
									</div>
		                        </td>
		                    </tr>
	                    </c:if>
	                    <c:if test="${field.NTT_DE.useYn eq 'Y' && field.NTT_DE.detailYn eq 'Y' }">
		                    <tr>
		                    	<th>게시일</th>
		                        <td>
		                        	<input type="text" class="half-width datepicker" id="bgnde" name="bgnde" value="${detail.bgnde }" placeholder="게시시작일" readonly>
		                        	<input type="text" class="half-width datepicker" id="endde" name="endde" value="${detail.endde }" placeholder="게시종료일" readonly>
		                        </td>
		                    </tr>
	                    </c:if>
	                    <tr>
	                    	<th>사이트 코드</th>
	                        <td>
	                        	<select id="siteCode" name="siteCode">
	                        		<option value="">선택</option>
	                        		<option value="admin" ${detail.siteCode eq 'admin' ? 'selected' : '' }>Admin</option>
	                        		<option value="user" ${detail.siteCode eq 'user' ? 'selected' : '' }>User</option>
	                        	</select>
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
	                    <c:if test="${field.ID.useYn eq 'Y' && field.ID.detailYn eq 'Y'}">
		                    <tr>
		                        <th>등록자ID</th>
		                        <td><c:out value="${detail.regId }"/></td>
		                        <th>수정자ID</th>
		                        <td><c:out value="${detail.updId }"/></td>
		                    </tr>
	                    </c:if>
	                    <c:if test="${field.DT.useYn eq 'Y' && field.DT.detailYn eq 'Y'}">
		                    <tr>
		                        <th>등록일시</th>
		                        <td><c:out value="${detail.regDt }"/></td>
		                        <th>수정일시</th>
		                        <td><c:out value="${detail.updDt }"/></td>
		                    </tr>
	                    </c:if>
	                </tbody>
	           </table>
	        </form>

            <div class="btn-form">
            	<c:choose>
            		<c:when test="${boardMst.insertYn eq 'Y' && holder.mode eq 'N' }">
            			<button id="btnSave" class="btn blue">저장</button>
            		</c:when>
            		<c:when test="${boardMst.updateYn eq 'Y' && holder.mode eq 'D' }">
            			<button id="btnSave" class="btn blue">저장</button>
            		</c:when>
            	</c:choose>
                <c:if test="${boardMst.deleteYn eq 'Y' && holder.mode eq 'D' }">
                	<button id="btnDel" class="btn red">삭제</button>
                </c:if>
                <button class="btn gray" onclick="fn_back()">목록</button>
            </div>
        </div>
	</div>
</body>
</html>