package net.octacomm.sample.controller;

import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
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

import net.octacomm.sample.dao.mapper.GroupMapper;
import net.octacomm.sample.dao.mapper.DailyOperationSummaryMapper;
import net.octacomm.sample.domain.Construction;
import net.octacomm.sample.domain.Group;
import net.octacomm.sample.domain.GroupParam;
import net.octacomm.sample.domain.SessionInfo;

@RequestMapping("/group")
@Controller
public class GroupController extends AbstractGroupCRUDController<GroupMapper, Group, GroupParam, Integer>{
	@Autowired
	private DailyOperationSummaryMapper dailyOperationSummaryMapper;
	
	@Autowired
	public void setCRUDMapper(GroupMapper mapper) {
		this.mapper = mapper;
	}

	@Override
	protected Class<Group> getDomainClass() {
		return Group.class;
	}
	
	@ResponseBody
	@RequestMapping(value = "/get/list", method = RequestMethod.GET)
	public List<Group> getList(HttpSession session) {
		return mapper.getList();
	}

	// 클라이언트 사이드 페이징용: 집계 필드 포함 전체 시공사 목록을 JSON으로 반환
	@ResponseBody
	@RequestMapping(value = "/ajax/list", method = RequestMethod.GET)
	public List<Group> ajaxList(HttpSession session) {
		GroupParam param = new GroupParam();
		param.setRole((int) session.getAttribute("role"));
		return mapper.getListByParam(0, Integer.MAX_VALUE, param);
	}

	@ResponseBody
	@RequestMapping(value = "/ajax/operation-trend", method = RequestMethod.GET)
	public List<Map<String, Object>> getOperationTrend(
				@RequestParam(value = "period", defaultValue = "day") String period) {
		if ("month".equals(period)) {
			return dailyOperationSummaryMapper.getMonthlyOperationTrend();
		}
		if ("year".equals(period)) {
			return dailyOperationSummaryMapper.getYearlyOperationTrend();
		}
		return dailyOperationSummaryMapper.getDailyOperationTrend();
	}
	
	@Override
	protected String getRedirectUrl(HttpServletRequest request, HttpSession session) {
		return "redirect:/group/list";
	}  
	
	@ModelAttribute
	public void setTotalUseCount(Model model, HttpSession session) {
		int headquartersDeviceCount = mapper.getTotalUseDeviceCount();
		int franchiseDeviceCount = mapper.getPrenchTotalUseDeviceCount();
		int constructionCount = mapper.getTotalUseConstructionCount();
		int spareDeviceCount = mapper.getTotalSpareDeviceCount();
		int currentOperationDeviceCount =  headquartersDeviceCount + franchiseDeviceCount;
		Integer maximumOperationDeviceCount = dailyOperationSummaryMapper.getMaximumOperationDeviceCount();
		Integer minimumOperationDeviceCount = dailyOperationSummaryMapper.getMinimumOperationDeviceCount();
		Integer yesterdayOperationDeviceCount = dailyOperationSummaryMapper.getYesterdayOperationDeviceCount();

		model.addAttribute("deviceCount", headquartersDeviceCount > 0 ? "총 " + headquartersDeviceCount + "대" : "총 0 대");
		model.addAttribute("devicePrenchCount", franchiseDeviceCount > 0 ? "총 " + franchiseDeviceCount + "대" : "총 0 대");
		model.addAttribute("constructionCount", constructionCount > 0 ? "총 " + constructionCount + "개" : "총 0 개");
		model.addAttribute("spareDeviceCount", spareDeviceCount > 0 ? "총 " + spareDeviceCount + "대" : "총 0 대");
		model.addAttribute("currentOperationDeviceCount", currentOperationDeviceCount + "대");
		model.addAttribute("maximumOperationDeviceCount", maximumOperationDeviceCount == null ? "-" : maximumOperationDeviceCount + "대");
		model.addAttribute("minimumOperationDeviceCount", minimumOperationDeviceCount == null ? "-" : minimumOperationDeviceCount + "대");

		if (yesterdayOperationDeviceCount == null) {
			model.addAttribute("operationDeviceChange", "-");
			model.addAttribute("operationDeviceChangeRate", "-");
			model.addAttribute("operationDeviceChangeClass", "neutral");
			return;
		}

		int operationDeviceChange = currentOperationDeviceCount - yesterdayOperationDeviceCount;
		String changeSign = operationDeviceChange > 0 ? "+" : operationDeviceChange < 0 ? "-" : "";
		String changeClass = operationDeviceChange > 0 ? "positive" : operationDeviceChange < 0 ? "negative" : "neutral";
		model.addAttribute("operationDeviceChange", changeSign + Math.abs(operationDeviceChange) + "대");
		model.addAttribute("operationDeviceChangeClass", changeClass);

		if (yesterdayOperationDeviceCount == 0) {
			model.addAttribute("operationDeviceChangeRate", "-");
		} else {
			double changeRate = (operationDeviceChange * 100.0) / yesterdayOperationDeviceCount;
			model.addAttribute("operationDeviceChangeRate", changeSign + String.format(Locale.KOREA, "%.2f", Math.abs(changeRate)) + "%");
		}
	}
	
	/*
	 * @ResponseBody
	 * 
	 * @RequestMapping(value = "/test", method = RequestMethod.GET) public int
	 * test(HttpSession session) { return mapper.updateGroupName(); }
	 */
	
	
	@ResponseBody
	@RequestMapping(value = "/registAjax", method = RequestMethod.POST)
	public int registAjax(@RequestBody Group group, BindingResult result) {
		return mapper.insert(group);
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
	
	
	@ResponseBody
	@RequestMapping(value = "/duplicate/check", method = RequestMethod.POST)
	public int groupDuplicateCheck(@RequestParam("groupName") String groupName){
		return mapper.getCountByGroupName(groupName);
	}
	
	@ResponseBody
	@RequestMapping(value = "/get/name",  produces = "application/text; charset=utf8", method = RequestMethod.POST)
	public String getName(@RequestParam("groupIdx") int groupIdx) {
		Group domain = mapper.get(groupIdx);
		return domain.getGroupName();
	}
	
	@ResponseBody
	@RequestMapping(value = "/updateAjax", method = RequestMethod.POST)
	public int updateAjax(@RequestBody Group group, HttpSession session) {
		Integer role = (Integer) session.getAttribute("role");
		if (role == null || role != 0) {
			return 0; 
		}
		if (group.getGroupName() == null || group.getGroupName().trim().isEmpty() || group.getIdx() <= 0) {
			return 0;
		}
		return mapper.updateGroupName(group);
	}
}
