package devel.cmmn.menu.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import devel.cmmn.menu.vo.MenuVO;

@Mapper
public interface MenuMapper {
	// 비밀번호실패 카운트 조회
	public List<MenuVO> getMenu(Map<String, Object> param);
}
