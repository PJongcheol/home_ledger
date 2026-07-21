package devel.user.budget.service;

import java.util.List;
import java.util.Map;

/**
 * 유저 예산을 위한 Service
 * @Class Name   : UserBudgetService
   @Description  : 유저 예산을 위한 Service

 * @author  : PJC
 * @date    : 2026. 7. 16
 * @desc    :
 * @version : 1.0
 * @see
 *
 * 개정이력(Modification Information)
 * 수정일		      수정자	     내용
 * ----------------  --------  -----------------
 *  2026. 7. 16		PJC			최초생성
 **/

public interface UserBudgetService {
	/**
     * 예산 년월 목록 조회
     * @param Map
	 * @return List
	 * @exception Exception
     */
	public List<Map<String, Object>> selectBudgetYearMonthList(Map<String, Object> param) throws Exception;

	/**
     * 예산 상세 조회
     * @param Map
	 * @return Map
	 * @exception Exception
     */
	public Map<String, Object> selectBudgetDtl(Map<String, Object> param) throws Exception;

	/**
     * 예산 저장
     * @param Map
	 * @return void
	 * @exception Exception
     */
	public void saveBudget(Map<String, Object> param) throws Exception;

	/**
     * 예산 삭제
     * @param Map
	 * @return void
	 * @exception Exception
     */
	public void deleteBudget(Map<String, Object> param) throws Exception;

	/**
     * 전월 예산 조회
     * @param Map
	 * @return int
	 * @exception Exception
     */
	public int prevBudget(Map<String, Object> param) throws Exception;

	/**
     * 예산 목록 조회
     * @param Map
	 * @return List
	 * @exception Exception
     */
	public List<Map<String, Object>> selectBudgetList(Map<String, Object> param) throws Exception;
}
