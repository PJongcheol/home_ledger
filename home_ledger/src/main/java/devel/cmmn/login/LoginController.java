package devel.cmmn.login;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import devel.cmmn.login.service.LoginService;
import devel.cmmn.login.vo.LoginVO;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * 로그인을 위한 컨트롤러
 * @Class Name   : LoginController
   @Description  : 로그인 및 로그아웃을 처리하는 Controller

 * @author  : PJC
 * @date    : 2026. 1. 5
 * @desc    :
 * @version : 1.0
 * @see
 *
 * 개정이력(Modification Information)
 * 수정일		      수정자	     내용
 * ----------------  --------  -----------------
 *  2026. 1. 5		PJC			최초생성
 **/
@Controller
public class LoginController {

	@Autowired
	private LoginService loginService;

	/**
     * 로그인 화면 redirect
     * @Method : loginRedirect
     * @param request
     * @param response
     * @param throws
     * @throws Exception
     * @return : String
     */
	@GetMapping(value ="/")
	public String loginRedirect(@RequestParam Map<String, Object> param
			, ModelMap model, HttpSession session) throws Exception {

		return "redirect:/login.do";

	}

	/**
     * 로그인 화면
     * @Method : login
     * @param request
     * @param response
     * @param throws
     * @throws Exception
     * @return : String
     */
	@GetMapping(value ="/login.do")
	public String login(@RequestParam Map<String, Object> param
			, ModelMap model, HttpSession session) throws Exception {

		session.removeAttribute("LoginVO");
		model.addAttribute("message", model.get("message"));

		return "dcms/login";

	}

	/**
     * 로그인 처리
     * @Method : actionLogin
     * @param request
     * @param response
     * @param throws
     * @throws Exception
     * @return : String
     */
	@PostMapping(value ="/login/actionLogin.do")
	public String actionLogin( HttpServletRequest req, HttpServletResponse response
			, @RequestParam Map<String, Object> param
			, ModelMap model, HttpSession session
			, RedirectAttributes redirectAttributes) throws Exception {

		String message = "";

		// 잘못된 정보를 확인할 수 있게 int가 아닌 string으로 null 체크
		String cnt = loginService.selectLoginFailCnt(param);

		if(cnt == null) {
			message = "잘못된 정보입니다. 관리자에게 문의 바랍니다.";
			redirectAttributes.addFlashAttribute("message", message);
			return "redirect:/login.do";
		}

		if(Integer.parseInt(cnt) > 4) {
			message = "비밀번호 5회 이상 오류로 계정이 차단 되었습니다. 관리자에게 문의 바랍니다.";
			redirectAttributes.addFlashAttribute("message", message);
			return "redirect:/login.do";
		}

		// 미리 실패 카운트를 올려준다.
		int failCnt = Integer.parseInt(cnt) + 1;
		param.put("failCnt", failCnt);

		// 이력을 남기기 위해 IP조회
		param.put("loginIp", req.getRemoteAddr());

		LoginVO loginVo = loginService.actionLogin(param);

		// 패스워드 틀렸을 시
		if(loginVo == null) {
			message = "비밀번호가 틀렸습니다. 다시 시도해주세요.";
			redirectAttributes.addFlashAttribute("message", message);
			return "redirect:/login.do";
		}

		// 승인이 된 아이디인지 확인
		String confmYn = loginService.selectConfmYn(param);

		if("N".equals(confmYn)) {
			message = "승인되지 않은 계정입니다. 관리자에게 문의 바랍니다.";
			redirectAttributes.addFlashAttribute("message", message);
			return "redirect:/login.do";
		}

		// 최종 로그인 일시를 업데이트 시켜준다.
		String memberId = loginVo.getMemberId();
		loginService.updateLastLogin(memberId);

		// session에 저장
		req.getSession().setAttribute("LoginVO", loginVo);

		return "redirect:/user/main/index.do";
	}

	/**
     * 회원가입 화면
     * @Method : signUpForm
     * @param request
     * @param response
     * @param throws
     * @throws Exception
     * @return : String
     */
	@GetMapping(value ="/login/signUp.do")
	public String signUpForm(@RequestParam Map<String, Object> param
			, ModelMap model, HttpSession session) throws Exception {

		session.removeAttribute("LoginVO");

		return "dcms/signUp";

	}

	/**
     * 아이디 중복검사
     * @Method : checkId
     * @param request
     * @param response
     * @param throws
     * @throws Exception
     * @return : map
     */
	@PostMapping(value ="/login/checkId.do")
	@ResponseBody
	public Map<String, Object> checkId(@RequestParam Map<String, Object> param
			, ModelMap model, HttpSession session) throws Exception {

		Map<String, Object> result = new HashMap<>();

		// 중복 카운트
		int chk = loginService.checkId(param);

		if(chk > 0) {
			result.put("message", "dup");
		} else {
			result.put("message", "ok");
		}

		return result;

	}

	/**
     * 회원가입 저장 처리
     * @Method : signUpSave
     * @param request
     * @param response
     * @param throws
     * @throws Exception
     * @return : map
     */
	@PostMapping(value ="/login/signUpSave.do")
	@ResponseBody
	public Map<String, Object> signUpSave(@RequestParam Map<String, Object> param
			, ModelMap model, HttpSession session) throws Exception {
		Map<String, Object> result = new HashMap<>();

		loginService.insertSignUp(param);

		result.put("message", "ok");

		return result;

	}

	/**
     * 아이디 찾기 폼
     * @Method : searchIdForm
     * @param request
     * @param response
     * @param throws
     * @throws Exception
     * @return : String
     */
	@GetMapping(value ="/login/searchId.do")
	public String searchId(@RequestParam Map<String, Object> param
			, ModelMap model, HttpSession session) throws Exception {

		session.removeAttribute("LoginVO");

		return "dcms/searchId";

	}

	/**
     * 아이디 찾기 ajax
     * @Method : searchUserId
     * @param request
     * @param response
     * @param throws
     * @throws Exception
     * @return : map
     */
	@PostMapping(value ="/login/searchUserId.do")
	@ResponseBody
	public Map<String, Object> searchUserId(@RequestParam Map<String, Object> param
			, ModelMap model, HttpSession session) throws Exception {
		Map<String, Object> result = new HashMap<>();
		Map<String, Object> detail = loginService.selectId(param);

		result.put("detail", detail);
		result.put("message", "ok");

		return result;

	}

	/**
     * 로그아웃
     * @Method : logout
     * @param request
     * @param response
     * @param throws
     * @throws Exception
     * @return : map
     */
	@GetMapping(value ="/login/logout.do")
	public String logout(@RequestParam Map<String, Object> param
			, ModelMap model, HttpSession session) throws Exception {
		Map<String, Object> result = new HashMap<>();

		session.removeAttribute("LoginVO");

		return "redirect:/login.do";
	}
}
