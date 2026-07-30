package net.octacomm.sample.service;

import net.octacomm.sample.dao.mapper.ConstructionMapper;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Component
public class ConstructionAutoCloseScheduler {

	private static final Logger logger = LoggerFactory.getLogger(ConstructionAutoCloseScheduler.class);

	@Autowired
	private ConstructionMapper constructionMapper;

	// 매일 새벽 1시: 보유 장비 중 가장 늦은 종료일(endDate) 기준 2개월이 지난 시행중(conduct=0) 현장을 자동 종료 처리
	// TODO: 일단 비활성화 (2026-07-24 요청). 재활성화하려면 아래 @Scheduled 주석을 해제.
	@Scheduled(cron = "0 0 1 * * *")
	public void autoCloseExpiredConstructions() {
		int updated = constructionMapper.autoCloseExpiredConstructions();
		if (updated > 0) {
			logger.info("장비 종료일 기준 2개월 경과로 자동 종료 처리된 현장 수: {}", updated);
		}
	}

}
