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
			var mId = node.id;
			var mPid = node.original.parent == "#" ? '0' : node.original.parent;

			$("#mngAuthMenuForm #menuId").val(mId);
			$("#mngAuthMenuForm #menuPid").val(mPid);
			$("#mngAuthMenuForm #siteCode").val(siteCode);

			// 권한 조회
			fn_authAjax(mId, mPid, siteCode);
		});

		// 권한 선택
		$("#siteSlc").change(function(){
			var siteCode = $("#siteSlc").prop("selected", true).val();
			$("#siteCode").val(siteCode);
			$("#mngAuthMenuForm").submit();
		});

		// 권한 등록
		$("#btnSave").on("click", function(){
			var siteCode = $("#siteCode").val();
			var menuId = $("#mngAuthMenuForm #menuId").val();
			var menuPid = $("#mngAuthMenuForm #menuPid").val();

			var auth = {};
			var authList = [];

			// 체크된 데이터만
			$("input[id^=raCheck_]:checked").each(function(){
				auth = {
					 authGrpCd : $(this).val()
					,siteCode : siteCode
					,menuId : menuId
					,menuPid : menuPid
				}

				authList.push(auth);
			});

			if(confirm("등록하시겠습니까?")) {
				$.ajax({
					  url: "/admin/menu/auth/insertMenuAuth.do",
					  type: "POST",
					  data: {
						jsonData : JSON.stringify(authList)
					  },
					  success: function(data) {
						if(data.message == "ok") {
							alert("정상적으로 처리되었습니다.");
							fn_authAjax(menuId, menuPid, siteCode)
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

		// 권한삭제
		$("#btnDelete").on("click", function(){
			var siteCode = $("#siteCode").val();
			var menuId = $("#mngAuthMenuForm #menuId").val();
			var menuPid = $("#mngAuthMenuForm #menuPid").val();

			var auth = {};
			var authList = [];

			// 체크된 데이터만
			$("input[id^=uraCheck_]:checked").each(function(){
				auth = {
					 authGrpCd : $(this).val()
					,siteCode : siteCode
					,menuId : menuId
					,menuPid : menuPid
				}

				authList.push(auth);
			});

			if(confirm("삭제하시겠습니까?")) {
				$.ajax({
					  url: "/admin/menu/auth/deleteMenuAuth.do",
					  type: "POST",
					  data: {
						jsonData : JSON.stringify(authList)
					  },
					  success: function(data) {
						if(data.message == "ok") {
							alert("정상적으로 처리되었습니다.");
							fn_authAjax(menuId, menuPid, siteCode)
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

	// 권한 목록 비동기 처리
	function fn_authAjax(mId, mPid, siteCode) {
		$.ajax({
			  url: "/admin/menu/auth/menuAuthList.do",
			  type: "POST",
			  data: {
				 menuId : mId
				,menuPid : mPid
				,siteCode : siteCode
			  },
			  success: function(data) {

				// 기존 tbody 정리
				$("#tb1").empty();
				$("#tb2").empty();

				var html1 = "";
				var html2 = "";

				// 동적 html
				// 미등록 권한
				for(var i=0; i<data[0].length; i++) {
					html1 += "<tr class=\"left-align\"><td><input type=\"checkbox\" id=\"raCheck_"+i+"\" value=\""+data[0][i].authGrpCd+"\" class=\"normal_check\"> "+data[0][i].authNm+" </td></tr>";
				}
				// 등록 권한
				for(var i=0; i<data[1].length; i++) {
					html2 += "<tr class=\"left-align\"><td><input type=\"checkbox\" id=\"uraCheck_"+i+"\" value=\""+data[1][i].authGrpCd+"\" class=\"normal_check\"> "+data[1][i].authNm+" </td></tr>";
				}

				if(html1 == "") {
					html1 += "<tr><td>미등록된 권한이 존재하지 않습니다.</td></tr>";
				}

				if(html2 == "") {
					html2 += "<tr><td>등록된 권한이 존재하지 않습니다.</td></tr>";
				}



				$("#tb1").append(html1);
				$("#tb2").append(html2);

			  },
			  error: function(xhr, status, error){
				  console.log(xhr + ":" + status + ":" + error);
				  alert("처리 중 오류가 발생했습니다.");
				  return false;
			  }
		});
	}
</script>
</head>
<body class="menu-page">
		<div class="menu-container">
		    <h2>메뉴권한관리</h2>
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
		            <h3>메뉴 권한 정보</h3>
					<form id="mngAuthMenuForm" name="mngAuthMenuForm" method="post" class="form-cls" action="/admin/menu/auth/list.do">
						<input type="hidden" id="menuId" name="menuId"/>
						<input type="hidden" id="menuPid" name="menuPid"/>
						<input type="hidden" id="siteCode" name="siteCode" value="${holder.siteCode }" />
						<!-- ===== 권한 관리 영역 ===== -->
						<div class="auth-block">

						    <!-- 미등록 권한 -->
						    <div class="auth-title">미등록 권한</div>
						    <div class="auth-table-wrap">
						        <table>
						            <tbody id="tb1">
						                <tr>
						                    <td>메뉴를 선택해 주세요.</td>
						                </tr>
						            </tbody>
						        </table>
						    </div>
						    <div class="form-actions">
				                <button type="button" class="btn primary" id="btnSave">등록</button>
				            </div>

						    <!-- 등록 권한 -->
						    <div class="auth-title" style="margin-top:20px;">등록 권한</div>
						    <div class="auth-table-wrap">
						        <table>
						            <tbody id="tb2">
						                <tr>
							            	<td>메뉴를 선택해 주세요.</td>
						                </tr>
						            </tbody>
						        </table>
						    </div>

						</div>

		            </form>
		            <div class="form-actions">
		                <button type="button" class="btn danger" id="btnDelete">삭제</button>
		            </div>
		        </div>

		    </div>
		</div>
</body>
</html>