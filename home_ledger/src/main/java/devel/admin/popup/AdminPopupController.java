package devel.admin.popup;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import devel.admin.popup.service.AdminPopupService;
import devel.cmmn.base.BaseController;
import devel.cmmn.file.service.FileService;
import devel.cmmn.login.vo.LoginVO;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

/**
 * 팝업 관리를 위한 컨트롤러
 * @Class Name   : AdminPopupController
   @Description  : 팝업관리 동작을 위한 컨트롤러

 * @author  : PJC
 * @date    : 2026. 2. 11
 * @desc    :
 * @version : 1.0
 * @see
 *
 * 개정이력(Modification Information)
 * 수정일		      수정자	     내용
 * ----------------  --------  -----------------
 *  2026. 2. 11		PJC			최초생성
 **/

@Controller
@RequestMapping("/admin/popup")
public class AdminPopupController extends BaseController {
	@Autowired
	AdminPopupService adminPopupService;

	@Autowired
	FileService fileService;

	/**
     * 팝업 목록 관리
     * @Method : list
     * @param request
     * @param response
     * @param throws
     * @throws Exception
     * @return : String
     */
	@PostMapping(value ="/list.do")
	public String list(@RequestParam Map<String, Object> param
			, ModelMap model, HttpSession session) throws Exception {

		// 페이지 값이 없다면
		if(param.get("pageIndex") == null || "".equals(param.get("pageIndex"))) {
			param.put("pageIndex", 1);
			param.put("pageSize", 10);
		} else {
			param.put("pageIndex", Integer.parseInt(param.get("pageIndex").toString()));
			param.put("pageSize", Integer.parseInt(param.get("pageSize").toString()));
		}

		// Limit을 위해 계산
		int offset = (Integer.parseInt(param.get("pageIndex").toString()) - 1) * 10;
		param.put("offset", offset);

		// 게시물 목록 카운트
		int totalCount = adminPopupService.selectPopupTotalCount(param);
		param.put("totalCount", totalCount);

		// 페이지 수
		int totalPage = (int) Math.ceil((double) totalCount / Integer.parseInt(param.get("pageSize").toString()));
		param.put("totalPage", totalPage);

		// 게시판 목록 조회
		List<Map<String, Object>> list = adminPopupService.selectPopupList(param);

		model.addAttribute("list", list);
		model.addAttribute("holder", param);

		return adminLayout(model, "/WEB-INF/views/admin/popup/list");

	}

	/**
     * 팝업 폼
     * @Method : form
     * @param request
     * @param response
     * @param throws
     * @throws Exception
     * @return : String
     */
	@PostMapping(value ="/form.do")
	public String form(@RequestParam Map<String, Object> param
			, ModelMap model, HttpSession session) throws Exception {

		if("D".equals(param.get("mode"))) {
			Map<String, Object> detail = adminPopupService.selectPopupDtl(param);
			model.addAttribute("detail", detail);

			// 파일 정보 조회
			List<Map<String, Object>> fileList = fileService.selectFileList(detail);
			model.addAttribute("fileList", fileList);
		}

		model.addAttribute("holder", param);

		return adminLayout(model, "/WEB-INF/views/admin/popup/form");

	}

	/**
     * 팝업 저장
     * @Method : savePopup
     * @param request
     * @param response
     * @param throws
     * @throws Exception
     * @return : String
     */
	@PostMapping(value ="/savePopup.do")
	@ResponseBody
	public Map<String, Object> savePopup(@RequestParam Map<String, Object> param
			, @RequestParam(value="files", required=false) List<MultipartFile> files
			, ModelMap model, HttpSession session, HttpServletRequest request) throws Exception {

		LoginVO user = (LoginVO) request.getSession().getAttribute("LoginVO");
		param.put("userId", user.getMemberId());
		param.put("dir", "popup");

		Map<String, Object> result = new HashMap<>();

		String atchfileno = param.get("atchfileno") == null ? "" : param.get("atchfileno").toString();

		// 첨부파일이 하나라도 있다면
		if(files != null && !files.isEmpty() && !files.get(0).isEmpty()) {
			// 기존에 이미 첨부된 파일이 없다면 첨부파일 일련번호를 먼저 조회한다.
			if(param.get("atchfileno") == null || "".equals(param.get("atchfileno"))) {
				atchfileno = String.valueOf(fileService.selectAtchfileno());
				param.put("atchfileno", atchfileno);
			}
			// 파일 리스트를 넘겨주며
			fileService.uploadFiles(param, files);
		}

		param.put("atchfileno", atchfileno);

		adminPopupService.savePopup(param);

		result.put("message", "ok");

		return result;
	}

	/**
     * 팝업 삭제
     * @Method : deletePopup
     * @param request
     * @param response
     * @param throws
     * @throws Exception
     * @return : String
     */
	@PostMapping(value ="/deletePopup.do")
	@ResponseBody
	public Map<String, Object> deletePopup(@RequestParam Map<String, Object> param
			, ModelMap model, HttpSession session) throws Exception {

		Map<String, Object> result = new HashMap<>();

		adminPopupService.deletePopup(param);

		result.put("message", "ok");

		return result;
	}
}
