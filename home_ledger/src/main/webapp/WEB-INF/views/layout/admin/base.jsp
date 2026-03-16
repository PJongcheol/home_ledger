<%@ page contentType="text/html; charset=UTF-8" %>
<%@ include file="/WEB-INF/views/common/taglib.jsp" %>


<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">

    <link rel="stylesheet" href="<c:url value='/css/admin.css'/>">
    <link rel="stylesheet" href="https://code.jquery.com/ui/1.13.2/themes/base/jquery-ui.css">
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script src="https://code.jquery.com/ui/1.13.2/jquery-ui.min.js"></script>
	<script src="<c:url value='/js/devel.js'/>"></script>
	<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
	<script src="https://cdn.ckeditor.com/ckeditor5/39.0.1/classic/ckeditor.js"></script>
</head>
<script>
	var editor;

	$(document).ready(function(){
		var editorElement = document.querySelector('.commonCn');

		if(editorElement) {
			ClassicEditor.create(document.querySelector('.commonCn'), {
		        removePlugins: ['MediaEmbed'],
		    	ckfinder: {
		            uploadUrl: '/etc/imageUpload.do'
		        }
		    })
		    .then( newEditor => {
				editor = newEditor;
		    })
		    .catch(error => {
		        console.error(error);
		    });
		}
	});
</script>
<body>
	<form id="downloadFileForm" name="downloadFileForm" method="post" action="/etc/downloadFile.do">
		<input type="hidden" id="atchfileno" name="atchfileno"/>
		<input type="hidden" id="fileord" name="fileord"/>
	</form>
	<jsp:include page="/WEB-INF/views/layout/admin/header.jsp"/>

	<div class="container">
		 <div class="sidebar">
			<jsp:include page="/WEB-INF/views/layout/admin/left.jsp"/>
		 </div>
		 <jsp:include page="${body}.jsp"/>
	</div>

	<jsp:include page="/WEB-INF/views/layout/admin/footer.jsp"/>
</body>

</html>
