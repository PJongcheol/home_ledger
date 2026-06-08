<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>통계</title>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels"></script>

<script type="text/javascript">
var chart1;
var chart2;
var chart3;

$(document).ready(function(){

    fn_drawChart();

	// 검색조건이 변경될 경우
    $("[class*=change]").change(function(){
		var id = this.id;
		var value = this.value;
		var beginDe = "";
		var endDe = "";

		if(id == "categoryBeginDe" || id == "categoryEndDe") {
			beginDe = $("#categoryBeginDe").val();
			endDe = $("#categoryEndDe").val();
		}

		$.ajax({
		  url: "/user/statistics/selectChartAjax.do",
		  type: "POST",
		  data: {
			 id : id
			,value : value
			,categoryBeginDe : beginDe
			,categoryEndDe : endDe
		  },
		  success: function(data) {
			  if(data.message == "ok") {
				  if(id == "categoryBeginDe" || id == "categoryEndDe") {
					categoryChart(data);
				  } else if(id == "spendingYear") {
					spendingChart(data);
				  } else if(id == "inoutYear") {
				  	inoutChart(data);
				  }
			  }
		  },
		  error: function(xhr, status, error){
			  console.log(xhr + ":" + status + ":" + error);
			  alert("처리 중 오류가 발생했습니다.");
			  return false;
		  }
		});
    });
});

// 차트
function fn_drawChart(){

	var categoryTotalList = JSON.parse('${categoryTotalList}');
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

	var spendingTotalList = JSON.parse('${spendingTotalList}');
	var spendingExpendData = spendingTotalList.map(r => r.totalAmount);

	// 월별 과소비 체크 금액 bar
    chart2 = new Chart(document.getElementById('spendingTotalChart'), {
        type: 'bar',
        data: {
            labels: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
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
            },
            onClick: function(event, elements) {
            	if(elements.length > 0) {
					var month = elements[0].index + 1;
					month = String(month).length == 1 ? "0" + month : month;

					var tranDate = $("#spendingYear").val() + "-" + month;

					chart2Layer(tranDate);
            	}
            }
        }
    });

    var inoutTotalList = JSON.parse('${inoutTotalList}');
    var inoutIncomeList = inoutTotalList.filter(r => r.inoutType == '수입');
    var inoutExpendList = inoutTotalList.filter(r => r.inoutType == '지출');
    var inoutIncomeData = inoutIncomeList.map(r => r.totalAmount);
	var inoutExpendData = inoutExpendList.map(r => r.totalAmount);

 // 월별 과소비 체크 금액 bar
    chart3 = new Chart(document.getElementById('inoutTotalChart'), {
        type: 'bar',
        data: {
            labels: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
            datasets: [
                {
                    label: '수입',
                    data: inoutIncomeData,
                    maxBarThickness: 50
                },
                {
                    label: '지출',
                    data: inoutExpendData,
                    maxBarThickness: 50
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


// ajax 카테로리 차트
function categoryChart(data) {
	var categoryTotalList = JSON.parse(data.selectList);
	var categoryNameData = categoryTotalList.map(r => r.categoryName);
	var categoryTotalData = categoryTotalList.map(r => r.totalAmount);
	var totalAmount = categoryTotalData.reduce((sum, value) => sum + value, 0);

	// 기존 차트, 텍스트 삭제
	chart1.destroy();
	$("#noDataText").hide();

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
}

//ajax 과소비 차트
function spendingChart(data) {
	var spendingTotalList = JSON.parse(data.selectList);
	var spendingExpendData = spendingTotalList.map(r => r.totalAmount);

	// 기존 차트 삭제
	chart2.destroy();

	// 월별 과소비 체크 금액 bar
    chart2 = new Chart(document.getElementById('spendingTotalChart'), {
        type: 'bar',
        data: {
            labels: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
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

//ajax 수입/지출 차트
function inoutChart(data) {
	var inoutTotalList = JSON.parse(data.selectList);
    var inoutIncomeList = inoutTotalList.filter(r => r.inoutType == '수입');
    var inoutExpendList = inoutTotalList.filter(r => r.inoutType == '지출');
    var inoutIncomeData = inoutIncomeList.map(r => r.totalAmount);
	var inoutExpendData = inoutExpendList.map(r => r.totalAmount);

	// 기존 차트 삭제
	chart3.destroy();

 	// 월별 과소비 체크 금액 bar
    chart3 = new Chart(document.getElementById('inoutTotalChart'), {
        type: 'bar',
        data: {
            labels: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
            datasets: [
                {
                    label: '수입',
                    data: inoutIncomeData,
                    maxBarThickness: 50
                },
                {
                    label: '지출',
                    data: inoutExpendData,
                    maxBarThickness: 50
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

//패스워드 layer 열기
function openChartLayer(){
    $("#layerDim").addClass("open");
    $("#chartLayer").addClass("open");

    setTimeout(function(){
        $("#nttPassword").focus();
    },200);
}


function chart2Layer(date) {
	var red = "<span class='text-color-red'></span>";
	$.ajax({
	  url: "/user/statistics/selectChart2List.do",
	  type: "POST",
	  data: {
		 date : date
	  },
	  success: function(data) {
		  if(data.message == "ok") {
			  var html = "";

			  for(i=0; i<data.selectList.length; i++) {
				  html += "<tr>";
				  html += "<td>"+data.selectList[i].aiNm+"</td>";
				  html += "<td>"+data.selectList[i].tranDate+"</td>";
				  html += "<td>"+data.selectList[i].aiSe+"</td>";
				  html += "<td>"+data.selectList[i].aiCode+"</td>";
				  html += "<td>"+data.selectList[i].cardType+"</td>";
				  html += "<td><span class=\"text-color-red\">"+data.selectList[i].inoutType+"</span></td>";
				  html += "<td><span class=\"text-color-red\">"+data.selectList[i].amount+"</span></td>";
				  html += "</tr>";
			  }

			  $("#title").empty();
			  $("#title").append("과소비 내역 (" + date + ")");

			  $("#tb1").empty();
			  $("#tb1").append(html);
			  openChartLayer()
		  }
	  },
	  error: function(xhr, status, error){
		  console.log(xhr + ":" + status + ":" + error);
		  alert("처리 중 오류가 발생했습니다.");
		  return false;
	  }
	});
}

function chart3Layer(date) {
	$.ajax({
	  url: "/user/statistics/selectChart2List.do",
	  type: "POST",
	  data: {
		 date : date
	  },
	  success: function(data) {
		  if(data.message == "ok") {
			  var html = "";

			  for(i=0; i<data.selectList.length; i++) {
				  html += "<tr>";
				  html += "<td>"+data.selectList[i].aiNm+"</td>";
				  html += "<td>"+data.selectList[i].tranDate+"</td>";
				  html += "<td>"+data.selectList[i].aiSe+"</td>";
				  html += "<td>"+data.selectList[i].aiCode+"</td>";
				  html += "<td>"+data.selectList[i].cardType+"</td>";
				  if(data.selectList[i].inoutType == "수입") {
					  html += "<td><span class=\"text-color-blue\">"+data.selectList[i].inoutType+"</span></td>";
					  html += "<td><span class=\"text-color-blue\">"+data.selectList[i].amount+"</span></td>";
				  } else {
					  html += "<td><span class=\"text-color-red\">"+data.selectList[i].inoutType+"</span></td>";
					  html += "<td><span class=\"text-color-red\">"+data.selectList[i].amount+"</span></td>";
				  }

				  html += "</tr>";
			  }

			  $("#title").empty();
			  $("#title").append(date + "과소비 내역");

			  $("#tb1").empty();
			  $("#tb1").append(html);
			  openChartLayer()
		  }
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

<body class="common-page">
	<div class="menu-container">
	    <h2>통계 (Analytics)</h2>
	    <div class="common_section">
	        <form id="statForm" method="post" action="/user/stat/statList.do">
	            <input type="hidden" id="pageIndex" name="pageIndex" value="${holder.pageIndex}"/>

				<div class="dashboard-grid">
		            <div class="dashboard-box" style="position:relative;">
		                <div class="dashboard-box-header">
		                    <div class="chartFlex">
			                    <h3>카테고리별 소비</h3>
			                    <div class="search-box">
					                <div class="search-row">
					                    <input type="text" id="categoryBeginDe" name="categoryBeginDe" value="${holder.categoryBeginDe}" class="search-input-small datepicker change" readonly>
					                     ~
					                    <input type="text" id="categoryEndDe" name="categoryEndDe" value="${holder.categoryEndDe}" class="search-input-small datepicker change" readonly>
					                </div>
					            </div>
				            </div>
		                </div>
		                <div class="chart-box">
		                    <canvas id="categoryChart"></canvas>
		                </div>
		                <div id="noDataText" class="chartText">가계부에 등록된 데이터가 없습니다</div>
		            </div>

		            <div class="dashboard-box">
		                <div class="dashboard-box-header">
		                	<div class="chartFlex">
			                    <h3>월별 과소비 체크 금액</h3>
			                    <div class="search-box">
					                <div class="search-row">
					                	<select id="spendingYear" name="spendingYear" class="change">
					                    	<c:forEach var="spending" items="${yearList }">
					                    		<option value="${spending.dummyYear }" ${spending.dummyYear eq holder.spendingYear ? 'selected' : ''}>${spending.dummyYear }년</option>
					                    	</c:forEach>
					                    </select>
					                </div>
								</div>
				            </div>
		                </div>
		                <div class="chartBar-box">
		                    <canvas id="spendingTotalChart"></canvas>
		                </div>
		            </div>
		        </div>

		        <div class="section">
		        	<div class="chartFlex">
			            <h3>월별 수입 / 지출 금액</h3>
			            <div class="search-box">
			                <div class="search-row">
			                    <select id="inoutYear" name="inoutYear" class="change">
			                    	<c:forEach var="inout" items="${yearList }">
			                    		<option value="${inout.dummyYear }" ${inout.dummyYear eq holder.inoutYear ? 'selected' : ''}>${inout.dummyYear }년</option>
			                    	</c:forEach>
			                    </select>
			                </div>
			            </div>
			        </div>
			        <canvas id="inoutTotalChart" height="100"></canvas>
		        </div>

<!-- 		        <div class="section"> -->
<!-- 		            <h3>상세 내역</h3> -->
<!-- 		            <table> -->
<!-- 		                <thead> -->
<!-- 		                    <tr> -->
<!-- 		                        <th>날짜</th> -->
<!-- 		                        <th>카테고리</th> -->
<!-- 		                        <th>구분</th> -->
<!-- 		                        <th>금액</th> -->
<!-- 		                    </tr> -->
<!-- 		                </thead> -->

<!-- 		                <tbody> -->
<%-- 		                    <c:choose> --%>
<%-- 		                        <c:when test="${!empty statList}"> --%>
<%-- 		                            <c:forEach var="item" items="${statList}"> --%>
<!-- 		                                <tr> -->
<%-- 		                                    <td>${item.date}</td> --%>
<%-- 		                                    <td>${item.category}</td> --%>
<!-- 		                                    <td> -->
<%-- 		                                        <span class="${item.inoutType eq 'I' ? 'text-color-blue' : 'text-color-red'}"> --%>
<%-- 		                                            ${item.inoutType eq 'I' ? '수입' : '지출'} --%>
<!-- 		                                        </span> -->
<!-- 		                                    </td> -->
<!-- 		                                    <td> -->
<%-- 		                                        <span class="${item.inoutType eq 'I' ? 'text-color-blue' : 'text-color-red'}"> --%>
<%-- 		                                            ${item.amount} --%>
<!-- 		                                        </span> -->
<!-- 		                                    </td> -->
<!-- 		                                </tr> -->
<%-- 		                            </c:forEach> --%>
<%-- 		                        </c:when> --%>
<%-- 		                        <c:otherwise> --%>
<!-- 		                            <tr> -->
<!-- 		                                <td colspan="4">데이터가 존재하지 않습니다.</td> -->
<!-- 		                            </tr> -->
<%-- 		                        </c:otherwise> --%>
<%-- 		                    </c:choose> --%>
<!-- 		                </tbody> -->
<!-- 		            </table> -->
<!-- 		        </div> -->

	        </form>
	    </div>
    </div>

    <!-- dim -->
	<div id="layerDim" class="layer-dim"></div>

    <!-- 레이어 -->
	<div id="chartLayer" class="chart-layer">

	    <h3 id="title"></h3>
		<form id="adminBbsPassword" name="adminBbsPassword">
			<table class="table-hover">
	        	<colgroup>
		        	<col style="width:15%">
		        	<col style="width:15%">
		        	<col style="width:15%">
		        	<col style="width:10%">
		        	<col style="width:15%">
		        	<col style="width:15%">
		        	<col style="width:20%">
		        </colgroup>
	            <thead>
	                <tr>
	                	<th>통장/카드명</th>
	                	<th>거래일자</th>
	                	<th>카드/통장 구분</th>
	                	<th>카드/통장</th>
	                	<th>신용/체크 구분</th>
	                	<th>수입/지출 구분</th>
	                	<th>금액</th>
	                </tr>
	            </thead>
	            <tbody id="tb1">

	            </tbody>
	        </table>
		</form>
	</div>
</body>
</html>