package devel.admin.user;

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

import devel.admin.user.service.AdminUserService;
import devel.cmmn.base.BaseController;
import devel.cmmn.login.vo.LoginVO;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

/**
 * 사용자 관리를 위한 컨트롤러
 * @Class Name   : AdminUserController
   @Description  : 사용자관리 동작을 위한 컨트롤러

 * @author  : PJC
 * @date    : 2026. 1. 28
 * @desc    :
 * @version : 1.0
 * @see
 *
 * 개정이력(Modification Information)
 * 수정일		      수정자	     내용
 * ----------------  --------  -----------------
 *  2026. 1. 28		PJC			최초생성
 **/

@Controller
@RequestMapping("/admin/user")
public class AdminUserController extends BaseController {

	@Autowired
	private AdminUserService adminUserService;

	/**
     * 사용자관리 목록
     * @Method : userList
     * @param request
     * @param response
     * @param throws
     * @throws Exception
     * @return : String
     */
	@PostMapping(value ="/userList.do")
	public String userList(@RequestParam Map<String, Object> param
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

		// 유저 목록 카운트
		int totalCount = adminUserService.selectUserTotalCount(param);
		param.put("totalCount", totalCount);

		// 페이지 수
		int totalPage = (int) Math.ceil((double) totalCount / Integer.parseInt(param.get("pageSize").toString()));
		param.put("totalPage", totalPage);

		// 유저 목록 조회
		List<Map<String, Object>> list = adminUserService.selectUserList(param);

		model.addAttribute("list", list);
		model.addAttribute("holder", param);

		return adminLayout(model, "/WEB-INF/views/admin/user/userList");

	}

	/**
     * 사용자관리 상세
     * @Method : userDetail
     * @param request
     * @param response
     * @param throws
     * @throws Exception
     * @return : String
     */
	@PostMapping(value ="/userDetail.do")
	public String userDetail(@RequestParam Map<String, Object> param
			, ModelMap model, HttpSession session) throws Exception {

		// 유저 목록 조회
		Map<String, Object> detail = adminUserService.selectUserDetail(param);

		model.addAttribute("detail", detail);

		return adminLayout(model, "/WEB-INF/views/admin/user/userDetail");

	}

	/**
     * 사용자관리 수정
     * @Method : saveUser
     * @param request
     * @param response
     * @param throws
     * @throws Exception
     * @return : Map
     */
	@PostMapping(value ="/saveUser.do")
	@ResponseBody
	public Map<String, Object> saveUser(@RequestParam Map<String, Object> param
			, ModelMap model, HttpSession session, HttpServletRequest request) throws Exception {

		// 로그인 사용자 정보
    	LoginVO user = (LoginVO) request.getSession().getAttribute("LoginVO");
    	param.put("userId", user.getMemberId());

		Map<String, Object> result = new HashMap<>();

		adminUserService.saveUser(param);

		result.put("message", "ok");

		return result;

	}

	/**
     * 로그인 실패 카운트 초기화
     * @Method : loginCountReset
     * @param request
     * @param response
     * @param throws
     * @throws Exception
     * @return : Map
     */
	@PostMapping(value ="/loginCountReset.do")
	@ResponseBody
	public Map<String, Object> loginCountReset(@RequestParam Map<String, Object> param
			, ModelMap model, HttpSession session, HttpServletRequest request) throws Exception {

		// 로그인 사용자 정보
    	LoginVO user = (LoginVO) request.getSession().getAttribute("LoginVO");
    	param.put("userId", user.getMemberId());

		Map<String, Object> result = new HashMap<>();

		adminUserService.loginCountReset(param);

		result.put("message", "ok");

		return result;

	}

	/**
     * 로그인 이력
     * @Method : logList
     * @param request
     * @param response
     * @param throws
     * @throws Exception
     * @return : String
     */
	@PostMapping(value ="/logList.do")
	public String logList(@RequestParam Map<String, Object> param
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

		// 로그인 이력 목록 카운트
		int totalCount = adminUserService.selectLogTotalCount(param);
		param.put("totalCount", totalCount);

		// 페이지 수
		int totalPage = (int) Math.ceil((double) totalCount / Integer.parseInt(param.get("pageSize").toString()));
		param.put("totalPage", totalPage);

		// 로그인 이력 목록 조회
		List<Map<String, Object>> list = adminUserService.selectLogList(param);

		model.addAttribute("list", list);
		model.addAttribute("holder", param);

		return adminLayout(model, "/WEB-INF/views/admin/user/logList");

	}
}
