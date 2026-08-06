package net.octacomm.sample.service;

import net.octacomm.sample.dao.mapper.DailyOperationSummaryMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class DailyOperationSummaryService {
		private final DailyOperationSummaryMapper dailyOperationSummaryMapper;
		
		@Autowired
		public DailyOperationSummaryService(DailyOperationSummaryMapper dailyOperationSummaryMapper) {
			this.dailyOperationSummaryMapper = dailyOperationSummaryMapper;
		}
		
		@Transactional
		public int collectAndSave() {
			return dailyOperationSummaryMapper.upsertDailySnapshot();
		}
}