package devel.cmmn.menu.comparator;

import java.util.Comparator;

import devel.cmmn.menu.vo.MenuVO;

public class MenuComparator implements Comparator<MenuVO>{

	@Override
	public int compare(MenuVO a, MenuVO b) {
		if(a.getMenuOrdr() == null && b.getMenuOrdr() == null) return 0;
		if(a.getMenuOrdr() == null) return 1;
		if(a.getMenuOrdr() == null) return -1;

		int result = a.getMenuOrdr().compareTo(b.getMenuOrdr());

		// 순서가 같다면 메뉴명으로 정렬
		if(result == 0) {
			return a.getMenuNm().compareTo(b.getMenuNm());
		}

		return result;
	}
}
