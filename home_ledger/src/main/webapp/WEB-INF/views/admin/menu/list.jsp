<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>메뉴관리</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.2.1/themes/default/style.min.css" />
<script src="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.2.1/jstree.min.js"></script>

<script type="text/javascript">
	$(document).ready(function(){
		// jstree 데이터 넣어주기
		var treeData = ${jsonString};
		$('#menuTree').jstree({
		    core: {
		      data: treeData,
		      check_callback:true
		    },
			themes: {
	            dots: false,
	            icons: true
	        }
		});

		// 노드 선택
		$("#menuTree").on("select_node.jstree", function(e, data){
			var node = data.node;
			var siteCode = "${holder.siteCode}";

			$("#mngMenuForm #menuId").val(node.id == '공백' ? '' : node.id);
			$("#mngMenuForm #menuPid").val(node.original.parent == '#' ? '0' : node.original.parent);
			$("#mngMenuForm #menuNm").val(node.text == '새 메뉴' ? '' : node.text);
			$("#mngMenuForm #parentName").val(node.parent == '#' ? 'ROOT' : $("#menuTree").jstree(true).get_node(node.parent).text);
			$("#mngMenuForm #menuIcon").val(node.original.menuIcon);
			$("#mngMenuForm #menuUrl").val(node.original.menuUrl);
			$("#mngMenuForm #menuDepth").val(node.original.menuDepth);
			$("#mngMenuForm #siteCode").val(node.original.siteCode);
			$("#mngMenuForm #menuOrdr").val(node.original.menuOrder);
			$("#mngMenuForm #menuType").prop("selected", true).val(node.original.menuType).trigger("change");
			$("#mngMenuForm #useYn").prop("selected", true).val(node.original.useYn);
			$("#mngMenuForm #siteCode").val(siteCode);
			$("#mngMenuForm #bbsSeq").val(node.original.bbsSeq);
		});

		// 하위 메뉴 추가
	    $('#btnAdd').click(function(){
	        var tree = $('#menuTree').jstree(true);
	        var sel = tree.get_selected()[0];
	        var parentNode = tree.get_node(sel);

	        // 부모 메뉴를 선택해는지
	        if(!sel) {
	        	alert('부모 메뉴를 선택하세요');
	        	return
	        }

	        var hasNewMenu = false;

	        tree.get_json('#', { flat: true }).some(function(node){
	            if(node.text === '새 메뉴'){
	                hasNewMenu = true;
	                return true; // break
	            }
	        });

	        // 추가중인 메뉴가 있는지
	        if(hasNewMenu){
	            alert('이미 추가 중인 메뉴가 있습니다.');
	            return;
	        }

        	var depth = Number(parentNode.original.menuDepth) + 1;
        	tree.create_node(sel, { id:'공백', text:'새 메뉴', parent:sel, menuDepth:depth}, 'last');
	        tree.open_node(sel);
	    });

	 	// 메뉴 저장
		$("#btnSave").on("click", function(){

			if($("#mngMenuForm #menuNm").val() == "") {
				alert("메뉴명은 필수입니다.");
				$("#mngMenuForm #menuNm").focus();
				return false;
			}

			if($("#mngMenuForm #menuUrl").val() == "") {
				alert("메뉴Url은 필수입니다.");
				$("#mngMenuForm #menuUrl").focus();
				return false;
			}

			if($("#mngMenuForm #menuUrl").val() == "") {
				alert("메뉴Url은 필수입니다.");
				$("#mngMenuForm #menuUrl").focus();
				return false;
			}

			if($("#mngMenuForm #menuOrdr").val() == "") {
				alert("메뉴 순서는 필수입니다.");
				$("#mngMenuForm #menuOrdr").focus();
				return false;
			}

			if($("#mngMenuForm #useYn").prop("selected", true).val() == "") {
				alert("사용유무는 필수입니다.");
				$("#mngMenuForm #useYn").focus();
				return false;
			}

			var formData = new FormData($("#mngMenuForm")[0]);

			if(confirm("저장 하시겠습니까?")) {
				$.ajax({
				  url: "/admin/menu/saveMenu.do",
				  type: "POST",
				  processData: false,
				  contentType: false,
				  data: formData,
				  success: function(data) {
					  if(data.message == "ok") {
						  alert("정상적으로 처리되었습니다.");
						  // interceptor를 위해 빈값 처리
						  $("#mngMenuForm #menuId").val("");
						  $("#mngMenuForm #menuPid").val("");
						  $("#mngMenuForm").submit();
					  }

					  if(data.message == "login") {
						  alert("로그인 정보가 없습니다.");
						  location.href = "/login.do";
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

		// 메뉴 삭제
		$("#btnDelete").on("click", function(){
			var tree = $("#menuTree").jstree(true);
		    var sel = tree.get_selected()[0];

		    if(!sel) {
		        alert("메뉴를 선택해주세요.");
		        return false;
		    }

		    var node = tree.get_node(sel);

		    // 임시로 추가된 노드 삭제
		    if(node.id == '공백' || node.original.nodeSel == '0') {
		        if(confirm("추가된 메뉴를 삭제 하시겠습니까?")) {
		            tree.delete_node(node);
		            $("#mngMenuForm")[0].reset();
		        }
		        return;
		    }

			var formData = new FormData($("#mngMenuForm")[0]);

			if(confirm("삭제 하시겠습니까?")) {
				$.ajax({
				  url: "/admin/menu/deleteMenu.do",
				  type: "POST",
				  processData: false,
				  contentType: false,
				  data: formData,
				  success: function(data) {
					  if(data.message == "ok") {
						  alert("정상적으로 처리되었습니다.");
						  $("#mngMenuForm").submit();
					  }

					  if(data.message == "login") {
						  alert("로그인 정보가 없습니다.");
						  location.href = "/login.do";
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

		// 권한 선택
		$("#siteSlc").change(function(){
			var siteCode = $("#siteSlc").prop("selected", true).val();
			$("#siteCode").val(siteCode);
			$("#mngMenuForm").submit();
		});

		// 메뉴 타입 변경 시
		$("#mngMenuForm #menuType").change(function(){
			var menuType = $("#menuType").val();

			if(menuType == "brd") {
				$(this).css("width", "49%");
				$("#bbsSeq").show();
			} else {
				$(this).css("width", "100%");
				$("#bbsSeq").hide();
			}

		});
	});
</script>
</head>
<body class="menu-page">
		<div class="menu-container">
		    <h2>메뉴목록관리</h2>
		    <div class="menu-layout">
		        <!-- LEFT : jstree -->
		        <div class="menu-tree-box">
				   <div class="menu-tree-header">
				        <div class="menu-role-select">
				            <label for="siteSlc">사이트코드 선택:</label>
				            <select id="siteSlc" name="siteSlc">
				                <option value="admin" ${holder.siteCode eq 'admin' ? 'selected' : ''}>관리자메뉴</option>
				                <option value="user" ${holder.siteCode eq 'user' ? 'selected' : ''}>사용자메뉴</option>
				            </select>
				        </div>
				    </div>

				     <!-- 기존 구분선 유지 -->
    				<div class="box-separator"></div>

				    <div id="menuTree" class="jstree-wrapper"></div>
				</div>
		        <!-- RIGHT : 메뉴 관리 -->
		        <div class="menu-info-box">
		            <h3>메뉴 정보</h3>
					<form id="mngMenuForm" name="mngMenuForm" method="post" class="form-cls" action="/admin/menu/list.do">
						<input type="hidden" id="siteCode" name="siteCode" value="${holder.siteCode }" />
						<div class="menu-form-grid">
				            <div class="form-row">
				                <label>메뉴 ID</label>
				                <input type="text" id="menuId" name="menuId" readonly>
				            </div>

				            <div class="form-row">
				                <label>메뉴 PID</label>
				                <input type="text" id="menuPid" name="menuPid" readonly>
				            </div>

				            <div class="form-row">
				                <label>상위 메뉴</label>
				                <input type="text" id="parentName" name="parentName" readonly>
				            </div>

				            <div class="form-row">
				                <label>메뉴 깊이</label>
				                <input type="text" id="menuDepth" name="menuDepth" readonly>
				            </div>

				            <div class="form-row">
				                <label>메뉴명</label>
				                <input type="text" id="menuNm" name="menuNm">
				            </div>
				            <div class="form-row">
				                <label>URL</label>
				                <input type="text" id="menuUrl" name="menuUrl">
				            </div>

				            <div class="form-row">
				                <label>메뉴아이콘</label>
				                <input type="text" id="menuIcon" name="menuIcon">
				            </div>

				            <div class="form-row-divide">
				                <label>메뉴종류</label>
				                <select id="menuType" name="menuType">
				                	<option value="">선택</option>
				                	<option value="pgm">프로그램</option>
				                	<option value="brd">게시판</option>
				                </select>
				                <select id="bbsSeq" name="bbsSeq" style="display:none; width:49%">
				                	<option value="">선택</option>
				                	<c:forEach var="bbs" items="${bbsList }">
				                		<option value="${bbs.bbsSeq }">${bbs.bbsNm }</option>
				                	</c:forEach>
				                </select>
				            </div>

				            <div class="form-row">
				                <label>정렬 순서</label>
				                <input type="text" id="menuOrdr" name="menuOrdr">
				            </div>

				            <div class="form-row">
				                <label>사용유무</label>
				                <select id="useYn" name="useYn">
				                	<option value="">선택</option>
				                	<option value="Y">사용</option>
				                	<option value="N">미사용</option>
				                </select>
				            </div>
			            </div>
		            </form>
		            <div class="form-actions">
		                <button type="button" class="btn primary" id="btnAdd">하위 메뉴 추가</button>
		                <button type="button" class="btn secondary" id="btnSave">저장</button>
		                <button type="button" class="btn danger" id="btnDelete">삭제</button>
		            </div>
		        </div>

		    </div>
		</div>
</body>
</html>