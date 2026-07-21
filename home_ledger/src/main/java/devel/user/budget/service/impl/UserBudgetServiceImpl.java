package devel.user.budget.service.impl;

import java.time.YearMonth;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import devel.user.budget.mapper.UserBudgetMapper;
import devel.user.budget.service.UserBudgetService;

/**
 * 유저 예산을 위한 ServiceImpl
 * @Class Name   : UserBudgetServiceImpl
   @Description  : 유저 예산을 위한 ServiceImpl

 * @author  : PJC
 * @date    : 2026. 7. 16
 * @desc    :
 * @version : 1.0
 * @see
 *
 * 개정이력(Modification Information)
 * 수정일		      수정자	     내용
 * ----------------  --------  -----------------
 *  2026. 7. 16		PJC			최초생성
 **/

@Service("userBudgetService")
public class UserBudgetServiceImpl implements UserBudgetService {

	@Autowired
	private UserBudgetMapper userBudgetMapper;

	/**
     * 예산 년월 목록 조회
     * @Method : list
     * @throws Exception
     * @return : String
     */
	@Override
	public List<Map<String, Object>> selectBudgetYearMonthList(Map<String, Object> param) throws Exception {
		return userBudgetMapper.selectBudgetYearMonthList(param);
	}

	/**
     * 예산 상세 조회
     * @param Map
	 * @return Map
	 * @exception Exception
     */
	@Override
	public Map<String, Object> selectBudgetDtl(Map<String, Object> param) throws Exception {
		return userBudgetMapper.selectBudgetDtl(param);
	}

	/**
     * 예산 저장
     * @param Map
	 * @return void
	 * @exception Exception
     */
	@Override
	public void saveBudget(Map<String, Object> param) throws Exception {
		if("I".equals(param.get("mode"))) {
			param.put("biSeq", userBudgetMapper.selectBudgetSeq(param));
			userBudgetMapper.insertBudget(param);
		} else {
			userBudgetMapper.updateBudget(param);
		}

	}

	/**
     * 예산 삭제
     * @param Map
	 * @return void
	 * @exception Exception
     */
	@Override
	public void deleteBudget(Map<String, Object> param) throws Exception {
		userBudgetMapper.deleteBudget(param);
	}

	/**
     * 전월 예산 조회
     * @param Map
	 * @return int
	 * @exception Exception
     */
	@Override
	public int prevBudget(Map<String, Object> param) throws Exception {
		int chk = 0;

		// 등록 년월 - 1달
		String biYearMonth = param.get("biYearMonth").toString();
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM");
		YearMonth yearMonth = YearMonth.parse(biYearMonth, formatter);

		param.put("prevYearMonth", yearMonth.minusMonths(1));

		Map<String, Object> newParam = userBudgetMapper.selectPrevBudgetDtl(param);

		// 전월 예산이 있다면
		if(newParam != null) {
			newParam.put("userId", param.get("userId"));
			newParam.put("biYearMonth", param.get("biYearMonth"));
			newParam.put("biSeq", userBudgetMapper.selectBudgetSeq(newParam));
			userBudgetMapper.insertBudget(newParam);

			chk++;
		}

		return chk;
	}

	/**
     * 예산 목록 조회
     * @Method : list
     * @throws Exception
     * @return : String
     */
	@Override
	public List<Map<String, Object>> selectBudgetList(Map<String, Object> param) throws Exception {

		List<Map<String, Object>> budgetList = userBudgetMapper.selectBudgetList(param);

		// 소분류 카테고리 리스트를 담아준다
		for(Map<String, Object> map : budgetList) {
			map.put("userId", param.get("userId"));
			map.put("subCategory", userBudgetMapper.selectSubCategoryList(map));
		}

		return budgetList;
	}
}
