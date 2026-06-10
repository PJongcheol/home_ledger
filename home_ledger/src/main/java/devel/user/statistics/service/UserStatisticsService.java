package devel.user.statistics.service;

import java.util.List;
import java.util.Map;

/**
 * 유저 가계부 통계를 위한 Service
 * @Class Name   : UserStatisticsService
   @Description  : 유저 가계부 통계를 위한 Service

 * @author  : PJC
 * @date    : 2026. 4. 8
 * @desc    :
 * @version : 1.0
 * @see
 *
 * 개정이력(Modification Information)
 * 수정일		      수정자	     내용
 * ----------------  --------  -----------------
 *  2026. 4. 8		PJC			최초생성
 **/
public interface UserStatisticsService {
	/**
	 * 카테고리별 총 금액 목록
	 * @param Map
	 * @return List
	 * @exception Exception
	 */
	public List<Map<String, Object>> selectCategoryTotalList(Map<String, Object> param) throws Exception;

	/**
	 * 과소비 체크 월별 총 금액 목록
	 * @param Map
	 * @return List
	 * @exception Exception
	 */
	public List<Map<String, Object>> selectSpendingTotalList(Map<String, Object> param) throws Exception;

	/**
	 * 수입/지출 월별 총 금액 목록
	 * @param Map
	 * @return List
	 * @exception Exception
	 */
	public List<Map<String, Object>> selectInoutTotalList(Map<String, Object> param) throws Exception;

	/**
	 * 카테고리별 소비 목록
	 * @param Map
	 * @return List
	 * @exception Exception
	 */
	public List<Map<String, Object>> selectCategoryList(Map<String, Object> param) throws Exception;

	/**
	 * 과소비 체크 목록
	 * @param Map
	 * @return List
	 * @exception Exception
	 */
	public List<Map<String, Object>> selectSpendingList(Map<String, Object> param) throws Exception;

	/**
	 * 월별 수입/지출(선택) 목록
	 * @param Map
	 * @return List
	 * @exception Exception
	 */
	public List<Map<String, Object>> selectInoutList(Map<String, Object> param) throws Exception;
}
