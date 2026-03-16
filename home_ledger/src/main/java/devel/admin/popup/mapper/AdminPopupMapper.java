package devel.admin.popup.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface AdminPopupMapper {
	// 팝업 목록 카운트
	public int selectPopupTotalCount(Map<String, Object> param);

	// 팝업 목록 조회
	public List<Map<String, Object>> selectPopupList(Map<String, Object> param);

	// 팝업 상세 조회
	public Map<String, Object> selectPopupDtl(Map<String, Object> param);

	// 팝업 저장
	public void insertPopup(Map<String, Object> param);

	// 팝업 수정
	public void updatePopup(Map<String, Object> param);

	// 팝업 삭제
	public void deletePopup(Map<String, Object> param);
}
