package devel.user.book;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.DataFormatter;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import devel.cmmn.base.BaseController;
import devel.cmmn.etc.service.EtcService;
import devel.cmmn.login.vo.LoginVO;
import devel.user.book.service.UserBookService;
import devel.user.settings.service.UserSettingsService;
import jakarta.servlet.http.HttpServletRequest;
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
	@RequestMapping(value ="bookList.do")
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
	@RequestMapping(value ="bookForm.do")
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
	@RequestMapping(value ="saveBook.do")
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
	@RequestMapping(value ="deleteBook.do")
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
	@RequestMapping(value ="updateOverSpendingYn.do")
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

	/**
     * 가계부 엑셀 업로드
     * @Method : uploadExcelBook
     * @param request
     * @param response
     * @param throws
     * @throws Exception
     * @return : Map
     */
	@RequestMapping(value ="/uploadExcelBook.do")
	@ResponseBody
	public Map<String, Object> uploadExcelBook(@RequestParam Map<String, Object> param
			,@RequestParam(value="file", required=false) MultipartFile file
			, ModelMap model, HttpSession session, HttpServletRequest request) throws Exception {

		// 로그인 사용자 정보
    	LoginVO user = (LoginVO) session.getAttribute("LoginVO");
    	param.put("userId", user.getMemberId());

		Map<String, Object> result = new HashMap<>();

		if(file.isEmpty()) {
			result.put("message", "none");
		}

		try (Workbook workbook = WorkbookFactory.create(file.getInputStream())) {
			Sheet sheet = workbook.getSheetAt(0);

			int idx = 0;

			HashMap<String, Object> newParam = new HashMap<String,Object>();
			newParam.put("userId", user.getMemberId());
			newParam.put("aiSeq", param.get("layerAccount"));

			DataFormatter formatter = new DataFormatter();

			for(Row row : sheet) {
				if(idx++ < 2) {
					continue;
				}

				String tranDate 		= formatter.formatCellValue(row.getCell(0));
				String amount 			= formatter.formatCellValue(row.getCell(1));
				String inoutType 		= formatter.formatCellValue(row.getCell(2));
				String category 		= formatter.formatCellValue(row.getCell(3));
				String ciNm 			= formatter.formatCellValue(row.getCell(4));
				String overSpendingYn 	= formatter.formatCellValue(row.getCell(5));
				String remark 			= formatter.formatCellValue(row.getCell(6));

				// 거래일자 유효성
				if(tranDate == null || "".equals(tranDate) || !tranDate.matches("^\\d{4}-\\d{2}-\\d{2}$")) {
					continue;
				}

				// 금액 유효성
				if(amount == null || "".equals(amount)) {
					continue;
				}

				// 수입/지출 타입 유효성
				if(inoutType == null || "".equals(inoutType) || !("수입".equals(inoutType) || "지출".equals(inoutType))) {
					continue;
				} else {
					inoutType = "수입".equals(inoutType) ? "I" : "E";
				}

				// 카테고리 유효성
				if(category == null || "".equals(category)) {
					continue;
				}

				// 카테고리 소분류 유효성
				if(ciNm == null || "".equals(ciNm)) {
					continue;
				}

				// 과소비 여부
				if(overSpendingYn != null && !"".equals(overSpendingYn)) {
					overSpendingYn = "Y".equals(overSpendingYn) ? "Y" : "N";
				} else {
					overSpendingYn = "N";
				}

				// 해당 카테고리가 있는지 유효성
				String categoryCode = userBookService.selectExcelUploadCategoryCode(category);

				if(categoryCode == null || "".equals(categoryCode)) {
					continue;
				}

				newParam.put("tranDate", tranDate);
				newParam.put("amount", amount);
				newParam.put("inoutType", inoutType);
				newParam.put("categoryCode", categoryCode);
				newParam.put("ciNm", ciNm);
				newParam.put("overSpendingYn", overSpendingYn);
				newParam.put("remark", remark);
				newParam.put("mode", "I");

				// 카테고리 소분류 조회
				newParam.put("ciSeq", userBookService.selectExcelUploadSubCategoryCode(newParam));

				// 가계부 저장
				userBookService.saveBook(newParam);
			}
		}

		result.put("message", "ok");

		return result;

	}
}
