package devel.admin.menu.service;

import java.util.List;
import java.util.Map;

/**
*
* @Class Name   : AdminMenuService
  @Description  : 메뉴관리 처리를 위한 서비스

* @author  : PJC
* @date    : 2026. 1. 19
* @desc    :
* @version : 1.0
* @see
*
* 개정이력(Modification Information)
* 수정일		      수정자	     내용
* ----------------  --------  -----------------
*  2026. 1. 19.	 	PJC	      최초작성
*/

public interface AdminMenuService {
	/**
	 * 메뉴목록 리스트 조회
	 * @param Map
	 * @return List
	 * @exception Exception
	 */
	public List<Map<String, Object>> getMenuList(Map<String, Object> param) throws Exception;

	/**
	 * 게시물 목록 조회
	 * @param Map
	 * @return List
	 * @exception Exception
	 */
	public List<Map<String, Object>> adminBbsList(Map<String, Object> param) throws Exception;

	/**
	 * 메뉴목록관리 저장
	 * @param Map
	 * @return void
	 * @exception Exception
	 */
	public void insertMenu(Map<String, Object> param) throws Exception;

	/**
	 * 메뉴목록관리 수정
	 * @param Map
	 * @return void
	 * @exception Exception
	 */
	public void updateMenu(Map<String, Object> param) throws Exception;

	/**
	 * 메뉴목록관리 삭제
	 * @param Map
	 * @return void
	 * @exception Exception
	 */
	public void deleteMenu(Map<String, Object> param) throws Exception;

	/**
	 * 메뉴권한관리 목록 조회
	 * @param Map
	 * @return List
	 * @exception Exception
	 */
	public List<Map<String, Object>> selectMenuAuthList(Map<String, Object> param) throws Exception;

	/**
	 * 메뉴권한 저장
	 * @param List
	 * @return void
	 * @exception Exception
	 */
	public void insertMenuAuth(List<Map<String, Object>> param) throws Exception;

	/**
	 * 메뉴권한 삭제
	 * @param List
	 * @return void
	 * @exception Exception
	 */
	public void deleteMenuAuth(List<Map<String, Object>> param) throws Exception;

	/**
	 * 메뉴 상세 정보 조회
	 * @param Map
	 * @return Map
	 * @exception Exception
	 */
	public Map<String, Object> selectMenuDtl(Map<String, Object> param) throws Exception;
}
