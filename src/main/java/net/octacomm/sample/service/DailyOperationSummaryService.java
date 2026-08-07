package net.octacomm.sample.service;

import net.octacomm.sample.dao.mapper.DailyOperationSummaryMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class DailyOperationSummaryService {
	@Autowired
	private DailyOperationSummaryMapper dailyOperationSummaryMapper;

	@Transactional
	public int collectAndSave() {
		int acquired = dailyOperationSummaryMapper.acquireDailySnapshotLock();
		if (acquired != 1) {
			return 0;
		}

		try {
			return dailyOperationSummaryMapper.insertSnapshotIfAbsent();
		} finally {
			dailyOperationSummaryMapper.releaseDailySnapshotLock();
		}
	}
}
