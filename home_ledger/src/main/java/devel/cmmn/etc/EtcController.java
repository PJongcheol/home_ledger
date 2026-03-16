package devel.cmmn.etc;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import devel.cmmn.etc.service.EtcService;
import devel.cmmn.file.service.FileService;
import devel.cmmn.login.vo.LoginVO;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * 공통 Controller
 * @Class Name   : EtcController
   @Description  :공통 Controller
 * @author  : PJC
 * @date    : 2026. 2. 13
 * @desc    :
 * @version : 1.0
 * @see
 *
 * 개정이력(Modification Information)
 * 수정일		      수정자	     내용
 * ----------------  --------  -----------------
 *  2026. 2. 13		PJC			최초생성
 **/
@Controller
@RequestMapping("/etc")
public class EtcController {

	@Autowired
	FileService fileService;

	@Autowired
	EtcService etcService;

	@Value("${file.upload.path}")
	private String uploadPath;

	@Value("${file.upload.url}")
	private String uploadUrl;

	/**
     * 에디터 이미지 업로드
     * @Method : uploadImage
     * @throws Exception
     * @return : Map
     */
	@PostMapping("/imageUpload.do")
	@ResponseBody
	public Map<String, Object> uploadImage(@RequestParam("upload") MultipartFile file){
		Map<String, Object> result = new HashMap<>();

		try {
			String originFileName = file.getOriginalFilename();
			String ext = originFileName.substring(originFileName.lastIndexOf("."));
			String fileName = UUID.randomUUID() + ext;

			File uploadFile = new File(uploadPath + fileName);

			if(!uploadFile.getParentFile().exists()) {
				uploadFile.getParentFile().mkdirs();
			}

			file.transferTo(uploadFile);

			result.put("uploaded", 1);
			result.put("fileName", fileName);
			result.put("url", uploadUrl + fileName);
 		} catch (IOException e) {
 			result.put("error", "업로드 오류");
 		}

		return result;
	}

	/**
     * 파일 다운로드
     * @Method : downloadFile
     * @throws Exception
     * @return : void
     */
	@PostMapping(value ="/downloadFile.do")
	public void downloadFileorm(@RequestParam Map<String, Object> param
			, ModelMap model, HttpSession session, HttpServletResponse response) throws Exception {

		Map<String, Object> fileMap = fileService.selectFile(param);

		String orgfilenm = "";
		String svfilenm = "";
		String fileDir = "";

		if(fileMap != null) {
			orgfilenm = fileMap.get("orgfilenm").toString();
			svfilenm = fileMap.get("svfilenm").toString();
			fileDir = fileMap.get("filedir").toString();
		}

		File file = new File(fileDir, svfilenm);

		if(!file.exists()) {
			throw new FileNotFoundException("파일이 존재하지 않습니다.");
		}

		// 다운로드 횟수
		fileService.updateFileCount(param);

		response.setContentType("application/octet-stream");
		response.setContentLengthLong(file.length());

		String encodedFileName = URLEncoder.encode(orgfilenm, "UTF-8").replaceAll("\\+", "%20");
		response.setHeader("Content-Disposition", "attachment; filename=\"" + encodedFileName + "\"");

		try {
			FileInputStream fis = new FileInputStream(file);
			OutputStream os = response.getOutputStream();

			byte[] buffer = new byte[8192];
			int bytesRead;

			while((bytesRead = fis.read(buffer)) != -1) {
				os.write(buffer, 0, bytesRead);
			}
			os.flush();
		} catch(IOException e) {
			e.printStackTrace();
			throw new RuntimeException("파일 다운로드 오류");
		}
	}

	/**
     * 파일 삭제
     * @Method : deleteFile
     * @throws Exception
     * @return : Map
     */
	@PostMapping(value ="/deleteFile.do")
	@ResponseBody
	public Map<String, Object> form(@RequestParam Map<String, Object> param
			, ModelMap model, HttpSession session) throws Exception {

		Map<String, Object> result = new HashMap<>();

		fileService.deleteFile(param);

		result.put("message", "ok");

		return result;
	}

	/**
     * 회원정보 수정 팝업
     * @Method : memberProfile
     * @throws Exception
     * @return : String
     */
	@GetMapping(value ="/memberProfile.do")
	public String memberProfile(@RequestParam Map<String, Object> param
			, ModelMap model, HttpSession session, HttpServletRequest request) throws Exception {

		LoginVO user = (LoginVO) request.getSession().getAttribute("LoginVO");
		param.put("memberId", user.getMemberId());

		// 사용자 정보 조회
		model.addAttribute("detail", etcService.selectMemeberDtl(param));

		return "/etc/popup/profilePop";
	}

	/**
     * 회원정보 수정
     * @Method : memberProfile
     * @throws Exception
     * @return : Map
     */
	@PostMapping(value ="/updateProfile.do")
	@ResponseBody
	public Map<String, Object> updateProfile(@RequestParam Map<String, Object> param
			, ModelMap model, HttpSession session, HttpServletRequest request) throws Exception {

		LoginVO user = (LoginVO) request.getSession().getAttribute("LoginVO");
		param.put("userId", user.getMemberId());

		Map<String, Object> result = new HashMap<>();

		// 회원정보 수정
		etcService.updateProfile(param);

		result.put("message", "ok");

		return result;
	}

}
