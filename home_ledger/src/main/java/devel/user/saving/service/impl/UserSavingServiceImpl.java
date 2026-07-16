package devel.user.saving.service.impl;

import java.time.LocalDate;
import java.time.YearMonth;
import java.time.temporal.ChronoUnit;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import devel.user.saving.mapper.UserSavingMapper;
import devel.user.saving.service.UserSavingService;

/**
 * 유저 가계부를 위한 ServiceImpl
 * @Class Name   : UserSavingServiceImpl
   @Description  : 유저 적금 현황을 위한 ServiceImpl

 * @author  : PJC
 * @date    : 2026. 7. 14
 * @desc    :
 * @version : 1.0
 * @see
 *
 * 개정이력(Modification Information)
 * 수정일		      수정자	     내용
 * ----------------  --------  -----------------
 *  2026. 7. 14		PJC			최초생성
 **/

@Service("userSavingService")
public class UserSavingServiceImpl implements UserSavingService {

	@Autowired
	private UserSavingMapper userSavingMapper;

	/**
	 * 적금 현황 목록 건수
	 * @param Map
	 * @return int
	 * @exception Exception
	 */
	@Override
	public int selectSavingTotalCount(Map<String, Object> param) throws Exception {
		return userSavingMapper.selectSavingTotalCount(param);
	}

	/**
	 * 적금 현황 목록 조회
	 * @param Map
	 * @return List
	 * @exception Exception
	 */
	@Override
	public List<Map<String, Object>> selectSavingList(Map<String, Object> param) throws Exception {
		return userSavingMapper.selectSavingList(param);
	}

	/**
	 * 적금 현황 상세 조회
	 * @param Map
	 * @return Map
	 * @exception Exception
	 */
	@Override
	public Map<String, Object> selectSavingDtl(Map<String, Object> param) throws Exception {
		return userSavingMapper.selectSavingDtl(param);
	}

	/**
	 * 적금 현황 저장
	 * @param Map
	 * @return void
	 * @exception Exception
	 */
	@Override
	public void saveSaving(Map<String, Object> param) throws Exception {
		// 총 입금 횟수 calculatePaymentCount method에서 계산해서 가져옴
		param.put("payCnt", calculatePaymentCount(param));

		if("I".equals(param.get("mode"))) { // 적금 현황 등록
			param.put("siSeq", userSavingMapper.selectSavingSeq(param));
			userSavingMapper.insertSaving(param);
		} else { // 적금 현황 수정
			userSavingMapper.updateSaving(param);
		}
	}

	/**
	 * 적금 현황 삭제
	 * @param Map
	 * @return void
	 * @exception Exception
	 */
	@Override
	public void deleteSaving(Map<String, Object> param) throws Exception {
		userSavingMapper.deleteSaving(param);
	}

	/**
	 * 납입 횟수 계산
	 * @param Map
	 * @return int
	 * @exception Exception
	 */
	public int calculatePaymentCount(Map<String, Object> param) throws Exception {
		String beginDe = param.get("beginDe").toString();
		String endDe = param.get("endDe").toString();

		LocalDate now = LocalDate.now();
		LocalDate begin = LocalDate.parse(beginDe);
		LocalDate end = LocalDate.parse(endDe);

		int siTotalAmount = Integer.parseInt(param.get("siTotalAmount").toString().replaceAll(",", ""));
		int monthlyPaymentAmount = Integer.parseInt(param.get("monthlyPaymentAmount").toString().replaceAll(",", ""));

		// 시작인보다 작은 경우 납입 횟수 0
		int payCnt = 0;

		// 조건에 따라 기본 세팅하는 횟수 계산
		if(!now.isBefore(begin) && !now.isAfter(end)) { // 시작일 ~ 종료일 안에 현재일이 포함되어 있다면
			if(YearMonth.from(begin).equals(YearMonth.from(LocalDate.now()))) { // 시작일과 현재일의 년월이 같은 경우 납입 횟수는 1 (보통 적금은 시작일에 첫 납입이 되고 익월부터 납일일에 납입됨)
				payCnt = 1;
			} else { // 시작일과 현재일의 년월이 다른 경우 납입 횟수 계산
				// 시작일, 현재일의 년월을 이용해 납입 횟수 계산
				// 현재일의 일이 납입일보다 작은 경우 그대로 넣어줌
				payCnt = (int) ChronoUnit.MONTHS.between(YearMonth.from(begin), YearMonth.from(LocalDate.now()));

				// 현재일의 일이 납입일보다 크거나 같은 경우 계산된 납입 횟수 + 1 (시작일에 기본 1회를 더해줌)
				if(now.getDayOfMonth() >= Integer.parseInt(param.get("tranDay").toString())) {
					payCnt++;
				}
			}
		} else if(!now.isBefore(end)) { // 종료일과 같거나 클 경우 (위에서 종료일을 체크하기 때문에 실질적으로는 종료일보다 큰 경우)
			payCnt = (siTotalAmount / monthlyPaymentAmount);
		}
		return payCnt;
	}

	//------------------------  Scheduler   ------------------------
	/**
	 * 스케줄러 적금 현황 목록 조회
	 * @param Map
	 * @return List
	 * @exception Exception
	 */
	@Override
	public List<Map<String, Object>> selectSchedulerSavingList(String day) throws Exception {
		return userSavingMapper.selectSchedulerSavingList(day);
	}

	/**
	 * 스케줄러 적금 현황 납입 횟수 수정
	 * @param Map
	 * @return void
	 * @exception Exception
	 */
	@Override
	public void updateSchedulerSaving(Map<String, Object> param) throws Exception {
		userSavingMapper.updateSchedulerSaving(param);
	}
}
