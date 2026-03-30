<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>가계부 목록 관리</title>
<script type="text/javascript">
	$(document).ready(function(){
		// 테이블 드레그
		$("#usedSortable").sortable({
	        handle: ".drag-handle",
	        cursor: "move",
	        opacity: 0.8,
	        placeholder: "ui-state-highlight"
	    });

	    $("#usedSortable").disableSelection();

	    // 사용 가능 목록 전체 체크
	    $("#useAllCheck").change(function(){
	    	if($(this).is(":checked")) {
	    		$("input[name=useCheck]:not(:disabled)").prop("checked", true);
			} else {
				$("input[name=useCheck]:not(:disabled)").prop("checked", false);
			}
	    });

	 	// 사용중인 목록 전체 체크
	    $("#usedAllCheck").change(function(){
	    	if($(this).is(":checked")) {
	    		$("input[name=usedCheck]:not(:disabled)").prop("checked", true);
			} else {
				$("input[name=usedCheck]:not(:disabled)").prop("checked", false);
			}
	    });
	});

	// 목록 추가
	function fn_add() {
		var obj = {};
		var result = [];

		if($("input[name=useCheck]:checked").length == 0) {
			alert("체크된 데이터가 없습니다.")
			return false;
		}

		$("input[name=useCheck]:checked").each(function(){
			obj = {
				 seq : $(this).data("seq")
				,bsOrder : $(this).data("seq")
			}

			result.push(obj);
		});

		if(confirm("추가 하시겠습니까?")) {
			$.ajax({
			  url: "/user/settings/addBookViewConfig.do",
			  type: "POST",
			  data: {
				jsonData : JSON.stringify(result)
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
	}

	// 목록 정렬
	function fn_order() {
		var obj = {};
		var result = [];

		$("input[name=usedCheck]").each(function(i, v){
			console.log(i);
			obj = {
				  seq : $(this).data("seq")
				 ,bsOrder : i + 1
			}

			result.push(obj);
		});

		if(confirm("정렬 저장 하시겠습니까?")) {
			$.ajax({
			  url: "/user/settings/orderBookViewConfig.do",
			  type: "POST",
			  data: {
				jsonData : JSON.stringify(result)
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
	}

	// 목록 삭제
	function fn_delete() {
		var obj = {};
		var result = [];

		if($("input[name=usedCheck]:checked").length == 0) {
			alert("체크된 데이터가 없습니다.")
			return false;
		}

		$("input[name=usedCheck]:checked").each(function(){
			obj = {
				 seq : $(this).data("seq")
			}

			result.push(obj);
		});

		if(confirm("삭제 하시겠습니까?")) {
			$.ajax({
			  url: "/user/settings/deleteBookViewConfig.do",
			  type: "POST",
			  data: {
				jsonData : JSON.stringify(result)
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
	}

	// 목록
	function fn_back() {
		$("#bookViewConfigForm").submit();
	}
</script>
</head>
<body class="common-page">
	<div class="menu-container">
	    <h2>가계부 목록 관리</h2>
	    <div class="common_section">
	        <div class="account-move-layout">
			    <div class="account-box">
			        <h3>사용 가능 목록</h3>
			        <form id="bookViewConfigForm" name="bookViewConfigForm" method="post" action="/user/settings/bookViewConfig.do">
	    			</form>
			        <table class="table-hover account-sort-table">
			        	<colgroup>
				        	<col style="width:10%">
				        	<col style="width:90%">
				        </colgroup>
			            <thead>
			                <tr>
			                	<th><input type="checkbox" id="useAllCheck" name="useAllCheck"/></th>
			                	<th>목록 컬럼명</th>
			                </tr>
			            </thead>
			            <tbody>
			            	<c:choose>
								<c:when test="${!empty useList }">
									<c:forEach var="item" items="${useList }" varStatus="useStatus">
										<tr>
											<td><input type="checkbox" id="useCheck_${useStatus.index }" name="useCheck" data-seq="${item.seq }" readonly/></td>
											<td><c:out value="${item.bcNm }"/></td>
										</tr>
									</c:forEach>
								</c:when>
								<c:otherwise>
									<tr>
										<td colspan="2" class="empty-row">데이터가 존재하지 않습니다.</td>
									</tr>
								</c:otherwise>
			            	</c:choose>
			            </tbody>
			        </table>
			    </div>
			    <div class="account-move-buttons">
			        <button class="btn blue" onclick="fn_add()">추가 →</button>
			        <button class="btn green" onclick="fn_order()">정렬 저장</button>
			        <button class="btn red" onclick="fn_delete()">← 삭제</button>
			    </div>

			    <div class="account-box">
			        <h3>사용중인 목록</h3>
			        <table class="table-hover account-sort-table">
			        	<colgroup>
				        	<col style="width:10%">
				        	<col style="width:90%">
				        </colgroup>
			            <thead>
			                <tr>
			                	<th><input type="checkbox" id="usedAllCheck" name="usedAllCheck"/></th>
			                	<th>목록 컬럼명</th>
			                </tr>
			            </thead>
			            <tbody id="usedSortable">
			            	<c:choose>
								<c:when test="${!empty usedList }">
									<c:forEach var="item" items="${usedList }" varStatus="usedStatus">
										<tr>
											<td><input type="checkbox" id="usedCheck_${usedStatus.index }" name="usedCheck" data-seq="${item.seq }" ${item.requiredYn eq 'Y' ? 'disabled' : '' }/></td>
											<td>
												 <span class="drag-text"><c:out value="${item.bcNm }"/></span>
    											 <span class="drag-handle">☰</span>
											</td>
										</tr>
									</c:forEach>
								</c:when>
								<c:otherwise>
									<tr>
										<td colspan="2" class="empty-row">데이터가 존재하지 않습니다.</td>
									</tr>
								</c:otherwise>
			            	</c:choose>
			            </tbody>
			        </table>
			    </div>
			</div>
	    </div>
	</div>
</body>
</html>