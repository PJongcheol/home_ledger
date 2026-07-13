<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>가계부</title>
<script type="text/javascript">
	$(document).ready(function(){
		// 과소비 체크 시
		$("input[name=overSpendingYn]").change(function(){
			var aiSeq = $(this).data("ai");
			var hliSeq = $(this).data("hli");
			var overSpendingYn = "N";

			if($(this).is(":checked")) {
				overSpendingYn = "Y";
			}

			$.ajax({
				  url: "/user/book/updateOverSpendingYn.do",
				  type: "POST",
				  data: {
					   aiSeq : $(this).data("ai")
					  ,hliSeq : $(this).data("hli")
					  ,overSpendingYn : overSpendingYn
				  },
				  success: function(data) {
				  },
				  error: function(xhr, status, error){
					  console.log(xhr + ":" + status + ":" + error);
					  alert("처리 중 오류가 발생했습니다.");
					  return false;
				  }
			});
		});
	});

	// 조회
	function fn_search() {
		$("#bookForm #pageIndex").val("1");
		$("#bookForm #pageSize").val("10");

		$("#bookForm").submit();
	}

	// 초기화
	function fn_reset() {
		$("#bookForm #beginDe").val("${holder.resetBeginDe}");
		$("#bookForm #endDe").val("${holder.resetEndDe}");
		$("#bookForm #inoutType").val("");
		$("#bookForm #aiSe").val("");
		$("#bookForm #aiSeq").val("");
	}

	// 신규등록
	function fn_new() {
		$("#bookDetailForm #aiSeq").val("");
		$("#bookDetailForm").submit();
	}

	// 상세정보
	function fn_detail(aiSeq, hliSeq) {
		$("#bookDetailForm #aiSeq").val(aiSeq);
		$("#bookDetailForm #hliSeq").val(hliSeq);
		$("#bookDetailForm").submit();
	}

	// 페이징
	function fn_paging(idx) {
		$("#bookForm #pageIndex").val(idx);
		$("#bookForm").submit();
	}

	//layer 열기
	function openChartLayer(){
	    $("#layerDim").addClass("open");
	    $("#chartLayer").addClass("open");
	}

	//layer 닫기
	function closeChartLayer() {
		 $("#layerDim").removeClass("open");
		 $("#chartLayer").removeClass("open");

		 $("#layerAccount").val("");
		 $("#file").val("");
	}

	// 첨부파일 유효성
	function file_validation(input) {
		var fileName = input.files[0].name.toLowerCase();

		if(!fileName.endsWith("xls") && !fileName.endsWith("xlsx")) {
			alert("엑셀파일만 업로드가 가능합니다.");
			input.value = "";
			return false;
		}
	}

	// 엑셀 업로드
	function fn_upload() {
		if($("#layerAccount").val() == "") {
			alert("통장/카드를 선택해 주세요.");
			return false;
		}

		if($("#file").val() == "") {
			alert("파일을 선택해 주세요.");
			return false;
		}

		if(confirm("데이터가 많은 경우 업로드에 시간이 걸릴 수 있습니다.\n계속 진행하시겠습니까?")) {
			var formData = new FormData($("#userBookLayerForm")[0]);

			$.ajax({
				  url: "/user/book/uploadExcelBook.do",
				  type: "POST",
				  processData: false,
				  contentType: false,
				  data: formData,
				  success: function(data) {
					  fn_search();
				  },
				  beforeSend:function(){
					 //(이미지 보여주기 처리)
					 $('.wrap-loading').removeClass('display-none');
				  },
				  complete:function(){
				  	 //(이미지 감추기 처리)
				     $('.wrap-loading').addClass('display-none');
				  },
				  error: function(xhr, status, error){
					  console.log("status :", status);
					    console.log("error :", error);
					    console.log("http status :", xhr.status);
					    console.log("response :", xhr.responseText);
					  $('.wrap-loading').addClass('display-none');
					  alert("처리 중 오류가 발생했습니다.");
					  return false;
				  }
			});
		}

	}
</script>
</head>
<body class="common-page">
	<div class="menu-container">
	    <h2>가계부</h2>
	    <div class="common_section">
	    	<div class="info-box">
			    <ul>
			        <li>통장/카드의 수입/치출 내역을 등록하는 가계부 페이지입니다.</li>
			        <li>목록 화면에서 지출에 대한 과소비 체크 시 자동으로 과소비로 수정되며,</li>
			        <li>가지고 계신 이전 가계부 데이터를 가계부 엑셀 업로드를 통하여 한번에 데이터를 입력할 수 있습니다</li>
			    </ul>
			</div>
	    	<form id="bookDetailForm" name="bookDetailForm" method="post" action="/user/book/bookForm.do">
	    		<input type="hidden" id="aiSeq" name="aiSeq" />
	    		<input type="hidden" id="hliSeq" name="hliSeq" />
	    	</form>
	        <form id="bookForm" name="bookForm" method="post" action="/user/book/bookList.do">
				<input type="hidden" id="pageIndex" name="pageIndex" value="${holder.pageIndex }"/>
				<input type="hidden" id="pageSize" name="pageSize" value="${holder.pageSize }"/>
			    <div class="search-box">
					<div class="search-row">
			            <input type="text" id="beginDe" name="beginDe" value="${holder.beginDe}" class="search-input-small datepicker" placeholder="시작일" readonly> ~
			            <input type="text" id="endDe" name="endDe" value="${holder.endDe}" class="search-input-small datepicker" placeholder="종료일" readonly>
			        </div>

					<div class="search-row">
			            <select id="inoutType" name="inoutType">
			                <option value="">수입/지출 전체</option>
			                <option value="I" ${holder.inoutType eq 'I' ? 'selected' : ''}>수입</option>
			                <option value="E"  ${holder.inoutType eq 'E' ? 'selected' : ''}>지출</option>
			            </select>
			        </div>

			        <div class="search-row">
			            <select id="osYn" name="osYn">
			                <option value="">과소비 전체</option>
			                <option value="Y" ${holder.osYn eq 'Y' ? 'selected' : ''}>Y</option>
			                <option value="N"  ${holder.osYn eq 'N' ? 'selected' : ''}>N</option>
			            </select>
			        </div>

					<div class="search-row">
			            <select id="aiSe" name="aiSe">
			                <option value="">타입 전체</option>
			                <option value="B" ${holder.aiSe eq 'B' ? 'selected' : ''}>통장</option>
			                <option value="C"  ${holder.aiSe eq 'C' ? 'selected' : ''}>카드</option>
			            </select>
			        </div>

			        <div class="search-row">
			            <select id="aiSeq" name="aiSeq">
			                <option value="">통장/카드명 전체</option>
			                <c:forEach var="account" items="${accountList }">
			                	<option value="${account.aiSeq }" ${holder.aiSeq eq account.aiSeq ? 'selected' : '' }>${account.aiNm }</option>
			                </c:forEach>
			            </select>
			        </div>

			        <div class="search-row">
			            <button type="button" onclick="fn_search()" class="btn-search">조회</button>
			            <button type="button" onclick="fn_reset()" class="btn-reset">초기화</button>
			        </div>
			        <div class="search-row-right">
			            <button type="button" onclick="openChartLayer()" class="btn-color-green">가계부 업로드</button>
			            <button type="button" onclick="fn_new()" class="btn-search">신규등록</button>
			        </div>

			    </div>
			</form>
			<div class="summary-box">
			    <div class="summary-item income">
			        총 수입 <span>₩ ${!empty total.incomeTotalAmount ? total.incomeTotalAmount : '0'}</span>
			    </div>

			    <div class="summary-item expense">
			        총 지출 <span>₩ ${!empty total.expendituretotalamount ? total.expendituretotalamount : '0'}</span>
			    </div>

			    <div class="summary-item count">
			        총 건수 <span>${!empty total.cnt ? total.cnt : '0'} 건</span>
			    </div>
			</div>
	        <table class="table-hover">
	        	<colgroup>
	        		<c:forEach var="colgroup" items="${bookView }">
	        			<col style="width:auto;">
	        		</c:forEach>
		        </colgroup>
	            <thead>
	                <tr>
	                	<c:forEach var="thead" items="${bookView }">
	                		<th>${thead.bcNm }</th>
	                	</c:forEach>
	                </tr>
	            </thead>
	            <tbody>
	            	<c:choose>
						<c:when test="${!empty list }">
							<c:forEach var="item" items="${list }">
								<tr>
									<c:forEach var="bodyItem" items="${bookView }" varStatus="status">
										<td>
											<c:choose>
												<c:when test="${bodyItem.colimnName eq 'event' }">
													<button onclick="fn_detail('${item.aiSeq}', '${item.hliSeq }')" class="tableBtn">보기</button>
												</c:when>
												<c:when test="${bodyItem.colimnName eq 'inoutType' }">
													<span class="${item[bodyItem.colimnName] eq '수입' ? 'text-color-blue' : 'text-color-red'}"><c:out value="${item[bodyItem.colimnName] }"/></span>
												</c:when>
												<c:when test="${bodyItem.colimnName eq 'amount' }">
													<span class="${item.inoutType eq '수입' ? 'text-color-blue' : 'text-color-red'}"><c:out value="${item[bodyItem.colimnName] }"/></span>
												</c:when>
												<c:when test="${bodyItem.colimnName eq 'overSpendingYn'}">
													<c:if test="${item.inoutType eq '지출' }">
														<input type="checkbox" id="overSpendingYn_${status.index }" name="overSpendingYn" value="Y" ${item.overSpendingYn eq 'Y' ? 'checked' : '' } data-ai="${item.aiSeq }" data-hli="${item.hliSeq }" />
													</c:if>
												</c:when>
												<c:otherwise>
													<c:out value="${item[bodyItem.colimnName] }"/>
												</c:otherwise>
											</c:choose>
										</td>
									</c:forEach>
								</tr>
							</c:forEach>
						</c:when>
						<c:otherwise>
							<tr>
								<td colspan="${bookView.size()}">데이터가 존재하지 않습니다.</td>
							</tr>
						</c:otherwise>
	            	</c:choose>
	            </tbody>
	        </table>
	        <jsp:include page="/WEB-INF/views/common/paging.jsp">
			    <jsp:param name="pageIndexName" value="userPageIndex" />
			</jsp:include>
	    </div>
	</div>

	 <!-- dim -->
	<div id="layerDim" class="layer-dim"></div>

    <!-- 레이어 -->
	<div id="chartLayer" class="chart-layer">
		 <button type="button" class="layer-close" onclick="closeChartLayer()">✕</button>
	    <h3 id="title">가계부 업로드</h3>
	    <div class="info-box">
		    <ul>
		        <li>가계부 업로드는 이전 데이터를 등록하기 위한 기능입니다.</li>
		        <li>등록된 통장/카드를 선택 후 제공되는 양식에 맞게 업로드 해주세요.</li>
		    </ul>
		</div>
		<form id="userBookLayerForm" name="userBookLayerForm">
			<table class="form-table">
            	<colgroup>
            		<col style="width:15%">
            		<col style="width:35%">
            		<col style="width:15%">
            		<col style="width:35%">
            	</colgroup>
                <tbody class="no-hover">
                    <tr>
                        <th>양식</th>
                        <td colspan="3"><a href="/file/bookExcelTemplate.xlsx" class="btn-color-green" download="가계부 양식.xlsx">다운로드</a></td>
                    </tr>
                    <tr>
                        <th>통장/카드<span class="required-label"></span></th>
                        <td colspan="3">
                        	<select id="layerAccount" name="layerAccount">
								<option value="">선택</option>
								<c:forEach var="layerAct" items="${accountList }">
				                	<option value="${layerAct.aiSeq }">${layerAct.aiNm }</option>
				                </c:forEach>
                        	</select>
                        </td>
                    </tr>
                    <tr>
                        <th>파일<span class="required-label"></span></th>
                        <td colspan="3"><input type="file" id="file" name="file" onchange="file_validation(this)" /></td>
                    </tr>
                </tbody>
            </table>
            <div class="layerBtn">
            	<button type="button" class="btn-color-blue" onclick="fn_upload()">업로드</button>
            </div>
		</form>
		<div class="wrap-loading display-none">
			<div><img src="/images/loading1.gif" /></div>
		</div>
	</div>

</body>
</html>