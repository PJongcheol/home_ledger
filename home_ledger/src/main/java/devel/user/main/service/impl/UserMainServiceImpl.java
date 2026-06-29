package devel.user.main.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import devel.user.main.mapper.UserMainMapper;
import devel.user.main.service.UserMainService;

/**
 * 메인 관리를 위한 ServiceImpl
 * @Class Name   : UserBookServiceImpl
   @Description  : 메인 관리를 위한 ServiceImpl

 * @author  : PJC
 * @date    : 2026. 6. 23
 * @desc    :
 * @version : 1.0
 * @see
 *
 * 개정이력(Modification Information)
 * 수정일		      수정자	     내용
 * ----------------  --------  -----------------
 *  2026. 6. 23		PJC			최초생성
 **/
@Service("userMainService")
public class UserMainServiceImpl implements UserMainService {
	@Autowired
	private UserMainMapper userMainMapper;

	/**
	 * 대시보드 상단 간략 정보 조회
	 * @param Map
	 * @return Map
	 * @exception Exception
	 */
	@Override
	public Map<String, Object> selectMainTopInfo(Map<String, Object> param) throws Exception {
		Map<String, Object> map = userMainMapper.selectMainTopInfo(param);

		if(map != null) {
			// 잔액 계산
			double nowBalance = Double.parseDouble(map.get("nowInAmount").toString()) - Double.parseDouble(map.get("nowExAmount").toString());
			double lastBalance = Double.parseDouble(map.get("nowInAmount").toString()) - Double.parseDouble(map.get("nowExAmount").toString());

			map.put("nowBalance", nowBalance);

			// 전월 대비 퍼센테이지 계산
			double rate = ((nowBalance - lastBalance) / lastBalance) * 100;

			// NaN 체크
			if(Double.isNaN(rate)) {
				rate = 0.00;
			}

			map.put("rate", String.format("%.2f", rate));
		}

		return map;
	}

	/**
	 * 해당월 카테고리별 지출 조회
	 * @param Map
	 * @return Map
	 * @exception Exception
	 */
	@Override
	public List<Map<String, Object>> selectMainCategoryList(Map<String, Object> param) throws Exception {
		return userMainMapper.selectMainCategoryList(param);
	}

	/**
	 * 해당월 과소비 체크 금액 조회
	 * @param Map
	 * @return Map
	 * @exception Exception
	 */
	@Override
	public List<Map<String, Object>> selectMainSpendingList(Map<String, Object> param) throws Exception {
		return userMainMapper.selectMainSpendingList(param);
	}

	/**
	 * 해당월 통장/카드 수입/지출 금액 조회
	 * @param Map
	 * @return Map
	 * @exception Exception
	 */
	@Override
	public List<Map<String, Object>> selectMainAccountAmountList(Map<String, Object> param) throws Exception {
		return userMainMapper.selectMainAccountAmountList(param);
	}
}
