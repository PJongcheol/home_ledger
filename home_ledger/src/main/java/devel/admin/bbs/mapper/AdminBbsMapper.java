package devel.admin.bbs.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface AdminBbsMapper {
	// 게시판 목록 카운트
	public int selectBbsMstTotalCount(Map<String, Object> param);

	// 게시판 목록
	public List<Map<String, Object>> selectBbsMstList(Map<String, Object> param);

	// 게시판 상세
	public Map<String, Object> selectBbsDetail(Map<String, Object> param);

	// 게시판 필드 상세 목록
	public List<Map<String, Object>> selectBbsDtlFieldList(Map<String, Object> param);

	// 게시판 필드 목록
	public List<Map<String, Object>> selectBbsFieldList(Map<String, Object> param);

	// 게시판 일련번호
	public int selectBbsSeq();

	// 게시판 저장
	public void insertBbs(Map<String, Object> param);

	// 게시판 필드 일련번호
	public int selectBbsFieldSeq(Map<String, Object> param);

	// 게시판 필드 목록 저장
	public void insertBbsField(Map<String, Object> param);

	// 게시판 수정
	public void updateBbs(Map<String, Object> param);

	// 게시판 필드 수정
	public void updateBbsField(Map<String, Object> param);

	// 게시판 삭제
	public void deleteBbs(Map<String, Object> param);

	// 게시판 필드 삭제
	public void deleteBbsField(Map<String, Object> param);

	// bbs 목록 카운트
	public int selectBbsTotalCount(Map<String, Object> param);

	// bbs 목록 조회
	public List<Map<String, Object>> selectBbsList(Map<String, Object> param);

	// bbs 비밀번호 체크
	public int bbsPassword(Map<String, Object> param);

	// bbs 조회
	public Map<String, Object> selectBoardMst(Map<String, Object> param);

	// bbs 필드 조회
	public List<Map<String, Object>> selectAdminBoardFieldList(Map<String, Object> param);

	// bbs 상세 조회
	public Map<String, Object> selectBoardDtl(Map<String, Object> param);

	// bbs 일련번호
	public int selectBoardSeq(Map<String, Object> param);

	// bbs 저장
	public void insertBoard(Map<String, Object> param);

	// bbs 수정
	public void updateBoard(Map<String, Object> param);

	// bbs 삭제
	public void deleteBoard(Map<String, Object> param);

	// bbs 조회수 업데이트
	public void updateBoardRdcnt(Map<String, Object> param);

}
