package devel.user.book.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import devel.user.book.mapper.UserBookMapper;
import devel.user.book.service.UserBookService;
import devel.user.settings.mapper.UserSettingsMapper;

/**
 * 유저 가계부를 위한 ServiceImpl
 * @Class Name   : UserBookServiceImpl
   @Description  : 유저 가계부를 위한 ServiceImpl

 * @author  : PJC
 * @date    : 2026. 3. 31
 * @desc    :
 * @version : 1.0
 * @see
 *
 * 개정이력(Modification Information)
 * 수정일		      수정자	     내용
 * ----------------  --------  -----------------
 *  2026. 3. 31		PJC			최초생성
 **/

@Service("userBookService")
public class UserBookServiceImpl implements UserBookService{
	@Autowired
	private UserBookMapper userBookMapper;

	@Autowired
	private UserSettingsMapper userSettingsMapper;

	/**
	 * 가계부 총 수입 지출 건수
	 * @param Map
	 * @return Map
	 * @exception Exception
	 */
	@Override
	public Map<String, Object> selectBookTotalAmount(Map<String, Object> param) throws Exception {
		return userBookMapper.selectBookTotalAmount(param);
	}

	/**
	 * 가계부 목록 카운트
	 * @param Map
	 * @return int
	 * @exception Exception
	 */
	@Override
	public int selectBookTotalCount(Map<String, Object> param) throws Exception {
		return userBookMapper.selectBookTotalCount(param);
	}

	/**
	 * 가계부 목록
	 * @param Map
	 * @return List
	 * @exception Exception
	 */
	@Override
	public List<Map<String, Object>> selectBookList(Map<String, Object> param) throws Exception {
		return userBookMapper.selectBookList(param);
	}

	/**
	 * 가계부 상세
	 * @param Map
	 * @return Map
	 * @exception Exception
	 */
	@Override
	public Map<String, Object> selectBookDtl(Map<String, Object> param) throws Exception {
		return userBookMapper.selectBookDtl(param);
	}

	/**
	 * 가계부 저장
	 * @param Map
	 * @return void
	 * @exception Exception
	 */
	@Override
	public void saveBook(Map<String, Object> param) throws Exception {
		if("I".equals(param.get("mode"))) {
			param.put("hliSeq", userBookMapper.selectBookSeq(param));
			userBookMapper.insertBook(param);
		} else {
			userBookMapper.updateBook(param);
		}
	}

	/**
	 * 가계부 삭제
	 * @param Map
	 * @return void
	 * @exception Exception
	 */
	@Override
	public void deleteBook(Map<String, Object> param) throws Exception {
		userBookMapper.deleteBook(param);
	}

	/**
	 * 가계부 과소비 update
	 * @param Map
	 * @return void
	 * @exception Exception
	 */
	@Override
	public void updateOverSpendingYn(Map<String, Object> param) throws Exception {
		userBookMapper.updateOverSpendingYn(param);
	}

	/**
	 * 카테고리 코드 조회
	 * @param Map
	 * @return String
	 * @exception Exception
	 */
	@Override
	public String selectExcelUploadCategoryCode(String param) throws Exception {
		return userBookMapper.selectExcelUploadCategoryCode(param);
	}

	/**
	 * 카테고리 소분류 조회
	 * @param Map
	 * @return String
	 * @exception Exception
	 */
	@Override
	public String selectExcelUploadSubCategoryCode(Map<String, Object> param) throws Exception {
			String ciSeq = userBookMapper.selectExcelUploadSubCategoryCode(param);

			if(ciSeq == null || "".equals(ciSeq)) {
				ciSeq = String.valueOf(userSettingsMapper.selectCategorySeq(param));
				param.put("ciSeq", ciSeq);

				userSettingsMapper.insertCategory(param);
			}

		return ciSeq;
	}

	/**
	 * 카드 사용 내역 총 지출 건수 조회
	 * @param Map
	 * @return int
	 * @exception Exception
	 */
	@Override
	public Map<String ,Object> selectCardTotalAmount(Map<String, Object> param) throws Exception {
		return userBookMapper.selectCardTotalAmount(param);
	}

	/**
	 * 카드 사용 목록 카운트
	 * @param Map
	 * @return int
	 * @exception Exception
	 */
	@Override
	public int selectCardTotalCount(Map<String, Object> param) throws Exception {
		return userBookMapper.selectCardTotalCount(param);
	}

	/**
	 * 카드 사용 목록
	 * @param Map
	 * @return List
	 * @exception Exception
	 */
	@Override
	public List<Map<String, Object>> selectCardList(Map<String, Object> param) throws Exception {
		return userBookMapper.selectCardList(param);
	}

	//------------------------  Scheduler   ------------------------
	/**
	 * 스케줄러 가계부 저장
	 * @param Map
	 * @return void
	 * @exception Exception
	 */
	@Override
	public void insertSchedulerBook(Map<String, Object> param) throws Exception {
		param.put("hliSeq", userBookMapper.selectSchedulerBookSeq(param));
		userBookMapper.insertSchedulerBook(param);
	}
}
