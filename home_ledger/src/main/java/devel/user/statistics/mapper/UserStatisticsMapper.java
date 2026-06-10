package devel.user.statistics.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface UserStatisticsMapper {
	// 카테고리별 총 금액 목록
	public List<Map<String, Object>> selectCategoryTotalList(Map<String, Object> param);

	// 과소비 체크 월별 총 금액 목록
	public List<Map<String, Object>> selectSpendingTotalList(Map<String, Object> param);

	// 수입/지출 월별 총 금액 목록
	public List<Map<String, Object>> selectInoutTotalList(Map<String, Object> param);

	// 카테고리별 소비 목록
	public List<Map<String, Object>> selectCategoryList(Map<String, Object> param);

	// 과소비 체크 목록
	public List<Map<String, Object>> selectSpendingList(Map<String, Object> param);

	// 월별 수입/지출(선택) 목록
	public List<Map<String, Object>> selectInoutList(Map<String, Object> param);
}
