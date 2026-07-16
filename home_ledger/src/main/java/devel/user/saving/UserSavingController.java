package devel.user.saving;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import devel.cmmn.base.BaseController;
import devel.cmmn.login.vo.LoginVO;
import devel.user.saving.service.UserSavingService;
import jakarta.servlet.http.HttpSession;

/**
 * 유저 가계부를 위한 컨트롤러
 * @Class Name   : UserSavingController
   @Description  : 유저 적금 현황을 위한 컨트롤러

 * @author  : PJC
 * @date    : 2026. 7. 13
 * @desc    :
 * @version : 1.0
 * @see
 *
 * 개정이력(Modification Information)
 * 수정일		      수정자	     내용
 * ----------------  --------  -----------------
 *  2026. 7. 13		PJC			최초생성
 **/

@Controller
@RequestMapping("/user/saving")
public class UserSavingController extends BaseController{
	@Autowired
	private UserSavingService userSavingService;

	/**
     * 적금 현황 목록
     * @Method : list
     * @throws Exception
     * @return : String
     */
	@RequestMapping(value ="list.do")
	public String list(@RequestParam Map<String, Object> param
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

		// 적금 현황 목록 건수
		int totalCount = userSavingService.selectSavingTotalCount(param);
		param.put("totalCount", totalCount);

		// 페이지 수
		int totalPage = (int) Math.ceil((double) totalCount / Integer.parseInt(param.get("pageSize").toString()));
		param.put("totalPage", totalPage);

		// 적금 현황 목록 조회
		List<Map<String, Object>> list = userSavingService.selectSavingList(param);
		model.addAttribute("list", list);

		model.addAttribute("holder", param);

		return userLayout(model, "/WEB-INF/views/user/saving/list");
	}

	/**
     * 적금 현황 목록
     * @Method : form
     * @throws Exception
     * @return : String
     */
	@RequestMapping(value ="form.do")
	public String form(@RequestParam Map<String, Object> param
			, ModelMap model, HttpSession session) throws Exception {

		LoginVO user = (LoginVO) session.getAttribute("LoginVO");
		param.put("userId", user.getMemberId());

		if("U".equals(param.get("mode"))) {
			model.addAttribute("detail", userSavingService.selectSavingDtl(param));
		}

		model.addAttribute("holder", param);

		return userLayout(model, "/WEB-INF/views/user/saving/form");
	}

	/**
     * 적금 현황 저장
     * @Method : saveSaving
     * @throws Exception
     * @return : String
     */
	@RequestMapping(value ="saveSaving.do")
	@ResponseBody
	public Map<String, Object> saveSaving(@RequestParam Map<String, Object> param
			, ModelMap model, HttpSession session) throws Exception {

		LoginVO user = (LoginVO) session.getAttribute("LoginVO");
		param.put("userId", user.getMemberId());

		Map<String, Object> result = new HashMap<>();

		userSavingService.saveSaving(param);

		result.put("message", "ok");

		return result;
	}

	/**
     * 적금 현황 삭제
     * @Method : deleteSaving
     * @throws Exception
     * @return : String
     */
	@RequestMapping(value ="deleteSaving.do")
	@ResponseBody
	public Map<String, Object> deleteSaving(@RequestParam Map<String, Object> param
			, ModelMap model, HttpSession session) throws Exception {

		LoginVO user = (LoginVO) session.getAttribute("LoginVO");
		param.put("userId", user.getMemberId());

		Map<String, Object> result = new HashMap<>();

		userSavingService.deleteSaving(param);

		result.put("message", "ok");

		return result;
	}
}
