package devel.user.main.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface UserMainMapper {
	// 대시보드 상단 간략 정보 조회
	public Map<String, Object> selectMainTopInfo(Map<String, Object> param);

	// 해당월 카테고리별 지출 조회
	public List<Map<String, Object>> selectMainCategoryList(Map<String, Object> param);

	// 해당월 과소비 체크 금액 조회
	public List<Map<String, Object>> selectMainSpendingList(Map<String, Object> param);

	// 해당월 통장/카드 수입/지출 금액 조회
	public List<Map<String, Object>> selectMainAccountAmountList(Map<String, Object> param);
}
