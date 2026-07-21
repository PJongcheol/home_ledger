package devel.user.budget;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import devel.cmmn.base.BaseController;
import devel.cmmn.etc.service.EtcService;
import devel.cmmn.login.vo.LoginVO;
import devel.user.budget.service.UserBudgetService;
import jakarta.servlet.http.HttpSession;

/**
 * 유저 예산을 위한 컨트롤러
 * @Class Name   : UserBudgetController
   @Description  : 유저 예산을 위한 컨트롤러

 * @author  : PJC
 * @date    : 2026. 7. 16
 * @desc    :
 * @version : 1.0
 * @see
 *
 * 개정이력(Modification Information)
 * 수정일		      수정자	     내용
 * ----------------  --------  -----------------
 *  2026. 7. 16		PJC			최초생성
 **/

@Controller
@RequestMapping("/user/budget")
public class UserBudgetController extends BaseController{

	@Autowired
	private UserBudgetService userBudgetService;

	@Autowired
	private EtcService etcService;

	/**
     * 예산 목록
     * @Method : budgetList
     * @throws Exception
     * @return : String
     */
	@RequestMapping(value ="budgetList.do")
	public String budgetList(@RequestParam Map<String, Object> param
			, ModelMap model, HttpSession session) throws Exception {

		LoginVO user = (LoginVO) session.getAttribute("LoginVO");
		param.put("userId", user.getMemberId());

		LocalDate date = LocalDate.now();
		String year = date.format(DateTimeFormatter.ofPattern("yyyy"));

		if(param.get("year") == null || "".equals(param.get("year"))) {
			param.put("year", year);
		}

		// 예산 년월 목록 조회
		model.addAttribute("list", userBudgetService.selectBudgetYearMonthList(param));
		model.addAttribute("yearList", etcService.selectYearList());

		model.addAttribute("holder", param);

		return userLayout(model, "/WEB-INF/views/user/budget/budgetList");
	}

	/**
     * 예산 폼
     * @Method : budgetForm
     * @throws Exception
     * @return : String
     */
	@RequestMapping(value ="budgetForm.do")
	public String budgetForm(@RequestParam Map<String, Object> param
			, ModelMap model, HttpSession session) throws Exception {

		LoginVO user = (LoginVO) session.getAttribute("LoginVO");
		param.put("userId", user.getMemberId());

		if("U".equals(param.get("mode"))) {
			model.addAttribute("detail", userBudgetService.selectBudgetDtl(param));
		}

		model.addAttribute("holder", param);

		return userLayout(model, "/WEB-INF/views/user/budget/budgetForm");
	}

	/**
     * 예산 저장
     * @Method : saveBudget
     * @throws Exception
     * @return : Map
     */
	@RequestMapping(value ="saveBudget.do")
	@ResponseBody
	public Map<String, Object> saveBudget(@RequestParam Map<String, Object> param
			, ModelMap model, HttpSession session) throws Exception {

		LoginVO user = (LoginVO) session.getAttribute("LoginVO");
		param.put("userId", user.getMemberId());

		Map<String, Object> result = new HashMap<>();

		userBudgetService.saveBudget(param);

		result.put("message", "ok");

		return result;
	}

	/**
     * 예산 삭제
     * @Method : deleteBudget
     * @throws Exception
     * @return : Map
     */
	@RequestMapping(value ="deleteBudget.do")
	@ResponseBody
	public Map<String, Object> deleteBudget(@RequestParam Map<String, Object> param
			, ModelMap model, HttpSession session) throws Exception {

		LoginVO user = (LoginVO) session.getAttribute("LoginVO");
		param.put("userId", user.getMemberId());

		Map<String, Object> result = new HashMap<>();

		userBudgetService.deleteBudget(param);

		result.put("message", "ok");

		return result;
	}

	/**
     * 전월 예산 불러오기
     * @Method : prevBudget
     * @throws Exception
     * @return : Map
     */
	@RequestMapping(value ="prevBudget.do")
	@ResponseBody
	public Map<String, Object> prevBudget(@RequestParam Map<String, Object> param
			, ModelMap model, HttpSession session) throws Exception {

		LoginVO user = (LoginVO) session.getAttribute("LoginVO");
		param.put("userId", user.getMemberId());

		Map<String, Object> result = new HashMap<>();

		int chk = userBudgetService.prevBudget(param);

		if(chk == 1) {
			result.put("message", "ok");
		} else {
			result.put("message", "none");
		}

		return result;
	}

	/**
     * 예산 현황
     * @Method : budgetOverview
     * @throws Exception
     * @return : String
     */
	@RequestMapping(value ="budgetOverview.do")
	public String budgetOverview(@RequestParam Map<String, Object> param
			, ModelMap model, HttpSession session) throws Exception {

		LoginVO user = (LoginVO) session.getAttribute("LoginVO");
		param.put("userId", user.getMemberId());

		LocalDate date = LocalDate.now();
		String year = date.format(DateTimeFormatter.ofPattern("yyyy"));
		String yearMonth = date.format(DateTimeFormatter.ofPattern("yyyy-MM"));

		// 파라미터에 yearMonth가 있다면 4자리 잘라서 year에 넣어주자
		if(param.get("yearMonth") == null || "".equals(param.get("yearMonth"))) {
			param.put("year", year);
			param.put("yearMonth", yearMonth);
		} else {
			param.put("year", param.get("yearMonth").toString().substring(0, 4));
		}

		// 예산 목록 조회
		model.addAttribute("list", userBudgetService.selectBudgetList(param));

		// 년월 목록 조회
		model.addAttribute("yearMonthList", etcService.selectYearMonthList());

		model.addAttribute("holder", param);

		return userLayout(model, "/WEB-INF/views/user/budget/budgetOverview");
	}
}
