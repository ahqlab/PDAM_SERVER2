package net.octacomm.sample.dao.mapper;

import java.util.List;
import java.util.Map;

public interface DailyOperationSummaryMapper {
	int upsertDailySnapshot();
	Integer getMaximumOperationDeviceCount();
	Integer getMinimumOperationDeviceCount();
	Integer getYesterdayOperationDeviceCount();
	List<Map<String, Object>> getDailyOperationTrend();
	List<Map<String, Object>> getMonthlyOperationTrend();
	List<Map<String, Object>> getYearlyOperationTrend();
}
