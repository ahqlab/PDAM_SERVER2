package net.octacomm.sample.view;

import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFPrintSetup;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.util.CellRangeAddress;

import org.springframework.web.servlet.view.document.AbstractExcelView;

import net.octacomm.sample.domain.Construction;
import net.octacomm.sample.domain.FileInventoryOfChart;
import net.octacomm.sample.domain.FileUsingChart;
import net.octacomm.sample.domain.MultiFileUsingChartObj;
import net.octacomm.sample.utils.DateUtil;

public class MultiFileUsingChartExcelView2 extends AbstractExcelView {

	public boolean isPhc = true;

	private static final int COLUNM_HEIGHT = 480;

	private static short TEXT_SISE = (short) (16 * 14);
	
	//String[][] allColLabel;
	private ArrayList<String[]> allColLabel;
	
	public String separateSinglePileType;
	public String separateSinglePileTypeText;
	
	public String separateBottomPileType;
	public String separateBottomPileTypeText;
	
	private List<MultiFileUsingChartObj> objList;
	
	
	
	@Override
	protected void buildExcelDocument(Map<String, Object> model, HSSFWorkbook workbook, HttpServletRequest req,
			HttpServletResponse res) throws Exception {

		allColLabel = new ArrayList<String[]>();
		
		String userAgent = req.getHeader("User-Agent");
		String fileName = "PDAM_FILE_CHART_" + DateUtil.getCurrentDatetime() + ".xls";
		if (userAgent.indexOf("MSIE") > -1) {
			fileName = URLEncoder.encode(fileName, "utf-8");
		} else {
			fileName = new String(fileName.getBytes("utf-8"), "iso-8859-1");
		}
		res.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\";");
		res.setHeader("Content-Transfer-Encoding", "binary");
		
		HSSFSheet sheet = createFirstSheet(workbook);
		HSSFPrintSetup print = sheet.getPrintSetup();
		print.setPaperSize((short) 9);
		print.setLandscape(true);
		sheet.setFitToPage(true);
		sheet.setMargin((short) 2, 0.1D);
		sheet.setMargin((short) 3, 0.1D);
		sheet.setMargin((short) 0, 0.2D);
		sheet.setMargin((short) 1, 0.2D);
		
		
		objList =  (List<MultiFileUsingChartObj>) model.get("fileUsingChartObjs");
		
		int rowIndex = 0;
		
		for (MultiFileUsingChartObj multiFileUsingChartObj : objList) {
			
			String pileName = multiFileUsingChartObj.getPileName();
//			if (pileName.startsWith("PHC")) {
//				this.isPhc = true;
//				print.setScale((short) 30);
//			} else {
//				this.isPhc = false;
//				print.setScale((short) 27);
//			}
			
			Construction construction = multiFileUsingChartObj.getConstruction();
			
			setExcelTitleLayoutSetting(sheet, workbook, construction, pileName, rowIndex);
			
			
			setExcelConstructionTitleLayoutSetting(sheet, workbook, rowIndex);
			
			FileUsingChart chart1 = multiFileUsingChartObj.getChart1();
			FileUsingChart chart2 = multiFileUsingChartObj.getChart2();
			FileUsingChart chart3 = multiFileUsingChartObj.getChart3();
			FileUsingChart chart4 = multiFileUsingChartObj.getChart4();
			
			separateSinglePileType = multiFileUsingChartObj.getSeparateSinglePileType();
			separateBottomPileType = multiFileUsingChartObj.getSeparateBottomPileType();
			try {
				separateSinglePileTypeText = (separateSinglePileType != null && separateSinglePileType.length() > 0 ? "(" + separateSinglePileType + ")" : "");
			}catch (Exception e) {
				separateSinglePileTypeText = "";
			}
			
			try {
				separateBottomPileTypeText = (separateBottomPileType != null && separateBottomPileType.length() > 0 ? "(" + separateBottomPileType + ")" : "");
			}catch (Exception e) {
				separateBottomPileTypeText = "";
			}
			
			//세번째줄 파일시공 수량 value
			setExcelConstructionValueLayoutSetting(sheet, workbook, chart1, chart2, chart3, chart4, rowIndex);
			
			FileInventoryOfChart surplusChart = multiFileUsingChartObj.getSurplusChart();
			
			//네번째 줄 파일재고수량
			setExcelSurplusLayoutSetting(sheet, workbook, surplusChart, rowIndex);
			
			setExcelMiddleLayoutSetting(sheet, workbook, rowIndex);
			
			List<FileInventoryOfChart> fileInventoryChartList = multiFileUsingChartObj.getFileInventoryChartList();
			
			FileInventoryOfChart sumChart = multiFileUsingChartObj.getSumChart();
			
			setExcelSumLayoutSetting(sheet, workbook, sumChart, rowIndex);
			
			int lastIndex = setExcelValueSetting(sheet, workbook, fileInventoryChartList, workbook.createCellStyle(), rowIndex);
			
			rowIndex = lastIndex + 1;
					
		}
		
		ArrayList<Integer> deleteTarget = new ArrayList<Integer>();
		
		//이건 없는 데이터를 삭제하기 위함인거 같다. 보니까.
		for (int i = 0; i < 1; i++) {
			for (int j = 0; j < allColLabel.get(i).length; j++) {
				if((allColLabel.get(2)[j].trim().equals("0") && allColLabel.get(3)[j].trim().equals("0")) == true) {
					deleteTarget.add(j);
				}
			}
		}
		
		for (int i = 0; i < deleteTarget.size(); i++) {
			sheet.setColumnHidden(Integer.parseInt(deleteTarget.get(i).toString()), true);
		}
		
		
		//첫줄 타이틀
		//두번째쭐 파일시공 수량 M숫자
	}

	private int setExcelValueSetting(HSSFSheet sheet, HSSFWorkbook workbook, List<FileInventoryOfChart> fileInventoryChartList, CellStyle cellStyle, int rowIndex ) {
		return createExcelValue(sheet, workbook, fileInventoryChartList, cellStyle, rowIndex);
	}

	private int createExcelValue(HSSFSheet sheet, HSSFWorkbook workbook, List<FileInventoryOfChart> fileInventoryChartList , CellStyle cellStyle, int rowIndex) {
		
		sheet.setColumnWidth(1, sheet.getColumnWidth(1) + (short)1024);
		
		int lastRowIndex = 0;
		
		for (int i = 0; i < fileInventoryChartList.size(); i++) {
			sheet.setColumnWidth(i, sheet.getColumnWidth(i) + 1024);
			if (this.isPhc) {
				
				String[] arr = new String[] { ((FileInventoryOfChart) fileInventoryChartList.get(i)).getMaker(),
						((FileInventoryOfChart) fileInventoryChartList.get(i)).getRegistDate(),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getTotal()),String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBTotal())),
						String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getAccum()),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof51()) , String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof51())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof61()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof61())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof71()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof71())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof81()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof81())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof91()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof91())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof101()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof101())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof111()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof111())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof121()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof121())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof131()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof131())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof141()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof141())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof151()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof151())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getTotal1()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBTotal1())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof52()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof52())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof62()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof62())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof72()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof72())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof82()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof82())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof92()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof92())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof102()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof102())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof112()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof112())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof122()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof122())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof132()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof132())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof142()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof142())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof152()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof152())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getTotal2()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBTotal2())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof53()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof53())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof63()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof63())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof73()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof73())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof83()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof83())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof93()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof93())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof103()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof103())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof113()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof113())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof123()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof123())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof123()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof123())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof143()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof143())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof153()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof153())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getTotal3()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBTotal3())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof54()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof54())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof64()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof64())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof74()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof74())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof84()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof84())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof94()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof94())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof104()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof104())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof114()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof114())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof124()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof124())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof134()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof134())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof144()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof144())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof154()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof154())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getTotal4()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBTotal4())),
						"" };
				allColLabel.add(arr);
				setExcelValue(workbook, sheet.createRow(rowIndex + i + 8), arr, cellStyle);
			
			} else {
				String[] arr = new String[] { ((FileInventoryOfChart) fileInventoryChartList.get(i)).getMaker(),
						((FileInventoryOfChart) fileInventoryChartList.get(i)).getRegistDate(),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getTotal()),String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBTotal())),
						String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getAccum()),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof51()) , String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof51())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof61()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof61())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof71()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof71())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof81()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof81())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof91()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof91())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof101()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof101())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof111()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof111())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof121()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof121())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof131()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof131())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof141()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof141())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof151()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof151())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof161()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof161())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof171()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof171())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof181()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof181())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getTotal1()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBTotal1())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof52()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof52())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof62()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof62())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof72()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof72())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof82()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof82())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof92()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof92())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof102()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof102())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof112()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof112())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof122()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof122())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof132()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof132())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof142()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof142())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof152()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof152())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof162()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof162())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof172()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof172())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof182()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof182())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getTotal2()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBTotal2())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof53()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof53())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof63()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof63())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof73()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof73())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof83()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof83())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof93()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof93())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof103()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof103())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof113()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof113())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof123()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof123())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof123()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof123())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof143()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof143())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof153()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof153())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof163()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof163())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof173()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof173())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof183()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof183())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getTotal3()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBTotal3())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof54()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof54())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof64()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof64())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof74()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof74())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof84()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof84())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof94()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof94())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof104()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof104())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof114()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof114())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof124()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof124())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof134()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof134())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof144()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof144())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof154()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof154())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof164()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof164())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof174()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof174())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getMeterof184()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBMeterof184())),
						plusBrokenValueCell(String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getTotal4()), String.valueOf(((FileInventoryOfChart) fileInventoryChartList.get(i)).getBTotal4())),
						"" };
				
				allColLabel.add(arr);
				setExcelValue(workbook, sheet.createRow(rowIndex + i + 8), arr , cellStyle);

			}
			lastRowIndex = rowIndex + i + 8;
		}
		
		return lastRowIndex;
	}

	
	private String plusBrokenValueCell(String originCell, String brokenCell) {
	    if (brokenCell != null 
	            && !brokenCell.trim().isEmpty() 
	            && !"null".equalsIgnoreCase(brokenCell.trim()) 
	            && !brokenCell.trim().equals("0") 
	            && !brokenCell.trim().equals("0.0")) {
	        return originCell + "(" + brokenCell + ")";
	    } else {
	        return originCell;
	    }
	}
	
	private void setExcelValue(HSSFWorkbook workbook, HSSFRow rows, String[] columnLabels, CellStyle cellStyle) {
		
		//System.err.println("columnLabels.length : " + columnLabels.length);
		cellStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);
		cellStyle.setWrapText(true);
		cellStyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
		cellStyle.setLocked(true);

		cellStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
		cellStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
		cellStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
		
		
		for (int i = 0; i < columnLabels.length; i++) {
			HSSFCell cell = rows.createCell(i);
			rows.setHeight((short) COLUNM_HEIGHT);
			cell.setCellValue(columnLabels[i]);
			try {
	      	  cell.setCellValue(Double.parseDouble(columnLabels[i]));
		   	}catch (java.lang.NumberFormatException e) {
		   	  	 cell.setCellValue(columnLabels[i]);
		   	}catch (NullPointerException e) {
		   	  	 cell.setCellValue(columnLabels[i]);
		   	}catch (Exception e) {
		   	  	 cell.setCellValue(columnLabels[i]);
		   	}
			cell.setCellStyle(cellStyle);
		}
	}

	private void setExcelSumLayoutSetting(HSSFSheet sheet, HSSFWorkbook workbook, FileInventoryOfChart sumChart, int rowIndex) {
		createExcelSum(sheet, workbook, sumChart, rowIndex);
	}

	private void createExcelSum(HSSFSheet sheet, HSSFWorkbook workbook, FileInventoryOfChart sumChart, int rowIndex) {
		if (isPhc) {
			String[] arr = new String[] {"", "합계", "N.A", plusBrokenValueCell(String.valueOf(sumChart.getTotal()),String.valueOf(sumChart.getBTotal())),
					String.valueOf(sumChart.getMeterof51()), String.valueOf(sumChart.getMeterof61()),
					String.valueOf(sumChart.getMeterof71()), String.valueOf(sumChart.getMeterof81()),
					String.valueOf(sumChart.getMeterof91()), String.valueOf(sumChart.getMeterof101()),
					String.valueOf(sumChart.getMeterof111()), String.valueOf(sumChart.getMeterof121()),
					String.valueOf(sumChart.getMeterof131()), String.valueOf(sumChart.getMeterof141()),
					String.valueOf(sumChart.getMeterof151()), plusBrokenValueCell(String.valueOf(sumChart.getTotal1()),String.valueOf(sumChart.getBTotal1())),
					String.valueOf(sumChart.getMeterof52()), String.valueOf(sumChart.getMeterof62()),
					String.valueOf(sumChart.getMeterof72()), String.valueOf(sumChart.getMeterof82()),
					String.valueOf(sumChart.getMeterof92()), String.valueOf(sumChart.getMeterof102()),
					String.valueOf(sumChart.getMeterof112()), String.valueOf(sumChart.getMeterof122()),
					String.valueOf(sumChart.getMeterof132()), String.valueOf(sumChart.getMeterof142()),
					String.valueOf(sumChart.getMeterof152()), plusBrokenValueCell(String.valueOf(sumChart.getTotal2()),String.valueOf(sumChart.getBTotal2())),
					String.valueOf(sumChart.getMeterof53()), String.valueOf(sumChart.getMeterof63()),
					String.valueOf(sumChart.getMeterof73()), String.valueOf(sumChart.getMeterof83()),
					String.valueOf(sumChart.getMeterof93()), String.valueOf(sumChart.getMeterof103()),
					String.valueOf(sumChart.getMeterof113()), String.valueOf(sumChart.getMeterof123()),
					String.valueOf(sumChart.getMeterof133()), String.valueOf(sumChart.getMeterof143()),
					String.valueOf(sumChart.getMeterof153()), plusBrokenValueCell(String.valueOf(sumChart.getTotal3()),String.valueOf(sumChart.getBTotal3())),
					String.valueOf(sumChart.getMeterof54()), String.valueOf(sumChart.getMeterof64()),
					String.valueOf(sumChart.getMeterof74()), String.valueOf(sumChart.getMeterof84()),
					String.valueOf(sumChart.getMeterof94()), String.valueOf(sumChart.getMeterof104()),
					String.valueOf(sumChart.getMeterof114()), String.valueOf(sumChart.getMeterof124()),
					String.valueOf(sumChart.getMeterof134()), String.valueOf(sumChart.getMeterof144()),
					String.valueOf(sumChart.getMeterof154()), 
					plusBrokenValueCell(String.valueOf(sumChart.getTotal4()),String.valueOf(sumChart.getBTotal4())), "" };
			allColLabel.add(arr);
			setExcelSum(workbook, sheet.createRow(rowIndex + 7), arr);
			
			
			
		} else {
			
			String[] arr = new String[] { "","합계", "N.A", plusBrokenValueCell(String.valueOf(sumChart.getTotal()),String.valueOf(sumChart.getBTotal())),
					String.valueOf(sumChart.getMeterof51()), String.valueOf(sumChart.getMeterof61()),
					String.valueOf(sumChart.getMeterof71()), String.valueOf(sumChart.getMeterof81()),
					String.valueOf(sumChart.getMeterof91()), String.valueOf(sumChart.getMeterof101()),
					String.valueOf(sumChart.getMeterof111()), String.valueOf(sumChart.getMeterof121()),
					String.valueOf(sumChart.getMeterof131()), String.valueOf(sumChart.getMeterof141()),
					String.valueOf(sumChart.getMeterof151()), String.valueOf(sumChart.getMeterof161()),
					String.valueOf(sumChart.getMeterof171()), String.valueOf(sumChart.getMeterof181()),
					plusBrokenValueCell(String.valueOf(sumChart.getTotal1()),String.valueOf(sumChart.getBTotal1())), String.valueOf(sumChart.getMeterof52()),
					String.valueOf(sumChart.getMeterof62()), String.valueOf(sumChart.getMeterof72()),
					String.valueOf(sumChart.getMeterof82()), String.valueOf(sumChart.getMeterof92()),
					String.valueOf(sumChart.getMeterof102()), String.valueOf(sumChart.getMeterof112()),
					String.valueOf(sumChart.getMeterof122()), String.valueOf(sumChart.getMeterof132()),
					String.valueOf(sumChart.getMeterof142()), String.valueOf(sumChart.getMeterof152()),
					String.valueOf(sumChart.getMeterof162()), String.valueOf(sumChart.getMeterof172()),
					String.valueOf(sumChart.getMeterof182()), plusBrokenValueCell(String.valueOf(sumChart.getTotal2()),String.valueOf(sumChart.getBTotal2())),
					String.valueOf(sumChart.getMeterof53()), String.valueOf(sumChart.getMeterof63()),
					String.valueOf(sumChart.getMeterof73()), String.valueOf(sumChart.getMeterof83()),
					String.valueOf(sumChart.getMeterof93()), String.valueOf(sumChart.getMeterof103()),
					String.valueOf(sumChart.getMeterof113()), String.valueOf(sumChart.getMeterof123()),
					String.valueOf(sumChart.getMeterof133()), String.valueOf(sumChart.getMeterof143()),
					String.valueOf(sumChart.getMeterof153()), String.valueOf(sumChart.getMeterof163()),
					String.valueOf(sumChart.getMeterof173()), String.valueOf(sumChart.getMeterof183()),
					plusBrokenValueCell(String.valueOf(sumChart.getTotal3()),String.valueOf(sumChart.getBTotal3())), String.valueOf(sumChart.getMeterof54()),
					String.valueOf(sumChart.getMeterof64()), String.valueOf(sumChart.getMeterof74()),
					String.valueOf(sumChart.getMeterof84()), String.valueOf(sumChart.getMeterof94()),
					String.valueOf(sumChart.getMeterof104()), String.valueOf(sumChart.getMeterof114()),
					String.valueOf(sumChart.getMeterof124()), String.valueOf(sumChart.getMeterof134()),
					String.valueOf(sumChart.getMeterof144()), String.valueOf(sumChart.getMeterof154()),
					String.valueOf(sumChart.getMeterof164()), String.valueOf(sumChart.getMeterof174()),
					String.valueOf(sumChart.getMeterof184()), plusBrokenValueCell(String.valueOf(sumChart.getTotal4()),String.valueOf(sumChart.getBTotal4())), "" };
			
			allColLabel.add(arr);
			setExcelSum(workbook, sheet.createRow(rowIndex + 7), arr );
		}
	}

	private void setExcelSum(HSSFWorkbook workbook, HSSFRow rows, String[] columnLabels) {
		
		CellStyle style = workbook.createCellStyle();
		style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
		style.setWrapText(true);
		style.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
		style.setLocked(true);
		style.setBorderRight(HSSFCellStyle.BORDER_THIN);
		style.setBorderLeft(HSSFCellStyle.BORDER_THIN);
		style.setBorderBottom(HSSFCellStyle.BORDER_THIN);
		style.setFillForegroundColor(HSSFColor.TAN.index);
		style.setFillPattern(CellStyle.SOLID_FOREGROUND);

		CellStyle redStyle = workbook.createCellStyle();
		redStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);
		redStyle.setWrapText(true);
		redStyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
		redStyle.setLocked(true);
		redStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
		redStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
		redStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
		redStyle.setFillForegroundColor(HSSFColor.TAN.index);
		redStyle.setFillPattern(CellStyle.SOLID_FOREGROUND);

		HSSFFont font = workbook.createFont();
		font.setColor(HSSFColor.RED.index);
		redStyle.setFont(font);

		for (int i = 0; i < columnLabels.length; i++) {
			HSSFCell cell = rows.createCell(i);
			rows.setHeight((short) COLUNM_HEIGHT);
			//cell.setCellValue(columnLabels[i]);
			try {
				 cell.setCellValue(Double.parseDouble(columnLabels[i]));
		   	}catch (java.lang.NumberFormatException e) {
		   	  	 cell.setCellValue(columnLabels[i]);
		   	}catch (NullPointerException e) {
		   	  	 cell.setCellValue(columnLabels[i]);
		   	}catch (Exception e) {
		   	  	 cell.setCellValue(columnLabels[i]);
		   	}
			cell.setCellStyle(style);
			
		}
	}

	private void setExcelMiddleLayoutSetting(HSSFSheet sheet, HSSFWorkbook workbook, int rowIndex) {
		createExcelMiddle(sheet, workbook, rowIndex);
		sheet.addMergedRegion(new CellRangeAddress(rowIndex + 4, rowIndex + 7, 0, 0));
		sheet.addMergedRegion(new CellRangeAddress(rowIndex + 4, rowIndex + 6, 1, 1));
		sheet.addMergedRegion(new CellRangeAddress(rowIndex + 4, rowIndex + 6, 2, 2));
		sheet.addMergedRegion(new CellRangeAddress(rowIndex + 4, rowIndex + 6, 3, 3));

		if (isPhc) {
			sheet.addMergedRegion(new CellRangeAddress(rowIndex + 1, rowIndex + 2, 64 - 12, 64 - 12));
			sheet.addMergedRegion(new CellRangeAddress(rowIndex + 4, rowIndex + 7, 64 - 12, 64 - 12));
		} else {
			sheet.addMergedRegion(new CellRangeAddress(rowIndex + 1, rowIndex + 2, 64, 64));
			sheet.addMergedRegion(new CellRangeAddress(rowIndex + 4, rowIndex + 7, 64, 64));
		}

		if (isPhc) {
			sheet.addMergedRegion(new CellRangeAddress(rowIndex + 4, rowIndex + 4, 4, 15)); //하단, 중단, 상단
			sheet.addMergedRegion(new CellRangeAddress(rowIndex + 5, rowIndex + 5, 4, 15)); //파일반입수량

			sheet.addMergedRegion(new CellRangeAddress(rowIndex + 4, rowIndex + 4, 16, 27)); //하단, 중단, 상단
			sheet.addMergedRegion(new CellRangeAddress(rowIndex + 5, rowIndex + 5, 16, 27)); //파일반입수량

			sheet.addMergedRegion(new CellRangeAddress(rowIndex + 4, rowIndex + 4, 28, 39)); //하단, 중단, 상단
			sheet.addMergedRegion(new CellRangeAddress(rowIndex + 5, rowIndex + 5, 28, 39)); //파일반입수량

			sheet.addMergedRegion(new CellRangeAddress(rowIndex + 4, rowIndex + 4, 40, 51)); //하단, 중단, 상단
			sheet.addMergedRegion(new CellRangeAddress(rowIndex + 5, rowIndex + 5, 40, 51)); //파일반입수량

			// sheet.addMergedRegion(new CellRangeAddress(4, 6 , (15 + 11 + 1 + 11 + 1 + 11)
			// + 1, (15 + 11 + 1 + 11 + 1 + 11) + 1));
		} else {
			sheet.addMergedRegion(new CellRangeAddress(rowIndex + 4, rowIndex + 4, 4, 18));
			sheet.addMergedRegion(new CellRangeAddress(rowIndex + 5, rowIndex + 5, 4, 18));

			sheet.addMergedRegion(new CellRangeAddress(rowIndex + 4, rowIndex + 4, 19, (19 + 14)));
			sheet.addMergedRegion(new CellRangeAddress(rowIndex + 5, rowIndex + 5, 19, (19 + 14)));

			sheet.addMergedRegion(new CellRangeAddress(rowIndex + 4, rowIndex + 4, (19 + 14 + 1), (19 + 14 + 1 + 14)));
			sheet.addMergedRegion(new CellRangeAddress(rowIndex + 5, rowIndex + 5, (19 + 14 + 1), (19 + 14 + 1 + 14)));

			sheet.addMergedRegion(new CellRangeAddress(rowIndex + 4, rowIndex + 4, (19 + 14 + 1 + 14 + 1), (19 + 14 + 1 + 14 + 1 + 14)));
			sheet.addMergedRegion(new CellRangeAddress(rowIndex + 5, rowIndex + 5, (19 + 14 + 1 + 14 + 1), (19 + 14 + 1 + 14 + 1 + 14)));
		}
		
	}

	private void createExcelMiddle(HSSFSheet sheet, HSSFWorkbook workbook, int rowIndex) {
		if (isPhc) {
			setExcelMiddleOfOne(workbook, sheet.createRow(rowIndex + 4),
					new String[] {"제조사", "날짜", "일일\n반입량\n(본)", "누계\n반입량\n(본)", "파일반입수량", "", "", "", "", "",
							"", "", "", "", "", "", "파일반입수량", "", "", "", "", "", "", "", "", "", "", "",
							"파일반입수량", "", "", "", "", "", "", "", "", "", "", "", "파일반입수량", "", "", "", "",
							"", "", "", "", "", "", "", "비고" });
			
			allColLabel.add(new String[] {"제조사", "날짜", "일일\n반입량\n(본)", "누계\n반입량\n(본)", "파일반입수량", "", "", "", "", "",
					"", "", "", "", "", "", "파일반입수량", "", "", "", "", "", "", "", "", "", "", "",
					"파일반입수량", "", "", "", "", "", "", "", "", "", "", "", "파일반입수량", "", "", "", "",
					"", "", "", "", "", "", "", "비고" });
			
			
			setExcelMiddleOfOne(workbook, sheet.createRow(rowIndex + 5),
					new String[] {"", "", "", "", "단본" + separateSinglePileTypeText, "", "", "", "", "", "", "", "", "", "", "", "하단" + separateBottomPileTypeText, "", "", "",
							"", "", "", "", "", "", "", "", "중단", "", "", "", "", "", "", "", "", "", "", "", "상단",
							"", "", "", "", "", "", "", "", "", "", "", "비고" });
			
			allColLabel.add(new String[] {"", "", "", "", "단본" + separateSinglePileTypeText, "", "", "", "", "", "", "", "", "", "", "", "하단" + separateBottomPileTypeText, "", "", "",
					"", "", "", "", "", "", "", "", "중단", "", "", "", "", "", "", "", "", "", "", "", "상단",
					"", "", "", "", "", "", "", "", "", "", "", "비고" });
			
			setExcelMiddle(workbook, sheet.createRow(rowIndex + 6),
					new String[] { "", "파일시공수량", "", "", "5M", "6M", "7M", "8M", "9M", "10M", "11M", "12M", "13M",
							"14M", "15M", "합계", "5M", "6M", "7M", "8M", "9M", "10M", "11M", "12M", "13M", "14M",
							"15M", "합계", "5M", "6M", "7M", "8M", "9M", "10M", "11M", "12M", "13M", "14M", "15M",
							"합계", "5M", "6M", "7M", "8M", "9M", "10M", "11M", "12M", "13M", "14M", "15M", "합계",
							"비고" });
			
			allColLabel.add(new String[] { "", "파일시공수량", "", "", "5M", "6M", "7M", "8M", "9M", "10M", "11M", "12M", "13M",
					"14M", "15M", "합계", "5M", "6M", "7M", "8M", "9M", "10M", "11M", "12M", "13M", "14M",
					"15M", "합계", "5M", "6M", "7M", "8M", "9M", "10M", "11M", "12M", "13M", "14M", "15M",
					"합계", "5M", "6M", "7M", "8M", "9M", "10M", "11M", "12M", "13M", "14M", "15M", "합계",
					"비고" });
			
		} else {
			setExcelMiddleOfOne(workbook, sheet.createRow(rowIndex + 4),
					new String[] {"제조사", "날짜", "일일\n반입량\n(본)", "누계\n반입량\n(본)", "파일반입수량", "", "", "", "", "",
							"", "", "", "", "", "", "", "", "", "파일반입수량", "", "", "", "", "", "", "", "", "", "",
							"", "", "", "", "파일반입수량", "", "", "", "", "", "", "", "", "", "", "", "", "", "",
							"파일반입수량", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "비고" });
			
			allColLabel.add(new String[] {"제조사", "날짜", "일일\n반입량\n(본)", "누계\n반입량\n(본)", "파일반입수량", "", "", "", "", "",
					"", "", "", "", "", "", "", "", "", "파일반입수량", "", "", "", "", "", "", "", "", "", "",
					"", "", "", "", "파일반입수량", "", "", "", "", "", "", "", "", "", "", "", "", "", "",
					"파일반입수량", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "비고" });
			
			
			
			setExcelMiddleOfOne(workbook, sheet.createRow(rowIndex + 5),
					new String[] { "","", "", "", "단본" + separateSinglePileTypeText, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "하단" + separateBottomPileTypeText,
							"", "", "", "", "", "", "", "", "", "", "", "", "", "", "중단", "", "", "", "", "", "", "",
							"", "", "", "", "", "", "", "상단", "", "", "", "", "", "", "", "", "", "", "", "", "", "",
							"비고" });
			
			allColLabel.add(new String[] { "","", "", "", "단본" + separateSinglePileTypeText, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "하단" + separateBottomPileTypeText,
					"", "", "", "", "", "", "", "", "", "", "", "", "", "", "중단", "", "", "", "", "", "", "",
					"", "", "", "", "", "", "", "상단", "", "", "", "", "", "", "", "", "", "", "", "", "", "",
					"비고" });
			
			setExcelMiddle(workbook, sheet.createRow(rowIndex + 6),
					new String[] { "","파일시공수량", "", "", "5M", "6M", "7M", "8M", "9M", "10M", "11M", "12M", "13M",
							"14M", "15M", "16M", "17M", "18M", "합계", "5M", "6M", "7M", "8M", "9M", "10M", "11M",
							"12M", "13M", "14M", "15M", "16M", "17M", "18M", "합계", "5M", "6M", "7M", "8M", "9M",
							"10M", "11M", "12M", "13M", "14M", "15M", "16M", "17M", "18M", "합계", "5M", "6M", "7M",
							"8M", "9M", "10M", "11M", "12M", "13M", "14M", "15M", "16M", "17M", "18M", "합계", "비고" });
			
			allColLabel.add(new String[] { "","파일시공수량", "", "", "5M", "6M", "7M", "8M", "9M", "10M", "11M", "12M", "13M",
					"14M", "15M", "16M", "17M", "18M", "합계", "5M", "6M", "7M", "8M", "9M", "10M", "11M",
					"12M", "13M", "14M", "15M", "16M", "17M", "18M", "합계", "5M", "6M", "7M", "8M", "9M",
					"10M", "11M", "12M", "13M", "14M", "15M", "16M", "17M", "18M", "합계", "5M", "6M", "7M",
					"8M", "9M", "10M", "11M", "12M", "13M", "14M", "15M", "16M", "17M", "18M", "합계", "비고" });
			
			
		}

	}

	private void setExcelMiddleOfOne(HSSFWorkbook workbook, HSSFRow rows, String[] columnLabels) {
		
		
		CellStyle style = workbook.createCellStyle();
		style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
		style.setWrapText(true);
		style.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
		style.setLocked(true);
		style.setBorderRight(HSSFCellStyle.BORDER_THIN);
		style.setBorderLeft(HSSFCellStyle.BORDER_THIN);
		style.setBorderBottom(HSSFCellStyle.BORDER_THIN);
		style.setFillForegroundColor(HSSFColor.TAN.index);
		style.setFillPattern(CellStyle.SOLID_FOREGROUND);

		CellStyle redStyle = workbook.createCellStyle();
		redStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);
		redStyle.setWrapText(true);
		redStyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
		redStyle.setLocked(true);
		redStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
		redStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
		redStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
		redStyle.setFillForegroundColor(HSSFColor.TAN.index);
		redStyle.setFillPattern(CellStyle.SOLID_FOREGROUND);

		HSSFFont font = workbook.createFont();
		font.setFontHeight(TEXT_SISE);
		redStyle.setFont(font);

		for (int i = 0; i < columnLabels.length; i++) {
			HSSFCell cell = rows.createCell(i);
			rows.setHeight((short) COLUNM_HEIGHT);
			cell.setCellValue(columnLabels[i]);
			cell.setCellStyle(style);

			if (i == 1 || i == 2 || i == 3 || i == 4 || i == 16 || i == 28 || i == 40 || i == 52) {
				rows.setHeight((short) COLUNM_HEIGHT);
				cell.setCellValue(columnLabels[i]);
				cell.setCellStyle(redStyle);
			} else {
				rows.setHeight((short) COLUNM_HEIGHT);
				cell.setCellValue(columnLabels[i]);
				cell.setCellStyle(style);
			}

		}

	}

	private void setExcelMiddle(HSSFWorkbook workbook, HSSFRow rows, String[] columnLabels) {
		
		
		CellStyle style = workbook.createCellStyle();
		style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
		style.setWrapText(true);
		style.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
		style.setLocked(true);
		style.setBorderRight(HSSFCellStyle.BORDER_THIN);
		style.setBorderLeft(HSSFCellStyle.BORDER_THIN);
		style.setBorderBottom(HSSFCellStyle.BORDER_THIN);
		style.setFillForegroundColor(HSSFColor.TAN.index);
		style.setFillPattern(CellStyle.SOLID_FOREGROUND);

		for (int i = 0; i < columnLabels.length; i++) {
			HSSFCell cell = rows.createCell(i);
			rows.setHeight((short) COLUNM_HEIGHT);
			cell.setCellValue(columnLabels[i]);
			cell.setCellStyle(style);
		}

	}

	private void setExcelSurplusLayoutSetting(HSSFSheet sheet, HSSFWorkbook workbook, FileInventoryOfChart surplusChart, int rowIndex) {
		createExcelSurplus(sheet, workbook, surplusChart, rowIndex);
		sheet.addMergedRegion(new CellRangeAddress(rowIndex + 3, rowIndex + 3, 0, 2));
	}

	private void createExcelSurplus(HSSFSheet sheet, HSSFWorkbook workbook, FileInventoryOfChart surplusChart, int rowIndex) {
		HSSFRow secondtRow = sheet.createRow(rowIndex + 3);
		if (isPhc) {
			String allTotal = String.valueOf(surplusChart.getTotal1() + surplusChart.getTotal2() + surplusChart.getTotal3() + surplusChart.getTotal4());
			String[] columnLabels = new String[] { "파일재고수량", "","", allTotal, String.valueOf(surplusChart.getMeterof51()),
					String.valueOf(surplusChart.getMeterof61()), String.valueOf(surplusChart.getMeterof71()),
					String.valueOf(surplusChart.getMeterof81()), String.valueOf(surplusChart.getMeterof91()),
					String.valueOf(surplusChart.getMeterof101()), String.valueOf(surplusChart.getMeterof111()),
					String.valueOf(surplusChart.getMeterof121()), String.valueOf(surplusChart.getMeterof131()),
					String.valueOf(surplusChart.getMeterof141()), String.valueOf(surplusChart.getMeterof151()),
					String.valueOf(surplusChart.getTotal1()), String.valueOf(surplusChart.getMeterof52()),
					String.valueOf(surplusChart.getMeterof62()), String.valueOf(surplusChart.getMeterof72()),
					String.valueOf(surplusChart.getMeterof82()), String.valueOf(surplusChart.getMeterof92()),
					String.valueOf(surplusChart.getMeterof102()), String.valueOf(surplusChart.getMeterof112()),
					String.valueOf(surplusChart.getMeterof122()), String.valueOf(surplusChart.getMeterof132()),
					String.valueOf(surplusChart.getMeterof142()), String.valueOf(surplusChart.getMeterof152()),
					String.valueOf(surplusChart.getTotal2()), String.valueOf(surplusChart.getMeterof53()),
					String.valueOf(surplusChart.getMeterof63()), String.valueOf(surplusChart.getMeterof73()),
					String.valueOf(surplusChart.getMeterof83()), String.valueOf(surplusChart.getMeterof93()),
					String.valueOf(surplusChart.getMeterof103()), String.valueOf(surplusChart.getMeterof113()),
					String.valueOf(surplusChart.getMeterof123()), String.valueOf(surplusChart.getMeterof133()),
					String.valueOf(surplusChart.getMeterof143()), String.valueOf(surplusChart.getMeterof153()),
					String.valueOf(surplusChart.getTotal3()), String.valueOf(surplusChart.getMeterof54()),
					String.valueOf(surplusChart.getMeterof64()), String.valueOf(surplusChart.getMeterof74()),
					String.valueOf(surplusChart.getMeterof84()), String.valueOf(surplusChart.getMeterof94()),
					String.valueOf(surplusChart.getMeterof104()), String.valueOf(surplusChart.getMeterof114()),
					String.valueOf(surplusChart.getMeterof124()), String.valueOf(surplusChart.getMeterof134()),
					String.valueOf(surplusChart.getMeterof144()), String.valueOf(surplusChart.getMeterof154()),
					String.valueOf(surplusChart.getTotal4()), "" };
			allColLabel.add(columnLabels);
			setExcelConstructionSurplus(workbook, secondtRow, columnLabels );
		} else {
			String allTotal = String.valueOf(surplusChart.getTotal1() + surplusChart.getTotal2() + surplusChart.getTotal3() + surplusChart.getTotal4());
			String[] columnLabels = new String[] { "파일재고수량", "","", allTotal, String.valueOf(surplusChart.getMeterof51()),
					String.valueOf(surplusChart.getMeterof61()), String.valueOf(surplusChart.getMeterof71()),
					String.valueOf(surplusChart.getMeterof81()), String.valueOf(surplusChart.getMeterof91()),
					String.valueOf(surplusChart.getMeterof101()), String.valueOf(surplusChart.getMeterof111()),
					String.valueOf(surplusChart.getMeterof121()), String.valueOf(surplusChart.getMeterof131()),
					String.valueOf(surplusChart.getMeterof141()), String.valueOf(surplusChart.getMeterof151()),
					String.valueOf(surplusChart.getMeterof161()), String.valueOf(surplusChart.getMeterof171()),
					String.valueOf(surplusChart.getMeterof181()), String.valueOf(surplusChart.getTotal1()),
					String.valueOf(surplusChart.getMeterof52()), String.valueOf(surplusChart.getMeterof62()),
					String.valueOf(surplusChart.getMeterof72()), String.valueOf(surplusChart.getMeterof82()),
					String.valueOf(surplusChart.getMeterof92()), String.valueOf(surplusChart.getMeterof102()),
					String.valueOf(surplusChart.getMeterof112()), String.valueOf(surplusChart.getMeterof122()),
					String.valueOf(surplusChart.getMeterof132()), String.valueOf(surplusChart.getMeterof142()),
					String.valueOf(surplusChart.getMeterof152()), String.valueOf(surplusChart.getMeterof162()),
					String.valueOf(surplusChart.getMeterof172()), String.valueOf(surplusChart.getMeterof182()),
					String.valueOf(surplusChart.getTotal2()), String.valueOf(surplusChart.getMeterof53()),
					String.valueOf(surplusChart.getMeterof63()), String.valueOf(surplusChart.getMeterof73()),
					String.valueOf(surplusChart.getMeterof83()), String.valueOf(surplusChart.getMeterof93()),
					String.valueOf(surplusChart.getMeterof103()), String.valueOf(surplusChart.getMeterof113()),
					String.valueOf(surplusChart.getMeterof123()), String.valueOf(surplusChart.getMeterof133()),
					String.valueOf(surplusChart.getMeterof143()), String.valueOf(surplusChart.getMeterof153()),
					String.valueOf(surplusChart.getMeterof163()), String.valueOf(surplusChart.getMeterof173()),
					String.valueOf(surplusChart.getMeterof183()), String.valueOf(surplusChart.getTotal3()),
					String.valueOf(surplusChart.getMeterof54()), String.valueOf(surplusChart.getMeterof64()),
					String.valueOf(surplusChart.getMeterof74()), String.valueOf(surplusChart.getMeterof84()),
					String.valueOf(surplusChart.getMeterof94()), String.valueOf(surplusChart.getMeterof104()),
					String.valueOf(surplusChart.getMeterof114()), String.valueOf(surplusChart.getMeterof124()),
					String.valueOf(surplusChart.getMeterof134()), String.valueOf(surplusChart.getMeterof144()),
					String.valueOf(surplusChart.getMeterof154()), String.valueOf(surplusChart.getMeterof164()),
					String.valueOf(surplusChart.getMeterof174()), String.valueOf(surplusChart.getMeterof184()),
					String.valueOf(surplusChart.getTotal4()), "" };
			
			allColLabel.add(columnLabels);
			setExcelConstructionSurplus(workbook, secondtRow, columnLabels );
		}

	}

	private void setExcelConstructionSurplus(HSSFWorkbook workbook, HSSFRow rows, String[] columnLabels) {
		
		
		CellStyle style = workbook.createCellStyle();
		style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
		style.setWrapText(true);
		style.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
		style.setLocked(true);
		style.setBorderRight(HSSFCellStyle.BORDER_THIN);
		style.setBorderLeft(HSSFCellStyle.BORDER_THIN);
		style.setBorderBottom(HSSFCellStyle.BORDER_THIN);
		style.setFillForegroundColor(HSSFColor.YELLOW.index);
		style.setFillPattern(CellStyle.SOLID_FOREGROUND);

		HSSFFont font = workbook.createFont();
		font.setColor(HSSFColor.RED.index);
		style.setFont(font);

		CellStyle textBicStyle = workbook.createCellStyle();
		textBicStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);
		textBicStyle.setWrapText(true);
		textBicStyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
		textBicStyle.setLocked(true);
		textBicStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
		textBicStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
		textBicStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
		textBicStyle.setFillForegroundColor(HSSFColor.YELLOW.index);
		textBicStyle.setFillPattern(CellStyle.SOLID_FOREGROUND);

		HSSFFont bicStylefont = workbook.createFont();
		bicStylefont.setColor(HSSFColor.RED.index);
		bicStylefont.setFontHeight(TEXT_SISE);// �궗�씠利�
		textBicStyle.setFont(bicStylefont);

		for (int i = 0; i < columnLabels.length; i++) {
			HSSFCell cell = rows.createCell(i);
			rows.setHeight((short) COLUNM_HEIGHT);
			//cell.setCellValue(columnLabels[i]);
			 try {
		      	  cell.setCellValue(Double.parseDouble(columnLabels[i]));
			   	  }catch (java.lang.NumberFormatException e) {
			   	  	 cell.setCellValue(columnLabels[i]);
			   	  }catch (NullPointerException e) {
			   	  	 cell.setCellValue(columnLabels[i]);
			   	  }catch (Exception e) {
			   	  	 cell.setCellValue(columnLabels[i]);
			   	  }
			cell.setCellStyle(style);

			if (i == 0) {
				rows.setHeight((short) COLUNM_HEIGHT);
				//cell.setCellValue(columnLabels[i]);
				 try {
		      	  cell.setCellValue(Double.parseDouble(columnLabels[i]));
			   	  }catch (java.lang.NumberFormatException e) {
			   	  	 cell.setCellValue(columnLabels[i]);
			   	  }catch (NullPointerException e) {
			   	  	 cell.setCellValue(columnLabels[i]);
			   	  }catch (Exception e) {
			   	  	 cell.setCellValue(columnLabels[i]);
			   	  }
				cell.setCellStyle(textBicStyle);
			} else {
				rows.setHeight((short) COLUNM_HEIGHT);
				//cell.setCellValue(columnLabels[i]);
				 try {
		      	  cell.setCellValue(Double.parseDouble(columnLabels[i]));
			   	  }catch (java.lang.NumberFormatException e) {
			   	  	 cell.setCellValue(columnLabels[i]);
			   	  }catch (NullPointerException e) {
			   	  	 cell.setCellValue(columnLabels[i]);
			   	  }catch (Exception e) {
			   	  	 cell.setCellValue(columnLabels[i]);
			   	  }
				cell.setCellStyle(style);
			}

		}

	}

	private void setExcelTitleLayoutSetting(HSSFSheet sheet, HSSFWorkbook workbook, Construction construction, String pileName, int rowIndex) {
		createExcelTitle(sheet, workbook, construction, pileName, rowIndex);
		
		if(isPhc) {
			sheet.addMergedRegion(new CellRangeAddress(rowIndex, rowIndex, 0, 52));
		}else {
			sheet.addMergedRegion(new CellRangeAddress(rowIndex, rowIndex, 0, (52 + 12)));
		}
	}

	private void createExcelTitle(HSSFSheet sheet, HSSFWorkbook workbook, Construction construction, String pileName, int rowIndex) {
		HSSFRow firstRow = sheet.createRow(rowIndex);
		if (isPhc) {
			
			String[] columnLabels = new String[] { "파일 반입 및 재고 현황  - " + construction.getLocation() + " " + pileName , "", "", "", "", "", "", "", "", "",
					//"", "", "", "", "", "", pileName, "", "", "",
					"", "", "", "", "", "", "", "", "", "",
					//"", "", "", "", "", "", "", "", "파일 반입 및 재고", "",
					"", "", "", "", "", "", "", "", "", "",
					"", "", "", "", "", "", "", "", "", "",
					"", "", "", "", "", "", "", "", "", "",
					"", "", "" };
			allColLabel.add(columnLabels);
			setExcelTitles1(workbook, firstRow, columnLabels);
		} else {
			
			String[] columnLabels = new String[] { "파일 반입 및 재고 현황  - " + construction.getLocation() + " " + pileName , "", "", "", "", "", "", "", "", "",
					//"", "", "", "", "", "", "", "", "", pileName,
					"", "", "", "", "", "", "", "", "", "",
					"", "", "", "", "", "", "", "", "", "",
					//"", "", "", "파일 반입 및 재고", "", "", "", "", "", "", 
					"", "", "", "", "", "", "", "", "", "", 
					"", "", "", "", "", "", "", "", "", "",
					"", "", "", "", "", "", "", "", "", "",
					"", "", "", "", "" };
			allColLabel.add(columnLabels);
			setExcelTitles1(workbook, firstRow, columnLabels);
		}

	}

	private void setExcelTitles1(HSSFWorkbook workbook, HSSFRow rows, String[] columnLabels) {
		
		CellStyle style = workbook.createCellStyle();
		style.setAlignment(HSSFCellStyle.ALIGN_LEFT);
		style.setWrapText(true);
		style.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);

		style.setBorderTop(HSSFCellStyle.BORDER_THIN);
		style.setBorderRight(HSSFCellStyle.BORDER_THIN);
		style.setBorderLeft(HSSFCellStyle.BORDER_THIN);
		style.setBorderBottom(HSSFCellStyle.BORDER_THIN);

		HSSFFont fontOfGothicBlackBold16 = workbook.createFont();
		fontOfGothicBlackBold16.setFontHeight((short) (24 * 13)); // �궗�씠利�
		fontOfGothicBlackBold16.setBoldweight(org.apache.poi.ss.usermodel.Font.BOLDWEIGHT_BOLD); // 蹂쇰뱶 (援듦쾶)
		style.setFont(fontOfGothicBlackBold16);

		for (int i = 0; i < columnLabels.length; i++) {

			HSSFCell cell = rows.createCell(i);
			rows.setHeight((short) COLUNM_HEIGHT);
			cell.setCellValue(columnLabels[i]);
			cell.setCellStyle(style);
		}
	}

	private void setExcelConstructionTitleLayoutSetting(HSSFSheet sheet, HSSFWorkbook workbook , int rowIndx) {
		createConstructionExcelTitle(sheet, workbook, rowIndx);
		sheet.addMergedRegion(new CellRangeAddress(rowIndx + 1, rowIndx + 2, 0, 2));
		sheet.addMergedRegion(new CellRangeAddress(rowIndx + 1, rowIndx + 2, 0, 0));
	}

	private void createConstructionExcelTitle(HSSFSheet sheet, HSSFWorkbook workbook, int rowIndx) {
		HSSFRow secondtRow = sheet.createRow(rowIndx + 1);
		sheet.setColumnWidth(3, (sheet.getColumnWidth(1)) + (short) 1024 * 2);

		if (isPhc) {
			
			String[] columnLabels = new String[] {"파일시공수량","", "", "총작업량(본)", "5M", "6M", "7M", "8M", "9M", "10M", "11M", "12M",
					"13M", "14M", "15M", "합계", "5M", "6M", "7M", "8M", "9M", "10M", "11M", "12M", "13M",
					"14M", "15M", "합계", "5M", "6M", "7M", "8M", "9M", "10M", "11M", "12M", "13M", "14M",
					"15M", "합계", "5M", "6M", "7M", "8M", "9M", "10M", "11M", "12M", "13M", "14M", "15M",
					"합계", "비고" };
			
			allColLabel.add(columnLabels);
			setExcelConstructionTitles(workbook, secondtRow, columnLabels);
			
		} else {
			
			String[] columnLabels = new String[] { "파일시공수량", "","", "총작업량(본)", "5M", "6M", "7M", "8M", "9M", "10M", "11M", "12M",
					"13M", "14M", "15M", "16M", "17M", "18M", "합계", "5M", "6M", "7M", "8M", "9M", "10M",
					"11M", "12M", "13M", "14M", "15M", "16M", "17M", "18M", "합계", "5M", "6M", "7M", "8M",
					"9M", "10M", "11M", "12M", "13M", "14M", "15M", "16M", "17M", "18M", "합계", "5M", "6M",
					"7M", "8M", "9M", "10M", "11M", "12M", "13M", "14M", "15M", "16M", "17M", "18M", "합계",
					"비고" };
			allColLabel.add(columnLabels);
			setExcelConstructionTitles(workbook, secondtRow, columnLabels);
		}

	}

	private void setExcelConstructionTitles(HSSFWorkbook workbook, HSSFRow rows, String[] columnLabels) {
		
		
		CellStyle style = workbook.createCellStyle();
		style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
		style.setWrapText(true);
		style.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
		style.setLocked(true);
		style.setFillForegroundColor(HSSFColor.PALE_BLUE.index);
		style.setFillPattern(CellStyle.SOLID_FOREGROUND);
		style.setBorderRight(HSSFCellStyle.BORDER_THIN);
		style.setBorderLeft(HSSFCellStyle.BORDER_THIN);
		style.setBorderBottom(HSSFCellStyle.BORDER_THIN);

		CellStyle redStyle = workbook.createCellStyle();
		redStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);
		redStyle.setWrapText(true);
		redStyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
		redStyle.setLocked(true);
		redStyle.setFillForegroundColor(HSSFColor.PALE_BLUE.index);
		redStyle.setFillPattern(CellStyle.SOLID_FOREGROUND);
		redStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
		redStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
		redStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);

		HSSFFont font = workbook.createFont();
		font.setColor(HSSFColor.RED.index);
		font.setFontHeight(TEXT_SISE);//
		redStyle.setFont(font);

		CellStyle textBicStyle = workbook.createCellStyle();
		textBicStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);
		textBicStyle.setWrapText(true);
		textBicStyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
		textBicStyle.setLocked(true);
		textBicStyle.setFillForegroundColor(HSSFColor.PALE_BLUE.index);
		textBicStyle.setFillPattern(CellStyle.SOLID_FOREGROUND);
		textBicStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
		textBicStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);   
		textBicStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);

		HSSFFont bicStyleFont = workbook.createFont();
		bicStyleFont.setFontHeight(TEXT_SISE);// �궗�씠利�
		textBicStyle.setFont(bicStyleFont);

		for (int i = 0; i < columnLabels.length; i++) {
			HSSFCell cell = rows.createCell(i);
			if (i == 1 || i == 2 || i == 3) {

				rows.setHeight((short) COLUNM_HEIGHT);
				cell.setCellValue(columnLabels[i]);
				cell.setCellStyle(textBicStyle);
			} else {
				// HSSFCell cell = rows.createCell(i);
				rows.setHeight((short) COLUNM_HEIGHT);
				cell.setCellValue(columnLabels[i]);
				cell.setCellStyle(style);
			}
		}
	}

	private void setExcelConstructionValues(HSSFWorkbook workbook, HSSFRow rows, String[] columnLabels) {
		
		System.err.println("세번째 줄 배열 사이즈 : " + columnLabels.length);
		
		CellStyle style = workbook.createCellStyle();
		style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
		style.setWrapText(true);
		style.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
		style.setLocked(true);
		style.setFillForegroundColor(HSSFColor.PALE_BLUE.index);
		style.setFillPattern(CellStyle.SOLID_FOREGROUND);
		style.setBorderRight(HSSFCellStyle.BORDER_THIN);
		style.setBorderLeft(HSSFCellStyle.BORDER_THIN);
		style.setBorderBottom(HSSFCellStyle.BORDER_THIN);

		CellStyle redStyle = workbook.createCellStyle();
		redStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);
		redStyle.setWrapText(true);
		redStyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
		redStyle.setLocked(true);
		redStyle.setFillForegroundColor(HSSFColor.PALE_BLUE.index);
		redStyle.setFillPattern(CellStyle.SOLID_FOREGROUND);
		redStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
		redStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
		redStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);

		HSSFFont font = workbook.createFont();
		font.setColor(HSSFColor.RED.index);
		font.setFontHeight(TEXT_SISE);// �궗�씠利�
		redStyle.setFont(font);

		CellStyle textBicStyle = workbook.createCellStyle();
		textBicStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);
		textBicStyle.setWrapText(true);
		textBicStyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
		textBicStyle.setLocked(true);
		textBicStyle.setFillForegroundColor(HSSFColor.PALE_BLUE.index);
		textBicStyle.setFillPattern(CellStyle.SOLID_FOREGROUND);
		textBicStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
		textBicStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
		textBicStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);

		HSSFFont bicStyleFont = workbook.createFont();
		bicStyleFont.setFontHeight(TEXT_SISE);// �궗�씠利�
		textBicStyle.setFont(bicStyleFont);

		for (int i = 0; i < columnLabels.length; i++) {
			HSSFCell cell = rows.createCell(i);
			rows.setHeight((short) COLUNM_HEIGHT);
			//cell.setCellValue(columnLabels[i]);
			 try {
		      	  cell.setCellValue(Double.parseDouble(columnLabels[i]));
			   	  }catch (java.lang.NumberFormatException e) {
			   	  	 cell.setCellValue(columnLabels[i]);
			   	  }catch (NullPointerException e) {
			   	  	 cell.setCellValue(columnLabels[i]);
			   	  }catch (Exception e) {
			   	  	 cell.setCellValue(columnLabels[i]);
			   	  }
			cell.setCellStyle(style);
		}
	}

	private void setExcelConstructionValueLayoutSetting(HSSFSheet sheet, HSSFWorkbook workbook, FileUsingChart chart1,
			FileUsingChart chart2, FileUsingChart chart3, FileUsingChart chart4, int rowIndex) {
		createConstructionValueExcelTitle(sheet, workbook, chart1, chart2, chart3, chart4, rowIndex);
		sheet.addMergedRegion(new CellRangeAddress(rowIndex + 2, rowIndex + 2, 1, 2));

	}

	private void createConstructionValueExcelTitle(HSSFSheet sheet, HSSFWorkbook workbook, FileUsingChart chart1,
			FileUsingChart chart2, FileUsingChart chart3, FileUsingChart chart4, int rowIndex) {
		HSSFRow secondtRow = sheet.createRow(rowIndex + 2);
		if (isPhc) {
			String total = String.valueOf(chart1.getTotal() + chart2.getTotal() + chart3.getTotal() + chart4.getTotal());
			
			String[] columnLabels = new String[] { "","","", total, String.valueOf(chart1.getValue5()),
					String.valueOf(chart1.getValue6()), String.valueOf(chart1.getValue7()),
					String.valueOf(chart1.getValue8()), String.valueOf(chart1.getValue9()),
					String.valueOf(chart1.getValue10()), String.valueOf(chart1.getValue11()),
					String.valueOf(chart1.getValue12()), String.valueOf(chart1.getValue13()),
					String.valueOf(chart1.getValue14()), String.valueOf(chart1.getValue15()),
					String.valueOf(chart1.getTotal()), String.valueOf(chart2.getValue5()),
					String.valueOf(chart2.getValue6()), String.valueOf(chart2.getValue7()),
					String.valueOf(chart2.getValue8()), String.valueOf(chart2.getValue9()),
					String.valueOf(chart2.getValue10()), String.valueOf(chart2.getValue11()),
					String.valueOf(chart2.getValue12()), String.valueOf(chart2.getValue13()),
					String.valueOf(chart2.getValue14()), String.valueOf(chart2.getValue15()),
					String.valueOf(chart2.getTotal()), String.valueOf(chart3.getValue5()),
					String.valueOf(chart3.getValue6()), String.valueOf(chart3.getValue7()),
					String.valueOf(chart3.getValue8()), String.valueOf(chart3.getValue9()),
					String.valueOf(chart3.getValue10()), String.valueOf(chart3.getValue11()),
					String.valueOf(chart3.getValue12()), String.valueOf(chart3.getValue13()),
					String.valueOf(chart3.getValue14()), String.valueOf(chart3.getValue15()),
					String.valueOf(chart3.getTotal()), String.valueOf(chart4.getValue5()),
					String.valueOf(chart4.getValue6()), String.valueOf(chart4.getValue7()),
					String.valueOf(chart4.getValue8()), String.valueOf(chart4.getValue9()),
					String.valueOf(chart4.getValue10()), String.valueOf(chart4.getValue11()),
					String.valueOf(chart4.getValue12()), String.valueOf(chart4.getValue13()),
					String.valueOf(chart4.getValue14()), String.valueOf(chart4.getValue15()),
					String.valueOf(chart4.getTotal()), "비고" };
			allColLabel.add(columnLabels);
			setExcelConstructionValues(workbook, secondtRow, columnLabels);
		} else {
			String total = String.valueOf(chart1.getTotal() + chart2.getTotal() + chart3.getTotal() + chart4.getTotal());
			
			String[] columnLabels = new String[] { "","","", total, String.valueOf(chart1.getValue5()),
					String.valueOf(chart1.getValue6()), String.valueOf(chart1.getValue7()),
					String.valueOf(chart1.getValue8()), String.valueOf(chart1.getValue9()),
					String.valueOf(chart1.getValue10()), String.valueOf(chart1.getValue11()),
					String.valueOf(chart1.getValue12()), String.valueOf(chart1.getValue13()),
					String.valueOf(chart1.getValue14()), String.valueOf(chart1.getValue15()),
					String.valueOf(chart1.getValue16()), String.valueOf(chart1.getValue17()),
					String.valueOf(chart1.getValue18()), String.valueOf(chart1.getTotal()),
					String.valueOf(chart2.getValue5()), String.valueOf(chart2.getValue6()),
					String.valueOf(chart2.getValue7()), String.valueOf(chart2.getValue8()),
					String.valueOf(chart2.getValue9()), String.valueOf(chart2.getValue10()),
					String.valueOf(chart2.getValue11()), String.valueOf(chart2.getValue12()),
					String.valueOf(chart2.getValue13()), String.valueOf(chart2.getValue14()),
					String.valueOf(chart2.getValue15()), String.valueOf(chart2.getValue16()),
					String.valueOf(chart2.getValue17()), String.valueOf(chart2.getValue18()),
					String.valueOf(chart2.getTotal()), String.valueOf(chart3.getValue5()),
					String.valueOf(chart3.getValue6()), String.valueOf(chart3.getValue7()),
					String.valueOf(chart3.getValue8()), String.valueOf(chart3.getValue9()),
					String.valueOf(chart3.getValue10()), String.valueOf(chart3.getValue11()),
					String.valueOf(chart3.getValue12()), String.valueOf(chart3.getValue13()),
					String.valueOf(chart3.getValue14()), String.valueOf(chart3.getValue15()),
					String.valueOf(chart3.getValue16()), String.valueOf(chart3.getValue17()),
					String.valueOf(chart3.getValue18()), String.valueOf(chart3.getTotal()),
					String.valueOf(chart4.getValue5()), String.valueOf(chart4.getValue6()),
					String.valueOf(chart4.getValue7()), String.valueOf(chart4.getValue8()),
					String.valueOf(chart4.getValue9()), String.valueOf(chart4.getValue10()),
					String.valueOf(chart4.getValue11()), String.valueOf(chart4.getValue12()),
					String.valueOf(chart4.getValue13()), String.valueOf(chart4.getValue14()),
					String.valueOf(chart4.getValue15()), String.valueOf(chart4.getValue16()),
					String.valueOf(chart4.getValue17()), String.valueOf(chart4.getValue18()),
					String.valueOf(chart4.getTotal()), "비고" };
			allColLabel.add(columnLabels);
			setExcelConstructionValues(workbook, secondtRow, columnLabels);
		}

	}

	private HSSFSheet createFirstSheet(HSSFWorkbook workbook) {
		HSSFSheet sheet = workbook.createSheet();
		// sheet.protectSheet("we8104");
		workbook.setSheetName(0, "총 파일집계표");
		// sheet.setColumnWidth(0, (int)(100 * 36.57));
		return sheet;
	}
}
