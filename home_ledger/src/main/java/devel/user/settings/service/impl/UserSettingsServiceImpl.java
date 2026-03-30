package devel.user.settings.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import devel.user.settings.mapper.UserSettingsMapper;
import devel.user.settings.service.UserSettingsService;
import tools.jackson.databind.ObjectMapper;

/**
 * 유저 설정을 위한 ServiceImpl
 * @Class Name   : UserSettingsServiceImpl
   @Description  : 유저 설정을 위한 ServiceImpl

 * @author  : PJC
 * @date    : 2026. 3. 19
 * @desc    :
 * @version : 1.0
 * @see
 *
 * 개정이력(Modification Information)
 * 수정일		      수정자	     내용
 * ----------------  --------  -----------------
 *  2026. 3. 19		PJC			최초생성
 **/
@Service("userSettingsService")
public class UserSettingsServiceImpl implements UserSettingsService {
	@Autowired
	UserSettingsMapper userSettingsMapper;

	/**
	 * 통장/카드 관리 목록 카운트
	 * @param Map
	 * @return int
	 * @exception Exception
	 */
	@Override
	public int selectAccountTotalCount(Map<String, Object> param) throws Exception {
		return userSettingsMapper.selectAccountTotalCount(param);
	}

	/**
	 * 통장/카드 관리 목록
	 * @param Map
	 * @return List
	 * @exception Exception
	 */
	@Override
	public List<Map<String, Object>> selectAccountList(Map<String, Object> param) throws Exception {
		return userSettingsMapper.selectAccountList(param);
	}

	/**
	 * 통장/카드 관리 상세
	 * @param Map
	 * @return Map
	 * @exception Exception
	 */
	@Override
	public Map<String, Object> selectAccountDtl(Map<String, Object> param) throws Exception {
		return userSettingsMapper.selectAccountDtl(param);
	}

	/**
	 * 통장/카드 저장
	 * @param Map
	 * @return void
	 * @exception Exception
	 */
	@Override
	public void saveAccount(Map<String, Object> param) throws Exception {
		if("I".equals(param.get("mode"))) {
			param.put("aiSeq", userSettingsMapper.selectAccountSeq(param));
			userSettingsMapper.insertAccount(param);
		} else {
			userSettingsMapper.updateAccount(param);
		}
	}

	/**
	 * 통장/카드 관리 삭제
	 * @param Map
	 * @return void
	 * @exception Exception
	 */
	@Override
	public void deleteAccount(Map<String, Object> param) throws Exception {
		userSettingsMapper.deleteAccount(param);
	}

	/**
	 * 카테고리 관리 목록
	 * @param Map
	 * @return List
	 * @exception Exception
	 */
	@Override
	public List<Map<String, Object>> selectCategoryList(Map<String, Object> param) throws Exception {
		List<Map<String, Object>> categoryList = userSettingsMapper.selectCategoryList(param);

		// 소분류 카테고리 리스트를 담아준다
		for(Map<String, Object> map : categoryList) {
			map.put("userId", param.get("userId"));
			map.put("subCategory", userSettingsMapper.selectSubCategoryList(map));
		}

		return categoryList;
	}

	/**
	 * 카테고리 상세
	 * @param Map
	 * @return Map
	 * @exception Exception
	 */
	@Override
	public Map<String, Object> selectCategoryDtl(Map<String, Object> param) throws Exception {
		return userSettingsMapper.selectCategoryDtl(param);
	}

	/**
	 * 카테고리 소분류 목록
	 * @param Map
	 * @return List
	 * @exception Exception
	 */
	public List<Map<String, Object>> selectCategory(Map<String, Object> param) throws Exception {
		return userSettingsMapper.selectCategory(param);
	}

	/**
	 * 카테고리 저장
	 * @param Map
	 * @return void
	 * @exception Exception
	 */
	@Override
	public void saveCategory(Map<String, Object> param) throws Exception {
		if("I".equals(param.get("mode"))) {
			param.put("ciSeq", userSettingsMapper.selectCategorySeq(param));
			userSettingsMapper.insertCategory(param);
		} else {
			userSettingsMapper.updateCategory(param);
		}
	}

	/**
	 * 카테고리 삭제
	 * @param Map
	 * @return void
	 * @exception Exception
	 */
	@Override
	public void deleteCategory(Map<String, Object> param) throws Exception {
		userSettingsMapper.deleteCategory(param);
	}

	/**
	 * 고정지출 관리 목록
	 * @param Map
	 * @return List
	 * @exception Exception
	 */
	@Override
	public List<Map<String, Object>> selectFixedExpenseList(Map<String, Object> param) throws Exception {
		List<Map<String, Object>> fixedExpenseList = userSettingsMapper.selectFiexedExpenseAccountList(param);

		// 소분류 카테고리 리스트를 담아준다
		for(Map<String, Object> map : fixedExpenseList) {
			map.put("userId", param.get("userId"));
			map.put("fixedExpense", userSettingsMapper.selectFixedExpenseList(map));
		}

		return fixedExpenseList;
	}

	/**
	 * 고정지출 상세
	 * @param Map
	 * @return Map
	 * @exception Exception
	 */
	@Override
	public Map<String, Object> selectFixedExpenseDtl(Map<String, Object> param) throws Exception {
		return userSettingsMapper.selectFixedExpenseDtl(param);
	}

	/**
	 * 고정지출 저장
	 * @param Map
	 * @return void
	 * @exception Exception
	 */
	@Override
	public void saveFixedExpense(Map<String, Object> param) throws Exception {
		if("I".equals(param.get("mode"))) {
			param.put("feiSeq", userSettingsMapper.selectFixedExpenseSeq(param));
			userSettingsMapper.insertFixedExpense(param);
		} else {
			userSettingsMapper.updateFixedExpense(param);
		}
	}

	/**
	 * 고정지출 삭제
	 * @param Map
	 * @return void
	 * @exception Exception
	 */
	@Override
	public void deleteFixedExpense(Map<String, Object> param) throws Exception {
		userSettingsMapper.deleteFixedExpense(param);
	}

	/**
	 * 사용 가능 가계부 목록
	 * @param Map
	 * @return List
	 * @exception Exception
	 */
	@Override
	public List<Map<String, Object>> selectUseBookViewConfigList(Map<String, Object> param) throws Exception {
		return userSettingsMapper.selectUseBookViewConfigList(param);
	}

	/**
	 * 사용중인 가계부 목록
	 * @param Map
	 * @return List
	 * @exception Exception
	 */
	@Override
	public List<Map<String, Object>> selectUsedBookViewConfigList(Map<String, Object> param) throws Exception {
		return userSettingsMapper.selectUsedBookViewConfigList(param);
	}

	/**
	 * 가계부 목록 추가
	 * @param Map
	 * @return void
	 * @exception Exception
	 */
	@Override
	public void addBookViewConfig(Map<String, Object> param) throws Exception {
		String jsonData = param.get("jsonData").toString();
		ObjectMapper mapper = new ObjectMapper();
		List<Map<String, Object>> list = mapper.readValue(jsonData, List.class);

		for(Map<String, Object> map : list) {
			map.put("userId", param.get("userId"));
			userSettingsMapper.addBookViewConfig(map);
		}
	}

	/**
	 * 가계부 목록 정렬 저장
	 * @param Map
	 * @return void
	 * @exception Exception
	 */
	@Override
	public void orderBookViewConfig(Map<String, Object> param) throws Exception {
		userSettingsMapper.deleteAllBookViewConfig(param);

		String jsonData = param.get("jsonData").toString();
		ObjectMapper mapper = new ObjectMapper();
		List<Map<String, Object>> list = mapper.readValue(jsonData, List.class);

		for(Map<String, Object> map : list) {
			map.put("userId", param.get("userId"));
			userSettingsMapper.addBookViewConfig(map);
		}
	}

	/**
	 * 가계부 목록 삭제
	 * @param Map
	 * @return void
	 * @exception Exception
	 */
	@Override
	public void deleteBookViewConfig(Map<String, Object> param) throws Exception {
		String jsonData = param.get("jsonData").toString();
		ObjectMapper mapper = new ObjectMapper();
		List<Map<String, Object>> list = mapper.readValue(jsonData, List.class);

		for(Map<String, Object> map : list) {
			map.put("userId", param.get("userId"));
			userSettingsMapper.deleteBookViewConfig(map);
		}
	}
}
