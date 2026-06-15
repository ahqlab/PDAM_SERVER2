package net.octacomm.sample.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import net.octacomm.sample.dao.mapper.SurveyResultMapper;
import net.octacomm.sample.domain.ReportOneLine;
import net.octacomm.sample.domain.SessionInfo;
import net.octacomm.sample.domain.SurveyResult;

@Controller
@RequestMapping("/survey")
public class SurveyController {
	
	@Autowired
	private SurveyResultMapper surveyResultMapper;
	
	@RequestMapping(value = "/result")
	public void result(Model model) {
		
	}
	
	@ResponseBody
	@RequestMapping(value = "/result/total", method = RequestMethod.POST)
	public List<SurveyResult> getTodayList(){
		return surveyResultMapper.selectResult();
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
