package net.octacomm.sample.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;

import net.octacomm.sample.dao.mapper.CompanyMapper;
import net.octacomm.sample.domain.Company;
import net.octacomm.sample.domain.SessionInfo;

@Controller
@RequestMapping("/company")
public class CompanyController {

	@Autowired
	private CompanyMapper companyMapper;

	@RequestMapping(value = "/list", method = RequestMethod.GET)
	public String list(Model model, HttpSession session) {
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
		return "company/list";
	}

	@ResponseBody
	@RequestMapping(value = "/ajax/list", method = RequestMethod.GET)
	public List<Company> ajaxList() {
		return companyMapper.getList();
	}

	@ResponseBody
	@RequestMapping(value = "/ajax/detail", method = RequestMethod.GET)
	public Company ajaxDetail(@RequestParam("id") int id) {
		return companyMapper.getById(id);
	}

	@ResponseBody
	@RequestMapping(value = "/ajax/getByName", method = RequestMethod.GET)
	public Company getByName(@RequestParam("name") String name) {
		return companyMapper.getByName(name);
	}

	@ResponseBody
	@RequestMapping(value = "/ajax/regist", method = RequestMethod.POST)
	public Map<String, Object> ajaxRegist(@ModelAttribute Company company) {
		Map<String, Object> result = new HashMap<>();
		try {
			companyMapper.insert(company);
			result.put("success", true);
		} catch (Exception e) {
			result.put("success", false);
			result.put("message", e.getMessage());
		}
		return result;
	}

	@ResponseBody
	@RequestMapping(value = "/ajax/update", method = RequestMethod.POST)
	public Map<String, Object> ajaxUpdate(@ModelAttribute Company company) {
		Map<String, Object> result = new HashMap<>();
		try {
			companyMapper.update(company);
			result.put("success", true);
		} catch (Exception e) {
			result.put("success", false);
			result.put("message", e.getMessage());
		}
		return result;
	}

	@ResponseBody
	@RequestMapping(value = "/ajax/delete", method = RequestMethod.POST)
	public Map<String, Object> ajaxDelete(@RequestParam("id") int id) {
		Map<String, Object> result = new HashMap<>();
		try {
			companyMapper.delete(id);
			result.put("success", true);
		} catch (Exception e) {
			result.put("success", false);
			result.put("message", e.getMessage());
		}
		return result;
	}
}
