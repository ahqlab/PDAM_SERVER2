package net.octacomm.sample.controller;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import net.octacomm.sample.dao.mapper.DeviceMapper;
import net.octacomm.sample.dao.mapper.FallMeterMapper;
import net.octacomm.sample.dao.mapper.OriginFallMeterMapper;
import net.octacomm.sample.dao.mapper.OriginPenetrationMapper;
import net.octacomm.sample.dao.mapper.OriginPieceMapper;
import net.octacomm.sample.dao.mapper.PenetrationMapper;
import net.octacomm.sample.dao.mapper.PieceMapper;
import net.octacomm.sample.dao.mapper.PileCrosSectionMapper;
import net.octacomm.sample.dao.mapper.PileSelectMethodValueMapper;
import net.octacomm.sample.dao.mapper.PileSelectValueMapper;
import net.octacomm.sample.dao.mapper.PileStandardMapper;
import net.octacomm.sample.dao.mapper.PileTicknessMapper;
import net.octacomm.sample.dao.mapper.ReportMapper;
import net.octacomm.sample.dao.mapper.ReportWithFallMeterMapper;
import net.octacomm.sample.domain.CommonListResponse;
import net.octacomm.sample.domain.CommonResponse;
import net.octacomm.sample.domain.Device;
import net.octacomm.sample.domain.FallMeter;
import net.octacomm.sample.domain.GReport;
import net.octacomm.sample.domain.Penetration;
import net.octacomm.sample.domain.Piece;
import net.octacomm.sample.domain.PileSelectMethodValue;
import net.octacomm.sample.domain.PileSelectValue;
import net.octacomm.sample.domain.PileSelectValueParent;
import net.octacomm.sample.domain.PileStandardInfo;
import net.octacomm.sample.domain.Report;
import net.octacomm.sample.domain.ReportWithFallMeter;
import net.octacomm.sample.exceptions.InvalidPasswordException;
import net.octacomm.sample.exceptions.NotFoundUserException;
import net.octacomm.sample.service.DeviceService;


@RequestMapping("/mobile")
@Controller
public class MobileController {
	
	@Autowired
	private DeviceService deviceService;
	
	@Autowired
	private DeviceMapper deviceMapper;
	
	@Autowired
	private ReportMapper reportMapper;
	
	@Autowired
	private PieceMapper pieceMapper;
	
	@Autowired
	private PenetrationMapper penetrationMapper;
	
	@Autowired
	private OriginPenetrationMapper originPenetrationMapper;
	
	@Autowired
	private OriginPieceMapper originPieceMapper;
	
	@Autowired
	private PileStandardMapper pileStandardMapper;
	
	@Autowired
	private PileCrosSectionMapper pileCrosSectionMapper;
	
	@Autowired
	private PileTicknessMapper pileTicknessMapper;
	
	@Autowired
	private FallMeterMapper fallMeterMapper;
	
	@Autowired
	private OriginFallMeterMapper originFallMeterMapper;
	
	@Autowired
	private ReportWithFallMeterMapper reportWithFallMeterMapper;
	
	@Autowired
	private PileSelectValueMapper pileSelectValueMapper;
	
	@Autowired
	private PileSelectMethodValueMapper pileSelectMethodValueMapper;
	
	
	
	//PDAM에서 온라인 에서 다이렉트로 보내는 곳
	@ResponseBody
	@RequestMapping(value = "/regist/report", method = RequestMethod.POST)
	public CommonResponse<Boolean> registReport(@RequestBody Report report, BindingResult result){
		System.err.println("/regist/report report sTring : "  + report);
		System.err.println("/regist/report report : " + report.getGongSac() + " balance : " + report.getBalance());
		CommonResponse<Boolean> response = new CommonResponse<Boolean>();
		try{
			if(report.getCreateDate() != null) {
				reportMapper.insert2(report);
				try {
					reportMapper.insert2Origin(report);
				}catch (Exception e) {
					
				}
			}else {
				System.err.println("여기서 입력이지??ㄴㄴㄴ");
				reportMapper.insert(report);
				try {
					reportMapper.insertOrigin(report);
				}catch (Exception e) {
				}
				
			}
		}catch (Exception e) {
			System.err.println("insert  오류");
		}
		
		for (Piece piece : report.getPiece()) {
			piece.setReportIdx(report.getId());
			try {
				pieceMapper.insert(piece);
				try {
					copyOfPiece(report.getId());
				}catch (Exception e) {}
			}catch (Exception e) {
				response.setDomain(false);
			}
		}
		for (Penetration penetration : report.getPenetrations()) {
			penetration.setReportIdx(report.getId());
			try {
				penetrationMapper.insert(penetration);
				try {
					copyOfPenetration(report.getId());
				}catch (Exception e) {}
				
			}catch (Exception e) {
				response.setDomain(false);
			}
		}
		response.setDomain(true);
		
		int dpCnt = reportMapper.isDuplication(report);
		if(dpCnt > 1) {
			reportMapper.updateDupl(report);
		}
		return response;
	}

	
	//PDAM에서 오프라인에서 쌓았던것을 한번에 쭉 보내는 곳
	@ResponseBody
	@RequestMapping(value = "/regist/report2", method = RequestMethod.POST)
	public CommonResponse<Boolean> registReport2(@RequestBody List<Report> report, BindingResult result){
		System.err.println("report2 : " + report);
		System.err.println("report : " + report.size());
		CommonResponse<Boolean> response = new CommonResponse<Boolean>();
		for (Report report2 : report) {
			try{
				if(report2.getCreateDate() != null) {
					reportMapper.insert2(report2);
					try {
						reportMapper.insert2Origin(report2);
					}catch (Exception e) {}
				}else {
					reportMapper.insert(report2);
					try {
						reportMapper.insertOrigin(report2);
					}catch (Exception e) {}
				}
			}catch (Exception e) {
				System.err.println("insert  오류");
				response.setDomain(false);
				return response;
			}
			
		
			for (Piece piece : report2.getPiece()) {
				piece.setReportIdx(report2.getId());
				try {
					pieceMapper.insert(piece);
					try {
						copyOfPiece(report2.getId());
					}catch (Exception e) {}
				}catch (Exception e) {
					response.setDomain(false);
				}
			}
			for (Penetration penetration : report2.getPenetrations()) {
				penetration.setReportIdx(report2.getId());
				try {
					penetrationMapper.insert(penetration);
					try {
						copyOfPenetration(report2.getId());
					}catch (Exception e) {}
				}catch (Exception e) {
					response.setDomain(false);
				}
			}
			response.setDomain(true);
			
			int dpCnt = reportMapper.isDuplication(report2);
			if(dpCnt > 1) {
				reportMapper.updateDupl(report2);
			}
		}
		
		return response;
	}
	
	//판단 안됨... 어디서 보내는거지....???
	@ResponseBody
	@RequestMapping(value = "/regist/report3", method = RequestMethod.POST)
	public CommonResponse<Boolean> registReport3(@RequestBody GReport report, BindingResult result){
		System.err.println("report : " + report);
		CommonResponse<Boolean> response = new CommonResponse<Boolean>();
		try{
			if(report.getCreateDate() != null) {
				reportMapper.insertG2(report);
				try {
					reportMapper.insertG2Origin(report);
				}catch (Exception e) {
					
				}
			} else {
				reportMapper.insertG(report);
				try {
					reportMapper.insertGOrigin(report);
				}catch (Exception e) {
				}
				
			}
		}catch (Exception e) {
			System.err.println("insert  오류");
		}
		
		for (Piece piece : report.getPiece()) {
			piece.setReportIdx(report.getId());
			try {
				pieceMapper.insert(piece);
				try {
					copyOfPiece(report.getId());
				}catch (Exception e) {}
			}catch (Exception e) {
				response.setDomain(false);
			}
		}
		for (Penetration penetration : report.getPenetrations()) {
			penetration.setReportIdx(report.getId());
			try {
				penetrationMapper.insert(penetration);
				try {
					copyOfPenetration(report.getId());
				}catch (Exception e) {}
				
			}catch (Exception e) {
				response.setDomain(false);
			}
		}
		response.setDomain(true);
		
		int dpCnt = reportMapper.isGDuplication(report);
		if(dpCnt > 1) {
			reportMapper.updateGDupl(report);
		}
		return response;
	}
	
	
	//낙하고 자동 측정 INSERT용
	@ResponseBody
	@RequestMapping(value = "/regist/report4", method = RequestMethod.POST)
	public CommonResponse<Boolean> registReport4(@RequestBody ReportWithFallMeter report, BindingResult result){
		System.err.println("/regist/report report sTring : "  + report);
		System.err.println("/regist/report report : " + report.getGongSac() + " balance : " + report.getBalance());
		
		report.setBigo("");
		report.setDrillingDepth(report.getIntrusionDepth());
		
		CommonResponse<Boolean> response = new CommonResponse<Boolean>();
		try{
			if(report.getCreateDate() != null) {
				reportWithFallMeterMapper.insert2(report);
				try {
					reportWithFallMeterMapper.insert2Origin(report);
				}catch (Exception e) {
					
				}
			}else {
				System.err.println("여기서 입력이지??ㄴㄴㄴ");
				reportWithFallMeterMapper.insert(report);
				try {
					reportWithFallMeterMapper.insertOrigin(report);
				}catch (Exception e) {
				}
				
			}
		}catch (Exception e) {
			e.printStackTrace();
			System.err.println("insert  오류");
		}
		
		for (Piece piece : report.getPiece()) {
			piece.setReportIdx(report.getId());
			try {
				pieceMapper.insert(piece);
				try {
					copyOfPiece(report.getId());
				}catch (Exception e) {}
			}catch (Exception e) {
				response.setDomain(false);
			}
		}
		
		
		for (Penetration penetration : report.getPenetrations()) {
			penetration.setReportIdx(report.getId());
			try {
				penetrationMapper.insert(penetration);
				try {
					copyOfPenetration(report.getId());
				}catch (Exception e) {}
				
			}catch (Exception e) {
				response.setDomain(false);
			}
		}
		
		for (FallMeter fallMeter : report.getTons()) {
			fallMeter.setReportIdx(report.getId());
			try {
				fallMeterMapper.insert(fallMeter);
				try {
					copyOfFallMeter(report.getId());
				}catch (Exception e) {}
				
			}catch (Exception e) {
				response.setDomain(false);
			}
		}
		
		response.setDomain(true);
		
		int dpCnt = reportWithFallMeterMapper.isDuplication(report);
		if(dpCnt > 1) {
			reportWithFallMeterMapper.updateDupl(report);
		}
		return response;
	}
	
	
	//낙하고 자동 측정 INSERT용
	@ResponseBody
	@RequestMapping(value = "/regist/report5", method = RequestMethod.POST)
	public CommonResponse<Boolean> registReport5(@RequestBody List<ReportWithFallMeter> report, BindingResult result){
		System.err.println("report : " + report.size());
		CommonResponse<Boolean> response = new CommonResponse<Boolean>();
		for (ReportWithFallMeter report2 : report) {
			try{
				if(report2.getCreateDate() != null) {
					reportWithFallMeterMapper.insert2(report2);
					try {
						reportWithFallMeterMapper.insert2Origin(report2);
					}catch (Exception e) {}
				}else {
					reportWithFallMeterMapper.insert(report2);
					try {
						reportWithFallMeterMapper.insertOrigin(report2);
					}catch (Exception e) {}
				}
			}catch (Exception e) {
				System.err.println("insert  오류");
				response.setDomain(false);
				return response;
			}
			
		
			for (Piece piece : report2.getPiece()) {
				piece.setReportIdx(report2.getId());
				try {
					pieceMapper.insert(piece);
					try {
						copyOfPiece(report2.getId());
					}catch (Exception e) {}
				}catch (Exception e) {
					response.setDomain(false);
				}
			}
			for (Penetration penetration : report2.getPenetrations()) {
				penetration.setReportIdx(report2.getId());
				try {
					penetrationMapper.insert(penetration);
					try {
						copyOfPenetration(report2.getId());
					}catch (Exception e) {}
				}catch (Exception e) {
					response.setDomain(false);
				}
			}
			
			
			for (FallMeter fallMeter : report2.getTons()) {
				fallMeter.setReportIdx(report2.getId());
				try {
					fallMeterMapper.insert(fallMeter);
					try {
						copyOfFallMeter(report2.getId());
					}catch (Exception e) {}
					
				}catch (Exception e) {
					response.setDomain(false);
				}
			}
			
			response.setDomain(true);
			
			int dpCnt = reportWithFallMeterMapper.isDuplication(report2);
			if(dpCnt > 1) {
				reportWithFallMeterMapper.updateDupl(report2);
			}
		}
		System.err.println("response : " + response);
		return response;
	}
	

	@ResponseBody
	@RequestMapping(value = "/device/login", method = RequestMethod.POST)
	public CommonResponse<Device> mobileLogin(@RequestBody Device device) {
		CommonResponse<Device> response = new CommonResponse<Device>();
		try {
			Device result = deviceService.login(device);
			response.setDomain(result);
			response.setResultMessage("성공");
		} catch (NotFoundUserException nfe) {
			response.setDomain(null);
			response.setResultMessage("아이디가 존재하지 않습니다.");
		} catch (InvalidPasswordException ipe) {
			response.setDomain(null);
			response.setResultMessage("아이디 비밀번호가 일치하지 않습니다.");
		}
		return response;
	}
	
	
	
	@ResponseBody
	@RequestMapping(value = "/device/all/list", method = RequestMethod.GET)
	public CommonListResponse<Device> allList(){
		CommonListResponse<Device> response = new CommonListResponse<Device>();
		response.setDomain(deviceMapper.getList());
		response.setResultMessage("성공");
		return response;
	}
	
	@ResponseBody
	@RequestMapping(value = "/pilestandard/all/list", method = RequestMethod.GET)
	public PileStandardInfo getPileStandard() {
		PileStandardInfo info = new PileStandardInfo();
		info.setPileStandardList(pileStandardMapper.getList());
		info.setPileSrossSectionList(pileCrosSectionMapper.getList());
		info.setPileTicknessList(pileTicknessMapper.getList());
		return info;
	}
	
//	@ResponseBody
//	@RequestMapping(value = "/pileselectvalue/piletype/list", method = RequestMethod.GET)
//	public List<PileSelectValue> getPileSelectValues(){
//		List<PileSelectValue> list = pileSelectValueMapper.getPileTypeList();
//		return (list != null && !list.isEmpty()) ? list : new ArrayList<PileSelectValue>();
//	}
	
	@ResponseBody
	@RequestMapping(value = "/pileselectvalue/list", method = RequestMethod.POST)
	public CommonResponse<PileSelectValueParent> getPileSelectValues(@RequestBody Device device){
		
		CommonResponse<PileSelectValueParent> response = new CommonResponse<PileSelectValueParent>();
		
		PileSelectValueParent parent = new PileSelectValueParent();
		List<PileSelectValue> currentSelectValueList = pileSelectValueMapper.getListByDeviceIdx(device.getId());
		List<PileSelectMethodValue> currentMethodValueList = pileSelectMethodValueMapper.getListByDeviceIdx(device.getId());
		
		if(currentSelectValueList.size() > 0) {
			parent.setPileSelectValues(currentSelectValueList);
			response.setDomain(parent);
		}else {
			currentSelectValueList = pileSelectValueMapper.getListByDeviceIdx(0);
			parent.setPileSelectValues(currentSelectValueList);
		}
		
		if(currentMethodValueList.size() > 0) {
			parent.setPileSelectMethodValue(currentMethodValueList);
		}else {
			currentMethodValueList = pileSelectMethodValueMapper.getListByDeviceIdx(0);
			parent.setPileSelectMethodValue(currentMethodValueList);
		}
		response.setDomain(parent);
		response.setResultMessage("성공");
		return response;
	}
	
	
	private void copyOfPenetration(int reportIdx) {
		List<Penetration> list = penetrationMapper.getListByReportIdxOfCopy(reportIdx);
		for (Penetration penetration : list) {
			try {
				originPenetrationMapper.insertOrigin(penetration);
			}catch (Exception e) {
			}
		}
	}
	
	
	private void copyOfPiece(int reportIdx) {
		List<Piece> list = pieceMapper.getListByReportIdxOfCopy(reportIdx);
		for (Piece piece : list) {
			try {
				originPieceMapper.insertOrigin(piece);
			}catch (Exception e) {
			}
		}
	}
	
	private void copyOfFallMeter(int reportIdx) {
		List<FallMeter> list = fallMeterMapper.getListByReportIdxOfCopy(reportIdx);
		for (FallMeter fallMeter : list) {
			try {
				originFallMeterMapper.insertOrigin(fallMeter);
			}catch (Exception e) {
			}
		}
	}
}
