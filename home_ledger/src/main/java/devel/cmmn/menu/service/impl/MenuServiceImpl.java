package devel.cmmn.menu.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;

import devel.cmmn.menu.comparator.MenuComparator;
import devel.cmmn.menu.mapper.MenuMapper;
import devel.cmmn.menu.service.MenuService;
import devel.cmmn.menu.vo.MenuVO;

/**
*
* @Class Name   : MenuServiceImpl
  @Description  : 메뉴 처리를 위한 서비스 Impl

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

@Service
public class MenuServiceImpl implements MenuService{

	@Autowired
	private MenuMapper menuMapper;

	/**
	 * 메뉴 조회
	 * @param String
	 * @return List<MenuVO>
	 * @exception Exception
	 */
	@Cacheable(
	    value = "MENU",
	    key = "#param"
	)
	@Override
	public List<MenuVO> getMenu(String param, String authGrpCd) throws Exception {
		Map<String, Object> newParam = new HashMap<>();

		newParam.put("authGrpCd", authGrpCd);

		if("admin".equals(param)) {
			newParam.put("siteCode", "admin");
		} else {
			newParam.put("siteCode", "user");
		}

		List<MenuVO> menuList = menuTree(menuMapper.getMenu(newParam));

		return menuList;
	}

	/**
	 * 메뉴 정렬
	 * @param List<MenuVO>
	 * @return List<MenuVO>
	 * @exception Exception
	 */
	private List<MenuVO> menuTree(List<MenuVO> menuList) throws Exception {

		List<MenuVO> list = new ArrayList<>();

		for(MenuVO menu : menuList) {

			// depth=1 부모 메뉴 필터링
			if("1".equals(menu.getMenuDepth())) {
				// 자식 메뉴 붙이기 DFS
				childrenMenu(menu, menuList);
				list.add(menu);
			}
		}

		return list;
	}

	/**
	 * 자식 메뉴 붙이기 DFS
	 * @param MenuVO, List<MenuVO>
	 * @return void
	 */
	private void childrenMenu(MenuVO menu, List<MenuVO> menuList) {
		for(MenuVO newMenu : menuList) {
			if(menu.getMenuId().equals(newMenu.getMenuPid())) {
				childrenMenu(newMenu, menuList);
				menu.getChildren().add(newMenu);
			}
		}

		// 메뉴 정렬
		menu.getChildren().sort(new MenuComparator());
	}
}
