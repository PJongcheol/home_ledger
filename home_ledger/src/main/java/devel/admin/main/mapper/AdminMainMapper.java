package devel.admin.main.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface AdminMainMapper {
	// 팝업 목록 조회
	public List<Map<String, Object>> selectPopupList();

	// 팝업 조회
	public Map<String, Object> selectPopup(Map<String, Object> param);

	// 대시보드 상단 조회
	public Map<String, Object> selectIndexTop();

	// 대시보드 회원 목록 조회
	public List<Map<String, Object>> selectIndexMemberList();

	// 대시보드 공지사항 목록 조회
	public List<Map<String, Object>> selectBbsList(Map<String, Object> param);
}
