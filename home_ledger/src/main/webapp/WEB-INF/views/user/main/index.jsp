<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>대시보드</title>
</head>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels"></script>
<script type="text/javascript">
	$(document).ready(function(){
		fn_drawChart();

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

// 차트
function fn_drawChart(){

	var categoryTotalList = JSON.parse('${categoryList}');
	var categoryNameData = categoryTotalList.map(r => r.categoryName);
	var categoryTotalData = categoryTotalList.map(r => r.totalAmount);
	var totalAmount = categoryTotalData.reduce((sum, value) => sum + value, 0);

    // 파이
    if(totalAmount == 0) {
		$("#noDataText").show();
    } else {
    	chart1 = new Chart(document.getElementById('categoryChart'), {
   	        type: 'pie',
   	        data: {
   	            labels:categoryNameData,
   	            datasets:[{
   					data: categoryTotalData
   	            }]
   	        },
   	        options: {
   	            plugins: {
   	                datalabels: {
   	                    color: '#fff',  // 글자색
   	                    font: {
   	                        weight: 'bold',
   	                        size: 14
   	                    },
   	                    formatter: function(value, ctx) {
   	                        var data = ctx.chart.data.datasets[0].data;
   	                        var total = data.reduce((a, b) => a + b, 0);
   	                        var percent = (value / total * 100).toFixed(1);
   	                        return percent + '%';
   	                    }
   	                }
   	            }
   	        },
   	        plugins: [ChartDataLabels]
   	    });
    }

	var spendingTotalList = JSON.parse('${spendingList}');
	var spendingExpendData = spendingTotalList.map(r => r.totalAmount);
	var month = "${month }" + "월";

	// 월별 과소비 체크 금액 bar
    chart2 = new Chart(document.getElementById('spendingTotalChart'), {
        type: 'bar',
        data: {
            labels: [month],
            datasets: [
                {
                    label: '지출',
                    data: spendingExpendData,
                    maxBarThickness: 50,
                    backgroundColor: 'rgba(255, 99, 132, 0.5)',
                    borderWidth: 1
                }
            ]
        },
        options: {
            plugins: {
                legend: {
                    display: false
                }
            }
        }
    });
}

// 이동
function fn_detail(mode) {

	var uri = "";
	var mId = "";
	var mPid = "";


	var oldForm = document.getElementById("detailForm");
	if(oldForm) {
		oldForm.remove();
	}

	if(mode != "acountAmount") {
		uri = "/user/statistics/form.do";
		mId = "23";
		mPid = "9";
	} else {
		uri = "/user/book/bookList.do";
		mId = "21";
		mPid = "9";
	}

	var form = document.createElement("form");
	form.id = "detailForm";
	form.method = "POST";
	form.action = uri;

	var menuId = document.createElement("input");
	menuId.type = "hidden";
	menuId.name = "menuId";
	menuId.value = mId;
    form.appendChild(menuId);

    var menuPid = document.createElement("input");
    menuPid.type = "hidden";
    menuPid.name = "menuPid";
    menuPid.value = mPid;
    form.appendChild(menuPid);

	document.body.appendChild(form);
    form.submit(form);
}

</script>
<body>
	<div class="main">
        <!-- 카드 -->
        <div class="cards">
            <div class="card blue">
                <h3>${month }월 수입</h3>
                <p><fmt:formatNumber value="${empty topInfo ? 0 : topInfo.nowInAmount}" pattern="#,###" /></p>
            </div>
            <div class="card red">
                <h3>${month }월 지출</h3>
                <p><fmt:formatNumber value="${empty topInfo ? 0 : topInfo.nowExAmount}" pattern="#,###" /></p>
            </div>
            <div class="card green">
                <h3>${month }월 잔액</h3>
                <p><fmt:formatNumber value="${empty topInfo ? 0 : topInfo.nowBalance}" pattern="#,###" /></p>
            </div>
            <div class="card purple">
                <h3>전월 대비</h3>
                <p><c:out value="${empty topInfo || topInfo.rate eq '-0.00' || topInfo.rate eq '0.00' ? 0 : topInfo.rate}"/>%</p>
            </div>
        </div>

        <!-- 그래프 -->
        <div class="dashboard-grid">
            <div class="dashboard-box">
            	<div class="dashboard-box-header">
					<h3>${month }월 카테고리별 지출</h3>
					<a href="javascript:void(0)" onclick="fn_detail('category')" class="dashboard-more">더보기 ></a>
				</div>
                <div class="chart-box">
                    <canvas id="categoryChart"></canvas>
                </div>
                <div id="noDataText" class="chartText">가계부에 등록된 데이터가 없습니다</div>
            </div>

            <div class="dashboard-box">
            	<div class="dashboard-box-header">
            		<h3>${month }월 과소비 체크 금액</h3>
					<a href="javascript:void(0)" onclick="fn_detail('spending')" class="dashboard-more">더보기 ></a>
				</div>
                <div class="chartBar-box">
                    <canvas id="spendingTotalChart"></canvas>
                </div>
            </div>

        </div>

        <!-- 테이블 -->
        <div class="section">
	        <div class="dashboard-box-header">
	            <h3>${month }월 통장/카드 수입/지출 금액</h3>
	            <a href="javascript:void(0)" onclick="fn_detail('acountAmount')" class="dashboard-more">더보기 ></a>
            </div>
            <table>
                <thead>
                    <tr>
                        <th>통장/카드 구분</th>
                        <th>통장/카드명</th>
                        <th>수입</th>
                        <th>지출</th>
                    </tr>
                </thead>
                <tbody>
                	<c:choose>
                		<c:when test="${!empty accountAmountList }">
							<c:forEach var="item" items="${accountAmountList}">
								<tr>
			                        <td><c:out value="${item.aiSe }"/></td>
			                        <td><c:out value="${item.aiNm }"/></td>
			                        <td><span class="text-color-blue"><fmt:formatNumber value="${item.inAmount }" pattern="#,###"/></span></td>
			                        <td><span class="text-color-red"><fmt:formatNumber value="${item.exAmount }" pattern="#,###"/></span></td>
			                    </tr>
							</c:forEach>
                		</c:when>
                		<c:otherwise>
                			<tr>
		                        <td colspan="4">조회된 데이터가 없습니다.</td>
		                    </tr>
                		</c:otherwise>
                	</c:choose>
                </tbody>
            </table>
        </div>

    </div>
</body>
</html>