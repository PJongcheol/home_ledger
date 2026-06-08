package devel.user.statistics;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
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
import devel.user.statistics.service.UserStatisticsService;
import jakarta.servlet.http.HttpSession;
import tools.jackson.databind.ObjectMapper;

/**
 * 유저 가계부 통계를 위한 컨트롤러
 * @Class Name   : UserStatisticsController
   @Description  : 유저 가계부 통계를 위한 컨트롤러

 * @author  : PJC
 * @date    : 2026. 4. 8
 * @desc    :
 * @version : 1.0
 * @see
 *
 * 개정이력(Modification Information)
 * 수정일		      수정자	     내용
 * ----------------  --------  -----------------
 *  2026. 4. 8		PJC			최초생성
 **/

@Controller
@RequestMapping("/user/statistics")
public class UserStatisticsController extends BaseController {

	@Autowired
	UserStatisticsService userStatisticsService;

	@Autowired
	EtcService etcService;

	/**
     * 통계 form
     * @Method : form
     * @throws Exception
     * @return : String
     */
	@PostMapping(value ="form.do")
	public String form(@RequestParam Map<String, Object> param
			, ModelMap model, HttpSession session) throws Exception {

		LoginVO user = (LoginVO) session.getAttribute("LoginVO");
		param.put("userId", user.getMemberId());

		LocalDate date = LocalDate.now();
		String year = date.format(DateTimeFormatter.ofPattern("yyyy"));
		String yearMonth = date.format(DateTimeFormatter.ofPattern("yyyy-MM"));
		LocalDate endOfMonth = date.withDayOfMonth(date.lengthOfMonth());
		String endDe = endOfMonth.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));

		ObjectMapper mapper = new ObjectMapper();

		// 년 목록
		model.addAttribute("yearList", etcService.selectYearList());

		// 카테고리별 소비 내역
		param.put("categoryBeginDe", yearMonth + "-01");
		param.put("categoryEndDe", endDe);
		model.addAttribute("categoryTotalList", mapper.writeValueAsString(userStatisticsService.selectCategoryTotalList(param)));

		// 과소비 체크 월별 총 금액
		param.put("spendingYear", year);
		model.addAttribute("spendingTotalList", mapper.writeValueAsString(userStatisticsService.selectSpendingTotalList(param)));

		// 수입/지출 월별 총 금액
		param.put("inoutYear", year);
		model.addAttribute("inoutTotalList", mapper.writeValueAsString(userStatisticsService.selectInoutTotalList(param)));

		// 수입/지출 월별 상세 내역

		model.addAttribute("holder", param);

		return userLayout(model, "/WEB-INF/views/user/statistics/form");
	}

	/**
     * 차트 조회 Ajax
     * @Method : selectChartAjax
     * @throws Exception
     * @return : String
     */
	@PostMapping(value ="selectChartAjax.do")
	@ResponseBody
	public Map<String, Object> selectChartAjax(@RequestParam Map<String, Object> param
			, ModelMap model, HttpSession session) throws Exception {

		LoginVO user = (LoginVO) session.getAttribute("LoginVO");
		param.put("userId", user.getMemberId());

		ObjectMapper mapper = new ObjectMapper();
		Map<String, Object> result = new HashMap<>();

		if("categoryBeginDe".equals(param.get("id")) || "categoryEndDe".equals(param.get("id"))) { // 카테고리
			result.put("selectList", mapper.writeValueAsString(userStatisticsService.selectCategoryTotalList(param)));
		} else if("spendingYear".equals(param.get("id"))) { // 과소비
			param.put("spendingYear", param.get("value"));
			result.put("selectList", mapper.writeValueAsString(userStatisticsService.selectSpendingTotalList(param)));
		} else if("inoutYear".equals(param.get("id"))) { // 수입/지출
			param.put("inoutYear", param.get("value"));
			result.put("selectList", mapper.writeValueAsString(userStatisticsService.selectInoutTotalList(param)));
		}

		result.put("message", "ok");

		return result;
	}

	/**
     * chart2Layer 목록 조회
     * @Method : selectChart2List
     * @throws Exception
     * @return : String
     */
	@PostMapping(value ="selectChart2List.do")
	@ResponseBody
	public Map<String, Object> selectChart2List(@RequestParam Map<String, Object> param
			, ModelMap model, HttpSession session) throws Exception {

		LoginVO user = (LoginVO) session.getAttribute("LoginVO");
		param.put("userId", user.getMemberId());

		Map<String, Object> result = new HashMap<>();

		result.put("selectList", userStatisticsService.selectSpendingList(param));
		result.put("message", "ok");

		return result;
	}
}
