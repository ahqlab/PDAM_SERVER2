package net.octacomm.sample.dao.mapper;

public interface DailyOperationSummaryMapper {
	int upsertDailySnapshot();
	Integer getMaximumOperationDeviceCount();
	Integer getMinimumOperationDeviceCount();
	Integer getYesterdayOperationDeviceCount();
}
