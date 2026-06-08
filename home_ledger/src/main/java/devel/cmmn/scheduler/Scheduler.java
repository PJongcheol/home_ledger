package devel.cmmn.scheduler;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import devel.user.book.service.UserBookService;
import devel.user.settings.service.UserSettingsService;

@Component
public class Scheduler {
	@Autowired
	private UserSettingsService userSettingsService;

	@Autowired
	private UserBookService userBookService;

//	@Scheduled(fixedDelay = 5000)// 테스트용
//	@Scheduled(cron = "0 0 0 * * *", zone = "Asia/Seoul")// 테스트용
	@Scheduled(cron = "0 0 2 * * *", zone = "Asia/Seoul") // 새벽 2시에 한번
	public void testScheduler() throws Exception {
		LocalDate now = LocalDate.now();

		String day = now.format(DateTimeFormatter.ofPattern("d"));
		String tranDate = now.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));

		List<Map<String, Object>> list = userSettingsService.selectSchedulerFixedExpenseList(day);

		for(Map<String, Object> map : list) {
			map.put("userId", map.get("memberId"));
			map.put("tranDate", tranDate);

			userBookService.insertSchedulerBook(map);
		}

	}
}
