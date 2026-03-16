package devel.admin.main;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import devel.admin.main.service.AdminMainService;
import devel.cmmn.base.BaseController;
import jakarta.servlet.http.HttpSession;

/**
 * 관리자 메인 관리를 위한 컨트롤러
 * @Class Name   : AdminMainController
   @Description  : 관리자 대시보드 및 대시보드 동작을 위한 컨트롤러

 * @author  : PJC
 * @date    : 2026. 1. 13
 * @desc    :
 * @version : 1.0
 * @see
 *
 * 개정이력(Modification Information)
 * 수정일		      수정자	     내용
 * ----------------  --------  -----------------
 *  2026. 1. 13		PJC			최초생성
 **/

@Controller
@RequestMapping("/admin/main")
public class AdminMainController extends BaseController{
	@Autowired
	AdminMainService adminMainService;

	@Value("${file.upload.url}")
	private String uploadUrl;

	/**
     * 메인 대시보드
     * @Method : index
     * @throws Exception
     * @return : String
     */
	@PostMapping(value ="/index.do")
	public String loginRedirect(@RequestParam Map<String, Object> param
			, ModelMap model, HttpSession session) throws Exception {

		// 팝업 목록 조회
		model.addAttribute("popupList", adminMainService.selectPopupList());
		model.addAttribute("uploadUrl", uploadUrl);

		// 대시보드 상단 조회
		model.addAttribute("top", adminMainService.selectIndexTop());

		// 대시보드 회원목록 조회
		model.addAttribute("userList", adminMainService.selectIndexMemberList());

		// 대시보드 공지사항 조회
		param.put("bbsSeq", "1"); // 공지사항 - 추후 대시보드를 공지사항 대신 바꾸고 싶다면 bbsSeq를 변경(board인 경우)
		model.addAttribute("noticeList", adminMainService.selectBbsList(param));

		return adminLayout(model, "/WEB-INF/views/admin/main/index");

	}

	/**
     * 팝업 호출
     * @Method : windowPopup
     * @throws Exception
     * @return : String
     */
	@GetMapping(value ="/windowPopup.do")
	public String windowPopup(@RequestParam Map<String, Object> param
			, ModelMap model, HttpSession session) throws Exception {

		// 팝업 조회
		Map<String, Object> popup = adminMainService.selectPopup(param);
		model.addAttribute("popup", popup);
		model.addAttribute("uploadUrl", uploadUrl);

		return "/admin/main/popup/popup";

	}
}
