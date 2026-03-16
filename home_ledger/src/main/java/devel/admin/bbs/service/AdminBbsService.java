package devel.admin.bbs.service;

import java.util.List;
import java.util.Map;

import org.springframework.web.multipart.MultipartFile;

/**
 * bbs 처리를 위한 Service
 * @Class Name   : AdminBbsService
   @Description  :bbs 처리를 위한 Service
 * @author  : PJC
 * @date    : 2026. 2. 6
 * @desc    :
 * @version : 1.0
 * @see
 *
 * 개정이력(Modification Information)
 * 수정일		      수정자	     내용
 * ----------------  --------  -----------------
 *  2026. 2. 6		PJC			최초생성
 **/
public interface AdminBbsService {
	/**
	 * 게시판 목록 카운트
	 * @param Map
	 * @return int
	 * @exception Exception
	 */
	public int selectBbsMstTotalCount(Map<String, Object> param) throws Exception;

	/**
	 * 게시판 목록
	 * @param Map
	 * @return List
	 * @exception Exception
	 */
	public List<Map<String, Object>> selectBbsMstList(Map<String, Object> param) throws Exception;

	/**
	 * 게시판 상세
	 * @param Map
	 * @return Map
	 * @exception Exception
	 */
	public Map<String, Object> selectBbsDetail(Map<String, Object> param) throws Exception;


	/**
	 * 게시판 필드 목록
	 * @param Map
	 * @return List
	 * @exception Exception
	 */
	public List<Map<String, Object>> selectBbsFieldList(Map<String, Object> param) throws Exception;

	/**
	 * 게시판 필드 목록
	 * @param Map, List
	 * @return void
	 * @exception Exception
	 */
	public void saveBbs(Map<String, Object> param, List<Map<String, Object>> list) throws Exception;

	/**
	 * 게시판 삭제
	 * @param Map
	 * @return void
	 * @exception Exception
	 */
	public void deleteBbs(Map<String, Object> param) throws Exception;

	/**
	 * bbs 목록 카운트
	 * @param Map
	 * @return int
	 * @exception Exception
	 */
	public int selectBbsTotalCount(Map<String, Object> param) throws Exception;

	/**
	 * bbs 목록 조회
	 * @param Map
	 * @return List
	 * @exception Exception
	 */
	public List<Map<String, Object>> selectBbsList(Map<String, Object> param) throws Exception;

	/**
	 * bbs 비밀번호 체크
	 * @param Map
	 * @return int
	 * @exception Exception
	 */
	public int bbsPassword(Map<String, Object> param) throws Exception;


	/**
	 * bbs 조회
	 * @param Map
	 * @return Map
	 * @exception Exception
	 */
	public Map<String, Object> selectBoardMst(Map<String, Object> param) throws Exception;

	/**
	 * bbs 필드 조회
	 * @param Map
	 * @return List
	 * @exception Exception
	 */
	public List<Map<String, Object>> selectAdminBoardFieldList(Map<String, Object> param) throws Exception;

	/**
	 * bbs 상세 조회
	 * @param Map
	 * @return Map
	 * @exception Exception
	 */
	public Map<String, Object> selectBoardDtl(Map<String, Object> param) throws Exception;

	/**
	 * bbs 저장
	 * @param Map
	 * @return void
	 * @exception Exception
	 */
	public void saveBoard(Map<String, Object> param) throws Exception;

	/**
	 * bbs 삭제
	 * @param Map
	 * @return void
	 * @exception Exception
	 */
	public void deleteBoard(Map<String, Object> param) throws Exception;

	/**
	 * bbs 조회수 업데이트
	 * @param Map
	 * @return void
	 * @exception Exception
	 */
	public void updateBoardRdcnt(Map<String, Object> param) throws Exception;
}
