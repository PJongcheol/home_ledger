package devel.cmmn.login.vo;

import lombok.Data;

/**
*
* @Class Name   : LoginVO
  @Description  : Login VO class

* @author  : PJC
* @date    : 2026. 1. 5
* @desc    :
* @version : 1.0
* @see
*
* 개정이력(Modification Information)
* 수정일		      수정자	     내용
* ----------------  --------  -----------------
*  2026. 1. 5.	 	PJC	     	최초작성
*/

@Data
public class LoginVO{
	private String memberId; 		// 사용자ID
	private String authGrpCd; 		// 권한그룹코드
	private String memberNm; 		// 이름
	private String masterCode; 		// 권한마스터코드
	private String memberEmail; 	// 이메일
	private String memberBrthdy;	// 생년월일
	private String memberPhone; 	// 핸드폰번호
	private String memberPost; 		// 우편번호
	private String memberAddr; 		// 주소
	private String memberAddrDetl; 	// 상세주소
	private String lastLoginDt; 	// 최종로그인일시
	private String failCnt; 		// 로그인실패카운트
}
