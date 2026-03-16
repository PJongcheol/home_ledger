package devel.cmmn.login.service.impl;

import java.util.Map;

import org.apache.commons.codec.digest.DigestUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import devel.cmmn.login.mapper.LoginMapper;
import devel.cmmn.login.service.LoginService;
import devel.cmmn.login.vo.LoginVO;

/**
*
* @Class Name   : LoginServiceImpl
  @Description  : 로그인 처리를 위한 서비스 Impl

* @author  : PJC
* @date    : 2026. 1. 5
* @desc    :
* @version : 1.0
* @see
*
* 개정이력(Modification Information)
* 수정일		      수정자	     내용
* ----------------  --------  -----------------
*  2026. 1. 5.	 	PJC	      최초작성
*/

@Service("loginService")
public class LoginServiceImpl implements LoginService {

	@Autowired
	private LoginMapper loginMapper;

	/**
	 * 비밀번호실패 카운트 조회
	 * @param Map
	 * @return String
	 * @exception Exception
	 */
	@Override
	public String selectLoginFailCnt(Map<String, Object> param) throws Exception {
		return loginMapper.selectLoginFailCnt(param);
	}

	/**
	 * 아이디 승인 체크
	 * @param Map
	 * @return String
	 * @exception Exception
	 */
	@Override
	public String selectConfmYn(Map<String, Object> param) throws Exception {
		return loginMapper.selectConfmYn(param);
	}

	/**
	 * 아이디 중복체크
	 * @param Map
	 * @return int
	 * @exception Exception
	 */
	@Override
	public int checkId(Map<String, Object> param) throws Exception {
		return loginMapper.checkId(param);
	}

	/**
	 * 로그인 처리
	 * @param Map
	 * @return LoginVO
	 * @exception Exception
	 */
	@Override
	public LoginVO actionLogin(Map<String, Object> param) throws Exception {
		LoginVO loginVo = null;

		// 패스워드 단방향 해시 - SHA256
		if(param.get("memberPw") != null && !"".equals(param.get("memberPw"))) {
			String pw = param.get("memberPw").toString();
			param.put("memberPw", DigestUtils.sha256Hex(pw));

			loginVo = loginMapper.actionLogin(param);

			// 로그인 성공 시 패스워드 실패 횟수 초기화
			if(loginVo != null) {
				param.put("failCnt", "0");

				// 로그인 이력 저장
				loginMapper.insertLoginHis(param);
			}

			loginMapper.updateUserFailCnt(param);
		}

		return loginVo;
	}

	/**
	 * 최종로그인 일시 처리
	 * @param String
	 * @return void
	 * @exception Exception
	 */
	@Override
	public void updateLastLogin(String id) throws Exception {
		loginMapper.updateLastLogin(id);
	}

	/**
	 * 회원 등록
	 * @param Map
	 * @return void
	 * @exception Exception
	 */
	@Override
	public void insertSignUp(Map<String, Object> param) throws Exception {
		String pw = param.get("memberPw").toString();
		param.put("memberPw", DigestUtils.sha256Hex(pw));
		loginMapper.insertSignUp(param);
	}

	/**
	 * 아이디 찾기
	 * @param Map
	 * @return void
	 * @exception Exception
	 */
	@Override
	public Map<String, Object> selectId(Map<String, Object> param) throws Exception {
		return loginMapper.selectId(param);
	}

	/**
	 * SNS 아이디 조회
	 * @param String
	 * @return LoginVO
	 * @exception Exception
	 */
	@Override
	public LoginVO selectSnsMember(String id) throws Exception {
		return loginMapper.selectSnsMember(id);
	}

	/**
	 * SNS 아이디 중복 조회
	 * @param String
	 * @return int
	 * @exception Exception
	 */
	@Override
	public int selectSnsIdCount(String id) throws Exception {
		return loginMapper.selectSnsIdCount(id);
	}

	/**
	 * SNS 아이디 저장
	 * @param Map
	 * @return void
	 * @exception Exception
	 */
	@Override
	public void insertSnsMember(Map<String, Object> param) throws Exception {
		String snsId = param.get("snsId").toString();
		param.put("memberPw", DigestUtils.sha256Hex(snsId));
		loginMapper.insertSnsMember(param);
	}
}
