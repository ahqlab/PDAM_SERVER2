package net.octacomm.sample.controller;

import java.util.List;

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

import net.octacomm.sample.dao.mapper.CustomerMapper;
import net.octacomm.sample.domain.Customer;
import net.octacomm.sample.domain.Device;
import net.octacomm.sample.domain.SessionInfo;

@RequestMapping("/customer")
@Controller
public class CustomerController {
	
	@Autowired
	private CustomerMapper customerMapper;
	
	@ResponseBody
	@RequestMapping(value = "/get/list", method = RequestMethod.GET)
	public List<Customer> getList() {
		return customerMapper.getLsit();
	}
	
	@RequestMapping(value = "/list")
	public void list() {
		
	}
	
	@ResponseBody
	@RequestMapping(value = "/regist", method = RequestMethod.POST)
	public int regist(@RequestBody Customer customer) {
		return customerMapper.insert(customer);
	}
	
	@ResponseBody
	@RequestMapping(value = "/update", method = RequestMethod.POST)
	public int update(@RequestBody Customer customer) {
		return customerMapper.update(customer);
	}
	
	
	@ResponseBody
	@RequestMapping(value = "/delete", method = RequestMethod.GET)
	public int delete(@RequestParam("id") int id) {
		return customerMapper.delete(id);
	}
	
	
	@ModelAttribute
	public void setSessionInfo(Model model, HttpSession session) {
		SessionInfo sessionInfo = new SessionInfo();
		sessionInfo.setUserId((String) session.getAttribute("userId"));
		sessionInfo.setRole((Integer) session.getAttribute("role"));
		sessionInfo.setConstructionIdx((Integer) session.getAttribute("constructionIdx"));
		sessionInfo.setHiddenManager((Boolean) session.getAttribute("isHiddenManager"));
		sessionInfo.setGroupIdx((Integer) session.getAttribute("groupIdx"));	
		sessionInfo.setFcIdx((Integer) session.getAttribute("fcIdx"));	
		sessionInfo.setShowPdfYn((Boolean) session.getAttribute("showPdfYn"));	
	    model.addAttribute("sessionInfo", sessionInfo);
	}
}
