package devel.user.book.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface UserBookMapper {
	// 가계부 총 수입 지출 건수
	public Map<String, Object> selectBookTotalAmount(Map<String , Object> param);

	// 가계부 목록 카운트
	public int selectBookTotalCount(Map<String, Object> param);

	// 가계부 목록
	public List<Map<String, Object>> selectBookList(Map<String, Object> param);

	// 가계부 상세
	public Map<String, Object> selectBookDtl(Map<String, Object> param);

	// 가계부 일련번호
	public int selectBookSeq(Map<String, Object> param);

	// 가계부 저장
	public void insertBook(Map<String, Object> param);

	// 가계부 수정
	public void updateBook(Map<String, Object> param);

	// 가계부 삭제
	public void deleteBook(Map<String, Object> param);

	// 가계부 과소비 update
	public void updateOverSpendingYn(Map<String, Object> param);

	// 카테고리 코드 조회
	public String selectExcelUploadCategoryCode(String param);

	// 카테고리 소분류 조회
	public String selectExcelUploadSubCategoryCode(Map<String, Object> param);

	// 카드 사용 내역 총 지출 건수 조회
	public Map<String ,Object> selectCardTotalAmount(Map<String, Object> param);

	// 카드 사용 목록 카운트
	public int selectCardTotalCount(Map<String, Object> param);

	// 카드 사용 목록
	public List<Map<String, Object>> selectCardList(Map<String, Object> param);

	//------------------------  Scheduler   ------------------------
	// 스케줄러 가계부 일련번호
	public int selectSchedulerBookSeq(Map<String, Object> param);

	// 스케줄러 가계부 저장
	public void insertSchedulerBook(Map<String, Object> param);

}
