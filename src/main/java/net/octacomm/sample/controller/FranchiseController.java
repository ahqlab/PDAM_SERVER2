package net.octacomm.sample.controller;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.List;

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

import net.octacomm.sample.dao.mapper.FranchiseMapper;
import net.octacomm.sample.domain.Construction;
import net.octacomm.sample.domain.Franchise;
import net.octacomm.sample.domain.FranchiseParam;
import net.octacomm.sample.domain.Group;
import net.octacomm.sample.domain.GroupParam;

@RequestMapping("/franchise")
@Controller
public class FranchiseController extends AbstractCRUDController<FranchiseMapper, Franchise, FranchiseParam, Integer>{
	
	@Autowired
	@Override
	public void setCRUDMapper(FranchiseMapper mapper) {
		this.mapper = mapper;
	}

	@Override
	protected Class<Franchise> getDomainClass() {
		return Franchise.class;
	}
	
	@ResponseBody
	@RequestMapping(value = "/get/list", method = RequestMethod.GET)
	public List<Franchise> getList(HttpSession session) {
		return mapper.getList();
	}
	
	@Override
	protected String getRedirectUrl(HttpServletRequest request, HttpSession session) {
		return "redirect:/franchise/list";
	}  
	
	
	@ResponseBody
	@RequestMapping(value = "/registAjax", method = RequestMethod.POST)
	public int registAjax(@RequestBody Franchise franchise) {
		return mapper.insert(franchise);
	}
	
	@ResponseBody
	@RequestMapping(value = "/get/name",  produces = "application/text; charset=utf8", method = RequestMethod.POST)
	public String getName(@RequestParam("fcIdx") int fcIdx) throws UnsupportedEncodingException {
		Franchise franchise = mapper.get(fcIdx);
		System.err.println("franchise.getFcName() : " + franchise.getFcName());
		return franchise.getFcName();
	}
	
	

}
