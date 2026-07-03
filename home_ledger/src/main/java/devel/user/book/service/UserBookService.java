package devel.user.book.service;

import java.util.List;
import java.util.Map;

/**
 * 유저 가계부를 위한 Service
 * @Class Name   : UserBookService
   @Description  : 유저 가계부를 위한 Service

 * @author  : PJC
 * @date    : 2026. 3. 31
 * @desc    :
 * @version : 1.0
 * @see
 *
 * 개정이력(Modification Information)
 * 수정일		      수정자	     내용
 * ----------------  --------  -----------------
 *  2026. 3. 31		PJC			최초생성
 **/
public interface UserBookService {
	/**
	 * 가계부 총 수입 지출 건수
	 * @param Map
	 * @return Map
	 * @exception Exception
	 */
	public Map<String, Object> selectBookTotalAmount(Map<String, Object> param) throws Exception;

	/**
	 * 가계부 목록 카운트
	 * @param Map
	 * @return int
	 * @exception Exception
	 */
	public int selectBookTotalCount(Map<String, Object> param) throws Exception;

	/**
	 * 가계부 목록
	 * @param Map
	 * @return List
	 * @exception Exception
	 */
	public List<Map<String, Object>> selectBookList(Map<String, Object> param) throws Exception;

	/**
	 * 가계부 상세
	 * @param Map
	 * @return Map
	 * @exception Exception
	 */
	public Map<String, Object> selectBookDtl(Map<String, Object> param) throws Exception;

	/**
	 * 가계부 저장
	 * @param Map
	 * @return void
	 * @exception Exception
	 */
	public void saveBook(Map<String, Object> param) throws Exception;

	/**
	 * 가계부 삭제
	 * @param Map
	 * @return void
	 * @exception Exception
	 */
	public void deleteBook(Map<String, Object> param) throws Exception;

	/**
	 * 가계부 과소비 update
	 * @param Map
	 * @return void
	 * @exception Exception
	 */
	public void updateOverSpendingYn(Map<String, Object> param) throws Exception;

	/**
	 * 카테고리 코드 조회
	 * @param Map
	 * @return String
	 * @exception Exception
	 */
	public String selectExcelUploadCategoryCode(String param) throws Exception;

	/**
	 * 카테고리 소분류 조회
	 * @param Map
	 * @return String
	 * @exception Exception
	 */
	public String selectExcelUploadSubCategoryCode(Map<String, Object> param) throws Exception;

	//------------------------  Scheduler   ------------------------
	/**
	 * 스케줄러 가계부 저장
	 * @param Map
	 * @return void
	 * @exception Exception
	 */
	public void insertSchedulerBook(Map<String, Object> param) throws Exception;
}
