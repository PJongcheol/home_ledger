package devel.cmmn.menu.service;

import java.util.List;

import devel.cmmn.menu.vo.MenuVO;

/**
*
* @Class Name   : MenuService
  @Description  : 메뉴 처리를 위한 서비스

* @author  : PJC
* @date    : 2026. 1. 13
* @desc    :
* @version : 1.0
* @see
*
* 개정이력(Modification Information)
* 수정일		      수정자	     내용
* ----------------  --------  -----------------
*  2026. 1. 13.	 	PJC	      최초작성
*/
public interface MenuService {
	/**
	 * 메뉴 조회
	 * @param String
	 * @return List<MenuVO>
	 * @exception Exception
	 */
	public List<MenuVO> getMenu(String param, String authGrpCd) throws Exception;
}
