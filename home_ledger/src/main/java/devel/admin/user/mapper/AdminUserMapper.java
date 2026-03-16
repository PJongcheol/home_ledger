package devel.admin.user.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface AdminUserMapper {
	// 사용자 목록 카운트
	public int selectUserTotalCount(Map<String, Object> param);

	// 사용자 목록 조회
	public List<Map<String, Object>> selectUserList(Map<String, Object> param);

	// 사용자 상세
	public Map<String, Object> selectUserDetail(Map<String, Object> param);

	// 사용자 상세 저장
	public void saveUser(Map<String, Object> param);

	// 로그인 실패 카운트 초기화
	public void loginCountReset(Map<String, Object> param);

	// 로그인 이력 목록 카운트
	public int selectLogTotalCount(Map<String, Object> param);

	// 로그인 이력 목록 조회
	public List<Map<String, Object>> selectLogList(Map<String, Object> param);
}
