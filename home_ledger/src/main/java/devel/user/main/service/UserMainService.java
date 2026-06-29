package devel.user.main.service;

import java.util.List;
import java.util.Map;

/**
 * 메인 관리를 위한 Service
 * @Class Name   : UserBookService
   @Description  : 메인 관리를 위한 Service

 * @author  : PJC
 * @date    : 2026. 6. 23
 * @desc    :
 * @version : 1.0
 * @see
 *
 * 개정이력(Modification Information)
 * 수정일		      수정자	     내용
 * ----------------  --------  -----------------
 *  2026. 6. 23		PJC			최초생성
 **/
public interface UserMainService {
	/**
	 * 대시보드 상단 간략 정보 조회
	 * @param Map
	 * @return Map
	 * @exception Exception
	 */
	public Map<String, Object> selectMainTopInfo(Map<String, Object> param) throws Exception;

	/**
	 * 해당월 카테고리별 지출 조회
	 * @param Map
	 * @return Map
	 * @exception Exception
	 */
	public List<Map<String, Object>> selectMainCategoryList(Map<String, Object> param) throws Exception;

	/**
	 * 해당월 과소비 체크 금액 조회
	 * @param Map
	 * @return Map
	 * @exception Exception
	 */
	public List<Map<String, Object>> selectMainSpendingList(Map<String, Object> param) throws Exception;

	/**
	 * 해당월 통장/카드 수입/지출 금액 조회
	 * @param Map
	 * @return Map
	 * @exception Exception
	 */
	public List<Map<String, Object>> selectMainAccountAmountList(Map<String, Object> param) throws Exception;
}
