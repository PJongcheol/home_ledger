package devel.user.book;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
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
import devel.user.book.service.UserBookService;
import devel.user.settings.service.UserSettingsService;
import jakarta.servlet.http.HttpSession;

/**
 * 유저 가계부를 위한 컨트롤러
 * @Class Name   : UserBookController
   @Description  : 유저 가계부를 위한 컨트롤러

 * @author  : PJC
 * @date    : 2026. 3. 31
 * @desc    :
 * @version : 1.0
 * @see
 *
 * 개정이력(Modification Information)
 * 수정일		      수정자	     내용
 * ----------------  --------  -----------------
 *  2026. 3. 31		PJC			최초생성
 **/

@Controller
@RequestMapping("/user/book")
public class UserBookController extends BaseController{
	@Autowired
	private UserSettingsService userSettingsService;

	@Autowired
	private UserBookService userBookService;

	@Autowired
	private EtcService etcService;

	/**
     * 가계부 목록
     * @Method : bookList
     * @throws Exception
     * @return : String
     */
	@PostMapping(value ="bookList.do")
	public String bookList(@RequestParam Map<String, Object> param
			, ModelMap model, HttpSession session) throws Exception {

		LoginVO user = (LoginVO) session.getAttribute("LoginVO");
		param.put("userId", user.getMemberId());

		LocalDate date = LocalDate.now();
		String yearMonth = date.format(DateTimeFormatter.ofPattern("yyyy-MM"));
		LocalDate endOfMonth = date.withDayOfMonth(date.lengthOfMonth());
		String resetBeginDe = yearMonth + "-01";
		String resetEndDe = endOfMonth.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));

		param.put("resetBeginDe", resetBeginDe);
		param.put("resetEndDe", resetEndDe);

		if(param.get("beginDe") == null || "".equals(param.get("beginDe"))) {
			param.put("beginDe", resetBeginDe);
		}

		if(param.get("endDe") == null || "".equals(param.get("endDe"))) {
			param.put("endDe", resetEndDe);
		}

		// 가계부 총 수입 지출 건수 조회
		model.addAttribute("total", userBookService.selectBookTotalAmount(param));

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

		// 가계부 목록 카운트
		int totalCount = userBookService.selectBookTotalCount(param);
		param.put("totalCount", totalCount);

		// 페이지 수
		int totalPage = (int) Math.ceil((double) totalCount / Integer.parseInt(param.get("pageSize").toString()));
		param.put("totalPage", totalPage);

		// 가계부 목록 조회
		List<Map<String, Object>> list = userBookService.selectBookList(param);
		model.addAttribute("list", list);

		// 가계부 목록 관리
		model.addAttribute("bookView", userSettingsService.selectBookViewList(param));

		// 통장/카드 목록
		model.addAttribute("accountList",  userSettingsService.selectFiexedExpenseAccountList(param));

		model.addAttribute("holder", param);

		return userLayout(model, "/WEB-INF/views/user/book/bookList");
	}

	/**
     * 가계부 폼
     * @Method : bookForm
     * @throws Exception
     * @return : String
     */
	@PostMapping(value ="bookForm.do")
	public String bookForm(@RequestParam Map<String, Object> param
			, ModelMap model, HttpSession session) throws Exception {

		LoginVO user = (LoginVO) session.getAttribute("LoginVO");
		param.put("userId", user.getMemberId());

		model.addAttribute("detail", userBookService.selectBookDtl(param));

		// 카테고리 목록 조회
		model.addAttribute("categoryList", etcService.selectCategoryList());

		// 통장/카드 목록
		model.addAttribute("accountList", etcService.selectAccountList(param));

		model.addAttribute("holder", param);

		return userLayout(model, "/WEB-INF/views/user/book/bookForm");
	}

	/**
     * 가계부 저장
     * @Method : saveBook
     * @throws Exception
     * @return : Map
     */
	@PostMapping(value ="saveBook.do")
	@ResponseBody
	public Map<String, Object> saveBook(@RequestParam Map<String, Object> param
			, ModelMap model, HttpSession session) throws Exception {

		Map<String, Object> result = new HashMap<>();

		LoginVO user = (LoginVO) session.getAttribute("LoginVO");
		param.put("userId", user.getMemberId());

		userBookService.saveBook(param);

		result.put("message", "ok");
		return result;
	}

	/**
     * 가계부 삭제
     * @Method : deleteBook
     * @throws Exception
     * @return : Map
     */
	@PostMapping(value ="deleteBook.do")
	@ResponseBody
	public Map<String, Object> deleteBook(@RequestParam Map<String, Object> param
			, ModelMap model, HttpSession session) throws Exception {

		Map<String, Object> result = new HashMap<>();

		LoginVO user = (LoginVO) session.getAttribute("LoginVO");
		param.put("userId", user.getMemberId());

		userBookService.deleteBook(param);

		result.put("message", "ok");
		return result;
	}

	/**
     * 가계부 과소비 체크
     * @Method : updateOverSpendingYn
     * @throws Exception
     * @return : Map
     */
	@PostMapping(value ="updateOverSpendingYn.do")
	@ResponseBody
	public Map<String, Object> updateOverSpendingYn(@RequestParam Map<String, Object> param
			, ModelMap model, HttpSession session) throws Exception {

		Map<String, Object> result = new HashMap<>();

		LoginVO user = (LoginVO) session.getAttribute("LoginVO");
		param.put("userId", user.getMemberId());

		userBookService.updateOverSpendingYn(param);

		result.put("message", "ok");
		return result;
	}
}
