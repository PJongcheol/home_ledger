package devel.cmmn.etc.mapper;

import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface EtcMapper {
	// 사용자 정보 조회
	public Map<String, Object> selectMemberDtl(Map<String, Object> param);

	// 사용자 정보 수정
	public void updateProfile(Map<String, Object> param);
}
