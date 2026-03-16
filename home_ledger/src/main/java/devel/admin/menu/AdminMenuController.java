package devel.admin.menu;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import devel.admin.menu.service.AdminMenuService;
import devel.cmmn.base.BaseController;
import devel.cmmn.login.vo.LoginVO;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import tools.jackson.databind.ObjectMapper;

/**
 * 관리자 메뉴 관리를 위한 컨트롤러
 * @Class Name   : AdminMenuController
   @Description  : 관리자 메뉴 동작을 위한 컨트롤러

 * @author  : PJC
 * @date    : 2026. 1. 19
 * @desc    :
 * @version : 1.0
 * @see
 *
 * 개정이력(Modification Information)
 * 수정일		      수정자	     내용
 * ----------------  --------  -----------------
 *  2026. 1. 19		PJC			최초생성
 **/

@Controller
@RequestMapping("/admin/menu")
public class AdminMenuController extends BaseController {

	@Autowired
	private AdminMenuService adminMenuService;

	/**
     * 메뉴목록관리
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

		if(param.get("siteCode") == null || "".equals(param.get("siteCode"))) {
			param.put("siteCode", "admin");
		}

		// jstree에 json 형태로 넣어줘야 하기 때문에 변환
		List<Map<String, Object>> jsonData = adminMenuService.getMenuList(param);
		ObjectMapper mapper = new ObjectMapper();
		String jsonString = mapper.writeValueAsString(jsonData);

		model.addAttribute("jsonString", jsonString);

		List<Map<String, Object>> bbsList = adminMenuService.adminBbsList(param);

		model.addAttribute("bbsList", bbsList);
		model.addAttribute("holder", param);

		return adminLayout(model, "/WEB-INF/views/admin/menu/list");

	}

	/**
     * 메뉴목록관리 저장
     * @Method : saveMenu
     * @param request
     * @param response
     * @param throws
     * @throws Exception
     * @return : String
     */
	@PostMapping(value ="/saveMenu.do")
	@ResponseBody
	public Map<String, Object> saveMenu(@RequestParam Map<String, Object> param
			, ModelMap model, HttpSession session, HttpServletRequest request) throws Exception {

		// 로그인 사용자 정보
    	LoginVO user = (LoginVO) request.getSession().getAttribute("LoginVO");

    	Map<String, Object> result = new HashMap<>();

    	// 유저 정보 유무 확인
    	if(user != null && user.getMemberId() != null) {
    		param.put("userId", user.getMemberId());

    		// menuId가 없다면 insert 있다면 update
    		if(param.get("menuId") == null || "".equals(param.get("menuId"))) {
    			adminMenuService.insertMenu(param);
    		} else {
    			adminMenuService.updateMenu(param);
    		}

    		result.put("message", "ok");
    	} else {
    		result.put("message", "login");
    	}

		return result;
	}

	/**
     * 메뉴목록관리 삭제
     * @Method : deleteMenu
     * @param request
     * @param response
     * @param throws
     * @throws Exception
     * @return : Map
     */
	@PostMapping(value ="/deleteMenu.do")
	@ResponseBody
	public Map<String, Object> deleteMenu(@RequestParam Map<String, Object> param
			, ModelMap model, HttpSession session, HttpServletRequest request) throws Exception {

		// 로그인 사용자 정보
    	LoginVO user = (LoginVO) request.getSession().getAttribute("LoginVO");

		Map<String, Object> result = new HashMap<>();

		// 유저 정보 유무 확인
		if(user != null && user.getMemberId() != null) {
    		param.put("userId", user.getMemberId());

    		adminMenuService.deleteMenu(param);

    		result.put("message", "ok");
    	} else {
    		result.put("message", "login");
    	}

		return result;
	}

	/**
     * 메뉴권한관리
     * @Method : authList
     * @param request
     * @param response
     * @param throws
     * @throws Exception
     * @return : String
     */
	@PostMapping(value ="/auth/list.do")
	public String authList(@RequestParam Map<String, Object> param
			, ModelMap model, HttpSession session) throws Exception {

		if(param.get("siteCode") == null || "".equals(param.get("siteCode"))) {
			param.put("siteCode", "admin");
		}

		// jstree에 json 형태로 넣어줘야 하기 때문에 변환
		List<Map<String, Object>> jsonData = adminMenuService.getMenuList(param);
		ObjectMapper mapper = new ObjectMapper();
		String jsonString = mapper.writeValueAsString(jsonData);

		model.addAttribute("jsonString", jsonString);
		model.addAttribute("holder", param);

		return adminLayout(model, "/WEB-INF/views/admin/menu/authList");

	}

	/**
     * 메뉴권한관리 목록 조회
     * @Method : menuAuthList
     * @param request
     * @param response
     * @param throws
     * @throws Exception
     * @return : List
     */
	@PostMapping(value ="/auth/menuAuthList.do")
	@ResponseBody
	public List<List<Map<String, Object>>> menuAuthList(@RequestParam Map<String, Object> param
			, ModelMap model, HttpSession session) throws Exception {

		List<List<Map<String, Object>>> result = new ArrayList<>();
		List<Map<String, Object>> listMap1 = new ArrayList<>(); // 등록 권한
		List<Map<String, Object>> listMap2 = new ArrayList<>(); // 미등록 권한

		// 1:일반사용자 9:관리자 10:최고관리자 > 필요에 따라 추가한다.
		String[] auth = {"1", "9", "10"};

		// 단순 포함 여부만 보기 때문에 Set 사용
		// String 으로 contains를 하면 포함이라 중복 비교가 될 수 있어서 Set 사용
		Set<String> arrSet = new HashSet<>();

		// 메뉴 조회
		List<Map<String, Object>> list = adminMenuService.selectMenuAuthList(param);

		// Set에 미리 넣어준다
		for(Map<String, Object> a : list) {
			String cd = a.get("authGrpCd").toString();
			arrSet.add(cd);
		}

		for(int i=0; i<auth.length; i++) {
			Map<String, Object> map = new HashMap<>();

			map.put("authGrpCd", auth[i]);
			map.put("authNm", authCheck(auth[i]));
			if(arrSet.contains(auth[i])) {
				listMap1.add(map);
			} else {
				listMap2.add(map);
			}
		}

		// 담아준다
		result.add(listMap2);
		result.add(listMap1);

		return result;
	}

	/**
     * 메뉴권한관리 권한 저장
     * @Method : insertMenuAuth
     * @param request
     * @param response
     * @param throws
     * @throws Exception
     * @return : Map
     */
	@PostMapping(value ="/auth/insertMenuAuth.do")
	@ResponseBody
	public Map<String, Object> insertMenuAuth(@RequestParam Map<String, Object> param
			, ModelMap model, HttpSession session) throws Exception {

		Map<String, Object> result = new HashMap<>();

		String jsonData = (String) param.get("jsonData");

		ObjectMapper objectMapper = new ObjectMapper();
		List<Map<String, Object>> jsonList = objectMapper.readValue(jsonData, List.class);

		adminMenuService.insertMenuAuth(jsonList);

		result.put("message", "ok");

		return result;
	}

	/**
     * 메뉴권한관리 권한 삭제
     * @Method : deleteMenuAuth
     * @param request
     * @param response
     * @param throws
     * @throws Exception
     * @return : Map
     */
	@PostMapping(value ="/auth/deleteMenuAuth.do")
	@ResponseBody
	public Map<String, Object> deleteMenuAuth(@RequestParam Map<String, Object> param
			, ModelMap model, HttpSession session) throws Exception {

		Map<String, Object> result = new HashMap<>();

		String jsonData = (String) param.get("jsonData");

		ObjectMapper objectMapper = new ObjectMapper();
		List<Map<String, Object>> jsonList = objectMapper.readValue(jsonData, List.class);

		adminMenuService.deleteMenuAuth(jsonList);

		result.put("message", "ok");

		return result;
	}

	/**
     * 메뉴 권한명 조회 메소드
     * @Method : authCheck
     * @param String
     * @return : String
     */
	private String authCheck(String auth) throws Exception {
		String name = "";

		if("10".equals(auth)) {
			name = "최고관리자";
		} else if("9".equals(auth)) {
			name = "관리자";
		} else {
			name ="일반사용자";
		}

		return name;
	}
}
