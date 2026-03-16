$(function () {
    // datepicker
	$.datepicker.setDefaults({
		dateFormat: 'yy-mm-dd',
	    prevText: '이전',
	    nextText: '다음',
	    monthNames: [
	      '1월','2월','3월','4월','5월','6월',
	      '7월','8월','9월','10월','11월','12월'
	    ],
	    monthNamesShort: [
	      '1월','2월','3월','4월','5월','6월',
	      '7월','8월','9월','10월','11월','12월'
	    ],
	    dayNames: ['일','월','화','수','목','금','토'],
	    dayNamesShort: ['일','월','화','수','목','금','토'],
	    dayNamesMin: ['일','월','화','수','목','금','토'],
	    showMonthAfterYear: true,
	    yearSuffix: '년',
	    changeMonth: true,
	    changeYear: true,
		yearRange: "1900:2100"
    });

    $(".datepicker").datepicker();

	// 전화번호 자동 변환
	$(".tel").on("input", function(){
		var value = $(this).val();

		// 숫자만 허용
		value = value.replace(/[^0-9]/g, "");

		// 최대 11자리
		if (value.length > 11) {
			value = value.slice(0, 11);
		}

		// 하이픈 처리
		if (value.length < 4) {
		// 그대로
		} else if (value.length < 8) {
			value = value.replace(/(\d{3})(\d+)/, "$1-$2");
		} else {
			value = value.replace(/(\d{3})(\d{4})(\d+)/, "$1-$2-$3");
		}

		$(this).val(value);
	});

	// 숫자 자동 변환
	$(".only_number").on("input", function(){
		var value = $(this).val();

		// 숫자만 허용
		value = value.replace(/[^0-9]/g, "");

		$(this).val(value);
	});
});

// 이메일 형식 체크
function emailCheck(email_address){
	email_regex = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/i;
	if(!email_regex.test(email_address)){
		return false;
	}else{
		return true;
	}
}

// 주소찾기
function fn_juso() {
	new daum.Postcode({
        oncomplete: function(data) {
            // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

            // 각 주소의 노출 규칙에 따라 주소를 조합한다.
            // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
            var addr = ''; // 주소 변수
            var extraAddr = ''; // 참고항목 변수

            //사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
            if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
                addr = data.roadAddress;
            } else { // 사용자가 지번 주소를 선택했을 경우(J)
                addr = data.jibunAddress;
            }

            // 우편번호와 주소 정보를 해당 필드에 넣는다.
            document.getElementById('memberPost').value = data.zonecode;
            document.getElementById("memberAddr").value = addr;
            document.getElementById("memberAddrDetl").focus();
        }
    }).open();
}

// 파일 다운로드
function fn_fileDownload(atchfileno, fileord) {
	$("#downloadFileForm #atchfileno").val(atchfileno)
	$("#downloadFileForm #fileord").val(fileord)
	$("#downloadFileForm").submit();
}

// 파일 삭제
function fn_fileDel(atchfileno, fileord) {
	var html = "";

	if(confirm("해당 파일을 삭제하시겠습니까?")) {
		$.ajax({
		  url: "/etc/deleteFile.do",
		  type: "POST",
		  data: {
			   atchfileno : atchfileno
			  ,fileord : fileord
		  },
		  success: function(data) {
			  if(data.message == "ok") {
				  alert("정상적으로 처리되었습니다.");

				  $(this).parent().remove();

				  var len = $("#fileDiv .file-item").length;

				  if(len == 0) {
					html += "<input type=\"file\" id=\"file\" name=\"files\">";
					$("#fileDiv").append(html);
				  }
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

function getCookie(name) {
    var cookies = document.cookie.split(';');
    for (var c of cookies) {
        const [key, value] = c.trim().split('=');
        if (key === name) return value;
    }
    return null;
}

function setCookie(name, value, days) {
    const date = new Date();
    date.setDate(date.getDate() + days);
    document.cookie =
        name + "=" + value +
        ";expires=" + date.toUTCString() +
        ";path=/";
}

// 레이어 팝업
function createLayerPop(seq, sj, content, width, height, widthLc, heightLc, mode) {
	// 쿠키에 등록 되어있는지 체크
	if(getCookie("popup_" + seq) == "done") {
		return;
	}

	var popup = document.createElement("div");
				popup.id = "popup_"+seq;
				popup.className = "layer-popup";
			    popup.style.width = width + "px";
			    popup.style.height = height + "px";
			    popup.style.left = widthLc + "px";
			    popup.style.top = heightLc + "px";
				popup.style.position = "fixed";
				popup.style.zIndex = "9999";
				popup.style.display = "flex";
				popup.style.flexDirection = "column";

	if(mode == "image") { // 이미지 링크형
		popup.innerHTML = `
		    <div class="layer-header" style="
		        padding:10px 15px;
		        background:#1f2c3d;
		        color:#fff;
		        font-weight:600;
		        cursor:move;
		        text-align:center;">
		        ${sj}
		    </div>

		    <div class="layer-body" style="
		        flex:1;
		        padding:20px;
		        overflow:auto;">
		        <img src="${content}" style="width:100%">
		    </div>

		    <div class="layer-footer" style="
		        padding:10px 15px;
		        border-top:1px solid #eee;
		        display:flex;
		        justify-content:space-between;
		        align-items:center;
		        background:#fafafa;">
		        <label style="
		            display:flex;
		            align-items:center;
		            gap:6px;
		            font-size:13px;
		            cursor:pointer;">
		            <input type="checkbox"
		                   id="weekClose_${seq}"
		                   style="margin:0;">
		            1주일간 열지 않음
		        </label>

		        <button onclick="fn_layerClose('${seq}')"
		            style="
		                padding:6px 12px;
		                border-radius:6px;
		                border:none;
		                background:#3498db;
		                color:#fff;
		                cursor:pointer;">
		            닫기
		        </button>
		    </div>
		`;
		  document.body.appendChild(popup);
	} else { // 에디터형
		popup.innerHTML = `
		        <div class="layer-header" style="padding:10px 15px;background:#1f2c3d;color:#fff;font-weight:600;cursor:move;text-align:center;">${sj}</div>

				<div class="layer-body" style="flex:1;padding:20px;overflow:auto;">${content}</div>

		        <div class="layer-footer" style="padding:10px 15px;border-top:1px solid #eee;
		             display:flex;justify-content:space-between;align-items:center;background:#fafafa;">
		            <label style="font-size:13px;">
		                <input type="checkbox" id="weekClose_${seq}" class="close">
		                1주일간 열지 않음
		            </label>
		            <button class="btn-close"
						onclick="fn_layerClose('${seq}')"
		                style="padding:6px 12px;border-radius:6px;border:none;
		                background:#3498db;color:#fff;cursor:pointer;">
		                닫기
		            </button>
		        </div>
		    `;
		  document.body.appendChild(popup);
	}
}

// 레이어 닫기
function fn_layerClose(seq) {
	// 1주일간 열지 않음 체크 시 쿠키 등록
	if($("#weekClose_"+seq).is(":checked")) {
		setCookie("popup_"+seq, "done", 7);
	}

	$("#popup_"+seq).remove();
}

// 로그인 페이지로 리다이렉트(세션 삭제)
function fn_sessionLogin() {
	location.href = "/login.do";
}