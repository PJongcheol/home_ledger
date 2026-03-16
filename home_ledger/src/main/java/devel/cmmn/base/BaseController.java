package devel.cmmn.base;

import org.springframework.ui.ModelMap;

/**
 * layout 관리를 위한 Base 컨트롤러
 * @Class Name   : BaseController
   @Description  : layout 관리 Controller

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

public abstract class BaseController {
	// user layout
	protected String userLayout(ModelMap model, String body) {
        model.addAttribute("body", body);
        return "layout/user/base";
    }

	// admin layout
	protected String adminLayout(ModelMap model, String body) {
        model.addAttribute("body", body);
        return "layout/admin/base";
    }
}
