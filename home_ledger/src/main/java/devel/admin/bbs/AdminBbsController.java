package devel.admin.bbs;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.codec.digest.DigestUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import devel.admin.bbs.service.AdminBbsService;
import devel.admin.menu.service.AdminMenuService;
import devel.cmmn.base.BaseController;
import devel.cmmn.file.service.FileService;
import devel.cmmn.login.vo.LoginVO;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import tools.jackson.databind.ObjectMapper;

/**
 * bbs 처리를 위한 Controller
 * @Class Name   : AdminBbsController
   @Description  :bbs 처리를 위한 Controller
 * @author  : PJC
 * @date    : 2026. 2. 6
 * @desc    :
 * @version : 1.0
 * @see
 *
 * 개정이력(Modification Information)
 * 수정일		      수정자	     내용
 * ----------------  --------  -----------------
 *  2026. 2. 6		PJC			최초생성
 **/
@Controller
@RequestMapping("/admin/bbs")
public class AdminBbsController extends BaseController{
	@Autowired
	FileService fileService;

	@Autowired
	AdminMenuService adminMenuService;

	@Autowired
	AdminBbsService adminBbsService;

	/**
     * 게시판 목록 관리
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

		// 게시판 목록 카운트
		int totalCount = adminBbsService.selectBbsMstTotalCount(param);
		param.put("totalCount", totalCount);

		// 페이지 수
		int totalPage = (int) Math.ceil((double) totalCount / Integer.parseInt(param.get("pageSize").toString()));
		param.put("totalPage", totalPage);

		// 게시판 목록 조회
		List<Map<String, Object>> list = adminBbsService.selectBbsMstList(param);

		model.addAttribute("list", list);
		model.addAttribute("holder", param);

		return adminLayout(model, "/WEB-INF/views/admin/bbs/bbsList");

	}

	/**
     * 게시판 폼
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

		if("D".equals(param.get("mode"))) { // 상세정보인 경우
			Map<String, Object> detail = adminBbsService.selectBbsDetail(param);
			model.addAttribute("detail", detail);
		}

		// 필드정보를 불러온다.
		List<Map<String, Object>> fieldList = adminBbsService.selectBbsFieldList(param);

		model.addAttribute("fieldList", fieldList);
		model.addAttribute("holder", param);

		return adminLayout(model, "/WEB-INF/views/admin/bbs/bbsForm");

	}

	/**
     * 게시판 저장
     * @Method : saveBbs
     * @param request
     * @param response
     * @param throws
     * @throws Exception
     * @return : Map
     */
	@PostMapping(value ="/saveBbs.do")
	@ResponseBody
	public Map<String, Object> saveBbs(@RequestParam Map<String, Object> param
			, ModelMap model, HttpSession session, HttpServletRequest request) throws Exception {

		LoginVO user = (LoginVO) request.getSession().getAttribute("LoginVO");
		param.put("userId", user.getMemberId());

		Map<String, Object> result = new HashMap<>();

		String jsonData = (String) param.get("jsonData");

		ObjectMapper objectMapper = new ObjectMapper();
		List<Map<String, Object>> jsonList = objectMapper.readValue(jsonData, List.class);

		// 게시판 저장
		adminBbsService.saveBbs(param, jsonList);
		result.put("message", "ok");

		return result;

	}

	/**
     * 게시판 삭제
     * @Method : deleteBbs
     * @param request
     * @param response
     * @param throws
     * @throws Exception
     * @return : Map
     */
	@PostMapping(value ="/deleteBbs.do")
	@ResponseBody
	public Map<String, Object> deleteBbs(@RequestParam Map<String, Object> param
			, ModelMap model, HttpSession session, HttpServletRequest request) throws Exception {

		LoginVO user = (LoginVO) request.getSession().getAttribute("LoginVO");

		Map<String, Object> result = new HashMap<>();

		// 유저 정보 유무 확인
		if(user != null && user.getMemberId() != null) {
			param.put("userId", user.getMemberId());

			// 게시판 삭제
			adminBbsService.deleteBbs(param);
			result.put("message", "ok");
		} else {
			result.put("message", "login");
		}

		return result;
	}

	/**
     * bbs 목록
     * @Method : bbsList
     * @param request
     * @param response
     * @param throws
     * @throws Exception
     * @return : String
     */
	@PostMapping(value ="/board/list.do")
	public String bbsList(@RequestParam Map<String, Object> param
			, ModelMap model, HttpSession session) throws Exception {

		// 메뉴 정보 조회
		Map<String, Object> menuDetail = adminMenuService.selectMenuDtl(param);
		model.addAttribute("menuDetail", menuDetail);

		param.put("bbsSeq", menuDetail.get("bbsSeq"));

		// 게시판 조회
		Map<String, Object> boardMst = adminBbsService.selectBoardMst(param);
		model.addAttribute("boardMst", boardMst);

		// 페이지 값이 없다면
		if(param.get("pageIndex") == null || "".equals(param.get("pageIndex"))) {
			param.put("pageIndex", 1);
			param.put("pageSize", Integer.parseInt(boardMst.get("pageListCo").toString()));
		} else {
			param.put("pageIndex", Integer.parseInt(param.get("pageIndex").toString()));
			param.put("pageSize", Integer.parseInt(param.get("pageSize").toString()));
		}

		// Limit을 위해 계산
		int offset = (Integer.parseInt(param.get("pageIndex").toString()) - 1) * 10;
		param.put("offset", offset);

		// bbs 목록 카운트
		int totalCount = adminBbsService.selectBbsTotalCount(param);
		param.put("totalCount", totalCount);

		// 페이지 수
		int totalPage = (int) Math.ceil((double) totalCount / Integer.parseInt(param.get("pageSize").toString()));
		param.put("totalPage", totalPage);

		// bbs 목록 조회
		List<Map<String, Object>> list = adminBbsService.selectBbsList(param);
		model.addAttribute("list", list);

		model.addAttribute("holder", param);

		return adminLayout(model, "/WEB-INF/views/admin/bbs/list");

	}

	/**
     * bbs 비밀번호 체크
     * @Method : bbsPassword
     * @param request
     * @param response
     * @param throws
     * @throws Exception
     * @return : Map
     */
	@PostMapping(value ="/board/bbsPassword.do")
	@ResponseBody
	public Map<String, Object> bbsPassword(@RequestParam Map<String, Object> param
			, ModelMap model, HttpSession session
			, HttpServletRequest request) throws Exception {

		Map<String, Object> result = new HashMap<>();

		// 비밀번호 암호화
		String pw = param.get("nttPassword").toString();
		param.put("nttPassword", DigestUtils.sha256Hex(pw));

		result.put("cnt", adminBbsService.bbsPassword(param));

		return result;

	}

	/**
     * bbs form
     * @Method : bbsform
     * @param request
     * @param response
     * @param throws
     * @throws Exception
     * @return : String
     */
	@PostMapping(value ="/board/form.do")
	public String bbsform(@RequestParam Map<String, Object> param
			, ModelMap model, HttpSession session) throws Exception {

		// 게시판 조회
		model.addAttribute("boardMst", adminBbsService.selectBoardMst(param));

		// 게시판 필드 조회
		List<Map<String, Object>> fieldList = adminBbsService.selectAdminBoardFieldList(param);
		Map<String, Object> fieldMap = new HashMap<>();

		// 게시판 필드가 목록 형태이기 때문에 map에 String : Map 형태로 담아준다.
		// 이렇게 하지 않으면 jsp에서 foreach가 불필요하게 많이 쓰임
		for(Map<String, Object> field : fieldList) {
			fieldMap.put(field.get("columnNm").toString(), field);
		}

		model.addAttribute("field", fieldMap);

		// mode로 bbs 상세 조회
		if("D".equals(param.get("mode"))) {
			Map<String, Object> detail = adminBbsService.selectBoardDtl(param);
			model.addAttribute("detail", detail);

			// 파일 정보 조회
			List<Map<String, Object>> fileList = fileService.selectFileList(detail);
			model.addAttribute("fileList", fileList);
		}

		model.addAttribute("holder", param);

		return adminLayout(model, "/WEB-INF/views/admin/bbs/form");

	}


	/**
     * bbs 저장
     * @Method : saveBoard
     * @param request
     * @param response
     * @param throws
     * @throws Exception
     * @return : Map
     */
	@PostMapping(value ="/board/saveBoard.do")
	@ResponseBody
	public Map<String, Object> saveBoard(@RequestParam Map<String, Object> param
			,@RequestParam(value="files", required=false) List<MultipartFile> files
			, ModelMap model, HttpSession session
			, HttpServletRequest request) throws Exception {

		Map<String, Object> result = new HashMap<>();

		LoginVO user = (LoginVO) request.getSession().getAttribute("LoginVO");
		param.put("userId", user.getMemberId());
		param.put("dir", "board");

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

		adminBbsService.saveBoard(param);

		result.put("message", "ok");

		return result;

	}

	/**
     * bbs 삭제
     * @Method : deleteBoard
     * @param request
     * @param response
     * @param throws
     * @throws Exception
     * @return : Map
     */
	@PostMapping(value ="/board/deleteBoard.do")
	@ResponseBody
	public Map<String, Object> deleteBoard(@RequestParam Map<String, Object> param
			, ModelMap model, HttpSession session
			, HttpServletRequest request) throws Exception {

		Map<String, Object> result = new HashMap<>();

		LoginVO user = (LoginVO) request.getSession().getAttribute("LoginVO");
		param.put("userId", user.getMemberId());

		adminBbsService.deleteBoard(param);

		result.put("message", "ok");

		return result;

	}

	/**
     * bbs view
     * @Method : bbsView
     * @param request
     * @param response
     * @param throws
     * @throws Exception
     * @return : String
     */
	@PostMapping(value ="/board/view.do")
	public String bbsView(@RequestParam Map<String, Object> param
			, ModelMap model, HttpSession session
			, HttpServletRequest request) throws Exception {

		// 게시판 조회
		model.addAttribute("boardMst", adminBbsService.selectBoardMst(param));

		// 게시판 필드 조회
		List<Map<String, Object>> fieldList = adminBbsService.selectAdminBoardFieldList(param);
		Map<String, Object> fieldMap = new HashMap<>();

		// 게시판 필드가 목록 형태이기 때문에 map에 String : Map 형태로 담아준다.
		// 이렇게 하지 않으면 jsp에서 foreach가 불필요하게 많이 쓰임
		for(Map<String, Object> field : fieldList) {
			fieldMap.put(field.get("columnNm").toString(), field);
		}

		model.addAttribute("field", fieldMap);

		// bbs 조회수 업데이트
		adminBbsService.updateBoardRdcnt(param);

		// bbs 상세 조회
		Map<String, Object> detail = adminBbsService.selectBoardDtl(param);
		model.addAttribute("detail", detail);

		// 파일 정보 조회
		List<Map<String, Object>> fileList = fileService.selectFileList(detail);
		model.addAttribute("fileList", fileList);


		model.addAttribute("holder", param);

		return adminLayout(model, "/WEB-INF/views/admin/bbs/view");

	}
}
