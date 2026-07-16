package devel.user.main;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import devel.cmmn.base.BaseController;
import devel.cmmn.login.vo.LoginVO;
import devel.user.main.service.UserMainService;
import jakarta.servlet.http.HttpSession;
import tools.jackson.databind.ObjectMapper;

/**
 * 메인 관리를 위한 컨트롤러
 * @Class Name   : UserMainController
   @Description  : 메인 관리를 위한 컨트롤러

 * @author  : PJC
 * @date    : 2026. 1. 12
 * @desc    :
 * @version : 1.0
 * @see
 *
 * 개정이력(Modification Information)
 * 수정일		      수정자	     내용
 * ----------------  --------  -----------------
 *  2026. 1. 12		PJC			최초생성
 **/

@Controller
@RequestMapping("/user/main")
public class UserMainController extends BaseController{
	@Autowired
	private UserMainService userMainService;

	/**
     * 메인 대시보드
     * @Method : dashboard
     * @param request
     * @param response
     * @param throws
     * @throws Exception
     * @return : String
     */
	@RequestMapping(value ="/dashboard.do")
	public String dashboard(@RequestParam Map<String, Object> param
			, ModelMap model, HttpSession session) throws Exception {

		return "redirect:/user/main/index.do";

	}

	/**
     * 메인 대시보드
     * @Method : index
     * @param request
     * @param response
     * @param throws
     * @throws Exception
     * @return : String
     */
	@RequestMapping(value ="/index.do")
	public String loginRedirect(@RequestParam Map<String, Object> param
			, ModelMap model, HttpSession session) throws Exception {

		LoginVO user = (LoginVO) session.getAttribute("LoginVO");
		param.put("userId", user.getMemberId());

		LocalDate now = LocalDate.now();
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM");

		ObjectMapper mapper = new ObjectMapper();

		// 현재달
		model.addAttribute("month", now.getMonthValue());

		// 현재 년월
		param.put("nowYearMonth", now.format(formatter));

		// 저번달 년월
		LocalDate lastMonth = now.minusMonths(1);
		param.put("lastYearMonth", lastMonth.format(formatter));

		// 대시보드 상단 간략 정보 조회
		model.addAttribute("topInfo", userMainService.selectMainTopInfo(param));

		// 해당월 카테고리별 지출 조회
		model.addAttribute("categoryList", mapper.writeValueAsString(userMainService.selectMainCategoryList(param)));

		// 해당월 과소비 체크 금액 조회
		model.addAttribute("spendingList", mapper.writeValueAsString(userMainService.selectMainSpendingList(param)));

		// 해당월 통장/카드 수입/지출 금액 조회
		model.addAttribute("accountAmountList", userMainService.selectMainAccountAmountList(param));

		// 총 적금 목표 달성률 조회
		model.addAttribute("savingGoalLate", userMainService.selectSavingGoalLate(param));

		return userLayout(model, "/WEB-INF/views/user/main/index");

	}
}
