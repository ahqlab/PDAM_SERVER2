package net.octacomm.sample.controller;

import java.util.List;

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
import net.octacomm.sample.domain.Construction;
import net.octacomm.sample.domain.Group;
import net.octacomm.sample.domain.GroupParam;
import net.octacomm.sample.domain.SessionInfo;

@RequestMapping("/group")
@Controller
public class GroupController extends AbstractGroupCRUDController<GroupMapper, Group, GroupParam, Integer>{
	
	@Autowired
	@Override
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
	
	@Override
	protected String getRedirectUrl(HttpServletRequest request, HttpSession session) {
		return "redirect:/group/list";
	}  
	
	@ModelAttribute
	public void setTotalUseCount(Model model, HttpSession session) {
	    model.addAttribute("deviceCount", mapper.getTotalUseDeviceCount() > 0 ? "총 " + mapper.getTotalUseDeviceCount() + "대" : "총 0 대");
	    model.addAttribute("devicePrenchCount", mapper.getPrenchTotalUseDeviceCount() > 0 ? "총 " + mapper.getPrenchTotalUseDeviceCount() + "대" : "총 0 대");
	    model.addAttribute("constructionCount",  mapper.getTotalUseConstructionCount() > 0 ? "" + "총 " + mapper.getTotalUseConstructionCount() + "개" : "총 0 개");
	    model.addAttribute("spareDeviceCount",  mapper.getTotalSpareDeviceCount() > 0 ? "" + "총 " + mapper.getTotalSpareDeviceCount() + "대" : "총 0 대");
	}
	
	@ResponseBody
	@RequestMapping(value = "/test", method = RequestMethod.GET)
	public int test(HttpSession session) {
		return mapper.updateGroupName();
	}
	
	
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
	
}
