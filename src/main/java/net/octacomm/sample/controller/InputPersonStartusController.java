package net.octacomm.sample.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import net.octacomm.sample.dao.mapper.InputPersonStatusMapper;
import net.octacomm.sample.domain.InputPersonStatus;
import net.octacomm.sample.domain.InputPersonStatusParam;

@RequestMapping("/ips")
@Controller
public class InputPersonStartusController extends AbstractIpsCRUDController<InputPersonStatusMapper, InputPersonStatus, InputPersonStatusParam, Integer>{

	@Autowired
	@Override
	public void setCRUDMapper(InputPersonStatusMapper mapper) {
		this.mapper = mapper;
	}

	@Override
	protected Class<InputPersonStatus> getDomainClass() {
		return InputPersonStatus.class;
	}

	@Override
	protected String getRedirectUrl(HttpServletRequest request, HttpSession session, InputPersonStatus domain) {
		return "redirect:/ips/list?deviceIdx=" + domain.getDeviceIdx() + "&constructionIdx=" + domain.getConstructionIdx();
	}  

}
