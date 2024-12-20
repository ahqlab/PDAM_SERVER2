package net.octacomm.sample.view;

import java.net.URLEncoder;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.octacomm.sample.domain.ReportOneLine;
import net.octacomm.sample.utils.DateUtil;
import net.octacomm.sample.utils.ExcelColor;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFPalette;
import org.apache.poi.hssf.usermodel.HSSFPrintSetup;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.util.CellRangeAddress;
import org.springframework.web.servlet.view.document.AbstractExcelView;

public class ReportFiveAllJh extends AbstractExcelView
{
  private static final int COLUNM_HEIGHT = 480;
  private static int tableLabelStartIndex = 3;
  private static int tableLabelEndIndex = 4;

  private static int tableValueStartIndex = 5;
  
  private int role;
  private int ubcYn;
  private int longCalYn;
  private boolean isHiddenManager;
  
  protected void buildExcelDocument(Map<String, Object> model, HSSFWorkbook workbook, HttpServletRequest req, HttpServletResponse res)
    throws Exception
  {
    String userAgent = req.getHeader("User-Agent");
    String fileName = "PDAM_REPORT_" + DateUtil.getCurrentDatetime() + ".xls";

    if (userAgent.indexOf("MSIE") > -1)
      fileName = URLEncoder.encode(fileName, "utf-8");
    else {
      fileName = new String(fileName.getBytes("utf-8"), "iso-8859-1");
    }
    
    role = (int) model.get("role");
    ubcYn = (int) model.get("ubcYn");
    longCalYn = (int) model.get("longCalYn");
    isHiddenManager = (boolean) model.get("isHiddenManager");
    
    
    if(role == 0) {
    	ubcYn = 1;
    }else if(role == 1) {
    	if(isHiddenManager == true && ubcYn == 1) {
    		ubcYn = 1;
    	}else {
    		ubcYn = 0;
    	}
    	
    }else if(role == 2) {
    	ubcYn = 0;
    }else if(role == 3) {
    	if(ubcYn == 1) {
    		ubcYn = 1;
    	}else {
    		ubcYn = 0;
    	}
    }
    
    res.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\";");
    res.setHeader("Content-Transfer-Encoding", "binary");

    HSSFSheet sheet = createFirstSheet(workbook);

    HSSFPrintSetup print = sheet.getPrintSetup();

    print.setPaperSize((short)9);

    print.setLandscape(true);

    print.setScale((short)52);
    sheet.setFitToPage(true);

    sheet.setMargin((short)2, 0.1D);
    sheet.setMargin((short)3, 0.1D);
    sheet.setMargin((short)0, 0.2D);
    sheet.setMargin((short)1, 0.2D);

    if(longCalYn > 0 && isHiddenManager == true) {
        sheet.setColumnWidth(1, 5000);
    }else {
        sheet.setColumnWidth(1, 3000);
    }
    
    setExcelTitleLayoutSetting(sheet, workbook);
    setColunmLabelLayoutSettiog(sheet, workbook);

    List reportList = (List) model.get("domainList");
   
    createColunm(sheet, workbook, reportList);
    createSumColunm(sheet, workbook, reportList);
    
  }

  private void createSumColunm(HSSFSheet sheet, HSSFWorkbook workbook, List<ReportOneLine> reportList)
  {
    double sumTotalConnectWidth = 0.0D;
    double sumConnectLength = 0.0D;
    double sumDrillingDepth = 0.0D;
    double sumIntrusionDepth = 0.0D;
    double sumBlance = 0.0D;
    double sumGongSac = 0.0D;
    for (ReportOneLine report : reportList) {
      sumTotalConnectWidth += Double.parseDouble(report.getTotalConnectWidth().isEmpty() ? "0" : report.getTotalConnectWidth());
      sumConnectLength += Double.parseDouble(report.getConnectLength().isEmpty() ? "0" : report.getConnectLength());
      sumDrillingDepth += Double.parseDouble(report.getDrillingDepth().isEmpty() ? "0" : report.getDrillingDepth());
      sumIntrusionDepth += Double.parseDouble(report.getIntrusionDepth().isEmpty() ? "0" : report.getIntrusionDepth());
      sumBlance += report.getBalance();
      sumGongSac += report.getGongSac();
    }

    HSSFRow row = sheet.createRow(tableValueStartIndex + reportList.size());
    //극한출력여부Y
    if(ubcYn > 0) {
    	setSumValues(workbook, row, 
  		      new String[] { 
  		      "합계", 
  		      null,
  		      null, 
  		      null, 
  		      null, 
  		      null, 
  		      null, 
  		      null, 
  		      null, 
  		      null, 
  		      null, 
  		      null, 
  		      null, 
  		      String.valueOf(String.format("%.2f", new Object[] { Double.valueOf(sumTotalConnectWidth) })), 
  		      String.valueOf(String.format("%.2f", new Object[] { Double.valueOf(sumConnectLength) })), 
  		      String.valueOf(String.format("%.2f", new Object[] { Double.valueOf(sumDrillingDepth) })), 
  		      String.valueOf(String.format("%.2f", new Object[] { Double.valueOf(sumIntrusionDepth) })), 
  		      String.valueOf(String.format("%.2f", new Object[] { Double.valueOf(sumBlance) })), 
  		      String.valueOf(String.format("%.2f", new Object[] { Double.valueOf(sumGongSac) })), 
  		      null, 
  		      null, 
  		      null, 
  		      null, //평균관입략
  		      null, //최종관립
  		      null, //극한지지력
  		      null, //해머효율
  		      null, //탄성계수
  		      null, //파일단면적 
		      null, //비고
		      null  //메모
  		      });
    }else { //일반 극한관련된 내용 보여주지 않는다.
    	setSumValues(workbook, row, 
    		      new String[] { 
    		      "합계", 
    		      null,
    		      null, 
    		      null, 
    		      null, 
    		      null, 
    		      null, 
    		      null, 
    		      null, 
    		      null, 
    		      null, 
    		      null, 
    		      null, 
    		      String.valueOf(String.format("%.2f", new Object[] { Double.valueOf(sumTotalConnectWidth) })), 
    		      String.valueOf(String.format("%.2f", new Object[] { Double.valueOf(sumConnectLength) })), 
    		      String.valueOf(String.format("%.2f", new Object[] { Double.valueOf(sumDrillingDepth) })), 
    		      String.valueOf(String.format("%.2f", new Object[] { Double.valueOf(sumIntrusionDepth) })), 
    		      String.valueOf(String.format("%.2f", new Object[] { Double.valueOf(sumBlance) })), 
    		      String.valueOf(String.format("%.2f", new Object[] { Double.valueOf(sumGongSac) })), 
    		      null, 
    		      null, 
    		      null, 
    		      null, //평균
    		      null, //최종관립
    		      null, //비고
    		      null  //메모
    		      });
    }
    
  }

	private void setSumValues(HSSFWorkbook workbook, HSSFRow row, String[] strings) {
		CellStyle style = workbook.createCellStyle();
		style.setAlignment((short) 2);
		style.setVerticalAlignment((short) 1);
		style.setBorderRight((short) 1);
		style.setBorderLeft((short) 1);
		style.setBorderBottom((short) 1);

		for (int i = 0; i < strings.length; i++) {
			HSSFCell cell = row.createCell(i);
			row.setHeight((short) 480);
			try {
				cell.setCellValue(Double.parseDouble(strings[i]));
			} catch (java.lang.NumberFormatException e) {
				cell.setCellValue(strings[i]);
			} catch (NullPointerException e) {
				cell.setCellValue(strings[i]);
			} catch (Exception e) {
				cell.setCellValue(strings[i]);
			}
			cell.setCellStyle(style);
		}
	}
  
	private HSSFColor rgbToHSSFColor(String color, HSSFWorkbook workbook) {
		// String pupleColor = ExcelColor.PURPLE;
		// 16진수값을 R,G,B값으로 변환
		int colorR = Integer.parseInt(color.substring(1, 3), 16);
		int colorG = Integer.parseInt(color.substring(3, 5), 16);
		int colorB = Integer.parseInt(color.substring(5, 7), 16);
		HSSFPalette palette = workbook.getCustomPalette();
		HSSFColor myColor = palette.findSimilarColor(colorR, colorG, colorB);
		return myColor;
	}

	private CellStyle styleOfBasicCellStyle(HSSFWorkbook workbook) {
		CellStyle style = workbook.createCellStyle();
		style.setAlignment((short) 2);
		style.setVerticalAlignment((short) 1);
		style.setBorderRight((short) 1);
		style.setBorderLeft((short) 1);
		style.setBorderBottom((short) 1);
		style.setLocked(true);
		return style;
	}

	private CellStyle styleOfRedCellStyle(HSSFWorkbook workbook) {
		CellStyle style = workbook.createCellStyle();
		style.setAlignment((short) 2);
		style.setVerticalAlignment((short) 1);
		style.setBorderRight((short) 1);
		style.setBorderLeft((short) 1);
		style.setBorderBottom((short) 1);
		style.setFillForegroundColor((short) 10);
		style.setFillPattern((short) 1);
		style.setLocked(true);
		return style;
	}

	private CellStyle styleOfBlueCellStyle(HSSFWorkbook workbook) {
		CellStyle style = workbook.createCellStyle();
		style.setAlignment((short) 2);
		style.setVerticalAlignment((short) 1);
		style.setBorderRight((short) 1);
		style.setBorderLeft((short) 1);
		style.setBorderBottom((short) 1);
		style.setFillForegroundColor(rgbToHSSFColor(ExcelColor.BLUE, workbook).getIndex());
		//style.setFillForegroundColor(HSSFColor.LIGHT_TURQUOISE.index);
		style.setFillPattern((short) 1);
		style.setLocked(true);
		return style;
	}

	private CellStyle styleOfPupleCellStyle(HSSFWorkbook workbook) {
		CellStyle style = workbook.createCellStyle();
		style.setAlignment((short) 2);
		style.setVerticalAlignment((short) 1);
		style.setBorderRight((short) 1);
		style.setBorderLeft((short) 1);
		style.setBorderBottom((short) 1);
		style.setFillForegroundColor(rgbToHSSFColor(ExcelColor.PURPLE, workbook).getIndex());
		style.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND); // 컬러가 cell에 적용되는 style 정의
		style.setLocked(true);
		return style;
	}

	private CellStyle styleOfOrangeCellStyle(HSSFWorkbook workbook) {
		CellStyle style = workbook.createCellStyle();
		style.setAlignment((short) 2);
		style.setVerticalAlignment((short) 1);
		style.setBorderRight((short) 1);
		style.setBorderLeft((short) 1);
		style.setBorderBottom((short) 1);
		//style.setFillForegroundColor(HSSFColor.ORANGE.index);
		style.setFillForegroundColor(rgbToHSSFColor(ExcelColor.ORANGE, workbook).getIndex());
		style.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND); // 컬러가 cell에 적용되는 style 정의
		style.setLocked(true);
		return style;
	}

	private CellStyle styleOfYellowCellStyle(HSSFWorkbook workbook) {
		CellStyle style = workbook.createCellStyle();
		style.setAlignment((short) 2);
		style.setVerticalAlignment((short) 1);
		style.setBorderRight((short) 1);
		style.setBorderLeft((short) 1);
		style.setBorderBottom((short) 1);
		//style.setFillForegroundColor(HSSFColor.YELLOW.index);
		style.setFillForegroundColor(rgbToHSSFColor(ExcelColor.YELLOW, workbook).getIndex());
		style.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND); // 컬러가 cell에 적용되는 style 정의
		style.setLocked(true);
		return style;
	}

  
  private void createColunm(HSSFSheet sheet, HSSFWorkbook workbook, List<ReportOneLine> reportList) {
	  
	  CellStyle style = styleOfBasicCellStyle(workbook);
      //공삭공
	  CellStyle redStyle = styleOfRedCellStyle(workbook);
      //시공장비별 중복(시공위치, 파일번호)	
      CellStyle blueStyle = styleOfBlueCellStyle(workbook);
      //전체 중복(시공위치, 파일번호)
      CellStyle pupleStyle = styleOfPupleCellStyle(workbook);
      //관리기준 초과/또는 NG
	  CellStyle orangeStyle = styleOfOrangeCellStyle(workbook);
      //미관입/또는 NG
      CellStyle yellowStyle = styleOfYellowCellStyle(workbook);
      HSSFFont font = workbook.createFont();
      font.setColor((short) 9 );
      redStyle.setFont(font);
      
      double piOneSum = 0;
      double piTwoSum = 0;
  	  double piThreeSum = 0;
  	  double piFourSum = 0;
  	  double piFiveSum = 0;
  	  double connectLengthSum = 0;
  	  double gongSacSum = 0;
      
    for (int i = 0; i < reportList.size(); i++) {
      HSSFRow row1 = sheet.createRow(i + tableValueStartIndex);
      
      if(i == 1  || i == 2 ) {
    	  sheet.autoSizeColumn(i);
          sheet.setColumnWidth(i, (sheet.getColumnWidth(i)) + 512 );
      }
      
      if(i == 3 || i == 4 || i == 5 ) {
    	  sheet.autoSizeColumn(i);
    	  if((sheet.getColumnWidth(i) + 512) >= 3320) {
    		  sheet.setColumnWidth(i, (sheet.getColumnWidth(i) + 512) );
    	  }else {
    		  sheet.setColumnWidth(i, 3320 );
    	  }
      }
      String[] strings = null;
      if(ubcYn > 0) {
    	  
    	  
    	  
    	  piOneSum += Double.parseDouble(((ReportOneLine)reportList.get(i)).getPiOne().isEmpty() ? "0" : ((ReportOneLine)reportList.get(i)).getPiOne());
    	  piTwoSum += Double.parseDouble(((ReportOneLine)reportList.get(i)).getPiTwo().isEmpty() ? "0" : ((ReportOneLine)reportList.get(i)).getPiTwo());
    	  piThreeSum += Double.parseDouble(((ReportOneLine)reportList.get(i)).getPiThree().isEmpty() ? "0" : ((ReportOneLine)reportList.get(i)).getPiThree());
    	  piFourSum += Double.parseDouble(((ReportOneLine)reportList.get(i)).getPiFour().isEmpty() ? "0" : ((ReportOneLine)reportList.get(i)).getPiFour());
    	  piFiveSum += Double.parseDouble(((ReportOneLine)reportList.get(i)).getPiFive().isEmpty() ? "0" : ((ReportOneLine)reportList.get(i)).getPiFive());
    	  connectLengthSum += Double.parseDouble(((ReportOneLine)reportList.get(i)).getConnectLength().isEmpty() ? "0" : ((ReportOneLine)reportList.get(i)).getConnectLength());
    	  ((ReportOneLine)reportList.get(i)).getBalance();
    	  gongSacSum +=  (double) Math.abs(((ReportOneLine)reportList.get(i)).getGongSac());
    	  
    	  strings = new String[]{ String.valueOf(i + 1), 
    			    setDinamicDate(role, isHiddenManager, longCalYn, ((ReportOneLine)reportList.get(i)).getCurrentDateTime(), ((ReportOneLine)reportList.get(i)).getCreateDate()),  
    			    ((ReportOneLine)reportList.get(i)).getMachineNumber(), 
    		        ((ReportOneLine)reportList.get(i)).getPileType(), 
    		        ((ReportOneLine)reportList.get(i)).getMethod(), 
    		        ((ReportOneLine)reportList.get(i)).getLocation(), 
    		        ((ReportOneLine)reportList.get(i)).getPileNo(), 
    		        ((ReportOneLine)reportList.get(i)).getPileStandard(), 
    		        ((ReportOneLine)reportList.get(i)).getPiOne().isEmpty() ? null : ((ReportOneLine)reportList.get(i)).getPiOne(), 
	    	        ((ReportOneLine)reportList.get(i)).getPiTwo().isEmpty() ? null : ((ReportOneLine)reportList.get(i)).getPiTwo(), 
	    	        ((ReportOneLine)reportList.get(i)).getPiThree().isEmpty() ? null : ((ReportOneLine)reportList.get(i)).getPiThree(), 
	    	        ((ReportOneLine)reportList.get(i)).getPiFour().isEmpty() ? null : ((ReportOneLine)reportList.get(i)).getPiFour(), 
	    	        ((ReportOneLine)reportList.get(i)).getPiFive().isEmpty() ? null : ((ReportOneLine)reportList.get(i)).getPiFive(),
	    	        ((ReportOneLine)reportList.get(i)).getTotalConnectWidth().isEmpty() ? null : ((ReportOneLine)reportList.get(i)).getTotalConnectWidth(),
    		        ((ReportOneLine)reportList.get(i)).getConnectLength(), 
    		        ((ReportOneLine)reportList.get(i)).getDrillingDepth(), 
    		        ((ReportOneLine)reportList.get(i)).getIntrusionDepth(), 
    		        String.valueOf(((ReportOneLine)reportList.get(i)).getBalance()), 
    		        String.valueOf(((ReportOneLine)reportList.get(i)).getGongSac()), 
    		        ((ReportOneLine)reportList.get(i)).getHammaT(), 
    		        ((ReportOneLine)reportList.get(i)).getFallMeter(), 
    		        ((ReportOneLine)reportList.get(i)).getManagedStandard(), 
    		        ((ReportOneLine)reportList.get(i)).getAvgPenetrationValue(), 
    		        ((ReportOneLine)reportList.get(i)).getTotalPenetrationValue(),
    		        ((ReportOneLine)reportList.get(i)).getUltimateBearingCapacity(),
    		        ((ReportOneLine)reportList.get(i)).getHammaEfficiency(),
    		        ((ReportOneLine)reportList.get(i)).getModulusElasticity(),
    		        ((ReportOneLine)reportList.get(i)).getCrossSection(),
    		        ((ReportOneLine)reportList.get(i)).getBigo(),
    		        ((ReportOneLine)reportList.get(i)).getSprCol1(),
    		        String.valueOf(((ReportOneLine)reportList.get(i)).getDuplicated()),
    		        String.valueOf(((ReportOneLine)reportList.get(i)).getTotalDuplicated())
    		        };
      }else {
    	  
    	  
    	  piOneSum += Double.parseDouble(((ReportOneLine)reportList.get(i)).getPiOne().isEmpty() ? "0" : ((ReportOneLine)reportList.get(i)).getPiOne());
    	  piTwoSum += Double.parseDouble(((ReportOneLine)reportList.get(i)).getPiTwo().isEmpty() ? "0" : ((ReportOneLine)reportList.get(i)).getPiTwo());
    	  piThreeSum += Double.parseDouble(((ReportOneLine)reportList.get(i)).getPiThree().isEmpty() ? "0" : ((ReportOneLine)reportList.get(i)).getPiThree());
    	  piFourSum += Double.parseDouble(((ReportOneLine)reportList.get(i)).getPiFour().isEmpty() ? "0" : ((ReportOneLine)reportList.get(i)).getPiFour());
    	  piFiveSum += Double.parseDouble(((ReportOneLine)reportList.get(i)).getPiFive().isEmpty() ? "0" : ((ReportOneLine)reportList.get(i)).getPiFive());
    	  connectLengthSum += Double.parseDouble(((ReportOneLine)reportList.get(i)).getConnectLength().isEmpty() ? "0" : ((ReportOneLine)reportList.get(i)).getConnectLength());
    	  ((ReportOneLine)reportList.get(i)).getBalance();
    	  gongSacSum +=  (double) Math.abs(((ReportOneLine)reportList.get(i)).getGongSac());
    	  
    	  strings = new String[]{ String.valueOf(i + 1), 
    		        setDinamicDate(role, isHiddenManager, longCalYn, ((ReportOneLine)reportList.get(i)).getCurrentDateTime(), ((ReportOneLine)reportList.get(i)).getCreateDate()),
    		        ((ReportOneLine)reportList.get(i)).getMachineNumber(), 
    		        ((ReportOneLine)reportList.get(i)).getPileType(), 
    		        ((ReportOneLine)reportList.get(i)).getMethod(), 
    		        ((ReportOneLine)reportList.get(i)).getLocation(), 
    		        ((ReportOneLine)reportList.get(i)).getPileNo(), 
    		        ((ReportOneLine)reportList.get(i)).getPileStandard(), 
    		        ((ReportOneLine)reportList.get(i)).getPiOne().isEmpty() ? null : ((ReportOneLine)reportList.get(i)).getPiOne(), 
	    	        ((ReportOneLine)reportList.get(i)).getPiTwo().isEmpty() ? null : ((ReportOneLine)reportList.get(i)).getPiTwo(), 
	    	        ((ReportOneLine)reportList.get(i)).getPiThree().isEmpty() ? null : ((ReportOneLine)reportList.get(i)).getPiThree(), 
	    	        ((ReportOneLine)reportList.get(i)).getPiFour().isEmpty() ? null : ((ReportOneLine)reportList.get(i)).getPiFour(), 
	    	        ((ReportOneLine)reportList.get(i)).getPiFive().isEmpty() ? null : ((ReportOneLine)reportList.get(i)).getPiFive(),
	    	        ((ReportOneLine)reportList.get(i)).getTotalConnectWidth().isEmpty() ? null : ((ReportOneLine)reportList.get(i)).getTotalConnectWidth(),
    		        ((ReportOneLine)reportList.get(i)).getConnectLength(), 
    		        ((ReportOneLine)reportList.get(i)).getDrillingDepth(), 
    		        ((ReportOneLine)reportList.get(i)).getIntrusionDepth(), 
    		        String.valueOf(((ReportOneLine)reportList.get(i)).getBalance()), 
    		        String.valueOf(((ReportOneLine)reportList.get(i)).getGongSac()), 
    		        ((ReportOneLine)reportList.get(i)).getHammaT(), 
    		        ((ReportOneLine)reportList.get(i)).getFallMeter(), 
    		        ((ReportOneLine)reportList.get(i)).getManagedStandard(), 
    		        ((ReportOneLine)reportList.get(i)).getAvgPenetrationValue(), 
    		        ((ReportOneLine)reportList.get(i)).getTotalPenetrationValue(),
    		        ((ReportOneLine)reportList.get(i)).getBigo(),
    		        ((ReportOneLine)reportList.get(i)).getSprCol1(),
    		        String.valueOf(((ReportOneLine)reportList.get(i)).getDuplicated()),
    		        String.valueOf(((ReportOneLine)reportList.get(i)).getTotalDuplicated())
    		        };
      }
      //setColumn(workbook, row1, strings, style, redStyle, blueStyle);
      setColumn(workbook, row1, strings, style, redStyle, blueStyle , pupleStyle, orangeStyle, yellowStyle);
      
      hideColumn(sheet, piOneSum, piTwoSum, piThreeSum, piFourSum, piFiveSum, connectLengthSum, gongSacSum);
    }
  }
  
  private void hideColumn(HSSFSheet sheet, double piOneSum, double piTwoSum, double piThreeSum, double piFourSum, double piFiveSum, double connectLengthSum, double gongSacSum) {
		
		sheet.setColumnHidden(8, piOneSum == 0 ? true : false);
		sheet.setColumnHidden(9, piTwoSum == 0 ? true : false);
		sheet.setColumnHidden(10, piThreeSum == 0 ? true : false);
		sheet.setColumnHidden(11, piFourSum == 0 ? true : false);
		sheet.setColumnHidden(12, piFiveSum == 0 ? true : false);
		sheet.setColumnHidden(14, connectLengthSum == 0 ? true : false);
		sheet.setColumnHidden(18, (double) gongSacSum == 0.0 ? true : false);
	}
  
  
  private HSSFSheet createFirstSheet(HSSFWorkbook workbook)
  {
    HSSFSheet sheet = workbook.createSheet();

    workbook.setSheetName(0, "접속통계");

    return sheet;
  }

  private void setExcelTitleLayoutSetting(HSSFSheet sheet, HSSFWorkbook workbook) {
    createExcelTitle(sheet, workbook);
    //sheet.addMergedRegion(new CellRangeAddress(1, 1, 8, 19));
    //해머효율삭제로 한칸 땡김
    //타이틀 영역
    //sheet.addMergedRegion(new CellRangeAddress(1, 1, 6, 17));
    
    if (ubcYn > 0) {
  		sheet.addMergedRegion(new CellRangeAddress(1, 1, 0, 29));
  	} else {
  		sheet.addMergedRegion(new CellRangeAddress(1, 1, 0, 25));
  	}
    
  }

  private void createExcelTitle(HSSFSheet sheet, HSSFWorkbook workbook)
  {
    HSSFRow firstRow = sheet.createRow(0);
	setExcelTitles1(workbook, firstRow, new String[] { "파일 항타 관입량 자동측정 시스템 (PDAM 시스템)\n Pile Driving Automatic Measurement system" });
    
    HSSFRow secondtRow = sheet.createRow(1);
	setExcelTitles2(workbook, secondtRow, new String[] { "파일 항타 관입량 자동측정 시스템 (PDAM 시스템)\n Pile Driving Automatic Measurement system" });
  
  }

  private void setExcelTitles1(HSSFWorkbook workbook, HSSFRow rows, String[] columnLabels) {
    CellStyle style = workbook.createCellStyle();

    style.setAlignment((short)2);
    style.setWrapText(true);
    style.setVerticalAlignment((short)1);
    style.setLocked(true);

    HSSFFont fontOfGothicBlackBold16 = workbook.createFont();
    fontOfGothicBlackBold16.setFontHeight((short)480);
    fontOfGothicBlackBold16.setBoldweight((short)700);
    style.setFont(fontOfGothicBlackBold16);

    for (int i = 0; i < columnLabels.length; i++) {
      HSSFCell cell = rows.createCell(i);
      rows.setHeight((short)0);
      cell.setCellValue(columnLabels[i]);
      cell.setCellStyle(style);
    }
  }

  private void setExcelTitles2(HSSFWorkbook workbook, HSSFRow rows, String[] columnLabels) {
    CellStyle style = workbook.createCellStyle();

    style.setAlignment((short)2);
    style.setWrapText(true);
    style.setVerticalAlignment((short)1);
    style.setLocked(true);

    HSSFFont fontOfGothicBlackBold16 = workbook.createFont();
    fontOfGothicBlackBold16.setFontHeight((short)480);
    fontOfGothicBlackBold16.setBoldweight((short)700);
    style.setFont(fontOfGothicBlackBold16);

    for (int i = 0; i < columnLabels.length; i++) {
      HSSFCell cell = rows.createCell(i);
      rows.setHeight((short)1500);
      cell.setCellValue(columnLabels[i]);
      cell.setCellStyle(style);
    }
  }

  private void createColumnLabels(HSSFSheet sheet, HSSFWorkbook workbook)
  {
    HSSFRow row1 = sheet.createRow(tableLabelStartIndex);

    //setColumnLabels(workbook, row1, new String[] { "번호", "시공일", "파일종류", "시공공법", "시공위치", "파일번호", "파일규격 \n( D )", "파일구분", "", "", "", "", "", "이음개소\n( EA )", "천공깊이\n( M )", "관입깊이\n( M )", "파일잔량\n( M )", "공삭공\n( M )", "해머무게\n( Ton )", "낙하높이\n( M )", "관리기준\n( mm )", "관입량 자동 측정( mm )", "", "", "", "", "", "", "비고", "해머효율\n( % )" });
    //setColumnLabels(workbook, row1, new String[] { "번호", "시공일", "시공장비", "파일종류", "시공공법", "시공위치", "파일번호", "파일규격 \n( D )", "파일구분", "", "", "", "", "", "이음개소\n( EA )", "천공깊이\n( M )", "관입깊이\n( M )", "파일잔량\n( M )", "공삭공\n( M )", "해머무게\n( Ton )", "낙하높이\n( M )", "관리기준\n( mm )", "관입량 자동 측정( mm )", "", "", "", "", "",  "", "", "", "", "", "", "극한\n지지력(kN)", "비고", "메모" });
    if(ubcYn > 0) {
    	setColumnLabels(workbook, row1, 
        		new String[] { "번호"
        					 , "시공일"
        					 , "시공장비"
        					 , "파일종류"
        					 , "시공공법"
        					 , "시공위치"
        					 , "파일번호"
        					 , "파일규격 \n( D )"
        					 , "파일구분"
        					 , ""
        					 , ""
        					 , ""
        					 , ""
        					 , ""
        					 , "이음개소\n( EA )"
        					 , "천공깊이\n( M )"
        					 , "관입깊이\n( M )"
        					 , "파일잔량\n( M )"
        					 , "공삭공\n( M )"
        					 , "해머무게\n( Ton )"
        					 , "낙하높이\n( M )"
        					 , "관리기준\n( mm )"
        					 , "평균관입"
        					 , "총관입량"
        					 , "극한\n지지력\n( kN )"
        					 , "해머효율\n( % )"
        					 , "탄성계수\n( t/cm2 )"
        					 , "파일\n단면적\n( cm2 )" 
        					 , "비고"
        					 , "메모" });
    }else {
    	
    	setColumnLabels(workbook, row1, 
        		new String[] { "번호"
        					 , "시공일"
        					 , "시공장비"
        					 , "파일종류"
        					 , "시공공법"
        					 , "시공위치"
        					 , "파일번호"
        					 , "파일규격 \n( D )"
        					 , "파일구분"
        					 , ""
        					 , ""
        					 , ""
        					 , ""
        					 , ""
        					 , "이음개소\n( EA )"
        					 , "천공깊이\n( M )"
        					 , "관입깊이\n( M )"
        					 , "파일잔량\n( M )"
        					 , "공삭공\n( M )"
        					 , "해머무게\n( Ton )"
        					 , "낙하높이\n( M )"
        					 , "관리기준\n( mm )"
        					 , "평균관입"
        					 , "총관입량"
        					 , "비고"
        					 , "메모" });
    	
    }
    
    //추가
    //setColumnLabels(workbook, row1, new String[] { "번호", "시공일", "파일종류", "시공공법", "시공위치", "파일번호", "파일규격 \n( D )", "파일구분", "", "", "", "", "", "이음개소\n( EA )", "천공깊이\n( M )", "관입깊이\n( M )", "파일잔량\n( M )", "공삭공\n( M )", "해머무게\n( Ton )", "낙하높이\n( M )", "관리기준\n( mm )", "관입량 자동 측정( mm )", "", "", "", "", "", "", "", "", "", "", "", "비고" });
    HSSFRow row2 = sheet.createRow(tableLabelEndIndex);

    //setColumnLabels(workbook, row2, new String[] { "번호", "시공일", "파일종류", "시공공법", "시공위치", "파일번호", "파일규격 D", "단본", "하단", "중단", "중단", "상단", "합계", "이음개소", "천공깊이", "관입깊이", "파일잔량", "공삭공", "해머무게", "낙하높이", "관리기준", "1회", "2회", "3회", "4회", "5회", "평균관입", "총관입량", "비고", "해머효율" });
    //추가 1회   
    //setColumnLabels(workbook, row2, new String[] { "번호", "시공일", "시공장비", "파일종류", "시공공법", "시공위치", "파일번호", "파일규격 D", "단본", "하단", "중단", "중단", "상단", "합계", "이음개소", "천공깊이", "관입깊이", "파일잔량", "공삭공", "해머무게", "낙하높이", "관리기준", "1회", "2회", "3회", "4회", "5회", "6회", "7회", "8회", "9회", "10회", "평균관입", "총관입량", "극한\n지지력(kN)", "비고", "메모" });
    
    if(ubcYn > 0) {
    	setColumnLabels(workbook, row2, 
        		new String[] { "번호"
        					 , "시공일"
        					 , "시공장비"
        					 , "파일종류"
        					 , "시공공법"
        					 , "시공위치"
        					 , "파일번호"
        					 , "파일규격 D"
        					 , "단본"
        					 , "하단"
        					 , "중단"
        					 , "중단"
        					 , "상단"
        					 , "합계"
        					 , "이음개소"
        					 , "천공깊이"
        					 , "관입깊이"
        					 , "파일잔량"
        					 , "공삭공"
        					 , "해머무게"
        					 , "낙하높이"
        					 , "관리기준"
        					 , "평균관입"
        					 , "총관입량"
        					 , "극한\n지지력\n( kN )"
        					 , "해머효율\n( % )"
        					 , "탄성계수\n( t/cm2 )"
        					 , "파일\n단면적\n( cm2 )" 
        					 , "비고"
        					 , "메모" });
    } else {
    	setColumnLabels(workbook, row2, 
        		new String[] { "번호"
        					 , "시공일"
        					 , "시공장비"
        					 , "파일종류"
        					 , "시공공법"
        					 , "시공위치"
        					 , "파일번호"
        					 , "파일규격 D"
        					 , "단본"
        					 , "하단"
        					 , "중단"
        					 , "중단"
        					 , "상단"
        					 , "합계"
        					 , "이음개소"
        					 , "천공깊이"
        					 , "관입깊이"
        					 , "파일잔량"
        					 , "공삭공"
        					 , "해머무게"
        					 , "낙하높이"
        					 , "관리기준"
        					 , "평균관입"
        					 , "총관입량"
        					 , "비고"
        					 , "메모" });
    }
    
  }

	private void setColumn(HSSFWorkbook workbook, HSSFRow row1, String[] strings, CellStyle style, CellStyle redStyle,
			CellStyle blueStyle, CellStyle pupleStyle, CellStyle orangeStyle, CellStyle yellowStyle) {

		for (int i = 0; i < strings.length - 2; i++) {
			HSSFCell cell = row1.createCell(i);
			row1.setHeight((short) 480);
			try {
				cell.setCellValue(Double.parseDouble(strings[i]));
			} catch (java.lang.NumberFormatException e) {
				cell.setCellValue(strings[i]);
			} catch (NullPointerException e) {
				cell.setCellValue(strings[i]);
			} catch (Exception e) {
				cell.setCellValue(strings[i]);
			}

			if (Integer.parseInt(strings[strings.length - 2]) > 1) {
				cell.setCellStyle(blueStyle);
			} else {
				if (Integer.parseInt(strings[strings.length - 1]) > 1) {
					cell.setCellStyle(pupleStyle);
				} else {
					if (Float.parseFloat(strings[21]) < Float.parseFloat(strings[22])) {
						cell.setCellStyle(orangeStyle);
					} else {
						cell.setCellStyle(style);
					}
				}
			}

			if ((i == 22) && (Float.parseFloat(strings[21]) < Float.parseFloat(strings[22]))) {

				cell.setCellStyle(redStyle);
				/*if (Integer.parseInt(strings[strings.length - 2]) > 1) {
					cell.setCellStyle(blueStyle);
				} else {
					cell.setCellStyle(redStyle);
				}*/
			}
		}
	}

  private void setColunmLabelLayoutSettiog(HSSFSheet sheet, HSSFWorkbook workbook)
  {
    createColumnLabels(sheet, workbook);
    sheet.addMergedRegion(new CellRangeAddress(
      tableLabelStartIndex, 
      tableLabelEndIndex, 
      0, 
      0));

    sheet.addMergedRegion(new CellRangeAddress(
      tableLabelStartIndex, 
      tableLabelEndIndex, 
      1, 
      1));

    sheet.addMergedRegion(new CellRangeAddress(
      tableLabelStartIndex, 
      tableLabelEndIndex, 
      2, 
      2));

    sheet.addMergedRegion(new CellRangeAddress(
      tableLabelStartIndex, 
      tableLabelEndIndex, 
      3, 
      3));

    sheet.addMergedRegion(new CellRangeAddress(
      tableLabelStartIndex, 
      tableLabelEndIndex, 
      4, 
      4));

    sheet.addMergedRegion(new CellRangeAddress(
      tableLabelStartIndex, 
      tableLabelEndIndex, 
      5, 
      5));

    sheet.addMergedRegion(new CellRangeAddress(
      tableLabelStartIndex, 
      tableLabelEndIndex, 
      6, 
      6));
    sheet.addMergedRegion(new CellRangeAddress(
      tableLabelStartIndex, 
      tableLabelEndIndex, 
      7, 
      7));
    //파일구분
    sheet.addMergedRegion(new CellRangeAddress(
      tableLabelStartIndex, 
      tableLabelEndIndex - 1, 
      8, 
      13));

    sheet.addMergedRegion(new CellRangeAddress(
      tableLabelStartIndex, 
      tableLabelEndIndex, 
      14, 
      14));

    sheet.addMergedRegion(new CellRangeAddress(
      tableLabelStartIndex, 
      tableLabelEndIndex, 
      15, 
      15));

    sheet.addMergedRegion(new CellRangeAddress(
      tableLabelStartIndex, 
      tableLabelEndIndex, 
      16, 
      16));

    sheet.addMergedRegion(new CellRangeAddress(
      tableLabelStartIndex, 
      tableLabelEndIndex, 
      17, 
      17));

    sheet.addMergedRegion(new CellRangeAddress(
      tableLabelStartIndex, 
      tableLabelEndIndex, 
      18, 
      18));

    sheet.addMergedRegion(new CellRangeAddress(
      tableLabelStartIndex, 
      tableLabelEndIndex, 
      18, 
      18));

    sheet.addMergedRegion(new CellRangeAddress(
      tableLabelStartIndex, 
      tableLabelEndIndex, 
      19, 
      19));

    sheet.addMergedRegion(new CellRangeAddress(
      tableLabelStartIndex, 
      tableLabelEndIndex, 
      20, 
      20));

    sheet.addMergedRegion(new CellRangeAddress(
      tableLabelStartIndex, 
      tableLabelEndIndex, 
      21, 
      21));

    sheet.addMergedRegion(new CellRangeAddress(
      tableLabelStartIndex, 
      tableLabelEndIndex, 
      22, 
      22));

    sheet.addMergedRegion(new CellRangeAddress(
      tableLabelStartIndex, 
      tableLabelEndIndex, 
      23, 
      23));

    sheet.addMergedRegion(new CellRangeAddress(
      tableLabelStartIndex, 
      tableLabelEndIndex, 
      24, 
      24));

    sheet.addMergedRegion(new CellRangeAddress(
      tableLabelStartIndex, 
      tableLabelEndIndex, 
      25, 
      25));
    
    
    	if(ubcYn > 0) {
	    	sheet.addMergedRegion(new CellRangeAddress(
			      tableLabelStartIndex, 
			      tableLabelEndIndex, 
			      //추가   
			      26,    
			      26));  
		    sheet.addMergedRegion(new CellRangeAddress(
			      tableLabelStartIndex, 
			      tableLabelEndIndex, 
			      //추가   
			      27,    
			      27)); 
		    sheet.addMergedRegion(new CellRangeAddress(
			      tableLabelStartIndex, 
			      tableLabelEndIndex, 
			      //추가   
			      28,    
			      28)); 
		    sheet.addMergedRegion(new CellRangeAddress(
			      tableLabelStartIndex, 
			      tableLabelEndIndex, 
			      //추가   
			      29,    
			      29));   
    	}
  }

  private void setColumnLabels(HSSFWorkbook workbook, HSSFRow rows, String[] columnLabels)
  {
    CellStyle style = workbook.createCellStyle();
    style.setWrapText(true);
    style.setAlignment((short)2);
    style.setVerticalAlignment((short)1);
    style.setLocked(true);

    HSSFFont font = workbook.createFont();

    style.setFont(font);
    style.setBorderRight((short)1);
    style.setBorderLeft((short)1);
    style.setBorderTop((short)1);
    style.setBorderBottom((short)1);
    font.setBoldweight((short)700);

    for (int i = 0; i < columnLabels.length; i++) {
      HSSFCell cell = null;
      cell = rows.createCell(i);
      rows.setHeight((short)480);
      cell.setCellValue(columnLabels[i]);
      cell.setCellStyle(style);
    }
  }
  
  
  private String setDinamicDate(int role, boolean isHiddenManager, int longCalYn, String currentDateTime, String createDate) {
	  if(role == 0) {
		  return createDate;
	  }else if(role == 3) {
		  if(longCalYn == 1) {
			  return createDate;
		  }
		  return currentDateTime;
	  }else {
		  if(longCalYn == 1 && isHiddenManager == true) {
			  return createDate;
		  }
		  return currentDateTime;
	  }
  }
 
}