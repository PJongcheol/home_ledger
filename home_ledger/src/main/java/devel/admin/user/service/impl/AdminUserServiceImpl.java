package devel.admin.user.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import devel.admin.user.mapper.AdminUserMapper;
import devel.admin.user.service.AdminUserService;

/**
*
* @Class Name   : AdminUserServiceImpl
  @Description  : 사용자관리 처리를 위한 서비스 Impl

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

@Service("adminUserService")
public class AdminUserServiceImpl implements AdminUserService{

	@Autowired
	AdminUserMapper adminUserMapper;

	/**
	 * 사용자 목록 카운트
	 * @param Map
	 * @return int
	 * @exception Exception
	 */
	@Override
	public int selectUserTotalCount(Map<String, Object> param) throws Exception {
		return adminUserMapper.selectUserTotalCount(param);
	}

	/**
	 * 사용자 목록 조회
	 * @param Map
	 * @return List
	 * @exception Exception
	 */
	@Override
	public List<Map<String, Object>> selectUserList(Map<String, Object> param) throws Exception {
		return adminUserMapper.selectUserList(param);
	}

	/**
	 * 사용자 상세
	 * @param Map
	 * @return Map
	 * @exception Exception
	 */
	@Override
	public Map<String, Object> selectUserDetail(Map<String, Object> param) throws Exception {
		return adminUserMapper.selectUserDetail(param);
	}

	/**
	 * 사용자 상세 저장
	 * @param Map
	 * @return void
	 * @exception Exception
	 */
	@Override
	public void saveUser(Map<String, Object> param) throws Exception {
		adminUserMapper.saveUser(param);
	}

	/**
	 * 로그인 실패 카운트 초기화
	 * @param Map
	 * @return void
	 * @exception Exception
	 */
	@Override
	public void loginCountReset(Map<String, Object> param) throws Exception {
		adminUserMapper.loginCountReset(param);
	}

	/**
	 * 로그인 이력 목록 카운트
	 * @param Map
	 * @return int
	 * @exception Exception
	 */
	@Override
	public int selectLogTotalCount(Map<String, Object> param) throws Exception {
		return adminUserMapper.selectLogTotalCount(param);
	}

	/**
	 * 로그인 이력 목록 조회
	 * @param Map
	 * @return List
	 * @exception Exception
	 */
	@Override
	public List<Map<String, Object>> selectLogList(Map<String, Object> param) throws Exception {
		return adminUserMapper.selectLogList(param);
	}
}
