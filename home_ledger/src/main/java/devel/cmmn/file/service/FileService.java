package devel.cmmn.file.service;

import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import devel.cmmn.file.mapper.FileMapper;

/**
 * 파일 관리를 위한 Service
 * @Class Name   : FileService
   @Description  : 파일 관리를 위한 Service

 * @author  : PJC
 * @date    : 2026. 2. 20
 * @desc    :
 * @version : 1.0
 * @see
 *
 * 개정이력(Modification Information)
 * 수정일		      수정자	     내용
 * ----------------  --------  -----------------
 *  2026. 2. 20		PJC			최초생성
 **/
@Service("fileService")
public class FileService {
	@Autowired
	FileMapper fileMapper;

	@Value("${file.upload.path}")
	private String uloadDir;

	/**
	 * 파일 일련변호 조회
	 * @param Map
	 * @return int
	 * @exception Exception
	 */
	public int selectAtchfileno() throws Exception {
		int atchfileno = fileMapper.selectAtchfileno();
		return atchfileno;
	}

	/**
	 * 파일 업로드
	 * @param Map, List
	 * @return void
	 * @exception Exception
	 */
	public void uploadFiles(Map<String, Object> param, List<MultipartFile> files) throws Exception {

		for(MultipartFile file : files) {
			if(file != null && !file.isEmpty()){
				param.put("fileord", fileMapper.selectFileord(param)); // 파일 순서

				String orgfilenm = file.getOriginalFilename(); // 실제 파일명
				param.put("orgfilenm", orgfilenm);

				int index = orgfilenm.lastIndexOf("."); // 확장자 추출을 위한 인덱스

				String fileext = ""; // 파일 확장자

				if(index > -1) {
					fileext = orgfilenm.substring(index);
				}

				param.put("fileext", fileext.replace(".", ""));

				String svfilenm = UUID.randomUUID().toString() + fileext;
				param.put("svfilenm", svfilenm); // 변경 파일명
				param.put("filesize", file.getSize()); // 파일 사이즈

				// uploadFiles 메소드를 쓰는 곳에서 dir 를 넣어줌
				Path path = Paths.get(uloadDir, param.get("dir").toString());
				String dir = path.toString();

				param.put("filedir", dir); // 파일 경로

				// 경로가 없다면 생성
				File directory = new File(dir);
				if(!directory.exists()) {
					directory.mkdirs();
				}

				// 실제 저장
				String upfile = dir + File.separator + svfilenm;
				file.transferTo(new File(upfile));

				// 파일 정보 저장
				fileMapper.insertFile(param);
			}
		}
	}

	/**
	 * 파일 목록 조회
	 * @param Map
	 * @return List
	 * @exception Exception
	 */
	public List<Map<String, Object>> selectFileList(Map<String, Object> param) throws Exception {
		return fileMapper.selectFileList(param);
	}

	/**
	 * 파일 삭제
	 * @param Map
	 * @return void
	 * @exception Exception
	 */
	public void deleteFile(Map<String, Object> param) throws Exception {
		fileMapper.deleteFile(param);
	}

	/**
	 * 파일 다운로드 횟수 업데이트
	 * @param Map
	 * @return Map
	 * @exception Exception
	 */
	public Map<String, Object> selectFile(Map<String, Object> param) throws Exception {
		return fileMapper.selectFile(param);
	}

	/**
	 * 파일 다운로드 횟수 업데이트
	 * @param Map
	 * @return void
	 * @exception Exception
	 */
	public void updateFileCount(Map<String, Object> param) throws Exception {
		fileMapper.updateFileCount(param);
	}

}
