package devel.admin.popup.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import devel.admin.popup.mapper.AdminPopupMapper;
import devel.admin.popup.service.AdminPopupService;

/**
 * 팝업 관리를 위한 ServiceImpl
 * @Class Name   : AdminPopupServiceImpl
   @Description  : 팝업관리 동작을 위한 ServiceImpl

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

@Service("adminPopupService")
public class AdminPopupServiceImpl implements AdminPopupService {
	@Autowired
	AdminPopupMapper adminPopupMapper;

	/**
	 * 팝업 목록 카운트
	 * @param Map
	 * @return int
	 * @exception Exception
	 */
	@Override
	public int selectPopupTotalCount(Map<String, Object> param) throws Exception {
		return adminPopupMapper.selectPopupTotalCount(param);
	}

	/**
	 * 팝업 목록 조회
	 * @param Map
	 * @return int
	 * @exception Exception
	 */
	@Override
	public List<Map<String, Object>> selectPopupList(Map<String, Object> param) throws Exception {
		return adminPopupMapper.selectPopupList(param);
	}

	/**
	 * 팝업 상세 조회
	 * @param Map
	 * @return int
	 * @exception Exception
	 */
	@Override
	public Map<String, Object> selectPopupDtl(Map<String, Object> param) throws Exception {
		return adminPopupMapper.selectPopupDtl(param);
	}

	/**
	 * 팝업 저장
	 * @param Map
	 * @return void
	 * @exception Exception
	 */
	public void savePopup(Map<String, Object> param) throws Exception {
		if("I".equals(param.get("mode"))) { // 저장
			adminPopupMapper.insertPopup(param);
		} else { // 수정
			adminPopupMapper.updatePopup(param);
		}
	}

	/**
	 * 팝업 삭제
	 * @param Map
	 * @return void
	 * @exception Exception
	 */
	public void deletePopup(Map<String, Object> param) throws Exception {
		adminPopupMapper.deletePopup(param);
	}
}
