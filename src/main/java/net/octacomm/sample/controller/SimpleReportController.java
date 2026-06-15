package net.octacomm.sample.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

import net.octacomm.sample.dao.mapper.ReportMapper;
import net.octacomm.sample.dao.mapper.SimpleReportMapper;
import net.octacomm.sample.domain.Report;
import net.octacomm.sample.domain.ReportParam;


@RequestMapping("/simple/report")
@Controller
public class SimpleReportController extends AbstractSimpleReportCRUDController<SimpleReportMapper, Report, ReportParam, Integer>{

	@Autowired
	public void setCRUDMapper(SimpleReportMapper mapper) {
		this.mapper = mapper;
	}

	@Override
	protected Class<Report> getDomainClass() {
		return Report.class;
	}

	@Override
	protected String getRedirectUrl(HttpServletRequest request, HttpSession session) {
		return "redirect:/simple/report/list";
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
}
