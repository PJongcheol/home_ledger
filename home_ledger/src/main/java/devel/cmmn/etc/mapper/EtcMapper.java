package devel.cmmn.etc.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface EtcMapper {
	// 사용자 정보 조회
	public Map<String, Object> selectMemberDtl(Map<String, Object> param);

	// 사용자 정보 수정
	public void updateProfile(Map<String, Object> param);

	// 통장 목록 조회
	public List<Map<String, Object>> selectBankList();

	// 카드 목록 조회
	public List<Map<String, Object>> selectCardList();

	// 카테고리 목록 조회
	public List<Map<String, Object>> selectCategoryList();

	// 통장/카드 목록 조회
	public List<Map<String, Object>> selectAccountList(Map<String, Object> param);
}
