package devel.user.saving.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface UserSavingMapper {
	// 적금 현황 목록 건수
	public int selectSavingTotalCount(Map<String, Object> param);

	// 적금 현황 목록 조회
	public List<Map<String, Object>> selectSavingList(Map<String, Object> param);

	// 적금 현황 상세 조회
	public Map<String, Object> selectSavingDtl(Map<String, Object> param);

	// 적금 현황 일련번호 조회
	public int selectSavingSeq(Map<String, Object> param);

	// 적금 현황 저장
	public void insertSaving(Map<String, Object> param);

	// 적금 현황 수정
	public void updateSaving(Map<String, Object> param);

	// 적금 현황 삭제
	public void deleteSaving(Map<String, Object> param);

	//------------------------  Scheduler   ------------------------
	// 스케줄러 적금 현황 목록 조회
	public List<Map<String, Object>> selectSchedulerSavingList(String day);

	// 스케줄러 적금 현황 납입 횟수 수정
	public void updateSchedulerSaving(Map<String, Object> param);
}
