package devel.cmmn.menu.vo;

import java.util.ArrayList;
import java.util.List;

import lombok.Data;

/**
*
* @Class Name   : MenuVO
  @Description  : Menu VO class

* @author  : PJC
* @date    : 2026. 1. 15
* @desc    :
* @version : 1.0
* @see
*
* 개정이력(Modification Information)
* 수정일		      수정자	     내용
* ----------------  --------  -----------------
*  2026. 1. 15.	 	PJC	     	최초작성
*/

@Data
public class MenuVO {
	private String menuId;			// 메뉴ID
	private String menuPid;			// 메뉴PID
	private String menuNm;			// 메뉴명
	private String menuOrdr;		// 메뉴순서
	private String menuType;		// 메뉴종류
	private String menuDepth;		// 메뉴깊이
	private String menuUrl;			// 메뉴URL
	private String menuIcon;		// 메뉴Icon
	private String useYn;			// 사용여부
	private String siteCode;		// 사이트코드
	private List<MenuVO> children = new ArrayList<>(); // 자식메뉴
}
