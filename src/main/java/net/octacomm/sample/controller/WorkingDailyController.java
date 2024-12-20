package net.octacomm.sample.controller;


import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import net.octacomm.sample.domain.SessionInfo;



@RequestMapping("/workingdaily")
@Controller
public class WorkingDailyController {

	
	@RequestMapping(value = "/list", method = RequestMethod.GET)
	public void list(HttpSession session) {
		
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
