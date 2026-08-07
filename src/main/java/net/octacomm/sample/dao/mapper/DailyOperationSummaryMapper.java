package net.octacomm.sample.dao.mapper;

public interface DailyOperationSummaryMapper {
	int acquireDailySnapshotLock();

	int insertSnapshotIfAbsent();

	int releaseDailySnapshotLock();
}
