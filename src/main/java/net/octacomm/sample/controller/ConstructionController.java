package net.octacomm.sample.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.mail.Session;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

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
import net.octacomm.sample.dao.mapper.DeviceMapper;
import net.octacomm.sample.domain.Construction;
import net.octacomm.sample.domain.ConstructionForAjax;
import net.octacomm.sample.domain.ConstructionParam;
import net.octacomm.sample.domain.Device;
import net.octacomm.sample.domain.SessionInfo;

@RequestMapping("/construction")
@Controller
public class ConstructionController extends AbstractConstructionCRUDController<ConstructionMapper, Construction, ConstructionParam, Integer>{
	
	@Autowired
	private DeviceMapper deviceMapper;
	
	@Autowired
	public void setCRUDMapper(ConstructionMapper mapper) {
		this.mapper = mapper;
	}

	@Override
	protected Class<Construction> getDomainClass() {
		return Construction.class;
	}

	@Override
	protected String getRedirectUrl(HttpServletRequest request, HttpSession session) {
		return "redirect:/construction/list";
	}
	
	@ModelAttribute
	public void setActiveMenu(Model model) {
	    model.addAttribute("menuIndex", 0);
	}
	
	
	@ResponseBody
	@RequestMapping(value = "/duplicate/contact/confirm", method = RequestMethod.POST)
	public List<Construction> duplicateContactConfirm(@RequestParam("userId") String userId) {
		return mapper.getFindByContact(userId);
	}
	
	@ResponseBody
	@RequestMapping(value = "/doDelete", method = RequestMethod.POST)
	public boolean doDelete(@RequestParam("id") int id) {
		List<Device> list = deviceMapper.getFindByConstructionIdx(id);
		for (Device device : list) {
			deviceMapper.doDelete(device.getId());
		}
		return mapper.doDelete(id) > 0;
	}
	
	@ResponseBody
	@RequestMapping(value = "/registAjax", method = RequestMethod.POST)
	public int registAjax(@RequestBody Construction construction) {
		return mapper.insert(construction);
	}
	
	@ResponseBody
	@RequestMapping(value = "/updateForAjax", method = RequestMethod.POST)
	public int updateForAjax(@RequestBody Construction construction) {
		System.err.println("construction : " + construction);
		return mapper.update(construction);
	}
	
	@ResponseBody
	@RequestMapping(value = "/get/infoOfAjax", method = RequestMethod.POST)
	public Construction infoOfAjax(@RequestParam("id") int id) {
		return mapper.get(id);
	}
	
	@ResponseBody
	@RequestMapping(value = "/update/conduct", method = RequestMethod.POST)
	public boolean updateConduct(@RequestParam("id") int id, @RequestParam("conduct") int conduct) {
		return mapper.updateConduct(id, conduct) > 0;
	}

	@ResponseBody
	@RequestMapping(value = "/update/blocked", method = RequestMethod.POST)
	public boolean updateBlockedYn(@RequestParam("id") int id, @RequestParam("blockedYn") int blockedYn,
			HttpSession session) {
		int role = (Integer) session.getAttribute("role");
		if (role != 0) return false;
		return mapper.updateBlockedYn(id, blockedYn) > 0;
	}

	@ResponseBody
	@RequestMapping(value = "/update/contractTarget", method = RequestMethod.POST)
	public boolean updateContractTargetYn(@RequestParam("id") int id, @RequestParam("targetYn") int targetYn,
			HttpSession session) {
		int role = (Integer) session.getAttribute("role");
		if (role != 0) return false;
		return mapper.updateContractTargetYn(id, targetYn) > 0;
	}
	
	@ResponseBody
	@RequestMapping(value = "/get/list", method = RequestMethod.GET)
	public List<Construction> getList(HttpSession session) {
		int role = (Integer) session.getAttribute("role");
		int constructionIdx = (Integer) session.getAttribute("constructionIdx");
		if(role > 0) {
			return mapper.getListByConstructionIdx(constructionIdx);
		}
		return mapper.getList();
	}
	
//	@ResponseBody
//	@RequestMapping(value = "/get/name",  produces = "application/text; charset=utf8", method = RequestMethod.POST)
//	public String getName(@RequestParam("id") int id, @RequestParam("role") int role) {
//		System.err.println("role : " + role);
//		Construction domain = mapper.getFullName(id, role);
//		return domain.getName();
//	}
	
	
	@ResponseBody
	@RequestMapping(value = "/get/name",  method = RequestMethod.POST)
	public Map<String, String> getName(@RequestParam("id") int id, @RequestParam("role") int role) {
		//System.err.println("role : " + role);
		Map<String, Object> domain = mapper.getFullName(id, role);
		Map<String, String> result = new HashMap<>();
		
		System.err.println((String) domain.get("groupName"));
		System.err.println((String) domain.get("constructionName"));
		System.err.println((String) domain.get("constructionLocation"));
		System.err.println((String) domain.get("constructionAddress"));
		
	    result.put("groupName",(String) domain.get("groupName"));
		result.put("constructionName", (String) domain.get("constructionName")); // 예시
		result.put("constructionLocation",(String) domain.get("constructionLocation")); // 예시
		result.put("constructionAddress", (String) domain.get("constructionAddress"));       // 예시
	    return result;    
	}
}
