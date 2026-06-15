package net.octacomm.sample.controller;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.support.SessionStatus;

import net.octacomm.sample.dao.mapper.ConstructionMapper;
import net.octacomm.sample.dao.mapper.DeviceMapper;
import net.octacomm.sample.dao.mapper.ExcelSignroomMapper;
import net.octacomm.sample.dao.mapper.OriginPenetrationMapper;
import net.octacomm.sample.dao.mapper.OriginPieceMapper;
import net.octacomm.sample.dao.mapper.OriginReportMapper;
import net.octacomm.sample.dao.mapper.PenetrationMapper;
import net.octacomm.sample.dao.mapper.PieceMapper;
import net.octacomm.sample.dao.mapper.ReportAllMapper;
import net.octacomm.sample.domain.Construction;
import net.octacomm.sample.domain.Device;
import net.octacomm.sample.domain.ExcelSignroom;
import net.octacomm.sample.domain.Penetration;
import net.octacomm.sample.domain.Piece;
import net.octacomm.sample.domain.Report;
import net.octacomm.sample.domain.ReportMaxCount;
import net.octacomm.sample.domain.ReportOneLine;
import net.octacomm.sample.domain.ReportParam;
import net.octacomm.sample.domain.SessionInfo;
import net.octacomm.sample.domain.UpdateReport;
import net.octacomm.sample.utils.MathUtil;
import net.octacomm.sample.utils.Pagination;
import net.octacomm.sample.utils.ReportPagination;
import net.octacomm.sample.utils.Utill;

@RequestMapping("/report/all")
@Controller
public class ReportAllController{
		
	@Autowired
	private DeviceMapper deviceMapper;
	
	@Autowired
	protected PenetrationMapper penetrationMapper;
	
	@Autowired  
	protected PieceMapper pieceMapper;
	
	@Autowired
	protected OriginPenetrationMapper originPenetrationMapper;
	
	@Autowired
	protected OriginPieceMapper originPieceMapper;
	
	@Autowired
	protected ReportAllMapper mapper;
	
	@Autowired
	protected OriginReportMapper originReportMapper;
	
	@Autowired
	protected ConstructionMapper constructionMapper;
	
	@Autowired
	private ExcelSignroomMapper excelSignroomMapper;
	
	
	@RequestMapping(value = "/list")
	public void list(Model model, @ModelAttribute("domainParam") ReportParam param, BindingResult result, HttpSession session) throws UnsupportedEncodingException {
		
		int totalConstruction = 0;

		int isBig = 0; 
		
		System.err.println("Search Param : {}" +  param); 
		
		isBig = mapper.isBigAllReports(param);
		
		Construction targetCon = constructionMapper.get((int) param.getConstructionIdx());
		System.err.println("targetCon : " + targetCon);
		
		param.setRole((int) session.getAttribute("role"));
		
		//param.setConstructionIdx((int) session.getAttribute("constructionIdx"));
		
		Construction con = constructionMapper.get((int) session.getAttribute("constructionIdx"));
		
		System.err.println("mycon : " + con);
		
		int totalCount = mapper.getCountByParam(param);
		
		System.err.println("Total Count : {}" +  totalCount);
	  
		ReportPagination page;
		
		if (param.getPageSize() > 0 && param.getPageGroupSize() > 0) {
			page = new ReportPagination(param.getPageSize(), param.getPageGroupSize(), totalCount, param.getCurrentPage());
		} else {
			page = new ReportPagination(totalCount, param.getCurrentPage());
		}
		
		Device device = deviceMapper.get(param.getId());
		
		totalConstruction = mapper.getCount(param);
		
		List<ReportOneLine> domainList = mapper.getReportOneLineListByParam(page.getStartRow(), page.getPageSize(), param);
		
		System.err.println("domainList : " + domainList.size());
		
		int rownum = (totalCount + 1) - page.getStartRow();
		
		for (int i = 0; i < domainList.size(); i++) {
			domainList.get(i).setRownum(rownum = rownum - 1);
//			domainList.get(i).setPiece(pieceMapper.getListByReportIdx(domainList.get(i).getId()));
//			List<Penetration> penetrationsList =  penetrationMapper.getListByReportIdx(domainList.get(i).getId());
//			System.err.println("penetrationsList.size() : " + penetrationsList.size());
//			if(penetrationsList.size() > 5) {
//				isBig = true;
//			}
//			domainList.get(i).setPenetrations(penetrationsList);
		}
		
		try {
			if((int) session.getAttribute("role") == 3) {
				model.addAttribute("longCalYn", targetCon.getLongCalYn());
				model.addAttribute("originDataYn", targetCon.getOriginDataYn());
				model.addAttribute("ubcYn", targetCon.getUbcYn());
				model.addAttribute("showPdfYn", targetCon.getShowPdfYn());
			}else {
				model.addAttribute("longCalYn", con.getLongCalYn());
				model.addAttribute("originDataYn", con.getOriginDataYn());
				model.addAttribute("ubcYn", con.getUbcYn());
				model.addAttribute("showPdfYn", con.getShowPdfYn());
			}
		}catch (Exception e) {
			model.addAttribute("longCalYn", 0);
			model.addAttribute("originDataYn", 0);
			model.addAttribute("ubcYn", 0);
			model.addAttribute("showPdfYn", 0);
		}
		
		model.addAttribute("totalConstruction", totalConstruction);
		model.addAttribute("device", device);
		model.addAttribute("param", param);
		model.addAttribute("page", page);		
		model.addAttribute("domainList", domainList);
		model.addAttribute("isBig", isBig);
		
	}
	
	
	
	@RequestMapping(value = "/origin/list")
	public String originList(Model model, @ModelAttribute("domainParam") ReportParam param, BindingResult result, HttpSession session) throws UnsupportedEncodingException {
		
		int totalConstruction = 0;

		boolean isBig = false; 
		
		System.err.println("Search Param : {}" +  param); 
		
		Construction targetCon = constructionMapper.get((int) param.getConstructionIdx());
		
		System.err.println("targetCon : " + targetCon);
		param.setRole((int) session.getAttribute("role"));
		param.setConstructionIdx((int) session.getAttribute("constructionIdx"));
		
		Construction con = constructionMapper.get((int) session.getAttribute("constructionIdx"));
		System.err.println("mycon : " + con);
		int totalCount = originReportMapper.getCountByParam(param);
		
		System.err.println("Total Count : {}" +  totalCount);
	  
		Pagination page;
		
		if (param.getPageSize() > 0 && param.getPageGroupSize() > 0) {
			page = new Pagination(param.getPageSize(), param.getPageGroupSize(), totalCount, param.getCurrentPage());
		} else {
			page = new Pagination(totalCount, param.getCurrentPage());
		}
		Device device = deviceMapper.get(param.getId());
		
		totalConstruction = originReportMapper.getCount(param);
		
		List<Report> domainList = originReportMapper.getListByParam(page.getStartRow(), page.getPageSize(), param);
		int rownum = (totalCount + 1) - page.getStartRow();
		
		for (int i = 0; i < domainList.size(); i++) {
			
			domainList.get(i).setRownum(rownum = rownum - 1);
			domainList.get(i).setPiece(originPieceMapper.getListByReportIdx(domainList.get(i).getId()));
			List<Penetration> penetrationsList =  originPenetrationMapper.getListByReportIdx(domainList.get(i).getId());
			System.err.println("penetrationsList.size() : " + penetrationsList.size());
			if(penetrationsList.size() > 5) {
				isBig = true;
			}
			domainList.get(i).setPenetrations(penetrationsList);
		}
		try {
			if((int) session.getAttribute("role") == 3) {
				model.addAttribute("longCalYn", targetCon.getLongCalYn());
				model.addAttribute("originDataYn", targetCon.getOriginDataYn());
				model.addAttribute("ubcYn", targetCon.getUbcYn());
				model.addAttribute("showPdfYn", targetCon.getShowPdfYn());
			}else {
				model.addAttribute("longCalYn", con.getLongCalYn());
				model.addAttribute("originDataYn", con.getOriginDataYn());
				model.addAttribute("ubcYn", con.getUbcYn());
				model.addAttribute("showPdfYn", con.getShowPdfYn());
			}
		}catch (Exception e) {
			model.addAttribute("longCalYn", 0);
			model.addAttribute("originDataYn", 0);
			model.addAttribute("ubcYn", 0);
			model.addAttribute("showPdfYn", 0);
		}
		model.addAttribute("totalConstruction", totalConstruction);
		model.addAttribute("device", device);
		model.addAttribute("param", param);
		model.addAttribute("page", page);		
		model.addAttribute("domainList", domainList);
		model.addAttribute("isBig", isBig);
		
		return "report/origin/listMulti";
		
	}
	
	@ModelAttribute
	public void setActiveMenu(Model model, HttpSession session) {
		int role = (Integer) session.getAttribute("role");
		if(role > 0) {
			model.addAttribute("menuIndex", 1);
		}else{
			model.addAttribute("menuIndex", 2);
		}
	}
	
	//원본기록지 다운로드 XXXXX   http://localhost:8080/web-template-mybatis/report/origin/download/excel?constructionIdx=812
	//All 총작업은 없음.  XXXXX
	@RequestMapping(value = "/origin/download/excel")
	public String originDownLoadExcel(Model model, @ModelAttribute("domainParam") ReportParam param, BindingResult result, HttpSession session) {
		
		boolean isBig = false; 
		int role = (int) session.getAttribute("role");
		//int constructionIdx = (int) session.getAttribute("constructionIdx");
		int constructionIdx = 0;
		if(role == 0) {
			//슈퍼관리자
			constructionIdx = param.getConstructionIdx();
		}else if(role == 1) {
			//일반협력사
			constructionIdx = (int) session.getAttribute("constructionIdx");
		}else if(role == 2) {
			//시공사
			constructionIdx = param.getConstructionIdx();
		}else if(role == 3) {
			//가맹점
			constructionIdx = param.getConstructionIdx();
		}
		
		boolean isHiddenManager  = (boolean) session.getAttribute("isHiddenManager");
		Construction targetCon = constructionMapper.get(param.getConstructionIdx());
		
		List<ExcelSignroom> signRoomList = excelSignroomMapper.getFindByConstructionIdxAndOrderBy(constructionIdx);
		
		Construction con = constructionMapper.get(constructionIdx);
		List<Report> domainList;
		if(param.getConstructionIdx() > 0) {
			domainList = originReportMapper.getListByParamExcel(param);
		}else {
			domainList = new ArrayList<Report>();
		}
		
		ReportMaxCount cnt =  originReportMapper.getMaxCount();
		if((cnt.getCnt() + 100) < domainList.size()) {
			domainList = new ArrayList<Report>();
		}
		
		for (Report d : domainList) {
			d.setPiece(originPieceMapper.getListByReportIdx(d.getId()));
			List<Penetration> penetrationsList =  originPenetrationMapper.getListByReportIdx(d.getId());
			d.setPenetrations(penetrationsList);
			if(penetrationsList.size() > 5) {
				isBig = true;
			}
		}
		
		try {
			if((int) session.getAttribute("role") == 3) {
				model.addAttribute("longCalYn", targetCon.getLongCalYn());
				model.addAttribute("originDataYn", targetCon.getOriginDataYn());
				model.addAttribute("ubcYn", targetCon.getUbcYn());
				model.addAttribute("showPdfYn", targetCon.getShowPdfYn());
			}else {
				model.addAttribute("longCalYn", con.getLongCalYn());
				model.addAttribute("originDataYn", con.getOriginDataYn());
				model.addAttribute("ubcYn", con.getUbcYn());
				model.addAttribute("showPdfYn", con.getShowPdfYn());
			}
		}catch (Exception e) {
			model.addAttribute("longCalYn", 0);
			model.addAttribute("originDataYn", 0);
			model.addAttribute("ubcYn", 0);
			model.addAttribute("showPdfYn", 0);
		}
		
		model.addAttribute("domainList", domainList);
		model.addAttribute("role", role);
		model.addAttribute("isHiddenManager", isHiddenManager);
		model.addAttribute("signRoomList", signRoomList);
		model.addAttribute("constructionIdx", constructionIdx);
		if(isBig) {
			if(constructionIdx == 645) {
				System.err.println("reportTenJh");
				System.err.println("reportTenJh");
				return "reportTenJh";
			}
			System.err.println("reportTen");
			System.err.println("reportTen");
			return "reportTen";
		}
		
		if(constructionIdx == 645) {
			System.err.println("reportFiveJh");
			System.err.println("reportFiveJh");
			return "reportFiveJh";
		}
		System.err.println("reportFive");
		System.err.println("reportFive");
		return "reportFive";
	}
	
	//일일 기록지 다운로드
	@RequestMapping(value = "/download/excel")
	public String downLoadExcel(Model model, @ModelAttribute("domainParam") ReportParam param, BindingResult result, HttpSession session) {
		
		System.err.println("/download/excel : " + param);
		
		int isBig = 0; 
		int role = (int) session.getAttribute("role");
		//int constructionIdx = (int) session.getAttribute("constructionIdx");
		int constructionIdx = 0;
		boolean isHiddenManager  = (boolean) session.getAttribute("isHiddenManager");
		
		List<ReportOneLine> domainList;
		isBig = mapper.isBigAllReports(param);
		Construction targetCon = constructionMapper.get(param.getConstructionIdx());
		
		List<ExcelSignroom> signRoomList = null;
		String constructionName =  null;
		
		if(role == 0) {
			//슈퍼관리자
			signRoomList = excelSignroomMapper.getFindByConstructionIdxAndOrderBy(param.getConstructionIdx());
			constructionName = constructionMapper.getFullNameByConstruction(param.getConstructionIdx(),role).getName();
			constructionIdx = param.getConstructionIdx();
			if(constructionIdx == 815) {
				constructionName = constructionName.replaceAll("두산에너빌리티 선일산업", "").trim();
			}
		}else if(role == 1) {
			//일반협력사
			constructionIdx = (int) session.getAttribute("constructionIdx");
			signRoomList = excelSignroomMapper.getFindByConstructionIdxAndOrderBy(constructionIdx);
			constructionName = constructionMapper.getFullNameByConstruction(constructionIdx, role).getName();
			if(constructionIdx == 815) {
				constructionName = constructionName.replaceAll("두산에너빌리티 선일산업", "").trim();
			}
		}else if(role == 2) {
			//시공사
			constructionIdx = param.getConstructionIdx();
			signRoomList = excelSignroomMapper.getFindByConstructionIdxAndOrderBy(param.getConstructionIdx());
			constructionName = constructionMapper.getFullNameByConstruction(param.getConstructionIdx(),role).getName();
			if(constructionIdx == 815) {
				constructionName = constructionName.replaceAll("두산에너빌리티 선일산업", "").trim();
			}
		}else if(role == 3) {
			//가맹점
			constructionIdx = param.getConstructionIdx();
			signRoomList = excelSignroomMapper.getFindByConstructionIdxAndOrderBy(param.getConstructionIdx());
			constructionName = constructionMapper.getFullNameByConstruction(param.getConstructionIdx(),role).getName();
			if(constructionIdx == 815) {
				constructionName = constructionName.replaceAll("두산에너빌리티 선일산업", "").trim();
			}
		}
		
		System.err.println("constructionName : " + constructionName);
		
		if(isBig > 0) {
			Construction con = constructionMapper.get(constructionIdx);
			if(param.getConstructionIdx() > 0) {
				domainList = mapper.getListByParamExcelTen(param);
			}else {
				domainList = new ArrayList<ReportOneLine>();
			}
			
			try {
				if((int) session.getAttribute("role") == 3) {
					model.addAttribute("longCalYn", targetCon.getLongCalYn());
					model.addAttribute("originDataYn", targetCon.getOriginDataYn());
					model.addAttribute("ubcYn", targetCon.getUbcYn());
					model.addAttribute("showPdfYn", targetCon.getShowPdfYn());
				}else {
					model.addAttribute("longCalYn", con.getLongCalYn());
					model.addAttribute("originDataYn", con.getOriginDataYn());
					model.addAttribute("ubcYn", con.getUbcYn());
					model.addAttribute("showPdfYn", con.getShowPdfYn());
				}
			}catch (Exception e) {
				model.addAttribute("longCalYn", 0);
				model.addAttribute("originDataYn", 0);
				model.addAttribute("ubcYn", 0);
				model.addAttribute("showPdfYn", 0);
			}
			
			model.addAttribute("role", role);
			model.addAttribute("isHiddenManager", isHiddenManager);
			model.addAttribute("domainList", domainList);
			model.addAttribute("constructionIdx", constructionIdx);
			model.addAttribute("param", param);
			model.addAttribute("signRoomList", signRoomList);
			model.addAttribute("constructionName", constructionName);
			
			if(constructionIdx == 645) {
				System.err.println("reportTenAllJh");
				System.err.println("reportTenAllJh");
				return "reportTenAllJh";
			}
			System.err.println("reportTenAll");
			System.err.println("reportTenAll");
			return "reportTenAll";
		}
		Construction con = constructionMapper.get(constructionIdx);
		if(param.getConstructionIdx() > 0) {
			domainList = mapper.getListByParamExcelFive(param);
		}else {
			domainList = new ArrayList<ReportOneLine>();
		}
		
		try {
			if((int) session.getAttribute("role") == 3) {
				model.addAttribute("longCalYn", targetCon.getLongCalYn());
				model.addAttribute("originDataYn", targetCon.getOriginDataYn());
				model.addAttribute("ubcYn", targetCon.getUbcYn());
				model.addAttribute("showPdfYn", targetCon.getShowPdfYn());
			}else {
				model.addAttribute("longCalYn", con.getLongCalYn());
				model.addAttribute("originDataYn", con.getOriginDataYn());
				model.addAttribute("ubcYn", con.getUbcYn());
				model.addAttribute("showPdfYn", con.getShowPdfYn());
			}
		}catch (Exception e) {
			model.addAttribute("longCalYn", 0);
			model.addAttribute("originDataYn", 0);
			model.addAttribute("ubcYn", 0);
			model.addAttribute("showPdfYn", 0);
		}
		
		
		model.addAttribute("role", role);
		model.addAttribute("domainList", domainList);
		model.addAttribute("isHiddenManager", isHiddenManager);
		model.addAttribute("constructionIdx", constructionIdx);
		model.addAttribute("param", param);
		model.addAttribute("signRoomList", signRoomList);
		model.addAttribute("constructionName", constructionName);
		
		if(constructionIdx == 645) {
			System.err.println("reportFiveAllJh");
			System.err.println("reportFiveAllJh");
			return "reportFiveAllJh";
		}
		
		System.err.println("reportFiveAll");
		System.err.println("reportFiveAll");
		return "reportFiveAll";
	}
	
	
	//엑셀 전체 출력 - 사용O
	@RequestMapping(value = "/download/all/excel")
	public String downLoadAllExcel(Model model, @ModelAttribute("domainParam") ReportParam param, BindingResult result, HttpSession session) {
		
		System.err.println("/download/all/excel");
		
		int isBig = 0; 
		int role = (int) session.getAttribute("role");
		//int constructionIdx = (int) session.getAttribute("constructionIdx");
		int constructionIdx = 0;
		boolean isHiddenManager  = (boolean) session.getAttribute("isHiddenManager");
		
		List<ReportOneLine> domainList;
		isBig = mapper.isOriginBigAllReports(param.getConstructionIdx());
		Construction targetCon = constructionMapper.get(param.getConstructionIdx());
		
		List<ExcelSignroom> signRoomList = null;
		String constructionName =  null;
		
		if(role == 0) {
			//슈퍼관리자
			constructionIdx = param.getConstructionIdx();
			signRoomList = excelSignroomMapper.getFindByConstructionIdxAndOrderBy(param.getConstructionIdx());
			constructionName = constructionMapper.getFullNameByConstruction(param.getConstructionIdx(),role).getName();
			if(param.getConstructionIdx() == 815) {
				constructionName = constructionName.replaceAll("두산에너빌리티 선일산업", "").trim();
			}
		}else if(role == 1) {
			//일반협력사
			constructionIdx = (int) session.getAttribute("constructionIdx");
			signRoomList = excelSignroomMapper.getFindByConstructionIdxAndOrderBy(constructionIdx);
			constructionName = constructionMapper.getFullNameByConstruction(constructionIdx ,role).getName();
			if(constructionIdx == 815) {
				constructionName = constructionName.replaceAll("두산에너빌리티 선일산업", "").trim();
			}
		}else if(role == 2) {
			//시공사
			constructionIdx = param.getConstructionIdx();
			signRoomList = excelSignroomMapper.getFindByConstructionIdxAndOrderBy(param.getConstructionIdx());
			constructionName = constructionMapper.getFullNameByConstruction(param.getConstructionIdx() ,role).getName();
			if(param.getConstructionIdx() == 815) {
				constructionName = constructionName.replaceAll("두산에너빌리티 선일산업", "").trim();
			}
		}else if(role == 3) {
			//가맹점
			constructionIdx = param.getConstructionIdx();
			signRoomList = excelSignroomMapper.getFindByConstructionIdxAndOrderBy(param.getConstructionIdx());
			constructionName = constructionMapper.getFullNameByConstruction(param.getConstructionIdx() ,role).getName();
			if(param.getConstructionIdx() == 815) {
				constructionName = constructionName.replaceAll("두산에너빌리티 선일산업", "").trim();
			}
		}
		
		System.err.println("constructionName : " + constructionName);
		
		if(isBig > 0) {
			Construction con = constructionMapper.get(constructionIdx);
			if(param.getConstructionIdx() > 0) {
				domainList = mapper.getListByParamExcelAllBig(param);
			}else {
				domainList = new ArrayList<ReportOneLine>();
			}
			
			try {
				if((int) session.getAttribute("role") == 3) {
					model.addAttribute("longCalYn", targetCon.getLongCalYn());
					model.addAttribute("originDataYn", targetCon.getOriginDataYn());
					model.addAttribute("ubcYn", targetCon.getUbcYn());
					model.addAttribute("showPdfYn", targetCon.getShowPdfYn());
				}else {
					model.addAttribute("longCalYn", con.getLongCalYn());
					model.addAttribute("originDataYn", con.getOriginDataYn());
					model.addAttribute("ubcYn", con.getUbcYn());
					model.addAttribute("showPdfYn", con.getShowPdfYn());
				}
			}catch (Exception e) {
				model.addAttribute("longCalYn", 0);
				model.addAttribute("originDataYn", 0);
				model.addAttribute("ubcYn", 0);
				model.addAttribute("showPdfYn", 0);
			}
			
			model.addAttribute("role", role);
			model.addAttribute("isHiddenManager", isHiddenManager);
			model.addAttribute("domainList", domainList);
			model.addAttribute("constructionIdx", constructionIdx);
			model.addAttribute("param", param);
			model.addAttribute("signRoomList", signRoomList);
			model.addAttribute("constructionName", constructionName);
			
			if(constructionIdx == 645) {
				System.err.println("reportTenAllJh");
				System.err.println("reportTenAllJh");
				return "reportTenAllJh";
			}
			
			System.err.println("reportTenAll");
			System.err.println("reportTenAll");
			return "reportTenAll";
		}
		Construction con = constructionMapper.get(constructionIdx);
		if(param.getConstructionIdx() > 0) {
			domainList = mapper.getListByParamExcelAll(param);
		}else {
			domainList = new ArrayList<ReportOneLine>();
		}
		
		try {
			if((int) session.getAttribute("role") == 3) {
				model.addAttribute("longCalYn", targetCon.getLongCalYn());
				model.addAttribute("originDataYn", targetCon.getOriginDataYn());
				model.addAttribute("ubcYn", targetCon.getUbcYn());
				model.addAttribute("showPdfYn", targetCon.getShowPdfYn());
			}else {
				model.addAttribute("longCalYn", con.getLongCalYn());
				model.addAttribute("originDataYn", con.getOriginDataYn());
				model.addAttribute("ubcYn", con.getUbcYn());
				model.addAttribute("showPdfYn", con.getShowPdfYn());
			}
		}catch (Exception e) {
			model.addAttribute("longCalYn", 0);
			model.addAttribute("originDataYn", 0);
			model.addAttribute("ubcYn", 0);
			model.addAttribute("showPdfYn", 0);
		}
		
		model.addAttribute("role", role);
		model.addAttribute("domainList", domainList);
		model.addAttribute("isHiddenManager", isHiddenManager);
		model.addAttribute("constructionIdx", constructionIdx);
		model.addAttribute("param", param);
		model.addAttribute("signRoomList", signRoomList);
		model.addAttribute("constructionName", constructionName);
		
		if(constructionIdx == 645) {
			System.err.println("reportFiveAllJh");
			System.err.println("reportFiveAllJh");
			return "reportFiveAllJh";
		}
		
		System.err.println("reportFiveAll");
		System.err.println("reportFiveAll");
		return "reportFiveAll";
	}
	
	
	
	@ResponseBody
	@RequestMapping(value = "/doRestoreMulti", method = RequestMethod.POST)
	public boolean doRestoreMulti(@RequestBody List<UpdateReport> report) {
		try {
			for (UpdateReport updateReport : report) { 
				doRestore(updateReport);
			}
		}catch (Exception e) {
			return false;
		}
		return true;
	}
	
	
	public void doRestore(UpdateReport report) {
		mapper.doRestore(report.getId());
	}
	
	@ResponseBody
	@RequestMapping(value = "/doDeleteMulti", method = RequestMethod.POST)
	public boolean doDeleteMulti(@RequestBody List<UpdateReport> report) {
		try {
			for (UpdateReport updateReport : report) {  
				doDelete(updateReport);
			}
		}catch (Exception e) {
			return false;
		}
		return true;
	}
	
	public void doDelete(UpdateReport report) {
		mapper.doDelete(report.getId());
	}
	
	@ResponseBody
	@RequestMapping(value = "/update/reportMulti", method = RequestMethod.POST)
	public boolean updateReportMulti(@RequestBody List<UpdateReport> report) {
		try {
			for (UpdateReport updateReport : report) {  
				updateReportOne(updateReport);
			}
		}catch (Exception e) {
			return false;
		}
		return true;
	}
	
	
	
	@ResponseBody
	@RequestMapping(value = "/update/report", method = RequestMethod.POST)
	public boolean updateReport(@RequestBody UpdateReport report) {
		
		report.setUltimateBearingCapacity(String.valueOf(calDanish(report)));
		int result = mapper.update(report);
		if(result > 0) {
			//전체를 다 삭제하고.
			pieceMapper.deleteByReportIdx(report.getId());
			for (Piece piese : report.getPiece()) {
				//다시 다 넣는다.
				if(pieceMapper.insert(piese) == 0) {
					return false;
				}
			}
			
			
			if(report.getPenetrations() != null) {
				for (Penetration penetration : report.getPenetrations()) {
					if(penetrationMapper.get(penetration.getId()) != null) {
						penetrationMapper.update(penetration);
					}else {
						penetrationMapper.insert(penetration);
					}
				}
			}
		}
		return true;
	}
	
	
	public boolean updateReportOne(UpdateReport report) {
		//원상태값
		//Report rp = mapper.get(report.getId());
		report.setUltimateBearingCapacity(String.valueOf(calDanish(report)));
		//report.setUltimateBearingCapacity(report.getUltimateBearingCapacity());
		int result = mapper.update(report);
//		List<Report> rp2 = mapper.getDuplicationRepotsAllReport(report);
//		if(rp2.size() > 1) {
//			for (int i = 0; i < rp2.size(); i++) {
//				if(i == 0) {
//					mapper.updateDupl2(rp2.get(i));
//				} else {
//					mapper.updateDupl(rp2.get(i));
//				}
//			}
//		}
		
		if(result > 0) {
			//전체를 다 삭제하고.
			pieceMapper.deleteByReportIdx(report.getId());
			for (Piece piese : report.getPiece()) {
				//다시 다 넣는다.
				if(pieceMapper.insert(piese) == 0) {
					return false;
				}
			}
			
			if(report.getPenetrations() != null) {
				for (Penetration penetration : report.getPenetrations()) {
					if(penetrationMapper.get(penetration.getId()) != null) {
						penetrationMapper.update(penetration);
					}else {
						penetrationMapper.insert(penetration);
					}
				}
			}
		}
		return true;
	}
	
	
	@ResponseBody
	@RequestMapping(value = "/test/report", method = RequestMethod.GET)
	public List<Report> test( @ModelAttribute("domainParam") ReportParam param){
		Pagination page;
		
		int totalCount = mapper.getCountByParam(param);
		
		if (param.getPageSize() > 0 && param.getPageGroupSize() > 0) {
			page = new Pagination(param.getPageSize(), param.getPageGroupSize(), totalCount, param.getCurrentPage());
		} else {
			page = new Pagination(totalCount, param.getCurrentPage());
		}
		
		List<Report> domainList = mapper.getListByParam(page.getStartRow(), page.getPageSize(), param);
		for (Report d : domainList) {
			d.setPiece(pieceMapper.getListByReportIdx(d.getId()));
			d.setPenetrations(penetrationMapper.getListByReportIdx(d.getId()));
		}
		return domainList;
	}
	
	@ResponseBody
	@RequestMapping(value = "/doRestore", method = RequestMethod.POST)
	public boolean doRestore(@RequestParam("id") int id) {
		return mapper.doRestore(id) > 0;
	}
	
	@ResponseBody
	@RequestMapping(value = "/doDelete", method = RequestMethod.POST)
	public boolean doDelete(@RequestParam("id") int id) {
		//pieceMapper.delete(id)
		return mapper.doDelete(id) > 0;
	}
	
//	private double calDanish(float S){
//
//        if(S < 0){
//            S = Math.abs(S);
//        }
//
//        float EH = Float.parseFloat(Utill.stringNullCheck(binding.hammaEfficiency.getText().toString()) ? binding.hammaEfficiency.getText().toString() : "0");
//        float WR = Float.parseFloat(Utill.stringNullCheck(binding.hammaT.getText().toString()) ? binding.hammaT.getText().toString() : "0");
//        float H =  Float.parseFloat(Utill.stringNullCheck(binding.fallMeter.getText().toString()) ? binding.fallMeter.getText().toString() : "0");
//        float L =  Float.parseFloat(Utill.stringNullCheck(binding.totalConnectWidth.getText().toString()) ? binding.totalConnectWidth.getText().toString() : "0");
//        float A =  Float.parseFloat(Utill.stringNullCheck(binding.crossSection.getText().toString()) ? binding.crossSection.getText().toString() : "0");
//        float E =  Float.parseFloat(Utill.stringNullCheck(binding.modulusElasticity.getText().toString()) ? binding.modulusElasticity.getText().toString() : "0");
//
//        double RU = MathUtill.calDanish(EH, WR, (H * 100), (L * 100) ,A , E, (S / 10));
//        if(Double.isInfinite(RU)){
//            return 0;
//        }else if(Double.isNaN(RU)){
//            return  0;
//        }else{
//            return RU;
//        }
//    }
	
	private int calDanish(UpdateReport report){

        float EH = Float.parseFloat(Utill.stringNullCheck(report.getHammaEfficiency()) ? report.getHammaEfficiency() : "0");
        float WR = Float.parseFloat(Utill.stringNullCheck(report.getHammaT()) ? report.getHammaT() : "0");
        float H =  Float.parseFloat(Utill.stringNullCheck(report.getFallMeter()) ? report.getFallMeter() : "0");
        float L =  Float.parseFloat(Utill.stringNullCheck(report.getIntrusionDepth()) ? report.getIntrusionDepth() : "0");
        float A =  Float.parseFloat(Utill.stringNullCheck(report.getCrossSection()) ? report.getCrossSection() : "0");
        float E =  Float.parseFloat(Utill.stringNullCheck(report.getModulusElasticity()) ? report.getModulusElasticity() : "0");
        float S =  Float.parseFloat(Utill.stringNullCheck(report.getAvgPenetrationValue()) ? report.getAvgPenetrationValue() : "0");
        
        double RU = MathUtil.calDanish(EH, WR, ( H * 100), (L * 100) ,A , E, (S / 10));
        if(Double.isInfinite(RU)){
            return 0;
        }else if(Double.isNaN(RU)){
            return  0;
        }else{
            //return (int) RU;
            return (int) Double.parseDouble(String.format("%.0f",(RU * 9.8)));
        }
    }  
	
	
	@RequestMapping(value = "/regist", method = RequestMethod.GET)
	public void regist(Model model) throws InstantiationException, IllegalAccessException {
		model.addAttribute("domain", new Report());
	}

	@RequestMapping(value = "/regist", method = RequestMethod.POST)
	public String regist(@ModelAttribute("domain") Report domain, SessionStatus sessionStatus) {
		System.err.println("domain : {} " +  domain);
		if (mapper.insert(domain) == 1) {
			return "/report/regist";
		}
		return "/report/regist";
	}
	
	@ResponseBody
	@RequestMapping(value = "/today/list", method = RequestMethod.POST)
	public List<ReportOneLine> getTodayList(@RequestParam("constructionIdx") int constructionIdx
			, @RequestParam("machineNumber") String machineNumber
			, @RequestParam("currentDateTime") String currentDateTime){
		return mapper.getTodayListByPdf(constructionIdx, machineNumber, currentDateTime);
	}
	
	@ResponseBody
	@RequestMapping(value = "/machine/list", method = RequestMethod.POST)
	public List<ReportOneLine> getTodayList(@RequestParam("constructionIdx") int constructionIdx
			, @RequestParam("machineNumber") String machineNumber){
		return mapper.getMachineListByPdf(constructionIdx, machineNumber);
	}
	
	@ModelAttribute
	public void setSessionInfo(Model model, HttpSession session) {
		SessionInfo sessionInfo = new SessionInfo();
		sessionInfo.setUserId((String) session.getAttribute("userId"));
		sessionInfo.setUserName((String) session.getAttribute("userName"));
		sessionInfo.setRole((Integer) session.getAttribute("role"));
		sessionInfo.setConstructionIdx((Integer) session.getAttribute("constructionIdx"));
		sessionInfo.setHiddenManager((Boolean) session.getAttribute("isHiddenManager"));
		sessionInfo.setGroupIdx((Integer) session.getAttribute("groupIdx"));	
		sessionInfo.setFcIdx((Integer) session.getAttribute("fcIdx"));	
		sessionInfo.setShowPdfYn((Boolean) session.getAttribute("showPdfYn"));	
	    model.addAttribute("sessionInfo", sessionInfo);
	}
}
