package devel.cmmn.file.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface FileMapper {
	// 파일 일련번호 조회
	public int selectAtchfileno();

	// 파일 순번 조회
	public int selectFileord(Map<String, Object> param);

	// 파일 저장
	public void insertFile(Map<String, Object> param);

	// 파일 목록 조회
	public List<Map<String, Object>> selectFileList(Map<String, Object> param);

	// 파일 삭제
	public void deleteFile(Map<String, Object> param);

	// 파일 다운로드 횟수 업데이트
	public void updateFileCount(Map<String, Object> param);

	// 파일 다운로드 횟수 업데이트
	public Map<String, Object> selectFile(Map<String, Object> param);
}
