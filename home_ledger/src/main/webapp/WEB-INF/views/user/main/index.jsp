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
		fn_startPigWave();
	    fn_setPigWater("${savingGoalLate}" == "" ? 0 : "${savingGoalLate.percent}");   // 원하는 퍼센트 변수로 교체

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
   					data: categoryTotalData,
   					backgroundColor: [
   				        "#4CAF50",
   				        "#2196F3",
   				        "#FF9800",
   				        "#F44336",
   				        "#9C27B0",
   				        "#00BCD4",
   				        "#FFC107",
   				        "#795548"
   				    ]
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

	if(mode == "saving") {
		uri = "/user/saving/list.do";
		mId = "30";
		mPid = "9";
	} else if(mode != "acountAmount") {
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

function fn_setPigWater(percent) {
    percent = Math.max(0, Math.min(100, percent));
    var svgHeight = 512;
    var offset = svgHeight * (1 - percent / 100) + 32;
    document.getElementById('pigWaterGroup').style.transform = 'translateY(' + offset + 'px)';
    document.querySelector('.pig-percent-label').textContent = percent + '%';
}

// 파도가 계속 흔들리게 (한 번만 실행)
function fn_startPigWave() {
    var wave = document.getElementById('pigWaveFront');
    var anim = document.createElementNS('http://www.w3.org/2000/svg', 'animateTransform');
    anim.setAttribute('attributeName', 'transform');
    anim.setAttribute('type', 'translate');
    anim.setAttribute('from', '0 0');
    anim.setAttribute('to', '-200 0');
    anim.setAttribute('dur', '2.4s');
    anim.setAttribute('repeatCount', 'indefinite');
    wave.appendChild(anim);
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
        <div class="dashboard-grid">
        	<div class="dashboard-box">
			    <div class="dashboard-box-header">
			        <h3>총 적금 목표 달성률</h3>
			        <a href="javascript:void(0)" onclick="fn_detail('saving')" class="dashboard-more">더보기 ></a>
			    </div>

			    <div class="pig-goal-layout">
			        <div class="pig">
			            <svg viewBox="0 0 576 512" class="pig-svg">
			                <!-- Font Awesome Free 6.7.2 by @fontawesome - https://fontawesome.com License - CC BY 4.0 -->
			                <defs>
			                    <clipPath id="pigClip">
			                        <path d="M400 96l0 .7c-5.3-.4-10.6-.7-16-.7L256 96c-16.5 0-32.5 2.1-47.8 6c-.1-2-.2-4-.2-6c0-53 43-96 96-96s96 43 96 96zm-16 32c3.5 0 7 .1 10.4 .3c4.2 .3 8.4 .7 12.6 1.3C424.6 109.1 450.8 96 480 96l11.5 0c10.4 0 18 9.8 15.5 19.9l-13.8 55.2c15.8 14.8 28.7 32.8 37.5 52.9l13.3 0c17.7 0 32 14.3 32 32l0 96c0 17.7-14.3 32-32 32l-32 0c-9.1 12.1-19.9 22.9-32 32l0 64c0 17.7-14.3 32-32 32l-32 0c-17.7 0-32-14.3-32-32l0-32-128 0 0 32c0 17.7-14.3 32-32 32l-32 0c-17.7 0-32-14.3-32-32l0-64c-34.9-26.2-58.7-66.3-63.2-112L68 304c-37.6 0-68-30.4-68-68s30.4-68 68-68l4 0c13.3 0 24 10.7 24 24s-10.7 24-24 24l-4 0c-11 0-20 9-20 20s9 20 20 20l31.2 0c12.1-59.8 57.7-107.5 116.3-122.8c12.9-3.4 26.5-5.2 40.5-5.2l128 0zm64 136a24 24 0 1 0 -48 0 24 24 0 1 0 48 0z"/>
			                    </clipPath>
			                </defs>

			                <path class="pig-body" d="M400 96l0 .7c-5.3-.4-10.6-.7-16-.7L256 96c-16.5 0-32.5 2.1-47.8 6c-.1-2-.2-4-.2-6c0-53 43-96 96-96s96 43 96 96zm-16 32c3.5 0 7 .1 10.4 .3c4.2 .3 8.4 .7 12.6 1.3C424.6 109.1 450.8 96 480 96l11.5 0c10.4 0 18 9.8 15.5 19.9l-13.8 55.2c15.8 14.8 28.7 32.8 37.5 52.9l13.3 0c17.7 0 32 14.3 32 32l0 96c0 17.7-14.3 32-32 32l-32 0c-9.1 12.1-19.9 22.9-32 32l0 64c0 17.7-14.3 32-32 32l-32 0c-17.7 0-32-14.3-32-32l0-32-128 0 0 32c0 17.7-14.3 32-32 32l-32 0c-17.7 0-32-14.3-32-32l0-64c-34.9-26.2-58.7-66.3-63.2-112L68 304c-37.6 0-68-30.4-68-68s30.4-68 68-68l4 0c13.3 0 24 10.7 24 24s-10.7 24-24 24l-4 0c-11 0-20 9-20 20s9 20 20 20l31.2 0c12.1-59.8 57.7-107.5 116.3-122.8c12.9-3.4 26.5-5.2 40.5-5.2l128 0zm64 136a24 24 0 1 0 -48 0 24 24 0 1 0 48 0z"/>

			                <g clip-path="url(#pigClip)">
			                    <g id="pigWaterGroup">
			                        <rect x="-100" y="0" width="776" height="512" class="pig-water-fill"/>
			                        <path id="pigWaveFront" d="M-100,0 Q-50,-14 0,0 T100,0 T200,0 T300,0 T400,0 T500,0 T600,0 T700,0 T800,0 V512 H-100 Z" class="pig-wave"/>
			                    </g>
			                </g>

			                <path class="pig-outline" fill="none" d="M400 96l0 .7c-5.3-.4-10.6-.7-16-.7L256 96c-16.5 0-32.5 2.1-47.8 6c-.1-2-.2-4-.2-6c0-53 43-96 96-96s96 43 96 96zm-16 32c3.5 0 7 .1 10.4 .3c4.2 .3 8.4 .7 12.6 1.3C424.6 109.1 450.8 96 480 96l11.5 0c10.4 0 18 9.8 15.5 19.9l-13.8 55.2c15.8 14.8 28.7 32.8 37.5 52.9l13.3 0c17.7 0 32 14.3 32 32l0 96c0 17.7-14.3 32-32 32l-32 0c-9.1 12.1-19.9 22.9-32 32l0 64c0 17.7-14.3 32-32 32l-32 0c-17.7 0-32-14.3-32-32l0-32-128 0 0 32c0 17.7-14.3 32-32 32l-32 0c-17.7 0-32-14.3-32-32l0-64c-34.9-26.2-58.7-66.3-63.2-112L68 304c-37.6 0-68-30.4-68-68s30.4-68 68-68l4 0c13.3 0 24 10.7 24 24s-10.7 24-24 24l-4 0c-11 0-20 9-20 20s9 20 20 20l31.2 0c12.1-59.8 57.7-107.5 116.3-122.8c12.9-3.4 26.5-5.2 40.5-5.2l128 0zm64 136a24 24 0 1 0 -48 0 24 24 0 1 0 48 0z"/>
			            </svg>
			        </div>

			        <div class="pig-goal-info">
			            <div class="goal-info-item">
			                <div class="goal-info-icon date">
			                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="18" rx="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg>
			                </div>
			                <div class="goal-info-text">
			                    <span class="goal-info-label">달성률</span>
			                    <span class="goal-info-value"><c:out value="${empty savingGoalLate.percent ? '0' : savingGoalLate.percent}"/><em>%</em></span>
			                </div>
			            </div>

			            <div class="goal-info-item">
			                <div class="goal-info-icon days">
			                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="9"/><polyline points="12 7 12 12 15 15"/></svg>
			                </div>
			                <div class="goal-info-text">
			                    <span class="goal-info-label">목표 날짜</span>
			                    <span class="goal-info-value"><c:out value="${empty savingGoalLate.endDe ? '-' : savingGoalLate.endDe}"/></span>
			                </div>
			            </div>

			            <div class="goal-info-item">
			                <div class="goal-info-icon wallet">
			                     <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 12V7H5a2 2 0 0 1 0-4h14v4"/><path d="M3 5v14a2 2 0 0 0 2 2h16v-5"/><path d="M18 12a2 2 0 0 0 0 4h4v-4Z"/></svg>
			                </div>
			                <div class="goal-info-text">
			                    <span class="goal-info-label">남은 일수</span>
			                    <span class="goal-info-value"><fmt:formatNumber value="${empty savingGoalLate.reaminDays ? '0' : savingGoalLate.reaminDays}" pattern="#,###"/> <em>일</em></span>
			                </div>
			            </div>

			            <div class="goal-info-message">
			                목표까지 <strong><fmt:formatNumber value="${empty savingGoalLate.reaminDays ? '0' : savingGoalLate.reaminDays}" pattern="#,###"/>일</strong> 남았습니다!
			            </div>
			        </div>

			        <div class="pig-goal-info">
			            <div class="goal-info-item">
			                <div class="goal-info-icon target">
			                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><circle cx="12" cy="12" r="9"/><circle cx="12" cy="12" r="5"/><circle cx="12" cy="12" r="1.2" fill="currentColor" stroke="none"/></svg>
			                </div>
			                <div class="goal-info-text">
			                    <span class="goal-info-label">목표 금액</span>
			                    <span class="goal-info-value"><fmt:formatNumber value="${empty savingGoalLate.siTotalAmount ? '0' : savingGoalLate.siTotalAmount}" pattern="#,###"/> <em>원</em></span>
			                </div>
			            </div>

			            <div class="goal-info-item">
			                <div class="goal-info-icon saved">
			                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><ellipse cx="12" cy="6" rx="8" ry="3"/><path d="M4 6v5c0 1.66 3.58 3 8 3s8-1.34 8-3V6"/><path d="M4 11v5c0 1.66 3.58 3 8 3s8-1.34 8-3v-5"/></svg>
			                </div>
			                <div class="goal-info-text">
			                    <span class="goal-info-label">현재 납입액</span>
			                    <span class="goal-info-value"><fmt:formatNumber value="${empty savingGoalLate.payAmount ? '0' : savingGoalLate.payAmount}" pattern="#,###"/> <em>원</em></span>
			                </div>
			            </div>

			            <div class="goal-info-item">
			                <div class="goal-info-icon remain">
			                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><rect x="3" y="9" width="18" height="11" rx="1.5"/><path d="M3 13h18M12 9v11"/><path d="M12 9c-1.4-3-5-3.2-5 0M12 9c1.4-3 5-3.2 5 0"/></svg>
			                </div>
			                <div class="goal-info-text">
			                    <span class="goal-info-label">남은 금액</span>
			                    <span class="goal-info-value"><fmt:formatNumber value="${empty savingGoalLate.remainingAmount ? '0' : savingGoalLate.remainingAmount}" pattern="#,###"/> <em>원</em></span>
			                </div>
			            </div>

			            <div class="goal-info-message">
			                목표까지 <strong><fmt:formatNumber value="${empty savingGoalLate.remainingAmount ? '0' : savingGoalLate.remainingAmount}" pattern="#,###"/>원</strong> 남았습니다!
			            </div>
			        </div>
			    </div>
			</div>
            <div class="dashboard-box">
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

    </div>
</body>
</html>