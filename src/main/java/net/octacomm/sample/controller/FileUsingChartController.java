package net.octacomm.sample.controller;


import java.io.IOException;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.CellStyle;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import net.octacomm.sample.dao.mapper.ConstructionMapper;
import net.octacomm.sample.dao.mapper.FileInventoryMapper;
import net.octacomm.sample.dao.mapper.FileUsingChartMapper;
import net.octacomm.sample.domain.Construction;
import net.octacomm.sample.domain.FileInventoryOfChart;
import net.octacomm.sample.domain.FileUsingChart;
import net.octacomm.sample.domain.FileUsingChartParam;
import net.octacomm.sample.domain.MultiFileUsingChartObj;


@RequestMapping("/file/using/chart")
@Controller
public class FileUsingChartController {

	@Autowired
	private FileUsingChartMapper mapper;

	@Autowired
	private FileInventoryMapper fileInventoryMapper;

	@Autowired
	private ConstructionMapper constructionMapper;

	@RequestMapping(value = "/download/excel")
	public String downLoadExcel(Model model, @ModelAttribute("domainParam") FileUsingChartParam param,
			BindingResult result, HttpSession session, HttpServletRequest req, HttpServletResponse response)
			throws IOException {
		
		FileInventoryOfChart sumChart = new FileInventoryOfChart();
		FileInventoryOfChart surplusChart  = new FileInventoryOfChart();

		Map<String, String> map = pileToPileInfoMap(param.getPile());
			
		Construction construction = constructionMapper.get(param.getConstructionIdx());
		
		FileUsingChart chart1 = getChartDate(param.getConstructionIdx(), map.get("pileType"), map.get("pileStandard") , "단본");
		FileUsingChart chart2 = getChartDate(param.getConstructionIdx(), map.get("pileType"), map.get("pileStandard") , "하단");
		FileUsingChart chart3 = getChartDate(param.getConstructionIdx(), map.get("pileType"), map.get("pileStandard") , "중단");
		FileUsingChart chart4 = getChartDate(param.getConstructionIdx(), map.get("pileType"), map.get("pileStandard") , "상단");
		
		int initAccumBuffer = 0;
		List<FileInventoryOfChart> list;
		if( param.getPile().startsWith("PHC") || param.getPile().startsWith("UHC") || param.getPile().startsWith("UPHC")) {

			list = fileInventoryMapper.getFileInventoryOfChart(param.getConstructionIdx(), map.get("pileType"), map.get("pileStandard"));
		}else {
 
			list = fileInventoryMapper.getFileInventoryOfSteelChart(param.getConstructionIdx(), map.get("pileType"), map.get("pileStandard"), map.get("pileWeight"));
		}							 
		//getFileInventoryOfMultiChart
		//getFileInventoryOfSteelMultiChart
		String separateSinglePileTypeTemp = null;
		String separateBottomPileTypeTemp = null;
	
		for (FileInventoryOfChart fileInventoryOfChart : list) {
			
			if(fileInventoryOfChart.getSeparateSinglePileType() != null) {
				separateSinglePileTypeTemp = fileInventoryOfChart.getSeparateSinglePileType();
			}
			if(fileInventoryOfChart.getSeparateBottomPileType() != null) {
				separateBottomPileTypeTemp = fileInventoryOfChart.getSeparateBottomPileType();
			}
			
			sumChart.setTotal(sumChart.getTotal() + fileInventoryOfChart.getTotal());
			
			sumChart.setMeterof51(sumSumStiringValue(sumChart.getMeterof51(), fileInventoryOfChart.getMeterof51()));
			sumChart.setMeterof52(sumSumStiringValue(sumChart.getMeterof52(), fileInventoryOfChart.getMeterof52()));
			sumChart.setMeterof53(sumSumStiringValue(sumChart.getMeterof53(), fileInventoryOfChart.getMeterof53()));
			sumChart.setMeterof54(sumSumStiringValue(sumChart.getMeterof54(), fileInventoryOfChart.getMeterof54()));
			
			sumChart.setMeterof61(sumSumStiringValue(sumChart.getMeterof61(), fileInventoryOfChart.getMeterof61()));
			sumChart.setMeterof62(sumSumStiringValue(sumChart.getMeterof62(), fileInventoryOfChart.getMeterof62()));
			sumChart.setMeterof63(sumSumStiringValue(sumChart.getMeterof63(), fileInventoryOfChart.getMeterof63()));
			sumChart.setMeterof64(sumSumStiringValue(sumChart.getMeterof64(), fileInventoryOfChart.getMeterof64()));
			
			sumChart.setMeterof71(sumSumStiringValue(sumChart.getMeterof71(), fileInventoryOfChart.getMeterof71()));
			sumChart.setMeterof72(sumSumStiringValue(sumChart.getMeterof72(), fileInventoryOfChart.getMeterof72()));
			sumChart.setMeterof73(sumSumStiringValue(sumChart.getMeterof73(), fileInventoryOfChart.getMeterof73()));
			sumChart.setMeterof74(sumSumStiringValue(sumChart.getMeterof74(), fileInventoryOfChart.getMeterof74()));
			
			sumChart.setMeterof81(sumSumStiringValue(sumChart.getMeterof81(), fileInventoryOfChart.getMeterof81()));
			sumChart.setMeterof82(sumSumStiringValue(sumChart.getMeterof82(), fileInventoryOfChart.getMeterof82()));
			sumChart.setMeterof83(sumSumStiringValue(sumChart.getMeterof83(), fileInventoryOfChart.getMeterof83()));
			sumChart.setMeterof84(sumSumStiringValue(sumChart.getMeterof84(), fileInventoryOfChart.getMeterof84()));
			
			sumChart.setMeterof91(sumSumStiringValue(sumChart.getMeterof91(), fileInventoryOfChart.getMeterof91()));
			sumChart.setMeterof92(sumSumStiringValue(sumChart.getMeterof92(), fileInventoryOfChart.getMeterof92()));
			sumChart.setMeterof93(sumSumStiringValue(sumChart.getMeterof93(), fileInventoryOfChart.getMeterof93()));
			sumChart.setMeterof94(sumSumStiringValue(sumChart.getMeterof94(), fileInventoryOfChart.getMeterof94()));
			
			sumChart.setMeterof101(sumSumStiringValue(sumChart.getMeterof101(), fileInventoryOfChart.getMeterof101()));
			sumChart.setMeterof102(sumSumStiringValue(sumChart.getMeterof102(), fileInventoryOfChart.getMeterof102()));
			sumChart.setMeterof103(sumSumStiringValue(sumChart.getMeterof103(), fileInventoryOfChart.getMeterof103()));
			sumChart.setMeterof104(sumSumStiringValue(sumChart.getMeterof104(), fileInventoryOfChart.getMeterof104()));
			
			sumChart.setMeterof111(sumSumStiringValue(sumChart.getMeterof111(), fileInventoryOfChart.getMeterof111()));
			sumChart.setMeterof112(sumSumStiringValue(sumChart.getMeterof112(), fileInventoryOfChart.getMeterof112()));
			sumChart.setMeterof113(sumSumStiringValue(sumChart.getMeterof113(), fileInventoryOfChart.getMeterof113()));
			sumChart.setMeterof114(sumSumStiringValue(sumChart.getMeterof114(), fileInventoryOfChart.getMeterof114()));
			
			sumChart.setMeterof121(sumSumStiringValue(sumChart.getMeterof121(), fileInventoryOfChart.getMeterof121()));
			sumChart.setMeterof122(sumSumStiringValue(sumChart.getMeterof122(), fileInventoryOfChart.getMeterof122()));
			sumChart.setMeterof123(sumSumStiringValue(sumChart.getMeterof123(), fileInventoryOfChart.getMeterof123()));
			sumChart.setMeterof124(sumSumStiringValue(sumChart.getMeterof124(), fileInventoryOfChart.getMeterof124()));
			
			sumChart.setMeterof131(sumSumStiringValue(sumChart.getMeterof131(), fileInventoryOfChart.getMeterof131()));
			sumChart.setMeterof132(sumSumStiringValue(sumChart.getMeterof132(), fileInventoryOfChart.getMeterof132()));
			sumChart.setMeterof133(sumSumStiringValue(sumChart.getMeterof133(), fileInventoryOfChart.getMeterof133()));
			sumChart.setMeterof134(sumSumStiringValue(sumChart.getMeterof134(), fileInventoryOfChart.getMeterof134()));
			
			sumChart.setMeterof141(sumSumStiringValue(sumChart.getMeterof141(), fileInventoryOfChart.getMeterof141()));
			sumChart.setMeterof142(sumSumStiringValue(sumChart.getMeterof142(), fileInventoryOfChart.getMeterof142()));
			sumChart.setMeterof143(sumSumStiringValue(sumChart.getMeterof143(), fileInventoryOfChart.getMeterof143()));
			sumChart.setMeterof144(sumSumStiringValue(sumChart.getMeterof144(), fileInventoryOfChart.getMeterof144()));
			
			sumChart.setMeterof151(sumSumStiringValue(sumChart.getMeterof151(), fileInventoryOfChart.getMeterof151()));
			sumChart.setMeterof152(sumSumStiringValue(sumChart.getMeterof152(), fileInventoryOfChart.getMeterof152()));
			sumChart.setMeterof153(sumSumStiringValue(sumChart.getMeterof153(), fileInventoryOfChart.getMeterof153()));
			sumChart.setMeterof154(sumSumStiringValue(sumChart.getMeterof154(), fileInventoryOfChart.getMeterof154()));
			
			sumChart.setMeterof161(sumSumStiringValue(sumChart.getMeterof161(), fileInventoryOfChart.getMeterof161()));
			sumChart.setMeterof162(sumSumStiringValue(sumChart.getMeterof162(), fileInventoryOfChart.getMeterof162()));
			sumChart.setMeterof163(sumSumStiringValue(sumChart.getMeterof163(), fileInventoryOfChart.getMeterof163()));
			sumChart.setMeterof164(sumSumStiringValue(sumChart.getMeterof164(), fileInventoryOfChart.getMeterof164()));
			
			sumChart.setMeterof171(sumSumStiringValue(sumChart.getMeterof171(), fileInventoryOfChart.getMeterof171()));
			sumChart.setMeterof172(sumSumStiringValue(sumChart.getMeterof172(), fileInventoryOfChart.getMeterof172()));
			sumChart.setMeterof173(sumSumStiringValue(sumChart.getMeterof173(), fileInventoryOfChart.getMeterof173()));
			sumChart.setMeterof174(sumSumStiringValue(sumChart.getMeterof174(), fileInventoryOfChart.getMeterof174()));
			
			sumChart.setMeterof181(sumSumStiringValue(sumChart.getMeterof181(), fileInventoryOfChart.getMeterof181()));
			sumChart.setMeterof182(sumSumStiringValue(sumChart.getMeterof182(), fileInventoryOfChart.getMeterof182()));
			sumChart.setMeterof183(sumSumStiringValue(sumChart.getMeterof183(), fileInventoryOfChart.getMeterof183()));
			sumChart.setMeterof184(sumSumStiringValue(sumChart.getMeterof184(), fileInventoryOfChart.getMeterof184()));
			
			sumChart.setTotal1(sumChart.getTotal1() + fileInventoryOfChart.getTotal1());
			sumChart.setTotal2(sumChart.getTotal2() + fileInventoryOfChart.getTotal2());
			sumChart.setTotal3(sumChart.getTotal3() + fileInventoryOfChart.getTotal3());
			sumChart.setTotal4(sumChart.getTotal4() + fileInventoryOfChart.getTotal4());
			
			
			fileInventoryOfChart.getTotal();
			if(initAccumBuffer == 0) {
				fileInventoryOfChart.setAccum(fileInventoryOfChart.getTotal());	
			}else {
				fileInventoryOfChart.setAccum(initAccumBuffer + fileInventoryOfChart.getTotal());
			}
			initAccumBuffer = fileInventoryOfChart.getAccum() ;
		
		}
	
		calSurplusChart(surplusChart, sumChart, chart1, chart2, chart3, chart4);
	
		
		model.addAttribute("chart1", chart1);
		model.addAttribute("chart2", chart2);
		model.addAttribute("chart3", chart3);
		model.addAttribute("chart4", chart4);
		model.addAttribute("fileInventoryChartList", list);
		model.addAttribute("sumChart", sumChart);
		model.addAttribute("surplusChart", surplusChart);
		model.addAttribute("construction", construction);
		model.addAttribute("pileName", param.getPile());
		model.addAttribute("separateSinglePileType", separateSinglePileTypeTemp);
		model.addAttribute("separateBottomPileType", separateBottomPileTypeTemp);
		
		return "fileUsingChartExcelView";
	}
	
	@RequestMapping(value = "/download/multi/excel")
	public String downLoadMultiExcel(Model model, @ModelAttribute("domainParam") FileUsingChartParam param,
			BindingResult result, HttpSession session, HttpServletRequest req, HttpServletResponse response)
			throws IOException {
		
		List<MultiFileUsingChartObj> fileUsingChartObjs = new ArrayList<MultiFileUsingChartObj>();
		
		String pileParam = param.getPile();
	    if (pileParam != null && !pileParam.trim().isEmpty()) {
	        String[] pileList = pileParam.split("\\s*,\\s*"); // 콤마 기준으로 자르고 공백 제거

	        for (String pile : pileList) {
	            //System.out.println("처리 중인 파일 타입: " + pile);
	        	MultiFileUsingChartObj chartObj = new MultiFileUsingChartObj();
	        	
	        	FileInventoryOfChart sumChart = new FileInventoryOfChart();
	    		FileInventoryOfChart  surplusChart  = new FileInventoryOfChart();

	    		Map<String, String> map = pileToPileInfoMap(pile);
	    			
	    		Construction construction = constructionMapper.get(param.getConstructionIdx());
	    		
	    		FileUsingChart chart1 = getChartDate(param.getConstructionIdx(), map.get("pileType"), map.get("pileStandard") , "단본");
	    		FileUsingChart chart2 = getChartDate(param.getConstructionIdx(), map.get("pileType"), map.get("pileStandard") , "하단");
	    		FileUsingChart chart3 = getChartDate(param.getConstructionIdx(), map.get("pileType"), map.get("pileStandard") , "중단");
	    		FileUsingChart chart4 = getChartDate(param.getConstructionIdx(), map.get("pileType"), map.get("pileStandard") , "상단");
	    		
	    		int initAccumBuffer = 0;
	    		List<FileInventoryOfChart> list;
	    		if( pile.startsWith("PHC") || pile.startsWith("UHC") || pile.startsWith("UPHC")) {

	    			list = fileInventoryMapper.getFileInventoryOfMultiChart(param.getConstructionIdx(), map.get("pileType"), map.get("pileStandard"));
	    		}else {
	     
	    			list = fileInventoryMapper.getFileInventoryOfSteelMultiChart(param.getConstructionIdx(), map.get("pileType"), map.get("pileStandard"), map.get("pileWeight"));
	    		}
	    		
	    		//getFileInventoryOfMultiChart
	    		//getFileInventoryOfSteelMultiChart
	    		
	    		String separateSinglePileTypeTemp = null;
	    		String separateBottomPileTypeTemp = null;
	    	
	    		for (FileInventoryOfChart fileInventoryOfChart : list) {
	    			
	    			if(fileInventoryOfChart.getSeparateSinglePileType() != null) {
	    				separateSinglePileTypeTemp = fileInventoryOfChart.getSeparateSinglePileType();
	    			}
	    			if(fileInventoryOfChart.getSeparateBottomPileType() != null) {
	    				separateBottomPileTypeTemp = fileInventoryOfChart.getSeparateBottomPileType();
	    			}
	    			
	    			sumChart.setTotal(sumChart.getTotal() + fileInventoryOfChart.getTotal());
	    			
	    			sumChart.setMeterof51(sumSumStiringValue(sumChart.getMeterof51(), fileInventoryOfChart.getMeterof51()));
	    			sumChart.setMeterof52(sumSumStiringValue(sumChart.getMeterof52(), fileInventoryOfChart.getMeterof52()));
	    			sumChart.setMeterof53(sumSumStiringValue(sumChart.getMeterof53(), fileInventoryOfChart.getMeterof53()));
	    			sumChart.setMeterof54(sumSumStiringValue(sumChart.getMeterof54(), fileInventoryOfChart.getMeterof54()));
	    			
	    			sumChart.setMeterof61(sumSumStiringValue(sumChart.getMeterof61(), fileInventoryOfChart.getMeterof61()));
	    			sumChart.setMeterof62(sumSumStiringValue(sumChart.getMeterof62(), fileInventoryOfChart.getMeterof62()));
	    			sumChart.setMeterof63(sumSumStiringValue(sumChart.getMeterof63(), fileInventoryOfChart.getMeterof63()));
	    			sumChart.setMeterof64(sumSumStiringValue(sumChart.getMeterof64(), fileInventoryOfChart.getMeterof64()));
	    			
	    			sumChart.setMeterof71(sumSumStiringValue(sumChart.getMeterof71(), fileInventoryOfChart.getMeterof71()));
	    			sumChart.setMeterof72(sumSumStiringValue(sumChart.getMeterof72(), fileInventoryOfChart.getMeterof72()));
	    			sumChart.setMeterof73(sumSumStiringValue(sumChart.getMeterof73(), fileInventoryOfChart.getMeterof73()));
	    			sumChart.setMeterof74(sumSumStiringValue(sumChart.getMeterof74(), fileInventoryOfChart.getMeterof74()));
	    			
	    			sumChart.setMeterof81(sumSumStiringValue(sumChart.getMeterof81(), fileInventoryOfChart.getMeterof81()));
	    			sumChart.setMeterof82(sumSumStiringValue(sumChart.getMeterof82(), fileInventoryOfChart.getMeterof82()));
	    			sumChart.setMeterof83(sumSumStiringValue(sumChart.getMeterof83(), fileInventoryOfChart.getMeterof83()));
	    			sumChart.setMeterof84(sumSumStiringValue(sumChart.getMeterof84(), fileInventoryOfChart.getMeterof84()));
	    			
	    			sumChart.setMeterof91(sumSumStiringValue(sumChart.getMeterof91(), fileInventoryOfChart.getMeterof91()));
	    			sumChart.setMeterof92(sumSumStiringValue(sumChart.getMeterof92(), fileInventoryOfChart.getMeterof92()));
	    			sumChart.setMeterof93(sumSumStiringValue(sumChart.getMeterof93(), fileInventoryOfChart.getMeterof93()));
	    			sumChart.setMeterof94(sumSumStiringValue(sumChart.getMeterof94(), fileInventoryOfChart.getMeterof94()));
	    			
	    			sumChart.setMeterof101(sumSumStiringValue(sumChart.getMeterof101(), fileInventoryOfChart.getMeterof101()));
	    			sumChart.setMeterof102(sumSumStiringValue(sumChart.getMeterof102(), fileInventoryOfChart.getMeterof102()));
	    			sumChart.setMeterof103(sumSumStiringValue(sumChart.getMeterof103(), fileInventoryOfChart.getMeterof103()));
	    			sumChart.setMeterof104(sumSumStiringValue(sumChart.getMeterof104(), fileInventoryOfChart.getMeterof104()));
	    			
	    			sumChart.setMeterof111(sumSumStiringValue(sumChart.getMeterof111(), fileInventoryOfChart.getMeterof111()));
	    			sumChart.setMeterof112(sumSumStiringValue(sumChart.getMeterof112(), fileInventoryOfChart.getMeterof112()));
	    			sumChart.setMeterof113(sumSumStiringValue(sumChart.getMeterof113(), fileInventoryOfChart.getMeterof113()));
	    			sumChart.setMeterof114(sumSumStiringValue(sumChart.getMeterof114(), fileInventoryOfChart.getMeterof114()));
	    			
	    			sumChart.setMeterof121(sumSumStiringValue(sumChart.getMeterof121(), fileInventoryOfChart.getMeterof121()));
	    			sumChart.setMeterof122(sumSumStiringValue(sumChart.getMeterof122(), fileInventoryOfChart.getMeterof122()));
	    			sumChart.setMeterof123(sumSumStiringValue(sumChart.getMeterof123(), fileInventoryOfChart.getMeterof123()));
	    			sumChart.setMeterof124(sumSumStiringValue(sumChart.getMeterof124(), fileInventoryOfChart.getMeterof124()));
	    			
	    			sumChart.setMeterof131(sumSumStiringValue(sumChart.getMeterof131(), fileInventoryOfChart.getMeterof131()));
	    			sumChart.setMeterof132(sumSumStiringValue(sumChart.getMeterof132(), fileInventoryOfChart.getMeterof132()));
	    			sumChart.setMeterof133(sumSumStiringValue(sumChart.getMeterof133(), fileInventoryOfChart.getMeterof133()));
	    			sumChart.setMeterof134(sumSumStiringValue(sumChart.getMeterof134(), fileInventoryOfChart.getMeterof134()));
	    			
	    			sumChart.setMeterof141(sumSumStiringValue(sumChart.getMeterof141(), fileInventoryOfChart.getMeterof141()));
	    			sumChart.setMeterof142(sumSumStiringValue(sumChart.getMeterof142(), fileInventoryOfChart.getMeterof142()));
	    			sumChart.setMeterof143(sumSumStiringValue(sumChart.getMeterof143(), fileInventoryOfChart.getMeterof143()));
	    			sumChart.setMeterof144(sumSumStiringValue(sumChart.getMeterof144(), fileInventoryOfChart.getMeterof144()));
	    			
	    			sumChart.setMeterof151(sumSumStiringValue(sumChart.getMeterof151(), fileInventoryOfChart.getMeterof151()));
	    			sumChart.setMeterof152(sumSumStiringValue(sumChart.getMeterof152(), fileInventoryOfChart.getMeterof152()));
	    			sumChart.setMeterof153(sumSumStiringValue(sumChart.getMeterof153(), fileInventoryOfChart.getMeterof153()));
	    			sumChart.setMeterof154(sumSumStiringValue(sumChart.getMeterof154(), fileInventoryOfChart.getMeterof154()));
	    			
	    			sumChart.setMeterof161(sumSumStiringValue(sumChart.getMeterof161(), fileInventoryOfChart.getMeterof161()));
	    			sumChart.setMeterof162(sumSumStiringValue(sumChart.getMeterof162(), fileInventoryOfChart.getMeterof162()));
	    			sumChart.setMeterof163(sumSumStiringValue(sumChart.getMeterof163(), fileInventoryOfChart.getMeterof163()));
	    			sumChart.setMeterof164(sumSumStiringValue(sumChart.getMeterof164(), fileInventoryOfChart.getMeterof164()));
	    			
	    			sumChart.setMeterof171(sumSumStiringValue(sumChart.getMeterof171(), fileInventoryOfChart.getMeterof171()));
	    			sumChart.setMeterof172(sumSumStiringValue(sumChart.getMeterof172(), fileInventoryOfChart.getMeterof172()));
	    			sumChart.setMeterof173(sumSumStiringValue(sumChart.getMeterof173(), fileInventoryOfChart.getMeterof173()));
	    			sumChart.setMeterof174(sumSumStiringValue(sumChart.getMeterof174(), fileInventoryOfChart.getMeterof174()));
	    			
	    			sumChart.setMeterof181(sumSumStiringValue(sumChart.getMeterof181(), fileInventoryOfChart.getMeterof181()));
	    			sumChart.setMeterof182(sumSumStiringValue(sumChart.getMeterof182(), fileInventoryOfChart.getMeterof182()));
	    			sumChart.setMeterof183(sumSumStiringValue(sumChart.getMeterof183(), fileInventoryOfChart.getMeterof183()));
	    			sumChart.setMeterof184(sumSumStiringValue(sumChart.getMeterof184(), fileInventoryOfChart.getMeterof184()));
	    			
	    			sumChart.setTotal1(sumChart.getTotal1() + fileInventoryOfChart.getTotal1());
	    			sumChart.setTotal2(sumChart.getTotal2() + fileInventoryOfChart.getTotal2());
	    			sumChart.setTotal3(sumChart.getTotal3() + fileInventoryOfChart.getTotal3());
	    			sumChart.setTotal4(sumChart.getTotal4() + fileInventoryOfChart.getTotal4());
	    			
	    			///
    				sumChart.setBTotal(sumChart.getBTotal() + fileInventoryOfChart.getBTotal());
	    			
	    			sumChart.setBMeterof51(sumSumStiringValue(sumChart.getBMeterof51(), fileInventoryOfChart.getBMeterof51()));
	    			sumChart.setBMeterof52(sumSumStiringValue(sumChart.getBMeterof52(), fileInventoryOfChart.getBMeterof52()));
	    			sumChart.setBMeterof53(sumSumStiringValue(sumChart.getBMeterof53(), fileInventoryOfChart.getBMeterof53()));
	    			sumChart.setBMeterof54(sumSumStiringValue(sumChart.getBMeterof54(), fileInventoryOfChart.getBMeterof54()));
	    			
	    			sumChart.setBMeterof61(sumSumStiringValue(sumChart.getBMeterof61(), fileInventoryOfChart.getBMeterof61()));
	    			sumChart.setBMeterof62(sumSumStiringValue(sumChart.getBMeterof62(), fileInventoryOfChart.getBMeterof62()));
	    			sumChart.setBMeterof63(sumSumStiringValue(sumChart.getBMeterof63(), fileInventoryOfChart.getBMeterof63()));
	    			sumChart.setBMeterof64(sumSumStiringValue(sumChart.getBMeterof64(), fileInventoryOfChart.getBMeterof64()));
	    			
	    			sumChart.setBMeterof71(sumSumStiringValue(sumChart.getBMeterof71(), fileInventoryOfChart.getBMeterof71()));
	    			sumChart.setBMeterof72(sumSumStiringValue(sumChart.getBMeterof72(), fileInventoryOfChart.getBMeterof72()));
	    			sumChart.setBMeterof73(sumSumStiringValue(sumChart.getBMeterof73(), fileInventoryOfChart.getBMeterof73()));
	    			sumChart.setBMeterof74(sumSumStiringValue(sumChart.getBMeterof74(), fileInventoryOfChart.getBMeterof74()));
	    			
	    			sumChart.setBMeterof81(sumSumStiringValue(sumChart.getBMeterof81(), fileInventoryOfChart.getBMeterof81()));
	    			sumChart.setBMeterof82(sumSumStiringValue(sumChart.getBMeterof82(), fileInventoryOfChart.getBMeterof82()));
	    			sumChart.setBMeterof83(sumSumStiringValue(sumChart.getBMeterof83(), fileInventoryOfChart.getBMeterof83()));
	    			sumChart.setBMeterof84(sumSumStiringValue(sumChart.getBMeterof84(), fileInventoryOfChart.getBMeterof84()));
	    			
	    			sumChart.setBMeterof91(sumSumStiringValue(sumChart.getBMeterof91(), fileInventoryOfChart.getBMeterof91()));
	    			sumChart.setBMeterof92(sumSumStiringValue(sumChart.getBMeterof92(), fileInventoryOfChart.getBMeterof92()));
	    			sumChart.setBMeterof93(sumSumStiringValue(sumChart.getBMeterof93(), fileInventoryOfChart.getBMeterof93()));
	    			sumChart.setBMeterof94(sumSumStiringValue(sumChart.getBMeterof94(), fileInventoryOfChart.getBMeterof94()));
	    			
	    			sumChart.setBMeterof101(sumSumStiringValue(sumChart.getBMeterof101(), fileInventoryOfChart.getBMeterof101()));
	    			sumChart.setBMeterof102(sumSumStiringValue(sumChart.getBMeterof102(), fileInventoryOfChart.getBMeterof102()));
	    			sumChart.setBMeterof103(sumSumStiringValue(sumChart.getBMeterof103(), fileInventoryOfChart.getBMeterof103()));
	    			sumChart.setBMeterof104(sumSumStiringValue(sumChart.getBMeterof104(), fileInventoryOfChart.getBMeterof104()));
	    			
	    			sumChart.setBMeterof111(sumSumStiringValue(sumChart.getBMeterof111(), fileInventoryOfChart.getBMeterof111()));
	    			sumChart.setBMeterof112(sumSumStiringValue(sumChart.getBMeterof112(), fileInventoryOfChart.getBMeterof112()));
	    			sumChart.setBMeterof113(sumSumStiringValue(sumChart.getBMeterof113(), fileInventoryOfChart.getBMeterof113()));
	    			sumChart.setBMeterof114(sumSumStiringValue(sumChart.getBMeterof114(), fileInventoryOfChart.getBMeterof114()));
	    			
	    			sumChart.setBMeterof121(sumSumStiringValue(sumChart.getBMeterof121(), fileInventoryOfChart.getBMeterof121()));
	    			sumChart.setBMeterof122(sumSumStiringValue(sumChart.getBMeterof122(), fileInventoryOfChart.getBMeterof122()));
	    			sumChart.setBMeterof123(sumSumStiringValue(sumChart.getBMeterof123(), fileInventoryOfChart.getBMeterof123()));
	    			sumChart.setBMeterof124(sumSumStiringValue(sumChart.getBMeterof124(), fileInventoryOfChart.getBMeterof124()));
	    			
	    			sumChart.setBMeterof131(sumSumStiringValue(sumChart.getBMeterof131(), fileInventoryOfChart.getBMeterof131()));
	    			sumChart.setBMeterof132(sumSumStiringValue(sumChart.getBMeterof132(), fileInventoryOfChart.getBMeterof132()));
	    			sumChart.setBMeterof133(sumSumStiringValue(sumChart.getBMeterof133(), fileInventoryOfChart.getBMeterof133()));
	    			sumChart.setBMeterof134(sumSumStiringValue(sumChart.getBMeterof134(), fileInventoryOfChart.getBMeterof134()));
	    			
	    			sumChart.setBMeterof141(sumSumStiringValue(sumChart.getBMeterof141(), fileInventoryOfChart.getBMeterof141()));
	    			sumChart.setBMeterof142(sumSumStiringValue(sumChart.getBMeterof142(), fileInventoryOfChart.getBMeterof142()));
	    			sumChart.setBMeterof143(sumSumStiringValue(sumChart.getBMeterof143(), fileInventoryOfChart.getBMeterof143()));
	    			sumChart.setBMeterof144(sumSumStiringValue(sumChart.getBMeterof144(), fileInventoryOfChart.getBMeterof144()));
	    			
	    			sumChart.setBMeterof151(sumSumStiringValue(sumChart.getBMeterof151(), fileInventoryOfChart.getBMeterof151()));
	    			sumChart.setBMeterof152(sumSumStiringValue(sumChart.getBMeterof152(), fileInventoryOfChart.getBMeterof152()));
	    			sumChart.setBMeterof153(sumSumStiringValue(sumChart.getBMeterof153(), fileInventoryOfChart.getBMeterof153()));
	    			sumChart.setBMeterof154(sumSumStiringValue(sumChart.getBMeterof154(), fileInventoryOfChart.getBMeterof154()));
	    			
	    			sumChart.setBMeterof161(sumSumStiringValue(sumChart.getBMeterof161(), fileInventoryOfChart.getBMeterof161()));
	    			sumChart.setBMeterof162(sumSumStiringValue(sumChart.getBMeterof162(), fileInventoryOfChart.getBMeterof162()));
	    			sumChart.setBMeterof163(sumSumStiringValue(sumChart.getBMeterof163(), fileInventoryOfChart.getBMeterof163()));
	    			sumChart.setBMeterof164(sumSumStiringValue(sumChart.getBMeterof164(), fileInventoryOfChart.getBMeterof164()));
	    			
	    			sumChart.setBMeterof171(sumSumStiringValue(sumChart.getBMeterof171(), fileInventoryOfChart.getBMeterof171()));
	    			sumChart.setBMeterof172(sumSumStiringValue(sumChart.getBMeterof172(), fileInventoryOfChart.getBMeterof172()));
	    			sumChart.setBMeterof173(sumSumStiringValue(sumChart.getBMeterof173(), fileInventoryOfChart.getBMeterof173()));
	    			sumChart.setBMeterof174(sumSumStiringValue(sumChart.getBMeterof174(), fileInventoryOfChart.getBMeterof174()));
	    			
	    			sumChart.setBMeterof181(sumSumStiringValue(sumChart.getBMeterof181(), fileInventoryOfChart.getBMeterof181()));
	    			sumChart.setBMeterof182(sumSumStiringValue(sumChart.getBMeterof182(), fileInventoryOfChart.getBMeterof182()));
	    			sumChart.setBMeterof183(sumSumStiringValue(sumChart.getBMeterof183(), fileInventoryOfChart.getBMeterof183()));
	    			sumChart.setBMeterof184(sumSumStiringValue(sumChart.getBMeterof184(), fileInventoryOfChart.getBMeterof184()));
	    			
	    			sumChart.setBTotal1(sumChart.getBTotal1() + fileInventoryOfChart.getBTotal1());
	    			sumChart.setBTotal2(sumChart.getBTotal2() + fileInventoryOfChart.getBTotal2());
	    			sumChart.setBTotal3(sumChart.getBTotal3() + fileInventoryOfChart.getBTotal3());
	    			sumChart.setBTotal4(sumChart.getBTotal4() + fileInventoryOfChart.getBTotal4());
	    			//
	    			
	    			
	    			
	    			fileInventoryOfChart.getTotal();
	    			if(initAccumBuffer == 0) {
	    				fileInventoryOfChart.setAccum(fileInventoryOfChart.getTotal());	
	    			}else {
	    				fileInventoryOfChart.setAccum(initAccumBuffer + fileInventoryOfChart.getTotal());
	    			}
	    			initAccumBuffer = fileInventoryOfChart.getAccum() ;
	    		
	    		}
	    	
	    		calSurplusChart(surplusChart, sumChart, chart1, chart2, chart3, chart4);
	    	
	    		chartObj.setChart1(chart1);
	    		chartObj.setChart2(chart2);
	    		chartObj.setChart3(chart3);
	    		chartObj.setChart4(chart4);
	    		chartObj.setFileInventoryChartList(list);
	    		chartObj.setSumChart(sumChart);
	    		chartObj.setSurplusChart(surplusChart);	    
	    		chartObj.setConstruction(construction);
	    		chartObj.setPileName(pile);
	    		chartObj.setSeparateSinglePileType(separateSinglePileTypeTemp);
	    		chartObj.setSeparateSinglePileType(separateBottomPileTypeTemp);
	    		
	    		fileUsingChartObjs.add(chartObj);
	        }
	        model.addAttribute("fileUsingChartObjs", fileUsingChartObjs);
	    } else {
	        System.out.println("pile 파라미터가 비어 있습니다.");
	    }
	    
	    return "multiFileUsingChartExcelView2";
	}

	private FileInventoryOfChart calSurplusChart(FileInventoryOfChart surplusChart, FileInventoryOfChart sumChart,
			FileUsingChart chart1, FileUsingChart chart2, FileUsingChart chart3, FileUsingChart chart4) {

		surplusChart.setMeterof51(calSurplusStringValue(sumChart.getMeterof51(), chart1.getValue5()));
		surplusChart.setMeterof61(calSurplusStringValue(sumChart.getMeterof61(), chart1.getValue6()));
		surplusChart.setMeterof71(calSurplusStringValue(sumChart.getMeterof71(), chart1.getValue7()));
		surplusChart.setMeterof81(calSurplusStringValue(sumChart.getMeterof81(), chart1.getValue8()));
		surplusChart.setMeterof91(calSurplusStringValue(sumChart.getMeterof91(), chart1.getValue9()));
		surplusChart.setMeterof101(calSurplusStringValue(sumChart.getMeterof101(), chart1.getValue10()));
		surplusChart.setMeterof111(calSurplusStringValue(sumChart.getMeterof111(), chart1.getValue11()));
		surplusChart.setMeterof121(calSurplusStringValue(sumChart.getMeterof121(), chart1.getValue12()));
		surplusChart.setMeterof131(calSurplusStringValue(sumChart.getMeterof131(), chart1.getValue13()));
		surplusChart.setMeterof141(calSurplusStringValue(sumChart.getMeterof141(), chart1.getValue14()));
		surplusChart.setMeterof151(calSurplusStringValue(sumChart.getMeterof151(), chart1.getValue15()));

		surplusChart.setMeterof161(calSurplusStringValue(sumChart.getMeterof161(), chart1.getValue16()));
		surplusChart.setMeterof171(calSurplusStringValue(sumChart.getMeterof171(), chart1.getValue17()));
		surplusChart.setMeterof181(calSurplusStringValue(sumChart.getMeterof181(), chart1.getValue18()));

		surplusChart.setTotal1(StringToInt(surplusChart.getMeterof51()) + StringToInt(surplusChart.getMeterof61())
				+ StringToInt(surplusChart.getMeterof71()) + StringToInt(surplusChart.getMeterof81())
				+ StringToInt(surplusChart.getMeterof91()) + StringToInt(surplusChart.getMeterof101())
				+ StringToInt(surplusChart.getMeterof111()) + StringToInt(surplusChart.getMeterof121())
				+ StringToInt(surplusChart.getMeterof131()) + StringToInt(surplusChart.getMeterof141())
				+ StringToInt(surplusChart.getMeterof151()));

		surplusChart.setMeterof52(calSurplusStringValue(sumChart.getMeterof52(), chart2.getValue5()));
		surplusChart.setMeterof62(calSurplusStringValue(sumChart.getMeterof62(), chart2.getValue6()));
		surplusChart.setMeterof72(calSurplusStringValue(sumChart.getMeterof72(), chart2.getValue7()));
		surplusChart.setMeterof82(calSurplusStringValue(sumChart.getMeterof82(), chart2.getValue8()));
		surplusChart.setMeterof92(calSurplusStringValue(sumChart.getMeterof92(), chart2.getValue9()));
		surplusChart.setMeterof102(calSurplusStringValue(sumChart.getMeterof102(), chart2.getValue10()));
		surplusChart.setMeterof112(calSurplusStringValue(sumChart.getMeterof112(), chart2.getValue11()));
		surplusChart.setMeterof122(calSurplusStringValue(sumChart.getMeterof122(), chart2.getValue12()));
		surplusChart.setMeterof132(calSurplusStringValue(sumChart.getMeterof132(), chart2.getValue13()));
		surplusChart.setMeterof142(calSurplusStringValue(sumChart.getMeterof142(), chart2.getValue14()));
		surplusChart.setMeterof152(calSurplusStringValue(sumChart.getMeterof152(), chart2.getValue15()));

		surplusChart.setMeterof162(calSurplusStringValue(sumChart.getMeterof162(), chart2.getValue16()));
		surplusChart.setMeterof172(calSurplusStringValue(sumChart.getMeterof172(), chart2.getValue17()));
		surplusChart.setMeterof182(calSurplusStringValue(sumChart.getMeterof182(), chart2.getValue18()));

		surplusChart.setTotal2(StringToInt(surplusChart.getMeterof52()) + StringToInt(surplusChart.getMeterof62())
				+ StringToInt(surplusChart.getMeterof72()) + StringToInt(surplusChart.getMeterof82())
				+ StringToInt(surplusChart.getMeterof92()) + StringToInt(surplusChart.getMeterof102())
				+ StringToInt(surplusChart.getMeterof112()) + StringToInt(surplusChart.getMeterof122())
				+ StringToInt(surplusChart.getMeterof132()) + StringToInt(surplusChart.getMeterof142())
				+ StringToInt(surplusChart.getMeterof152()));

		surplusChart.setMeterof53(calSurplusStringValue(sumChart.getMeterof53(), chart3.getValue5()));
		surplusChart.setMeterof63(calSurplusStringValue(sumChart.getMeterof63(), chart3.getValue6()));
		surplusChart.setMeterof73(calSurplusStringValue(sumChart.getMeterof73(), chart3.getValue7()));
		surplusChart.setMeterof83(calSurplusStringValue(sumChart.getMeterof83(), chart3.getValue8()));
		surplusChart.setMeterof93(calSurplusStringValue(sumChart.getMeterof93(), chart3.getValue9()));
		surplusChart.setMeterof103(calSurplusStringValue(sumChart.getMeterof103(), chart3.getValue10()));
		surplusChart.setMeterof113(calSurplusStringValue(sumChart.getMeterof113(), chart3.getValue11()));
		surplusChart.setMeterof123(calSurplusStringValue(sumChart.getMeterof123(), chart3.getValue12()));
		surplusChart.setMeterof133(calSurplusStringValue(sumChart.getMeterof133(), chart3.getValue13()));
		surplusChart.setMeterof143(calSurplusStringValue(sumChart.getMeterof143(), chart3.getValue14()));
		surplusChart.setMeterof153(calSurplusStringValue(sumChart.getMeterof153(), chart3.getValue15()));

		surplusChart.setMeterof163(calSurplusStringValue(sumChart.getMeterof163(), chart3.getValue16()));
		surplusChart.setMeterof173(calSurplusStringValue(sumChart.getMeterof173(), chart3.getValue17()));
		surplusChart.setMeterof183(calSurplusStringValue(sumChart.getMeterof183(), chart3.getValue18()));

		surplusChart.setTotal3(StringToInt(surplusChart.getMeterof53()) + StringToInt(surplusChart.getMeterof63())
				+ StringToInt(surplusChart.getMeterof73()) + StringToInt(surplusChart.getMeterof83())
				+ StringToInt(surplusChart.getMeterof93()) + StringToInt(surplusChart.getMeterof103())
				+ StringToInt(surplusChart.getMeterof113()) + StringToInt(surplusChart.getMeterof123())
				+ StringToInt(surplusChart.getMeterof133()) + StringToInt(surplusChart.getMeterof143())
				+ StringToInt(surplusChart.getMeterof153()));

		surplusChart.setMeterof54(calSurplusStringValue(sumChart.getMeterof54(), chart4.getValue5()));
		surplusChart.setMeterof64(calSurplusStringValue(sumChart.getMeterof64(), chart4.getValue6()));
		surplusChart.setMeterof74(calSurplusStringValue(sumChart.getMeterof74(), chart4.getValue7()));
		surplusChart.setMeterof84(calSurplusStringValue(sumChart.getMeterof84(), chart4.getValue8()));
		surplusChart.setMeterof94(calSurplusStringValue(sumChart.getMeterof94(), chart4.getValue9()));
		surplusChart.setMeterof104(calSurplusStringValue(sumChart.getMeterof104(), chart4.getValue10()));
		surplusChart.setMeterof114(calSurplusStringValue(sumChart.getMeterof114(), chart4.getValue11()));
		surplusChart.setMeterof124(calSurplusStringValue(sumChart.getMeterof124(), chart4.getValue12()));
		surplusChart.setMeterof134(calSurplusStringValue(sumChart.getMeterof134(), chart4.getValue13()));
		surplusChart.setMeterof144(calSurplusStringValue(sumChart.getMeterof144(), chart4.getValue14()));
		surplusChart.setMeterof154(calSurplusStringValue(sumChart.getMeterof154(), chart4.getValue15()));

		surplusChart.setMeterof164(calSurplusStringValue(sumChart.getMeterof164(), chart4.getValue16()));
		surplusChart.setMeterof174(calSurplusStringValue(sumChart.getMeterof174(), chart4.getValue17()));
		surplusChart.setMeterof184(calSurplusStringValue(sumChart.getMeterof184(), chart4.getValue18()));

		surplusChart.setTotal4(StringToInt(surplusChart.getMeterof54()) + StringToInt(surplusChart.getMeterof64())
				+ StringToInt(surplusChart.getMeterof74()) + StringToInt(surplusChart.getMeterof84())
				+ StringToInt(surplusChart.getMeterof94()) + StringToInt(surplusChart.getMeterof104())
				+ StringToInt(surplusChart.getMeterof114()) + StringToInt(surplusChart.getMeterof124())
				+ StringToInt(surplusChart.getMeterof134()) + StringToInt(surplusChart.getMeterof144())
				+ StringToInt(surplusChart.getMeterof154()));

		return surplusChart;
	}

	private int StringToInt(String value) {
		int iValue = 0;
		try {
			iValue = Integer.parseInt(value);
		} catch (NullPointerException e) {
			iValue = 0;
		} catch (Exception e) {
			iValue = 0;
		}
		return iValue;
	}

	private String calSurplusStringValue(String baseValue, int sumValue) {
		int bValue = 0;
		int result = 0;
		try {
			bValue = Integer.parseInt(baseValue);
		} catch (NullPointerException e) {
			bValue = 0;
		} catch (Exception e) {
			bValue = 0;
		}

		result = bValue - sumValue;
		return String.valueOf(result);
	}

	private String sumSumStiringValue(String baseValue, String sumValue) {
		int bValue = 0;
		int sValue = 0;
		int result = 0;

		try {
			bValue = Integer.parseInt(baseValue);
		} catch (NullPointerException e) {
			bValue = 0;
		} catch (Exception e) {
			bValue = 0;
		}

		try {
			sValue = Integer.parseInt(sumValue);
		} catch (NullPointerException e) {
			sValue = 0;
		} catch (Exception e) {
			sValue = 0;
		}
		result = bValue + sValue;
		return String.valueOf(result);
	}

	public FileUsingChart getChartDate(int constructionIdx, String pileType, String pileStandard, String name) {
		return mapper.getChartData(constructionIdx, pileType, pileStandard, name);
	}
	
	public Map<String, String> pileToPileInfoMap(String pile) {
		String pileType = "";
		String pileWeight = "";
		String pileStandard = "";
		Map<String, String> map = new HashMap<>();
		String[] piles = pile.split("\\s+");
		if (pile.startsWith("PHC") || pile.startsWith("UHC")  || pile.startsWith("UPHC")) {
			try {
				pileType = piles[0];
				map.put("pileType", pileType);
				pileStandard = piles[1];
				map.put("pileStandard", pileStandard);
			} catch (Exception e) {
				pileType = "";
				map.put("pileType", pileType);
				pileStandard = "";
				map.put("pileStandard", pileStandard);
			}
		} else {
			try {
				pileType = piles[0];
				map.put("pileType", pileType);
				pileWeight = piles[1];
				map.put("pileWeight", pileWeight);
				pileStandard = piles[2];
				map.put("pileStandard", pileStandard);

				System.err.println("pileType : " + pileType);
				System.err.println("pileType 1 index : " + piles[0]);
				System.err.println("pileType 2 index : " + piles[2]);
			} catch (Exception e) {
				pileType = "";
				map.put("pileType", pileType);
				pileStandard = "";
				map.put("pileStandard", pileStandard);



			}
		}

		return map;
	}
}
