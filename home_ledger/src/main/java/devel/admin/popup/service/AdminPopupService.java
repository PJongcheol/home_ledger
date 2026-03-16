package devel.admin.popup.service;

import java.util.List;
import java.util.Map;

import org.springframework.web.multipart.MultipartFile;

/**
 * 팝업 관리를 위한 Service
 * @Class Name   : AdminPopupService
   @Description  : 팝업관리 동작을 위한 Service

 * @author  : PJC
 * @date    : 2026. 2. 11
 * @desc    :
 * @version : 1.0
 * @see
 *
 * 개정이력(Modification Information)
 * 수정일		      수정자	     내용
 * ----------------  --------  -----------------
 *  2026. 2. 11		PJC			최초생성
 **/
public interface AdminPopupService {
	/**
	 * 팝업 목록 카운트
	 * @param Map
	 * @return int
	 * @exception Exception
	 */
	public int selectPopupTotalCount(Map<String, Object> param) throws Exception;

	/**
	 * 팝업 목록 조회
	 * @param Map
	 * @return int
	 * @exception Exception
	 */
	public List<Map<String, Object>> selectPopupList(Map<String, Object> param) throws Exception;

	/**
	 * 팝업 상세 조회
	 * @param Map
	 * @return int
	 * @exception Exception
	 */
	public Map<String, Object> selectPopupDtl(Map<String, Object> param) throws Exception;

	/**
	 * 팝업 저장
	 * @param Map
	 * @return void
	 * @exception Exception
	 */
	public void savePopup(Map<String, Object> param) throws Exception;

	/**
	 * 팝업 삭제
	 * @param Map
	 * @return void
	 * @exception Exception
	 */
	public void deletePopup(Map<String, Object> param) throws Exception;

}
