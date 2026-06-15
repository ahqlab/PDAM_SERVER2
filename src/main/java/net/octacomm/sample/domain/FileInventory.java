package net.octacomm.sample.domain;

import lombok.Data;

@Data
public class FileInventory implements Domain{
	
	private int fiIdx;
	
	private int brokenFiIdx;
	
	private int constructionIdx;
	
	//파일종류 2020-05-13 new
	private String pileType;
	//파일규격
	private String pileStandard;
	
	private String fileWeight;
	
	private String registDate;
	
	private String maker;
	
	private String bigo;
	//별도의 파일 타입? EX) EXT, SMART (단본)
	private String separateSinglePileType;
	//별도의 파일 타입? EX) EXT, SMART (단본)
	private String separateBottomPileType;
	
	private String meterof51;
	
	private String meterof52;
	
	private String meterof53;
	
	private String meterof54;
	
	private String meterof61;
	
	private String meterof62;

	private String meterof63;
	
	private String meterof64;
	
	private String meterof71;
	
	private String meterof72;

	private String meterof73;
	
	private String meterof74;
	
	private String meterof81;
	
	private String meterof82;

	private String meterof83;
	
	private String meterof84;

	private String meterof91;
	
	private String meterof92;

	private String meterof93;
	
	private String meterof94;
	
	private String meterof101;
	
	private String meterof102;

	private String meterof103;
	
	private String meterof104;
	
	private String meterof111;
	
	private String meterof112;

	private String meterof113;
	
	private String meterof114;

	private String meterof121;
	
	private String meterof122;

	private String meterof123;
	
	private String meterof124;

	private String meterof131;
	
	private String meterof132;

	private String meterof133;
	
	private String meterof134;

	private String meterof141;
	
	private String meterof142;

	private String meterof143;
	
	private String meterof144;

	private String meterof151;
	
	private String meterof152;

	private String meterof153;
	
	private String meterof154;

	private String meterof161;
	
	private String meterof162;

	private String meterof163;
	
	private String meterof164;

	private String meterof171;
	
	private String meterof172;

	private String meterof173;
	
	private String meterof174;

	private String meterof181;
	
	private String meterof182;

	private String meterof183;
	
	private String meterof184;
	
	private String bRegistDate;
	
	private String bMaker;
	
	private String bBigo;
	//별도의 파일 타입? EX) EXT, SMART (단본)
	private String bSeparateSinglePileType;
	//별도의 파일 타입? EX) EXT, SMART (단본)
	private String bSeparateBottomPileType;
	
	private String bMeterof51;
	
	private String bMeterof52;
	
	private String bMeterof53;
	
	private String bMeterof54;
	
	private String bMeterof61;
	
	private String bMeterof62;

	private String bMeterof63;
	
	private String bMeterof64;
	
	private String bMeterof71;
	
	private String bMeterof72;

	private String bMeterof73;
	
	private String bMeterof74;
	
	private String bMeterof81;
	
	private String bMeterof82;

	private String bMeterof83;
	
	private String bMeterof84;

	private String bMeterof91;
	
	private String bMeterof92;

	private String bMeterof93;
	
	private String bMeterof94;
	
	private String bMeterof101;
	
	private String bMeterof102;

	private String bMeterof103;
	
	private String bMeterof104;
	
	private String bMeterof111;
	
	private String bMeterof112;

	private String bMeterof113;
	
	private String bMeterof114;

	private String bMeterof121;
	
	private String bMeterof122;

	private String bMeterof123;
	
	private String bMeterof124;

	private String bMeterof131;
	
	private String bMeterof132;

	private String bMeterof133;
	
	private String bMeterof134;

	private String bMeterof141;
	
	private String bMeterof142;

	private String bMeterof143;
	
	private String bMeterof144;

	private String bMeterof151;
	
	private String bMeterof152;

	private String bMeterof153;
	
	private String bMeterof154;

	private String bMeterof161;
	
	private String bMeterof162;

	private String bMeterof163;
	
	private String bMeterof164;

	private String bMeterof171;
	
	private String bMeterof172;

	private String bMeterof173;
	
	private String bMeterof174;

	private String bMeterof181;
	
	private String bMeterof182;

	private String bMeterof183;
	
	private String bMeterof184;
	
	//신규버전만 추가
	private int fcIdx;
	//???
	private String machineNumber;
	
}
