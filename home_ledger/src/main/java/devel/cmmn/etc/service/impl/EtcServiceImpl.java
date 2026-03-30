package devel.cmmn.etc.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import devel.cmmn.etc.mapper.EtcMapper;
import devel.cmmn.etc.service.EtcService;

/**
 * 공통 ServiceImpl
 * @Class Name   : EtcServiceImpl
   @Description  :공통 ServiceImpl
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

@Service("etcService")
public class EtcServiceImpl implements EtcService{

	@Autowired
	EtcMapper etcMapper;

	/**
     * 사용자 정보 조회
     * @Method : selectMemeberDtl
     * @throws Exception
     * @return : Map
     */
	@Override
	public Map<String, Object> selectMemeberDtl(Map<String, Object> param) throws Exception {
		return etcMapper.selectMemberDtl(param);
	}

	/**
     * 사용자 정보 수정
     * @Method : updateProfile
     * @throws Exception
     * @return : void
     */
	@Override
	public void updateProfile(Map<String, Object> param) throws Exception {
		etcMapper.updateProfile(param);
	}

	/**
     * 통장 목록 조회
     * @Method : selectBankList
     * @throws Exception
     * @return : List
     */
	@Override
	public List<Map<String, Object>> selectBankList() throws Exception {
		return etcMapper.selectBankList();
	}

	/**
     * 카드 목록 조회
     * @Method : selectCardList
     * @throws Exception
     * @return : List
     */
	@Override
	public List<Map<String, Object>> selectCardList() throws Exception {
		return etcMapper.selectCardList();
	}

	/**
     * 카테고리 목록 조회
     * @Method : selectCategoryList
     * @throws Exception
     * @return : List
     */
	@Override
	public List<Map<String, Object>> selectCategoryList() throws Exception {
		return etcMapper.selectCategoryList();
	}

	/**
     * 통장/카드 목록 조회
     * @Method : selectCategoryList
     * @throws Exception
     * @return : List
     */
	@Override
	public List<Map<String, Object>> selectAccountList(Map<String, Object> param) throws Exception {
		return etcMapper.selectAccountList(param);
	}
}
