package devel.user.settings;

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

import devel.cmmn.base.BaseController;
import devel.cmmn.etc.service.EtcService;
import devel.cmmn.login.vo.LoginVO;
import devel.user.settings.service.UserSettingsService;
import jakarta.servlet.http.HttpSession;
import tools.jackson.databind.ObjectMapper;

/**
 * 유저 설정을 위한 컨트롤러
 * @Class Name   : UserSettingsController
   @Description  : 유저 설정을 위한 컨트롤러

 * @author  : PJC
 * @date    : 2026. 3. 19
 * @desc    :
 * @version : 1.0
 * @see
 *
 * 개정이력(Modification Information)
 * 수정일		      수정자	     내용
 * ----------------  --------  -----------------
 *  2026. 3. 19		PJC			최초생성
 **/

@Controller
@RequestMapping("/user/settings")
public class UserSettingsController extends BaseController{

	@Autowired
	EtcService etcService;

	@Autowired
	UserSettingsService userSettingsService;

	/**
     * 통장/카드 관리 목록
     * @Method : accountList
     * @throws Exception
     * @return : String
     */
	@PostMapping(value ="accountList.do")
	public String accountList(@RequestParam Map<String, Object> param
			, ModelMap model, HttpSession session) throws Exception {

		LoginVO user = (LoginVO) session.getAttribute("LoginVO");
		param.put("userId", user.getMemberId());

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

		// 통장/카드 관리 목록 카운트
		int totalCount = userSettingsService.selectAccountTotalCount(param);
		param.put("totalCount", totalCount);

		// 페이지 수
		int totalPage = (int) Math.ceil((double) totalCount / Integer.parseInt(param.get("pageSize").toString()));
		param.put("totalPage", totalPage);

		// 통장/카드 관리 목록 조회
		List<Map<String, Object>> list = userSettingsService.selectAccountList(param);

		model.addAttribute("list", list);
		model.addAttribute("holder", param);

		return userLayout(model, "/WEB-INF/views/user/settings/accountList");
	}

	/**
     * 통장/카드 관리 폼
     * @Method : accountForm
     * @throws Exception
     * @return : String
     */
	@PostMapping(value ="accountForm.do")
	public String accountForm(@RequestParam Map<String, Object> param
			, ModelMap model, HttpSession session) throws Exception {

		LoginVO user = (LoginVO) session.getAttribute("LoginVO");
		param.put("userId", user.getMemberId());

		// 통장 목록 조회
		model.addAttribute("bankList", etcService.selectBankList());
		// 카드 목록 조회
		model.addAttribute("cardList", etcService.selectCardList());

		model.addAttribute("detail", userSettingsService.selectAccountDtl(param));
		model.addAttribute("holder", param);

		return userLayout(model, "/WEB-INF/views/user/settings/accountForm");
	}

	/**
     * 통장/카드 저장
     * @Method : saveAccount
     * @throws Exception
     * @return : Map
     */
	@PostMapping(value ="saveAccount.do")
	@ResponseBody
	public Map<String, Object> saveAccount(@RequestParam Map<String, Object> param
			, ModelMap model, HttpSession session) throws Exception {

		Map<String, Object> result = new HashMap<>();

		LoginVO user = (LoginVO) session.getAttribute("LoginVO");
		param.put("userId", user.getMemberId());

		userSettingsService.saveAccount(param);

		result.put("message", "ok");

		return result;
	}

	/**
     * 통장/카드 삭제
     * @Method : deleteAccount
     * @throws Exception
     * @return : Map
     */
	@PostMapping(value ="deleteAccount.do")
	@ResponseBody
	public Map<String, Object> deleteAccount(@RequestParam Map<String, Object> param
			, ModelMap model, HttpSession session) throws Exception {

		Map<String, Object> result = new HashMap<>();

		LoginVO user = (LoginVO) session.getAttribute("LoginVO");
		param.put("userId", user.getMemberId());

		userSettingsService.deleteAccount(param);

		result.put("message", "ok");

		return result;
	}

	/**
     * 카테고리 관리 목록
     * @Method : categoryList
     * @throws Exception
     * @return : String
     */
	@PostMapping(value ="categoryList.do")
	public String categoryList(@RequestParam Map<String, Object> param
			, ModelMap model, HttpSession session) throws Exception {

		LoginVO user = (LoginVO) session.getAttribute("LoginVO");
		param.put("userId", user.getMemberId());

		// 카테고리 관리 목록 조회
		List<Map<String, Object>> list = userSettingsService.selectCategoryList(param);

		model.addAttribute("list", list);

		// 카테고리 목록 조회
		model.addAttribute("categoryList", etcService.selectCategoryList());
		model.addAttribute("holder", param);

		return userLayout(model, "/WEB-INF/views/user/settings/categoryList");
	}

	/**
     * 카테고리 관리 폼
     * @Method : categoryForm
     * @throws Exception
     * @return : String
     */
	@PostMapping(value ="categoryForm.do")
	public String categoryForm(@RequestParam Map<String, Object> param
			, ModelMap model, HttpSession session) throws Exception {

		LoginVO user = (LoginVO) session.getAttribute("LoginVO");
		param.put("userId", user.getMemberId());

		// 카테고리 관리 상세 조회
		model.addAttribute("detail", userSettingsService.selectCategoryDtl(param));

		// 카테고리 목록 조회
		model.addAttribute("categoryList", etcService.selectCategoryList());

		model.addAttribute("holder", param);

		return userLayout(model, "/WEB-INF/views/user/settings/categoryForm");
	}

	/**
     * 카테고리 저장
     * @Method : saveCategory
     * @throws Exception
     * @return : Map
     */
	@PostMapping(value ="saveCategory.do")
	@ResponseBody
	public Map<String, Object> saveCategory(@RequestParam Map<String, Object> param
			, ModelMap model, HttpSession session) throws Exception {

		Map<String, Object> result = new HashMap<>();

		LoginVO user = (LoginVO) session.getAttribute("LoginVO");
		param.put("userId", user.getMemberId());

		userSettingsService.saveCategory(param);

		result.put("message", "ok");

		return result;
	}

	/**
     * 카테고리 삭제
     * @Method : deleteCategory
     * @throws Exception
     * @return : Map
     */
	@PostMapping(value ="deleteCategory.do")
	@ResponseBody
	public Map<String, Object> deleteCategory(@RequestParam Map<String, Object> param
			, ModelMap model, HttpSession session) throws Exception {

		Map<String, Object> result = new HashMap<>();

		LoginVO user = (LoginVO) session.getAttribute("LoginVO");
		param.put("userId", user.getMemberId());

		userSettingsService.deleteCategory(param);

		result.put("message", "ok");

		return result;
	}

	/**
     * 고정지출 관리 목록
     * @Method : fixedExpenseList
     * @throws Exception
     * @return : String
     */
	@PostMapping(value ="fixedExpenseList.do")
	public String fixedExpenseList(@RequestParam Map<String, Object> param
			, ModelMap model, HttpSession session) throws Exception {

		LoginVO user = (LoginVO) session.getAttribute("LoginVO");
		param.put("userId", user.getMemberId());

		// 고정지출 관리 목록 조회
		List<Map<String, Object>> list = userSettingsService.selectFixedExpenseList(param);

		model.addAttribute("list", list);
		model.addAttribute("holder", param);

		return userLayout(model, "/WEB-INF/views/user/settings/fixedExpenseList");
	}

	/**
     * 고정지출 관리 폼
     * @Method : fixedExpenseForm
     * @throws Exception
     * @return : String
     */
	@PostMapping(value ="fixedExpenseForm.do")
	public String fixedExpenseForm(@RequestParam Map<String, Object> param
			, ModelMap model, HttpSession session) throws Exception {

		LoginVO user = (LoginVO) session.getAttribute("LoginVO");
		param.put("userId", user.getMemberId());

		// 카테고리 관리 상세 조회
		model.addAttribute("detail", userSettingsService.selectFixedExpenseDtl(param));

		// 카테고리 목록 조회
		model.addAttribute("categoryList", etcService.selectCategoryList());

		// 통장/카드 목록
		model.addAttribute("accountList", etcService.selectAccountList(param));

		model.addAttribute("holder", param);

		return userLayout(model, "/WEB-INF/views/user/settings/fixedExpenseForm");
	}

	/**
     * 카테고리 소분류 조회
     * @Method : selectCategory
     * @throws Exception
     * @return : Map
     */
	@PostMapping(value ="selectCategory.do")
	@ResponseBody
	public Map<String, Object> selectCategory(@RequestParam Map<String, Object> param
			, ModelMap model, HttpSession session) throws Exception {

		Map<String, Object> result = new HashMap<>();

		LoginVO user = (LoginVO) session.getAttribute("LoginVO");
		param.put("userId", user.getMemberId());

		result.put("list", userSettingsService.selectCategory(param));

		result.put("message", "ok");

		return result;
	}

	/**
     * 고정지출 저장
     * @Method : saveFixedExpense
     * @throws Exception
     * @return : Map
     */
	@PostMapping(value ="saveFixedExpense.do")
	@ResponseBody
	public Map<String, Object> saveFixedExpense(@RequestParam Map<String, Object> param
			, ModelMap model, HttpSession session) throws Exception {

		Map<String, Object> result = new HashMap<>();

		LoginVO user = (LoginVO) session.getAttribute("LoginVO");
		param.put("userId", user.getMemberId());

		userSettingsService.saveFixedExpense(param);

		result.put("message", "ok");

		return result;
	}

	/**
     * 고정지출 삭제
     * @Method : deleteFixedExpense
     * @throws Exception
     * @return : Map
     */
	@PostMapping(value ="deleteFixedExpense.do")
	@ResponseBody
	public Map<String, Object> deleteFixedExpense(@RequestParam Map<String, Object> param
			, ModelMap model, HttpSession session) throws Exception {

		Map<String, Object> result = new HashMap<>();

		LoginVO user = (LoginVO) session.getAttribute("LoginVO");
		param.put("userId", user.getMemberId());

		userSettingsService.deleteFixedExpense(param);

		result.put("message", "ok");

		return result;
	}

	/**
     * 가계부 목록 관리
     * @Method : bookViewConfig
     * @throws Exception
     * @return : String
     */
	@PostMapping(value ="bookViewConfig.do")
	public String bookViewConfig(@RequestParam Map<String, Object> param
			, ModelMap model, HttpSession session) throws Exception {

		LoginVO user = (LoginVO) session.getAttribute("LoginVO");
		param.put("userId", user.getMemberId());

		// 사용 가능 가계부 목록 조회
		model.addAttribute("useList", userSettingsService.selectUseBookViewConfigList(param));

		// 사용중인 가계부 목록 조회
		model.addAttribute("usedList", userSettingsService.selectUsedBookViewConfigList(param));

		model.addAttribute("holder", param);

		return userLayout(model, "/WEB-INF/views/user/settings/bookViewConfig");
	}

	/**
     * 가계부 목록 추가
     * @Method : addBookViewConfig
     * @throws Exception
     * @return : Map
     */
	@PostMapping(value ="addBookViewConfig.do")
	@ResponseBody
	public Map<String, Object> addBookViewConfig(@RequestParam Map<String, Object> param
			, ModelMap model, HttpSession session) throws Exception {

		LoginVO user = (LoginVO) session.getAttribute("LoginVO");
		param.put("userId", user.getMemberId());

		Map<String, Object> result = new HashMap<>();

		userSettingsService.addBookViewConfig(param);

		result.put("message", "ok");

		return result;
	}

	/**
     * 가계부 목록 정렬 저장
     * @Method : orderBookViewConfig
     * @throws Exception
     * @return : Map
     */
	@PostMapping(value ="orderBookViewConfig.do")
	@ResponseBody
	public Map<String, Object> orderBookViewConfig(@RequestParam Map<String, Object> param
			, ModelMap model, HttpSession session) throws Exception {

		LoginVO user = (LoginVO) session.getAttribute("LoginVO");
		param.put("userId", user.getMemberId());

		Map<String, Object> result = new HashMap<>();

		userSettingsService.orderBookViewConfig(param);

		result.put("message", "ok");

		return result;
	}

	/**
     * 가계부 목록 삭제
     * @Method : deleteBookViewConfig
     * @throws Exception
     * @return : Map
     */
	@PostMapping(value ="deleteBookViewConfig.do")
	@ResponseBody
	public Map<String, Object> deleteBookViewConfig(@RequestParam Map<String, Object> param
			, ModelMap model, HttpSession session) throws Exception {

		LoginVO user = (LoginVO) session.getAttribute("LoginVO");
		param.put("userId", user.getMemberId());

		Map<String, Object> result = new HashMap<>();

		userSettingsService.deleteBookViewConfig(param);

		result.put("message", "ok");

		return result;
	}
}
