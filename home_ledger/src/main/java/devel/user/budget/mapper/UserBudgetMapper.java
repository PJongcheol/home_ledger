package devel.user.budget.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface UserBudgetMapper {
	// 예산 년월 목록 조회
	public List<Map<String, Object>> selectBudgetYearMonthList(Map<String, Object> param);

	// 예산 상세 조회
	public Map<String, Object> selectBudgetDtl(Map<String, Object> param);

	// 예산 일련번호 조회
	public int selectBudgetSeq(Map<String, Object> param);

	// 예산 저장
	public void insertBudget(Map<String, Object> param);

	// 예산 수정
	public void updateBudget(Map<String, Object> param);

	// 예산 삭제
	public void deleteBudget(Map<String, Object> param);

	// 전월 예산 조회
	public Map<String, Object> selectPrevBudgetDtl(Map<String, Object> param);

	// 예산 목록 조회
	public List<Map<String, Object>> selectBudgetList(Map<String, Object> param);

	// 소규모 카테고리 목록 조회
	public List<Map<String, Object>> selectSubCategoryList(Map<String, Object> param);
}
