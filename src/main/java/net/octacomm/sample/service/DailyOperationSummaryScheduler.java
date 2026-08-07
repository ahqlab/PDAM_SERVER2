package net.octacomm.sample.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Component
public class DailyOperationSummaryScheduler {
		private static final Logger logger = LoggerFactory.getLogger(DailyOperationSummaryScheduler.class);
		private final DailyOperationSummaryService dailyOperationSummaryService;
		
		@Autowired
		public DailyOperationSummaryScheduler(DailyOperationSummaryService dailyOperationSummaryService) {
			this.dailyOperationSummaryService = dailyOperationSummaryService;
		}
		
		@Scheduled(cron = "0 0 9 * * *")
		public void collectDailyOperationSummary() {
			try {
				int affectedRows = dailyOperationSummaryService.collectAndSave();
				if (affectedRows == 0) {
					logger.info("일일 운영 현황 스냅샷이 이미 저장되어 실행을 건너뜁니다.");
				} else {
					logger.info("일일 운영 현황 스냅샷 저장 완료. 반영 행 수: {}", affectedRows);
				}
			} catch(Exception e) {
				logger.error("일일 운영 현황 스냅샷 저장 실패", e);
			}
		}
}
