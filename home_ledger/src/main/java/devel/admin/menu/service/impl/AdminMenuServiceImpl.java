package devel.admin.menu.service.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import devel.admin.menu.mapper.AdminMenuMapper;
import devel.admin.menu.service.AdminMenuService;

/**
*
* @Class Name   : AdminMenuServiceImpl
  @Description  : 메뉴관리 처리를 위한 서비스 Impl

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

@Service("adminService")
public class AdminMenuServiceImpl implements AdminMenuService{

	@Autowired
	AdminMenuMapper adminMenuMapper;

	/**
	 * 메뉴목록 리스트 조회
	 * @param Map
	 * @return List
	 * @exception Exception
	 */
	@Override
	public List<Map<String, Object>> getMenuList(Map<String, Object> param) throws Exception {
		return menuTree(adminMenuMapper.getMenuList(param));
	}

	/**
	 * 게시물 목록 조회
	 * @param Map
	 * @return List
	 * @exception Exception
	 */
	public List<Map<String, Object>> adminBbsList(Map<String, Object> param) throws Exception {
		return adminMenuMapper.adminBbsList(param);
	}

	/**
	 * 메뉴 정렬
	 * @param List<Map<String, Object>>
	 * @return List<Map<String, Object>>
	 * @exception Exception
	 */
	private List<Map<String, Object>> menuTree(List<Map<String, Object>> menuList) throws Exception {
		List<Map<String, Object>> list = new ArrayList<>();

		for(Map<String, Object> menu : menuList) {

			// depth=1 부모 메뉴 필터링
			if("#".equals(menu.get("parent"))) {
				list.add(menu);
				childrenMenu(menu, menuList, list);
			}
		}

		return list;
	}

	/**
	 * 자식 메뉴 붙이기 DFS
	 * @param Map<String, Object>, List<Map<String, Object>>, List<Map<String, Object>>
	 * @return void
	 */
	private void childrenMenu(Map<String, Object> menu, List<Map<String, Object>> menuList, List<Map<String, Object>> list) {

	    for (Map<String, Object> child : menuList) {
	    	String id = String.valueOf(menu.get("id"));
	    	String parent = String.valueOf(child.get("parent"));
	    	if (id.equals(parent)) {
	            list.add(child);
	            childrenMenu(child, menuList, list);
	        }
	    }
	}

	/**
	 * 메뉴목록관리 저장
	 * @param Map
	 * @return void
	 * @exception Exception
	 */
	@Override
	public void insertMenu(Map<String, Object> param) throws Exception {
		adminMenuMapper.insertMenu(param);
	}

	/**
	 * 메뉴목록관리 수정
	 * @param Map
	 * @return void
	 * @exception Exception
	 */
	@Override
	public void updateMenu(Map<String, Object> param) throws Exception {
		adminMenuMapper.updateMenu(param);
	}

	/**
	 * 메뉴목록관리 삭제
	 * @param Map
	 * @return void
	 * @exception Exception
	 */
	@Override
	public void deleteMenu(Map<String, Object> param) throws Exception {
		adminMenuMapper.deleteMenu(param);
	}

	/**
	 * 메뉴권한관리 목록 조회
	 * @param Map
	 * @return List
	 * @exception Exception
	 */
	public List<Map<String, Object>> selectMenuAuthList(Map<String, Object> param) throws Exception {
		return adminMenuMapper.selectMenuAuthList(param);
	}

	/**
	 * 메뉴권한 저장
	 * @param List
	 * @return void
	 * @exception Exception
	 */
	@Override
	public void insertMenuAuth(List<Map<String, Object>> param) throws Exception {
		adminMenuMapper.insertMenuAuth(param);
	}

	/**
	 * 메뉴권한 저장
	 * @param List
	 * @return void
	 * @exception Exception
	 */
	@Override
	public void deleteMenuAuth(List<Map<String, Object>> param) throws Exception {
		adminMenuMapper.deleteMenuAuth(param);
	}

	/**
	 * 메뉴 상세 정보 조회
	 * @param Map
	 * @return Map
	 * @exception Exception
	 */
	public Map<String, Object> selectMenuDtl(Map<String, Object> param) throws Exception {
		return adminMenuMapper.selectMenuDtl(param);
	}
}
