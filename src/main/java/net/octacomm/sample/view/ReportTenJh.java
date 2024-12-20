package net.octacomm.sample.view;

import java.net.URLEncoder;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import net.octacomm.sample.domain.Penetration;
import net.octacomm.sample.domain.Piece;
import net.octacomm.sample.domain.Report;
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

public class ReportTenJh extends AbstractExcelView
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

    print.setScale((short) 45);
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

    List reportList = (List)model.get("domainList");
    
    System.err.println("reportList :  " + reportList.size());

    createColunm(sheet, workbook, reportList);
    createSumColunm(sheet, workbook, reportList);
  }

	private void createSumColunm(HSSFSheet sheet, HSSFWorkbook workbook, List<Report> reportList) {
		double sumTotalConnectWidth = 0.0D;
		double sumConnectLength = 0.0D;
		double sumDrillingDepth = 0.0D;
		double sumIntrusionDepth = 0.0D;
		double sumBlance = 0.0D;
		double sumGongSac = 0.0D;
		for (Report report : reportList) {
			sumTotalConnectWidth += Double.parseDouble(report.getTotalConnectWidth().isEmpty() ? "0" : report.getTotalConnectWidth());
			sumConnectLength += Double.parseDouble(report.getConnectLength().isEmpty() ? "0" : report.getConnectLength());
			sumDrillingDepth += Double.parseDouble(report.getDrillingDepth().isEmpty() ? "0" : report.getDrillingDepth());
			sumIntrusionDepth += Double.parseDouble(report.getIntrusionDepth().isEmpty() ? "0" : report.getIntrusionDepth());
			sumBlance += report.getBalance();
			sumGongSac += report.getGongSac();
		}

		HSSFRow row = sheet.createRow(tableValueStartIndex + reportList.size());
		if (ubcYn > 0) {
			setSumValues(workbook, row,
					new String[] { "합계", 
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
									null, // 평균관입략
									null, // 최종관립
									null, // 극한지지력
									null, // 해머효율
									null, // 탄성계수
									null, // 파일단면적
									null, // 비고
									null // 메모
					});
		} else {
			setSumValues(workbook, row,
					new String[] { "합계", 
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
									null, // 평균
									null, // 최종관립
									null, // 비고
									null // 메모
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

  private void createColunm(HSSFSheet sheet, HSSFWorkbook workbook, List<Report> reportList) {
	  
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
	  
	  for (int i = 0; i < reportList.size(); i++) {
      HSSFRow row1 = sheet.createRow(i + tableValueStartIndex);
      
      if(i == 1  || i == 2 ) {
    	  sheet.autoSizeColumn(i);
          sheet.setColumnWidth(i, (sheet.getColumnWidth(i)) + 512 );
      }
      
      if(i == 4 || i == 5 ) {
    	  sheet.autoSizeColumn(i);
    	  if((sheet.getColumnWidth(i) + 512) >= 3320) {
    		  sheet.setColumnWidth(i, (sheet.getColumnWidth(i) + 512) );
    	  }else {
    		  sheet.setColumnWidth(i, 3320 );
    	  }
      }
      String[] strings = null;
      if(ubcYn > 0) {
    	  strings = new String[]{ String.valueOf(i + 1), 
    		    	//(role == 0  ? ((Report)reportList.get(i)).getCreateDate() : ((Report)reportList.get(i)).getCurrentDateTime()),  
    			    setDinamicDate(role, isHiddenManager, longCalYn, ((Report)reportList.get(i)).getCurrentDateTime(), ((Report)reportList.get(i)).getCreateDate()), 
    			    ((Report)reportList.get(i)).getMachineNumber(), 
    			    ((Report)reportList.get(i)).getPileType(), 
    		        ((Report)reportList.get(i)).getMethod(), 
    		        ((Report)reportList.get(i)).getLocation(), 
    		        ((Report)reportList.get(i)).getPileNo(), 
    		        ((Report)reportList.get(i)).getPileStandard(), 
    		        "", 
    		        "", 
    		        "", 
    		        "", 
    		        "", 
    		        ((Report)reportList.get(i)).getTotalConnectWidth(), 
    		        ((Report)reportList.get(i)).getConnectLength(), 
    		        ((Report)reportList.get(i)).getDrillingDepth(), 
    		        ((Report)reportList.get(i)).getIntrusionDepth(), 
    		        String.valueOf(((Report)reportList.get(i)).getBalance()), 
    		        String.valueOf(((Report)reportList.get(i)).getGongSac()), 
    		        ((Report)reportList.get(i)).getHammaT(), 
    		        ((Report)reportList.get(i)).getFallMeter(), 
    		        ((Report)reportList.get(i)).getManagedStandard(), 
    		        ((Report)reportList.get(i)).getAvgPenetrationValue(), 
    		        ((Report)reportList.get(i)).getTotalPenetrationValue(),
    		        ((Report)reportList.get(i)).getUltimateBearingCapacity(),
    		        ((Report)reportList.get(i)).getHammaEfficiency(),
    		        ((Report)reportList.get(i)).getModulusElasticity(),
    		        ((Report)reportList.get(i)).getCrossSection(),
    		        ((Report)reportList.get(i)).getBigo(), 
    		        ((Report)reportList.get(i)).getSprCol1(), 
    		        String.valueOf(((Report)reportList.get(i)).getDuplicated()),
    		        String.valueOf(((Report)reportList.get(i)).getTotalDuplicated())
    		        };
      }else {
    	  strings = new String[]{ String.valueOf(i + 1), 
    			  	setDinamicDate(role, isHiddenManager, longCalYn, ((Report)reportList.get(i)).getCurrentDateTime(), ((Report)reportList.get(i)).getCreateDate()), 
    			  	((Report)reportList.get(i)).getMachineNumber(), 
    			  	((Report)reportList.get(i)).getPileType(), 
    		        ((Report)reportList.get(i)).getMethod(), 
    		        ((Report)reportList.get(i)).getLocation(), 
    		        ((Report)reportList.get(i)).getPileNo(), 
    		        ((Report)reportList.get(i)).getPileStandard(), 
    		        "", 
    		        "", 
    		        "", 
    		        "", 
    		        "", 
    		        ((Report)reportList.get(i)).getTotalConnectWidth(), 
    		        ((Report)reportList.get(i)).getConnectLength(), 
    		        ((Report)reportList.get(i)).getDrillingDepth(), 
    		        ((Report)reportList.get(i)).getIntrusionDepth(), 
    		        String.valueOf(((Report)reportList.get(i)).getBalance()), 
    		        String.valueOf(((Report)reportList.get(i)).getGongSac()), 
    		        ((Report)reportList.get(i)).getHammaT(), 
    		        ((Report)reportList.get(i)).getFallMeter(), 
    		        ((Report)reportList.get(i)).getManagedStandard(), 
    		        ((Report)reportList.get(i)).getAvgPenetrationValue(), 
    		        ((Report)reportList.get(i)).getTotalPenetrationValue(),
    		        ((Report)reportList.get(i)).getBigo(), 
    		        ((Report)reportList.get(i)).getSprCol1(), 
    		        String.valueOf(((Report)reportList.get(i)).getDuplicated()),
    		        String.valueOf(((Report)reportList.get(i)).getTotalDuplicated())
    		        };
      }
      
      
      if(((Piece)((Report)reportList.get(i)).getPiece().get(0)).getValue().isEmpty()) {
    	  strings[8] = null;
      }else {
    	  strings[8] = ((Piece)((Report)reportList.get(i)).getPiece().get(0)).getValue();
      }
      
      if(((Piece)((Report)reportList.get(i)).getPiece().get(1)).getValue().isEmpty()) {
    	  strings[9] = null;
      }else {
    	  strings[9] = ((Piece)((Report)reportList.get(i)).getPiece().get(1)).getValue();
      }
      
      
      if(((Report)reportList.get(i)).getPiece().size() >= 4) {
    	  if(((Piece)((Report)reportList.get(i)).getPiece().get(2)).getValue().isEmpty()) {
    		  strings[10] = null;
    	  }else {
    		  strings[10] = ((Piece)((Report)reportList.get(i)).getPiece().get(2)).getValue();
    	  }
      }else {
    	  strings[10] = null;
      }
      
      if(((Report)reportList.get(i)).getPiece().size() >= 5) {
    	  if(((Piece)((Report)reportList.get(i)).getPiece().get(3)).getValue().isEmpty()) {
    		  strings[11] = null;
    	  }else {
    		  strings[11] = ((Piece)((Report)reportList.get(i)).getPiece().get(3)).getValue();
    	  }
      }else {
    	  strings[11] = null;
      }
      
      
      if(((Piece)((Report)reportList.get(i)).getPiece().get(((Report)reportList.get(i)).getPiece().size() - 1)).getValue().isEmpty()) {
    	  strings[12] = null;
      }else {
    	  strings[12] = ((Piece)((Report)reportList.get(i)).getPiece().get(((Report)reportList.get(i)).getPiece().size() - 1)).getValue();
      }
      
      //strings[7] = ((Piece)((Report)reportList.get(i)).getPiece().get(0)).getValue();
      //strings[8] = ((Piece)((Report)reportList.get(i)).getPiece().get(1)).getValue();
      //strings[9] = (((Report)reportList.get(i)).getPiece().size() >= 4 ? ((Piece)((Report)reportList.get(i)).getPiece().get(2)).getValue() : "");
      //strings[10] = (((Report)reportList.get(i)).getPiece().size() >= 5 ? ((Piece)((Report)reportList.get(i)).getPiece().get(3)).getValue() : "");
      //strings[11] = ((Piece)((Report)reportList.get(i)).getPiece().get(((Report)reportList.get(i)).getPiece().size() - 1)).getValue();
      
      //추가 9로 변경
      //setColumn(workbook, row1, strings);
      //setColumn(workbook, row1, strings, style, redStyle, blueStyle);
      
      setColumn(workbook, row1, strings, style, redStyle, blueStyle , pupleStyle, orangeStyle, yellowStyle);
    }
  }

  private HSSFSheet createFirstSheet(HSSFWorkbook workbook)
  {
    HSSFSheet sheet = workbook.createSheet();

    workbook.setSheetName(0, "접속통계");

    return sheet;
  }

  private void setExcelTitleLayoutSetting(HSSFSheet sheet, HSSFWorkbook workbook) {
    createExcelTitle(sheet, workbook);
    //해머효율삭제로 한칸 땡김
    sheet.addMergedRegion(new CellRangeAddress(1, 1, 7, 18));
  }

	private void createExcelTitle(HSSFSheet sheet, HSSFWorkbook workbook) {
		HSSFRow firstRow = sheet.createRow(0);

		// 해머효율삭제
		if (ubcYn > 0) {
			setExcelTitles1(workbook, firstRow, new String[] { "", "", "", "", "", "", "", "", "", "", "", "", "", "",
					"", "", "", "", "", "", "", "", "", "", "", "", "", "", "" , ""});
		} else {
			setExcelTitles1(workbook, firstRow,
					new String[] { "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "" });
		}

		HSSFRow secondtRow = sheet.createRow(1);

		// 해머효율삭제
		if (ubcYn > 0) {
			setExcelTitles2(workbook, secondtRow,
					new String[] { "", "", "", "", "", "","",
							"파일 항타 관입량 자동측정 시스템 (PDAM 시스템)\n Pile Driving Automatic Measurement system", "", "", "", "",
							"", "", "", "", "", "", "" });

		} else {
			setExcelTitles2(workbook, secondtRow,
					new String[] { "", "", "", "", "", "","",
							"파일 항타 관입량 자동측정 시스템 (PDAM 시스템)\n Pile Driving Automatic Measurement system", "", "", "", "",
							"", "", "", "" });
		}

	}

	private void setExcelTitles1(HSSFWorkbook workbook, HSSFRow rows, String[] columnLabels) {
		CellStyle style = workbook.createCellStyle();

		style.setAlignment((short) 2);
		style.setWrapText(true);
		style.setVerticalAlignment((short) 1);
		style.setLocked(true);

		HSSFFont fontOfGothicBlackBold16 = workbook.createFont();
		fontOfGothicBlackBold16.setFontHeight((short) 480);
		fontOfGothicBlackBold16.setBoldweight((short) 700);
		style.setFont(fontOfGothicBlackBold16);

		for (int i = 0; i < columnLabels.length; i++) {
			HSSFCell cell = rows.createCell(i);
			rows.setHeight((short) 0);
			cell.setCellValue(columnLabels[i]);
			cell.setCellStyle(style);
		}
	}

	private void setExcelTitles2(HSSFWorkbook workbook, HSSFRow rows, String[] columnLabels) {
		CellStyle style = workbook.createCellStyle();

		style.setAlignment((short) 2);
		style.setWrapText(true);
		style.setVerticalAlignment((short) 1);
		style.setLocked(true);

		HSSFFont fontOfGothicBlackBold16 = workbook.createFont();
		fontOfGothicBlackBold16.setFontHeight((short) 480);
		fontOfGothicBlackBold16.setBoldweight((short) 700);
		style.setFont(fontOfGothicBlackBold16);

		for (int i = 0; i < columnLabels.length; i++) {
			HSSFCell cell = rows.createCell(i);
			rows.setHeight((short) 1500);
			cell.setCellValue(columnLabels[i]);
			cell.setCellStyle(style);
		}
	}

	private void createColumnLabels(HSSFSheet sheet, HSSFWorkbook workbook) {
		
		HSSFRow row1 = sheet.createRow(tableLabelStartIndex);

    //setColumnLabels(workbook, row1, new String[] { "번호", "시공일", "파일종류", "시공공법", "시공위치", "파일번호", "파일규격 \n( D )", "파일구분", "", "", "", "", "", "이음개소\n( EA )", "천공깊이\n( M )", "관입깊이\n( M )", "파일잔량\n( M )", "공삭공\n( M )", "해머무게\n( Ton )", "낙하높이\n( M )", "관리기준\n( mm )", "관입량 자동 측정( mm )", "", "", "", "", "", "", "비고", "해머효율\n( % )" });
    //setColumnLabels(workbook, row1, new String[] { "번호", "시공일", "파일종류", "시공공법", "시공위치", "파일번호", "파일규격 \n( D )", "파일구분", "", "", "", "", "", "이음개소\n( EA )", "천공깊이\n( M )", "관입깊이\n( M )", "파일잔량\n( M )", "공삭공\n( M )", "해머무게\n( Ton )", "낙하높이\n( M )", "관리기준\n( mm )", "관입량 자동 측정( mm )", "", "", "", "", "", "", "비고" });
    //추가
    
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
    
    HSSFRow row2 = sheet.createRow(tableLabelEndIndex);

    //setColumnLabels(workbook, row2, new String[] { "번호", "시공일", "파일종류", "시공공법", "시공위치", "파일번호", "파일규격 D", "단본", "하단", "중단", "중단", "상단", "합계", "이음개소", "천공깊이", "관입깊이", "파일잔량", "공삭공", "해머무게", "낙하높이", "관리기준", "1회", "2회", "3회", "4회", "5회", "평균관입", "총관입량", "비고", "해머효율" });
    //추가 1회
    
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
			// cell.setCellStyle(style);
			if (Integer.parseInt(strings[strings.length - 2]) > 1) {
				cell.setCellStyle(blueStyle);
			} else {
				if (Integer.parseInt(strings[strings.length - 1]) > 1) {
					cell.setCellStyle(pupleStyle);
				} else {
					if ((Float.parseFloat((strings[21] == "" ? "0" : strings[21])) < Float.parseFloat(strings[22] == "" ? "0" : strings[22]))) {
						cell.setCellStyle(orangeStyle);
					} else {
						cell.setCellStyle(style);
					}
				}
			}

			if ((i == 22) && (Float.parseFloat((strings[21] == "" ? "0" : strings[21])) < Float.parseFloat(strings[22] == "" ? "0" : strings[22])))
				cell.setCellStyle(redStyle);
				/*if (Integer.parseInt(strings[strings.length - 2]) > 1) {
					cell.setCellStyle(blueStyle);
				} else {
					cell.setCellStyle(redStyle);
				}*/
		}
	}

	private void setColunmLabelLayoutSettiog(HSSFSheet sheet, HSSFWorkbook workbook) {
		createColumnLabels(sheet, workbook);
		sheet.addMergedRegion(new CellRangeAddress(tableLabelStartIndex, tableLabelEndIndex, 0, 0));

		sheet.addMergedRegion(new CellRangeAddress(tableLabelStartIndex, tableLabelEndIndex, 1, 1));

		sheet.addMergedRegion(new CellRangeAddress(tableLabelStartIndex, tableLabelEndIndex, 2, 2));

		sheet.addMergedRegion(new CellRangeAddress(tableLabelStartIndex, tableLabelEndIndex, 3, 3));

		sheet.addMergedRegion(new CellRangeAddress(tableLabelStartIndex, tableLabelEndIndex, 4, 4));

		sheet.addMergedRegion(new CellRangeAddress(tableLabelStartIndex, tableLabelEndIndex, 5, 5));

		sheet.addMergedRegion(new CellRangeAddress(tableLabelStartIndex, tableLabelEndIndex, 6, 6));
		
		sheet.addMergedRegion(new CellRangeAddress(tableLabelStartIndex, tableLabelEndIndex, 7, 7));
		// 파일구분
		sheet.addMergedRegion(new CellRangeAddress(tableLabelStartIndex, tableLabelEndIndex - 1, 8, 13));

		sheet.addMergedRegion(new CellRangeAddress(tableLabelStartIndex, tableLabelEndIndex, 14, 14));

		sheet.addMergedRegion(new CellRangeAddress(tableLabelStartIndex, tableLabelEndIndex, 15, 15));

		sheet.addMergedRegion(new CellRangeAddress(tableLabelStartIndex, tableLabelEndIndex, 16, 16));

		sheet.addMergedRegion(new CellRangeAddress(tableLabelStartIndex, tableLabelEndIndex, 18, 18));

		sheet.addMergedRegion(new CellRangeAddress(tableLabelStartIndex, tableLabelEndIndex, 17, 17));

		sheet.addMergedRegion(new CellRangeAddress(tableLabelStartIndex, tableLabelEndIndex, 18, 18));

		sheet.addMergedRegion(new CellRangeAddress(tableLabelStartIndex, tableLabelEndIndex, 19, 19));

		sheet.addMergedRegion(new CellRangeAddress(tableLabelStartIndex, tableLabelEndIndex, 20, 20));

		sheet.addMergedRegion(new CellRangeAddress(tableLabelStartIndex, tableLabelEndIndex, 21, 21));

		sheet.addMergedRegion(new CellRangeAddress(tableLabelStartIndex, tableLabelEndIndex, 22, 22));

		sheet.addMergedRegion(new CellRangeAddress(tableLabelStartIndex, tableLabelEndIndex, 23, 23));

		sheet.addMergedRegion(new CellRangeAddress(tableLabelStartIndex, tableLabelEndIndex, 24, 24));
		
		sheet.addMergedRegion(new CellRangeAddress(tableLabelStartIndex, tableLabelEndIndex, 25, 25));

		if (ubcYn > 0) {
			sheet.addMergedRegion(new CellRangeAddress(tableLabelStartIndex, tableLabelEndIndex,
					// 추가
					26, 26));
			sheet.addMergedRegion(new CellRangeAddress(tableLabelStartIndex, tableLabelEndIndex,
					// 추가
					27, 27));
			sheet.addMergedRegion(new CellRangeAddress(tableLabelStartIndex, tableLabelEndIndex,
					// 추가
					28, 28));
			sheet.addMergedRegion(new CellRangeAddress(tableLabelStartIndex, tableLabelEndIndex,
					// 추가
					29, 29));
		}
	}

	private void setColumnLabels(HSSFWorkbook workbook, HSSFRow rows, String[] columnLabels) {
		CellStyle style = workbook.createCellStyle();
		style.setWrapText(true);
		style.setAlignment((short) 2);
		style.setVerticalAlignment((short) 1);
		style.setLocked(true);

		HSSFFont font = workbook.createFont();

		style.setFont(font);
		style.setBorderRight((short) 1);
		style.setBorderLeft((short) 1);
		style.setBorderTop((short) 1);
		style.setBorderBottom((short) 1);
		font.setBoldweight((short) 700);

		for (int i = 0; i < columnLabels.length; i++) {
			HSSFCell cell = null;
			if ((i > 18) && (i < 26)) {
				cell = rows.createCell(i);
				rows.setHeight((short) 480);
				cell.setCellValue(columnLabels[i]);
				cell.setCellStyle(style);
			} else {
				cell = rows.createCell(i);
				rows.setHeight((short) 480);
				cell.setCellValue(columnLabels[i]);
				cell.setCellStyle(style);
			}
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