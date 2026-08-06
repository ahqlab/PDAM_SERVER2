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
		return dailyOperationSummaryMapper.insertSnapshot();
	}
}
