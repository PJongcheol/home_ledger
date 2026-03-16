package devel.admin.user.service;

import java.util.List;
import java.util.Map;

/**
*
* @Class Name   : AdminUserService
  @Description  : 사용자관리 처리를 위한 서비스

* @author  : PJC
* @date    : 2026. 1. 28
* @desc    :
* @version : 1.0
* @see
*
* 개정이력(Modification Information)
* 수정일		      수정자	     내용
* ----------------  --------  -----------------
*  2026. 1. 28.	 	PJC	      최초작성
*/

public interface AdminUserService {
	/**
	 * 사용자 목록 카운트
	 * @param Map
	 * @return int
	 * @exception Exception
	 */
	public int selectUserTotalCount(Map<String, Object> param) throws Exception;

	/**
	 * 사용자 목록 조회
	 * @param Map
	 * @return List
	 * @exception Exception
	 */
	public List<Map<String, Object>> selectUserList(Map<String, Object> param) throws Exception;

	/**
	 * 사용자 상세
	 * @param Map
	 * @return Map
	 * @exception Exception
	 */
	public Map<String, Object> selectUserDetail(Map<String, Object> param) throws Exception;

	/**
	 * 사용자 상세 저장
	 * @param Map
	 * @return void
	 * @exception Exception
	 */
	public void saveUser(Map<String, Object> param) throws Exception;

	/**
	 * 로그인 실패 카운트 초기화
	 * @param Map
	 * @return void
	 * @exception Exception
	 */
	public void loginCountReset(Map<String, Object> param) throws Exception;

	/**
	 * 로그인 이력 목록 카운트
	 * @param Map
	 * @return int
	 * @exception Exception
	 */
	public int selectLogTotalCount(Map<String, Object> param) throws Exception;

	/**
	 * 로그인 이력 목록 조회
	 * @param Map
	 * @return List
	 * @exception Exception
	 */
	public List<Map<String, Object>> selectLogList(Map<String, Object> param) throws Exception;

}
