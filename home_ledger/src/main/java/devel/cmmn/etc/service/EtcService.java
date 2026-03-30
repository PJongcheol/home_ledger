package devel.cmmn.etc.service;

import java.util.List;
import java.util.Map;

/**
 * 공통 Service
 * @Class Name   : EtcService
   @Description  :공통 Service
 * @author  : PJC
 * @date    : 2026. 3. 4
 * @desc    :
 * @version : 1.0
 * @see
 *
 * 개정이력(Modification Information)
 * 수정일		      수정자	     내용
 * ----------------  --------  -----------------
 *  2026. 3. 4		PJC			최초생성
 **/
public interface EtcService {
	/**
     * 사용자 정보 조회
     * @Method : selectMemeberDtl
     * @throws Exception
     * @return : Map
     */
	public Map<String, Object> selectMemeberDtl(Map<String, Object> param) throws Exception;

	/**
     * 사용자 정보 수정
     * @Method : updateProfile
     * @throws Exception
     * @return : void
     */
	public void updateProfile(Map<String, Object> param) throws Exception;

	/**
     * 통장 목록 조회
     * @Method : selectBankList
     * @throws Exception
     * @return : List
     */
	public List<Map<String, Object>> selectBankList() throws Exception;

	/**
     * 카드 목록 조회
     * @Method : selectCardList
     * @throws Exception
     * @return : List
     */
	public List<Map<String, Object>> selectCardList() throws Exception;

	/**
     * 카테고리 목록 조회
     * @Method : selectCategoryList
     * @throws Exception
     * @return : List
     */
	public List<Map<String, Object>> selectCategoryList() throws Exception;

	/**
     * 통장/카드 목록 조회
     * @Method : selectCategoryList
     * @throws Exception
     * @return : List
     */
	public List<Map<String, Object>> selectAccountList(Map<String, Object> param) throws Exception;
}
