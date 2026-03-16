package devel.admin.bbs.service.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.commons.codec.digest.DigestUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import devel.admin.bbs.mapper.AdminBbsMapper;
import devel.admin.bbs.service.AdminBbsService;

/**
 * bbs 처리를 위한 ServiceImpl
 * @Class Name   : AdminBbsServiceImpl
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
@Service("adminBbsService")
public class AdminBbsServiceImpl implements AdminBbsService{
	@Autowired
	AdminBbsMapper adminBbsMapper;

	/**
	 * 게시판 목록 카운트
	 * @param Map
	 * @return int
	 * @exception Exception
	 */
	@Override
	public int selectBbsMstTotalCount(Map<String, Object> param) throws Exception {
		return adminBbsMapper.selectBbsMstTotalCount(param);
	}

	/**
	 * 게시판 목록
	 * @param Map
	 * @return List
	 * @exception Exception
	 */
	@Override
	public List<Map<String, Object>> selectBbsMstList(Map<String, Object> param) throws Exception {
		return adminBbsMapper.selectBbsMstList(param);
	}

	/**
	 * 게시판 상세
	 * @param Map
	 * @return Map
	 * @exception Exception
	 */
	@Override
	public Map<String, Object> selectBbsDetail(Map<String, Object> param) throws Exception {
		return adminBbsMapper.selectBbsDetail(param);
	}

	/**
	 * 게시판 필드 목록
	 * @param Map
	 * @return List
	 * @exception Exception
	 */
	@Override
	public List<Map<String, Object>> selectBbsFieldList(Map<String, Object> param) throws Exception {

		List<Map<String, Object>> fieldList = new ArrayList<>();

		if("D".equals(param.get("mode"))) { // 상세라면 등록된 필드 목록을 불러오고
			fieldList = adminBbsMapper.selectBbsDtlFieldList(param);
		} else { // 신규라면 디폴트로 잡혀있는 기본 필드 목록을 불러온다
			fieldList = adminBbsMapper.selectBbsFieldList(param);
		}

		return fieldList;
	}

	/**
	 * 게시판 상세
	 * @param Map
	 * @return Map
	 * @exception Exception
	 */
	@Override
	public void saveBbs(Map<String, Object> param, List<Map<String, Object>> list) throws Exception {
		if("I".equals(param.get("mode"))) {
			// 게시판 일련번호
			int bbsSeq = adminBbsMapper.selectBbsSeq();
			param.put("bbsSeq", bbsSeq);

			// 게시판 저장
			adminBbsMapper.insertBbs(param);

			for(int i=0; i<list.size(); i++) {
				Map<String, Object> map = list.get(i);
				map.put("bbsSeq", bbsSeq);

				// 게시판 필드 일련번호
				int seq = adminBbsMapper.selectBbsFieldSeq(param);
				map.put("seq", seq);

				// 게시판 필드 목록 저장
				adminBbsMapper.insertBbsField(map);
			}
		} else {
			// 게시판 수정
			adminBbsMapper.updateBbs(param);

			// 게시판 유형이 기본이라면 필드 목록을 수정처리 하고 기본이 아니라면 기존 필드 목록 삭제
			if("DEFAULT".equals(param.get("bbsType"))) {
				for(int i=0; i<list.size(); i++) {
					Map<String, Object> map = list.get(i);
					map.put("bbsSeq", param.get("bbsSeq"));

					if(map.get("seq") == null || "".equals(map.get("seq"))) {
						// 게시판 필드 일련번호
						int seq = adminBbsMapper.selectBbsFieldSeq(param);
						map.put("seq", seq);

						adminBbsMapper.insertBbsField(map);
					} else {
						adminBbsMapper.updateBbsField(map);
					}

				}

			} else {
				adminBbsMapper.deleteBbsField(param);
			}
		}
	}

	/**
	 * 게시판 삭제
	 * @param Map
	 * @return void
	 * @exception Exception
	 */
	@Override
	public void deleteBbs(Map<String, Object> param) throws Exception {
		adminBbsMapper.deleteBbs(param);
		adminBbsMapper.deleteBbsField(param);
	}

	/**
	 * bbs 목록 카운트
	 * @param Map
	 * @return int
	 * @exception Exception
	 */
	@Override
	public int selectBbsTotalCount(Map<String, Object> param) throws Exception {
		return adminBbsMapper.selectBbsTotalCount(param);
	}

	/**
	 * bbs 목록 조회
	 * @param Map
	 * @return List
	 * @exception Exception
	 */
	@Override
	public List<Map<String, Object>> selectBbsList(Map<String, Object> param) throws Exception {
		return adminBbsMapper.selectBbsList(param);
	}

	/**
	 * bbs 비밀번호 체크
	 * @param Map
	 * @return int
	 * @exception Exception
	 */
	@Override
	public int bbsPassword(Map<String, Object> param) throws Exception {
		return adminBbsMapper.bbsPassword(param);
	}

	/**
	 * bbs 조회
	 * @param Map
	 * @return Map
	 * @exception Exception
	 */
	@Override
	public Map<String, Object> selectBoardMst(Map<String, Object> param) throws Exception {
		return adminBbsMapper.selectBoardMst(param);
	}

	/**
	 * bbs 필드 조회
	 * @param Map
	 * @return List
	 * @exception Exception
	 */
	@Override
	public List<Map<String, Object>> selectAdminBoardFieldList(Map<String, Object> param) throws Exception {
		return adminBbsMapper.selectAdminBoardFieldList(param);
	}

	/**
	 * bbs 상세 조회
	 * @param Map
	 * @return Map
	 * @exception Exception
	 */
	@Override
	public Map<String, Object> selectBoardDtl(Map<String, Object> param) throws Exception {
		return adminBbsMapper.selectBoardDtl(param);
	}

	/**
	 * bbs 저장
	 * @param Map
	 * @return void
	 * @exception Exception
	 */
	@Override
	public void saveBoard(Map<String, Object> param) throws Exception {
		// 비밀번호 암호화
		String pw = param.get("nttPassword").toString();
		param.put("nttPassword", DigestUtils.sha256Hex(pw));

		if("I".equals(param.get("mode"))) { // 저장
			// nttSeq 조회
			param.put("nttSeq", adminBbsMapper.selectBoardSeq(param));

			adminBbsMapper.insertBoard(param);
		} else { // 수정
			adminBbsMapper.updateBoard(param);
		}
	}

	/**
	 * bbs 삭제
	 * @param Map
	 * @return void
	 * @exception Exception
	 */
	@Override
	public void deleteBoard(Map<String, Object> param) throws Exception {
		adminBbsMapper.deleteBoard(param);
	}

	/**
	 * bbs 조회수 업데이트
	 * @param Map
	 * @return void
	 * @exception Exception
	 */
	@Override
	public void updateBoardRdcnt(Map<String, Object> param) throws Exception {
		adminBbsMapper.updateBoardRdcnt(param);
	}
}
