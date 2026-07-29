package net.octacomm.sample.domain;

import java.util.ArrayList;
import java.util.List;

import lombok.Data;

@Data
public class ReportExcelUploadAnalysis implements Domain {

	private boolean success;
	private boolean applied;
	private String message;
	private String fileName;
	private String analysisToken;
	private String backupVersion;
	private int totalCount;
	private int duplicateCount;
	private int modifiedCount;
	private int addedCount;
	private int deletedCount;
	private List<DuplicateGroup> duplicateGroups = new ArrayList<DuplicateGroup>();
	private List<DuplicateDetail> duplicateDetails = new ArrayList<DuplicateDetail>();
	private List<ChangeDetail> changes = new ArrayList<ChangeDetail>();

	@Data
	public static class DuplicateGroup {
		private String key;
		private String constructionDate;
		private String machineNumber;
		private String location;
		private String pileNo;
		private int originalCount;
	}

	@Data
	public static class DuplicateDetail {
		private String key;
		private String type;
		private String constructionDate;
		private String machineNumber;
		private String location;
		private String pileNo;
		private String judgment;
	}

	@Data
	public static class ChangeDetail {
		private String target;
		private String field;
		private String beforeValue;
		private String afterValue;
	}
}
