package net.octacomm.sample.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.mail.Session;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import net.octacomm.sample.dao.mapper.ConstructionMapper;
import net.octacomm.sample.dao.mapper.DeviceBackupHistoryMapper;
import net.octacomm.sample.dao.mapper.DeviceMapper;
import net.octacomm.sample.dao.mapper.ExcelSignroomMapper;
import net.octacomm.sample.dao.mapper.TotalWorkQuantityMapper;
import net.octacomm.sample.domain.Construction;
import net.octacomm.sample.domain.ConstructionParam;
import net.octacomm.sample.domain.ConstructionSetting;
import net.octacomm.sample.domain.Device;
import net.octacomm.sample.domain.DeviceBackupHistory;
import net.octacomm.sample.domain.DeviceBackupSnapshot;
import net.octacomm.sample.domain.DeviceParam;
import net.octacomm.sample.domain.ReportParam;
import net.octacomm.sample.domain.SessionInfo;
import net.octacomm.sample.service.DeviceBackupHistoryService;

@RequestMapping("/device")
@Controller
public class DeviceController extends AbstractDeviceCRUDController<DeviceMapper, Device, DeviceParam, Integer>{

	private static final Logger logger = LoggerFactory.getLogger(DeviceController.class);
	
	@Autowired
	private TotalWorkQuantityMapper totalWorkQuantityMapper;
	
	@Autowired
	private ConstructionMapper ConstructionMapper;

	@Autowired
	private DeviceBackupHistoryMapper deviceBackupHistoryMapper;

	@Autowired
	private DeviceBackupHistoryService deviceBackupHistoryService;

	@Autowired
	private ExcelSignroomMapper excelSignroomMapper;

	@Autowired
	public void setCRUDMapper(DeviceMapper mapper) {
		this.mapper = mapper;
	}

	@Override
	protected Class<Device> getDomainClass() {
		return Device.class;
	}
	
	@Override
	protected String getRedirectUrl(HttpServletRequest request, HttpSession session) {
		return "redirect:/construction/list";
	}
	
	@ModelAttribute
	public void setActiveMenu(Model model, HttpSession session) {
		int role = (Integer) session.getAttribute("role");
		if(role > 0) {
			model.addAttribute("menuIndex", 0);
		}else{
			model.addAttribute("menuIndex", 1);
		}
	}

	@RequestMapping(value = "/regist2", method = RequestMethod.GET)
	public void regist(Model model, @RequestParam("constructionIdx") int constructionIdx){
		model.addAttribute("constructionIdx", constructionIdx);
		model.addAttribute("domain", new Device());
	}

	@RequestMapping(value = "/backup-history", method = RequestMethod.GET)
	public String backupHistory(
			Model model,
			@RequestParam("constructionIdx") int constructionIdx,
			@RequestParam(value = "deviceId", required = false) Integer deviceId) {
		List<Device> deviceList = mapper.getDeviceList(constructionIdx);
		Device selectedDevice = null;

		if (deviceId != null) {
			for (Device device : deviceList) {
				if (device.getId() == deviceId.intValue()) {
					selectedDevice = device;
					break;
				}
			}
		}

		List<DeviceBackupHistory> backupHistoryList = java.util.Collections.emptyList();
		if (selectedDevice != null) {
			try {
				backupHistoryList = deviceBackupHistoryMapper.getListByDevice(
						constructionIdx, selectedDevice.getId());
			} catch (Exception e) {
				logger.warn("Device backup history table is not ready.", e);
			}
		} else {
			try {
				backupHistoryList = deviceBackupHistoryMapper.getListByConstruction(
						constructionIdx);
			} catch (Exception e) {
				logger.warn("Device backup history table is not ready.", e);
			}
		}

		model.addAttribute("constructionIdx", constructionIdx);
		model.addAttribute("deviceList", deviceList);
		model.addAttribute("selectedDevice", selectedDevice);
		model.addAttribute("backupHistoryList", backupHistoryList);
		model.addAttribute("currentBackup",
				backupHistoryList.isEmpty() ? null : backupHistoryList.get(0));
		return "device/backupHistory";
	}

	@ResponseBody
	@RequestMapping(
			value = "/backup-history/restore",
			method = RequestMethod.POST)
	public Map<String, Object> restoreBackupHistory(
			@RequestParam("constructionIdx") int constructionIdx,
			@RequestParam("deviceId") int deviceId,
			@RequestParam("historyId") int historyId) {
		Map<String, Object> result = new HashMap<String, Object>();
		try {
			DeviceBackupHistory restored =
					deviceBackupHistoryService.restoreBackup(
							constructionIdx, deviceId, historyId);
			result.put("success", true);
			result.put("version", restored.getVersion());
			result.put("created", restored.getId() != historyId);
		} catch (Exception e) {
			logger.error("Device backup restore failed.", e);
			result.put("success", false);
			result.put("message", e.getMessage());
		}
		return result;
	}

	@RequestMapping(
			value = "/backup-history/download",
			method = RequestMethod.GET)
	public String downloadBackupHistory(
			Model model,
			HttpSession session,
			HttpServletResponse response,
			@RequestParam("constructionIdx") int constructionIdx,
			@RequestParam("deviceId") int deviceId,
			@RequestParam("historyId") int historyId) throws IOException {
		DeviceBackupHistory history = deviceBackupHistoryService.getHistory(
				historyId, constructionIdx, deviceId);
		DeviceBackupSnapshot snapshot =
				deviceBackupHistoryService.getSnapshot(
						historyId, constructionIdx, deviceId);
		if (history == null || snapshot == null
				|| snapshot.getExcelReports() == null) {
			response.sendError(
					HttpServletResponse.SC_NOT_FOUND,
					"다운로드할 백업 데이터를 찾을 수 없습니다.");
			return null;
		}

		Integer roleValue = (Integer) session.getAttribute("role");
		int role = roleValue == null ? 0 : roleValue.intValue();
		boolean isHiddenManager = Boolean.TRUE.equals(
				session.getAttribute("isHiddenManager"));
		if (Boolean.TRUE.equals(session.getAttribute("settingRequired"))) {
			isHiddenManager = true;
		}

		Construction construction = ConstructionMapper.get(constructionIdx);
		ReportParam param = new ReportParam();
		param.setId(deviceId);
		param.setConstructionIdx(constructionIdx);

		model.addAttribute("role", role);
		model.addAttribute("isHiddenManager", isHiddenManager);
		model.addAttribute("domainList", snapshot.getExcelReports());
		model.addAttribute("constructionIdx", constructionIdx);
		model.addAttribute("param", param);
		model.addAttribute("backupDownloadFileName",
				createBackupDownloadFileName(history));
		model.addAttribute(
				"signRoomList",
				excelSignroomMapper.getFindByConstructionIdxAndOrderBy(
						constructionIdx));
		model.addAttribute(
				"constructionName",
				getConstructionName(construction, constructionIdx, role));
		model.addAttribute(
				"extensivePileUsage",
				snapshot.getExtensivePileUsage());
		addExcelPermissionModel(model, session, construction);

		return getBackupExcelViewName(
				constructionIdx,
				snapshot.isBig(),
				snapshot.getExtensivePileUsage());
	}

	private String createBackupDownloadFileName(DeviceBackupHistory history) {
		String createdAt = history.getCreatedAt() == null ? ""
				: history.getCreatedAt().replaceAll("[^0-9]", "");
		return "PDAM_REPORT_"
				+ sanitizeFileNamePart(history.getVersion())
				+ "_" + sanitizeFileNamePart(history.getWorkType())
				+ (createdAt.isEmpty() ? "" : "_" + createdAt)
				+ ".xls";
	}

	private String sanitizeFileNamePart(String value) {
		if (value == null || value.trim().isEmpty()) {
			return "기록지";
		}
		return value.trim().replaceAll("[\\\\/:*?\"<>|\\s]+", "_");
	}

	private String getConstructionName(
			Construction construction, int constructionIdx, int role) {
		Construction fullNameConstruction =
				ConstructionMapper.getFullNameByConstruction(
						constructionIdx, role);
		if (fullNameConstruction != null
				&& fullNameConstruction.getName() != null) {
			return fullNameConstruction.getName();
		}
		return construction == null ? "" : construction.getName();
	}

	private void addExcelPermissionModel(
			Model model,
			HttpSession session,
			Construction construction) {
		int longCalYn = construction == null ? 0 : construction.getLongCalYn();
		int originDataYn =
				construction == null ? 0 : construction.getOriginDataYn();
		int ubcYn = construction == null ? 0 : construction.getUbcYn();
		int showPdfYn = construction == null ? 0 : construction.getShowPdfYn();

		ConstructionSetting setting =
				(ConstructionSetting) session.getAttribute(
						"constructionSetting");
		if (Boolean.TRUE.equals(session.getAttribute("settingRequired"))
				&& setting != null) {
			boolean admin = Boolean.TRUE.equals(
					session.getAttribute("isHiddenManager"));
			longCalYn = admin
					? (setting.isUseAdminReportTime() ? 1 : 0)
					: (setting.isUseGuestReportTime() ? 1 : 0);
			ubcYn = admin
					? (setting.isUseAdminUbc() ? 1 : 0)
					: (setting.isUseGuestUbc() ? 1 : 0);
			originDataYn = admin
					? (setting.isUseAdminOriginData() ? 1 : 0)
					: (setting.isUseGuestOriginData() ? 1 : 0);
			showPdfYn = admin
					? (setting.isUseAdminPdf() ? 1 : 0)
					: (setting.isUseGuestPdf() ? 1 : 0);
		}

		model.addAttribute("longCalYn", longCalYn);
		model.addAttribute("originDataYn", originDataYn);
		model.addAttribute("ubcYn", ubcYn);
		model.addAttribute("showPdfYn", showPdfYn);
	}

	private String getBackupExcelViewName(
			int constructionIdx, boolean isBig, int extensivePileUsage) {
		if (isBig) {
			if (constructionIdx == 645) {
				return "reportTenAllJh";
			}
			if (constructionIdx == 1269) {
				return "reportTenAllFor1269";
			}
			if (extensivePileUsage > 0) {
				return "reportTenAllFor1338";
			}
			return "reportTenAll";
		}

		if (constructionIdx == 645) {
			return "reportFiveAllJh";
		}
		if (constructionIdx == 1082) {
			return "reportFiveAllBy";
		}
		if (constructionIdx == 1269) {
			return "reportFiveAllFor1269";
		}
		if (extensivePileUsage > 0) {
			return "reportFiveAllFor1338";
		}
		return "reportFiveAll";
	}
	
	@ResponseBody
	@RequestMapping(value = "/duplicate/tabletNo/confirm", method = RequestMethod.POST)
	public List<Device> duplicateContactConfirm(@RequestParam("tabletNo") String tabletNo) {
		return mapper.getFindByTabletNo(tabletNo);
	}
		
	@ResponseBody
	@RequestMapping(value = "/doDelete", method = RequestMethod.POST)
	public boolean doDelete(@RequestParam("id") int id) {
		return mapper.doDelete(id) > 0;
	}
	
	
	@ResponseBody
	@RequestMapping(value = "/update/conduct", method = RequestMethod.POST)
	public boolean updateConduct(@RequestParam("id") int id, @RequestParam("conduct") int conduct) {
		return mapper.updateConduct(id, conduct) > 0;
	}
	
	
	@ResponseBody
	@RequestMapping(value = "/registAjax", method = RequestMethod.POST)
	public int registAjax(@RequestBody Device device) {
		return mapper.insert(device);
	}

	@ResponseBody
	@RequestMapping(value = "/updateOfAjax", method = RequestMethod.POST)
	public int updateOfAjax(@RequestBody Device device) {
		return mapper.update(device);
	}
	
	@ResponseBody
	@RequestMapping(value = "/get/info", method = RequestMethod.POST)
	public Device getInfo(@RequestParam("id") int id) {
		return mapper.getInfoOfAjax(id);
	}
	
	
	@ResponseBody
	@RequestMapping(value = "/get/list", method = RequestMethod.POST)
	public List<Device> getDeviceList(@RequestParam("constructionIdx") int constructionIdx) {
		return mapper.getDeviceList(constructionIdx);
	}
	
	//@ModelAttribute
	//public void setTotalWorkQuantity(Model model) {
	//	totalWorkQuantityMapper.get(id);
	//    //model.addAttribute("sessionInfo", sessionInfo);
	//}
}
