package devel.admin.menu.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface AdminMenuMapper {
	// 메뉴목록 리스트 조회
	public List<Map<String, Object>> getMenuList(Map<String, Object> param);

	// 게시물 목록 조회
	public List<Map<String, Object>> adminBbsList(Map<String, Object> param);

	// 메뉴목록관리 저장
	public void insertMenu(Map<String, Object> param);

	// 메뉴목록관리 수정
	public void updateMenu(Map<String, Object> param);

	// 메뉴목록관리 삭제
	public void deleteMenu(Map<String, Object> param);

	// 메뉴권한관리 목록 조회
	public List<Map<String, Object>> selectMenuAuthList(Map<String, Object> param);

	// 메뉴권한 저장
	public void insertMenuAuth(List<Map<String, Object>> param);

	// 메뉴권한 삭제
	public void deleteMenuAuth(List<Map<String, Object>> param);

	// 메뉴 상세 정보 조회
	public Map<String, Object> selectMenuDtl(Map<String, Object> param);
}
