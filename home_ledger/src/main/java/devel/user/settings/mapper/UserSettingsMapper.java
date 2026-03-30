package devel.user.settings.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface UserSettingsMapper {
	// 통장/카드 관리 목록 카운트
	public int selectAccountTotalCount(Map<String, Object> param);

	// 통장/카드 관리 목록
	public List<Map<String, Object>> selectAccountList(Map<String, Object> param);

	// 통장/카드 관리 상세
	public Map<String, Object> selectAccountDtl(Map<String, Object> param);

	// 통장/카드 일련번호
	public int selectAccountSeq(Map<String, Object> param);

	// 통장/카드 저장
	public void insertAccount(Map<String, Object> param);

	// 통장/카드 수정
	public void updateAccount(Map<String, Object> param);

	// 통장/카드 삭제
	public void deleteAccount(Map<String, Object> param);

	// 카테고리 목록
	public List<Map<String, Object>> selectCategoryList(Map<String, Object> param);

	// 카테고리 소분류 목록
	public List<Map<String, Object>> selectSubCategoryList(Map<String, Object> param);

	// 카테고리 상세
	public Map<String, Object> selectCategoryDtl(Map<String, Object> param);

	// 카테고리 일련번호
	public int selectCategorySeq(Map<String, Object> param);

	// 카테고리 저장
	public void insertCategory(Map<String, Object> param);

	// 카테고리 수정
	public void updateCategory(Map<String, Object> param);

	// 카테고리 삭제
	public void deleteCategory(Map<String, Object> param);

	// 고정지출 통장/카드 목록
	public List<Map<String, Object>> selectFiexedExpenseAccountList(Map<String, Object> param);

	// 고정지출 목록
	public List<Map<String, Object>> selectFixedExpenseList(Map<String, Object> param);

	// 고정지출 상세
	public Map<String, Object> selectFixedExpenseDtl(Map<String, Object> param);

	// 카테고리 소분류 목록
	public List<Map<String, Object>> selectCategory(Map<String, Object> param);

	// 고정지출 일련번호
	public int selectFixedExpenseSeq(Map<String, Object> param);

	// 고정지출 저장
	public void insertFixedExpense(Map<String, Object> param);

	// 고정지출 수정
	public void updateFixedExpense(Map<String, Object> param);

	// 고정지출 삭제
	public void deleteFixedExpense(Map<String, Object> param);

	// 사용 가능 가계부 목록
	public List<Map<String, Object>> selectUseBookViewConfigList(Map<String, Object> param);

	// 사용중인 가계부 목록
	public List<Map<String, Object>> selectUsedBookViewConfigList(Map<String, Object> param);

	// 가계부 목록 추가
	public void addBookViewConfig(Map<String, Object> param);

	// 가계부 목록 삭제
	public void deleteAllBookViewConfig(Map<String, Object> param);

	// 가계부 목록 삭제
	public void deleteBookViewConfig(Map<String, Object> param);

	// 신규 유저 가계부 목록 추가
	public void addSignUpBookViewConfig(Map<String, Object> param);

}
