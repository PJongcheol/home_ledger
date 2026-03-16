package devel.admin.main.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import devel.admin.main.mapper.AdminMainMapper;
import devel.admin.main.service.AdminMainService;

/**
 * 관리자 메인 관리를 위한 ServiceImpl
 * @Class Name   : AdminMainServiceImpl
   @Description  : 관리자 대시보드 및 대시보드 동작을 위한 ServiceImpl

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
@Service("adminMainService")
public class AdminMainServiceImpl implements AdminMainService{
	@Autowired
	AdminMainMapper adminMainMapper;

	/**
	 * 팝업 목록 조회
	 * @param
	 * @return List
	 * @exception Exception
	 */
	@Override
	public List<Map<String, Object>> selectPopupList() throws Exception {
		return adminMainMapper.selectPopupList();
	}

	/**
	 * 팝업 조회
	 * @param Map
	 * @return Map
	 * @exception Exception
	 */
	@Override
	public Map<String, Object> selectPopup(Map<String, Object> param) throws Exception {
		return adminMainMapper.selectPopup(param);
	}

	/**
	 * 대시보드 상단 조회
	 * @param
	 * @return Map
	 * @exception Exception
	 */
	@Override
	public Map<String, Object> selectIndexTop() throws Exception {
		return adminMainMapper.selectIndexTop();
	}

	/**
	 * 대시보드 회원 목록 조회
	 * @param
	 * @return List
	 * @exception Exception
	 */
	@Override
	public List<Map<String, Object>> selectIndexMemberList() throws Exception {
		return adminMainMapper.selectIndexMemberList();
	}

	/**
	 * 대시보드 공지사항 목록 조회
	 * @param Map
	 * @return List
	 * @exception Exception
	 */
	@Override
	public List<Map<String, Object>> selectBbsList(Map<String, Object> param) throws Exception {
		return adminMainMapper.selectBbsList(param);
	}
}
