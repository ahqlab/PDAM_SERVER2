package net.octacomm.sample.domain;

import lombok.Data;

@Data
public class Contract implements Domain {
	private int contractIdx;
	private int constructionIdx;
	private String constructionName;    // JOIN from TB_CONSTRUCTION
	private String contractType;        // DAILY, MONTHLY
	private String contractNo;
	private String siteName;
	private String companyName;
	private String modelName;
	private String supplyDeadline;
	private String dailyFee;
	private String reqTradeName;
	private String reqAddress;
	private String reqBusinessNo;
	private String reqTel;
	private String reqRepresentative;
	private String siteManager;         // 현장 담당자
	private String status;              // DRAFT, SIGNED
	private String createdAt;
	private String signedAt;
	private int isDel;
	private byte[] buyerSignature;
	private byte[] contractPdf;
}
