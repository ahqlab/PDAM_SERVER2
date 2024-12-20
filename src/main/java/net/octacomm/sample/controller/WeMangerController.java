package net.octacomm.sample.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import net.octacomm.sample.dao.mapper.WeManagerMapper;
import net.octacomm.sample.domain.WeManager;

@RequestMapping("/wemanager")
@Controller
public class WeMangerController {
	
	@Autowired
	private WeManagerMapper mapper;
	
	@ResponseBody
	@RequestMapping(value = "/get/list", method = RequestMethod.GET)
	public List<WeManager> getList(HttpSession session) {
		return mapper.getList();
	}

}
