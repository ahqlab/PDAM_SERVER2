package net.octacomm.sample.domain;

import lombok.Data;

@Data
public class DeviceBackupHistory implements Domain {

	private int id;
	private int constructionIdx;
	private int deviceId;
	private int versionNo;
	private String version;
	private String createdAt;
	private String workType;
	private String snapshotData;
}
