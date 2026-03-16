package devel.cmmn.api.social.login;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.client.RestTemplate;

import devel.cmmn.base.BaseController;
import devel.cmmn.login.service.LoginService;
import devel.cmmn.login.vo.LoginVO;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * SNS 로그인을 위한 Controller
 * @Class Name   : SocialLoginController
   @Description  :SNS 로그인을 위한 Controller
 * @author  : PJC
 * @date    : 2026. 2. 26
 * @desc    :
 * @version : 1.0
 * @see
 *
 * 개정이력(Modification Information)
 * 수정일		      수정자	     내용
 * ----------------  --------  -----------------
 *  2026. 2. 26		PJC			최초생성
 **/
@Controller
@RequestMapping("/api/social/login")
public class SocialLoginController extends BaseController{
	@Autowired
	LoginService loginService;

	@Value("${kakao.rest.api.key}")
	private String kakaoRestApiKey;

	@Value("${kakao.login.secret.key}")
	private String kakaoLoginSecretKey;

	@Value("${naver.client.id}")
	private String naverClientId;

	@Value("${naver.client.secret}")
	private String naverClientSecret;

	/**
     * 인가코드 발급
     * @Method : getKakaoUserInfo
     * @throws Exception
     * @return : Map
     */
	@GetMapping(value="/oauth.do")
	public void getKakaoUserInfo(HttpServletRequest request, HttpServletResponse response) throws Exception {

		String scheme = request.getScheme();
		String serverName = request.getServerName();
		int serverPort = request.getServerPort();
		String contextPath = request.getContextPath();

		String baseUrl = scheme + "://" + serverName + ":" + serverPort + contextPath;

		String redirectUri = baseUrl + "/api/social/login/snsAuth.do";

		String sns = request.getParameter("sns");
		String oauthUrl = "";
		String key = "";

		if("kakao".equals(sns)) {
			oauthUrl = "https://kauth.kakao.com/oauth/authorize";
			key = kakaoRestApiKey;
		} else if("naver".equals(sns)) {
			oauthUrl = "https://nid.naver.com/oauth2.0/authorize";
			key = naverClientId;
		}

//		redirectUri = URLEncoder.encode(redirectUri, "UTF-8");

		String url = oauthUrl
		            + "?response_type=code"
		            + "&client_id=" + key
		            + "&redirect_uri=" + redirectUri
					+ "&state=" + sns;

		response.sendRedirect(url);
	}

	/**
     * sns 로그인
     * @Method : snsAuth
     * @throws Exception
     * @return : Map
     */
	@GetMapping(value="/snsAuth.do")
	public String snsAuth(HttpServletRequest request, @RequestParam String code, @RequestParam String state) throws Exception {
		String scheme = request.getScheme();
		String serverName = request.getServerName();
		int serverPort = request.getServerPort();
		String contextPath = request.getContextPath();

		String baseUrl = scheme + "://" + serverName + ":" + serverPort + contextPath;

		String redirectUri= baseUrl + "/api/social/login/snsAuth.do";

		// sns에 따른 분기처리
		String tokenUrl = "";
		String userUrl = "";
		String key = "";
		String secretKey = "";
		if("kakao".equals(state)) {
			tokenUrl = "https://kauth.kakao.com/oauth/token";
			userUrl = "https://kapi.kakao.com/v2/user/me";
			key = kakaoRestApiKey;
			secretKey = kakaoLoginSecretKey;
		} else if("naver".equals(state)) {
			tokenUrl = "https://nid.naver.com/oauth2.0/token";
			userUrl = "https://openapi.naver.com/v1/nid/me";
			key = naverClientId;
			secretKey = naverClientSecret;
		}

		RestTemplate template = new RestTemplate();

		MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
		params.add("grant_type", "authorization_code");
		params.add("client_id", key);
		params.add("client_secret", secretKey);
		params.add("redirect_uri", redirectUri);
		params.add("code", code);

		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
		headers.set("Accept", "application/json");

		HttpEntity<MultiValueMap<String, String>> tokenRequest = new HttpEntity<>(params, headers);

		ResponseEntity<Map> tokenResponse = template.postForEntity(
			tokenUrl,
			tokenRequest,
			Map.class
		);

		String accessToken = (String) tokenResponse.getBody().get("access_token");

		HttpHeaders userHeaders = new HttpHeaders();
		userHeaders.setBearerAuth(accessToken);
		userHeaders.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

		HttpEntity<?> userRequest = new HttpEntity<>(userHeaders);

		ResponseEntity<Map> userResponse = template.exchange(
			userUrl,
			HttpMethod.GET,
	        userRequest,
	        Map.class
		);

		Map<String, Object> userInfo = userResponse.getBody();

		Map<String, Object> userMap = new HashMap<>();

		// 랜덤 아이디 생성
		String id = UUID.randomUUID().toString();

		boolean idChk = true;

		LoginVO loginInfo = new LoginVO();

		if("kakao".equals(state)) { // 카카오
			Map<String, Object> user = (Map<String, Object>) userInfo.get("kakao_account");

			// 등록된 아이디가 있는지
			loginInfo = loginService.selectSnsMember(userInfo.get("id").toString());

			if(loginInfo == null) { // 등록된 아이디가 없다면 등록 먼저
				// 랜덤 아이디 중복검사
				while(idChk) {
					int idCount = loginService.selectSnsIdCount(id);

					// 중복되는 아이디가 없으면 while문 종료
					if(idCount == 0) {
						idChk = false;
					} else {
						id = UUID.randomUUID().toString();
					}
				}

				userMap.put("memberId", id);
				userMap.put("memberEmail", user.get("email"));
				// 사업자등록번호를 기재해야 하기 때문에 잠시 주석처리
//				userMap.put("memberNm", user.get("name"));
//				userMap.put("memberBrthdy", user.get("birthyear") + "-" + user.get("birthday"));
//				userMap.put("memberPhone", user.get("mobile"));
				userMap.put("snsId", userInfo.get("id"));
				userMap.put("snsSe", "1");

				loginService.insertSnsMember(userMap);

				loginInfo = loginService.selectSnsMember(userInfo.get("id").toString());
			}

		} else if("naver".equals(state)) { // 네이버
			Map<String, Object> user = (Map<String, Object>) userInfo.get("response");

			// 등록된 아이디가 있는지
			loginInfo = loginService.selectSnsMember(user.get("id").toString());

			if(loginInfo == null) { // 등록된 아이디가 없다면 등록 먼저
				// 랜덤 아이디 중복검사
				while(idChk) {
					int idCount = loginService.selectSnsIdCount(id);

					// 중복되는 아이디가 없으면 while문 종료
					if(idCount == 0) {
						idChk = false;
					} else {
						id = UUID.randomUUID().toString();
					}
				}

				userMap.put("memberId", id);
				userMap.put("memberNm", user.get("name"));
				userMap.put("memberEmail", user.get("email"));
				userMap.put("memberBrthdy", user.get("birthyear") + "-" + user.get("birthday"));
//				userMap.put("memberPhone", user.get("mobile")); // 핸드폰 번호 요청 시 사업자등록번호를 기재해야 하기 때문에 잠시 주석처리
				userMap.put("snsId", user.get("id"));
				userMap.put("snsSe", "1");

				loginService.insertSnsMember(userMap);

				loginInfo = loginService.selectSnsMember(user.get("id").toString());
			}
		}

		// 최종 로그인 일시를 업데이트 시켜준다.
		String memberId = loginInfo.getMemberId();
		loginService.updateLastLogin(memberId);

		// 세션에 넣어준다.
		request.getSession().setAttribute("LoginVO", loginInfo);

		return "redirect:/user/main/index.do";
	}
}
