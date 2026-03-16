package devel.admin.main.service;

import java.util.List;
import java.util.Map;

/**
 * 관리자 메인 관리를 위한 Service
 * @Class Name   : AdminMainService
   @Description  : 관리자 대시보드 및 대시보드 동작을 위한 Service

 * @author  : PJC
 * @date    : 2026. 2. 24
 * @desc    :
 * @version : 1.0
 * @see
 *
 * 개정이력(Modification Information)
 * 수정일		      수정자	     내용
 * ----------------  --------  -----------------
 *  2026. 2. 24		PJC			최초생성
 **/
public interface AdminMainService {
	/**
	 * 팝업 목록 조회
	 * @param
	 * @return List
	 * @exception Exception
	 */
	public List<Map<String, Object>> selectPopupList() throws Exception;

	/**
	 * 팝업 조회
	 * @param Map
	 * @return Map
	 * @exception Exception
	 */
	public Map<String, Object> selectPopup(Map<String, Object> param) throws Exception;

	/**
	 * 대시보드 상단 조회
	 * @param
	 * @return Map
	 * @exception Exception
	 */
	public Map<String, Object> selectIndexTop() throws Exception;

	/**
	 * 대시보드 회원 목록 조회
	 * @param
	 * @return List
	 * @exception Exception
	 */
	public List<Map<String, Object>> selectIndexMemberList() throws Exception;

	/**
	 * 대시보드 공지사항 목록 조회
	 * @param Map
	 * @return List
	 * @exception Exception
	 */
	public List<Map<String, Object>> selectBbsList(Map<String, Object> param) throws Exception;
}
