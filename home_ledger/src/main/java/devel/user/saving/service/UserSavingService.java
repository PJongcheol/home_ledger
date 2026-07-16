package devel.user.saving.service;

import java.util.List;
import java.util.Map;

/**
 * 유저 가계부를 위한 Service
 * @Class Name   : UserSavingService
   @Description  : 유저 적금 현황을 위한 Service

 * @author  : PJC
 * @date    : 2026. 7. 14
 * @desc    :
 * @version : 1.0
 * @see
 *
 * 개정이력(Modification Information)
 * 수정일		      수정자	     내용
 * ----------------  --------  -----------------
 *  2026. 7. 14		PJC			최초생성
 **/

public interface UserSavingService {
	/**
	 * 적금 현황 목록 건수
	 * @param Map
	 * @return int
	 * @exception Exception
	 */
	public int selectSavingTotalCount(Map<String, Object> param) throws Exception;

	/**
	 * 적금 현황 목록 조회
	 * @param Map
	 * @return List
	 * @exception Exception
	 */
	public List<Map<String, Object>> selectSavingList(Map<String, Object> param) throws Exception;

	/**
	 * 적금 현황 상세 조회
	 * @param Map
	 * @return Map
	 * @exception Exception
	 */
	public Map<String, Object> selectSavingDtl(Map<String, Object> param) throws Exception;

	/**
	 * 적금 현황 저장
	 * @param Map
	 * @return void
	 * @exception Exception
	 */
	public void saveSaving(Map<String, Object> param) throws Exception;

	/**
	 * 적금 현황 삭제
	 * @param Map
	 * @return void
	 * @exception Exception
	 */
	public void deleteSaving(Map<String, Object> param) throws Exception;

	//------------------------  Scheduler   ------------------------
	/**
	 * 스케줄러 적금 현황 목록 조회
	 * @param Map
	 * @return List
	 * @exception Exception
	 */
	public List<Map<String, Object>> selectSchedulerSavingList(String day) throws Exception;

	/**
	 * 스케줄러 적금 현황 납입 횟수 수정
	 * @param Map
	 * @return void
	 * @exception Exception
	 */
	public void updateSchedulerSaving(Map<String, Object> param) throws Exception;
}
