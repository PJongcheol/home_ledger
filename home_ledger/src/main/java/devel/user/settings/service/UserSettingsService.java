package devel.user.settings.service;

import java.util.List;
import java.util.Map;

/**
 * 유저 설정을 위한 Service
 * @Class Name   : UserSettingsService
   @Description  : 유저 설정을 위한 Service

 * @author  : PJC
 * @date    : 2026. 3. 19
 * @desc    :
 * @version : 1.0
 * @see
 *
 * 개정이력(Modification Information)
 * 수정일		      수정자	     내용
 * ----------------  --------  -----------------
 *  2026. 3. 19		PJC			최초생성
 **/
public interface UserSettingsService {
	/**
	 * 통장/카드 관리 목록 카운트
	 * @param Map
	 * @return int
	 * @exception Exception
	 */
	public int selectAccountTotalCount(Map<String, Object> param) throws Exception;

	/**
	 * 통장/카드 관리 목록
	 * @param Map
	 * @return List
	 * @exception Exception
	 */
	public List<Map<String, Object>> selectAccountList(Map<String, Object> param) throws Exception;

	/**
	 * 통장/카드 관리 상세
	 * @param Map
	 * @return Map
	 * @exception Exception
	 */
	public Map<String, Object> selectAccountDtl(Map<String, Object> param) throws Exception;

	/**
	 * 통장/카드 저장
	 * @param Map
	 * @return void
	 * @exception Exception
	 */
	public void saveAccount(Map<String, Object> param) throws Exception;

	/**
	 * 통장/카드 관리 삭제
	 * @param Map
	 * @return void
	 * @exception Exception
	 */
	public void deleteAccount(Map<String, Object> param) throws Exception;

	/**
	 * 카테고리 관리 목록
	 * @param Map
	 * @return List
	 * @exception Exception
	 */
	public List<Map<String, Object>> selectCategoryList(Map<String, Object> param) throws Exception;

	/**
	 * 카테고리 상세
	 * @param Map
	 * @return Map
	 * @exception Exception
	 */
	public Map<String, Object> selectCategoryDtl(Map<String, Object> param) throws Exception;

	/**
	 * 카테고리 저장
	 * @param Map
	 * @return void
	 * @exception Exception
	 */
	public void saveCategory(Map<String, Object> param) throws Exception;

	/**
	 * 카테고리 삭제
	 * @param Map
	 * @return void
	 * @exception Exception
	 */
	public void deleteCategory(Map<String, Object> param) throws Exception;

	/**
	 * 고정지출 관리 목록
	 * @param Map
	 * @return List
	 * @exception Exception
	 */
	public List<Map<String, Object>> selectFixedExpenseList(Map<String, Object> param) throws Exception;

	/**
	 * 고정지출 상세
	 * @param Map
	 * @return Map
	 * @exception Exception
	 */
	public Map<String, Object> selectFixedExpenseDtl(Map<String, Object> param) throws Exception;

	/**
	 * 카테고리 소분류 목록
	 * @param Map
	 * @return List
	 * @exception Exception
	 */
	public List<Map<String, Object>> selectCategory(Map<String, Object> param) throws Exception;

	/**
	 * 고정지출 저장
	 * @param Map
	 * @return void
	 * @exception Exception
	 */
	public void saveFixedExpense(Map<String, Object> param) throws Exception;

	/**
	 * 고정지출 삭제
	 * @param Map
	 * @return void
	 * @exception Exception
	 */
	public void deleteFixedExpense(Map<String, Object> param) throws Exception;

	/**
	 * 사용 가능 가계부 목록
	 * @param Map
	 * @return List
	 * @exception Exception
	 */
	public List<Map<String, Object>> selectUseBookViewConfigList(Map<String, Object> param) throws Exception;

	/**
	 * 사용중인 가계부 목록
	 * @param Map
	 * @return List
	 * @exception Exception
	 */
	public List<Map<String, Object>> selectUsedBookViewConfigList(Map<String, Object> param) throws Exception;

	/**
	 * 가계부 목록 추가
	 * @param Map
	 * @return void
	 * @exception Exception
	 */
	public void addBookViewConfig(Map<String, Object> param) throws Exception;

	/**
	 * 가계부 목록 정렬 저장
	 * @param Map
	 * @return void
	 * @exception Exception
	 */
	public void orderBookViewConfig(Map<String, Object> param) throws Exception;

	/**
	 * 가계부 목록 삭제
	 * @param Map
	 * @return void
	 * @exception Exception
	 */
	public void deleteBookViewConfig(Map<String, Object> param) throws Exception;

}
