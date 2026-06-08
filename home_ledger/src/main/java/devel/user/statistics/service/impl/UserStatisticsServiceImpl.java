package devel.user.statistics.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import devel.user.statistics.mapper.UserStatisticsMapper;
import devel.user.statistics.service.UserStatisticsService;

/**
 * 유저 가계부 통계를 위한 ServiceImpl
 * @Class Name   : UserStatisticsServiceImpl
   @Description  : 유저 가계부 통계를 위한 ServiceImpl

 * @author  : PJC
 * @date    : 2026. 4. 8
 * @desc    :
 * @version : 1.0
 * @see
 *
 * 개정이력(Modification Information)
 * 수정일		      수정자	     내용
 * ----------------  --------  -----------------
 *  2026. 4. 8		PJC			최초생성
 **/

@Service("userStatisticsService")
public class UserStatisticsServiceImpl implements UserStatisticsService {
	@Autowired
	UserStatisticsMapper userStatisticsMapper;

	/**
	 * 카테고리별 총 금액 목록
	 * @param Map
	 * @return List
	 * @exception Exception
	 */
	@Override
	public List<Map<String, Object>> selectCategoryTotalList(Map<String, Object> param) throws Exception {
		return userStatisticsMapper.selectCategoryTotalList(param);
	}

	/**
	 * 과소비 체크 월별 총 금액 목록
	 * @param Map
	 * @return List
	 * @exception Exception
	 */
	@Override
	public List<Map<String, Object>> selectSpendingTotalList(Map<String, Object> param) throws Exception {
		return userStatisticsMapper.selectSpendingTotalList(param);
	}

	/**
	 * 수입/지출 월별 총 금액 목록
	 * @param Map
	 * @return List
	 * @exception Exception
	 */
	@Override
	public List<Map<String, Object>> selectInoutTotalList(Map<String, Object> param) throws Exception {
		return userStatisticsMapper.selectInoutTotalList(param);
	}

	/**
	 * 과소비 체크 목록
	 * @param Map
	 * @return List
	 * @exception Exception
	 */
	@Override
	public List<Map<String, Object>> selectSpendingList(Map<String, Object> param) throws Exception {
		return userStatisticsMapper.selectSpendingList(param);
	}
}
