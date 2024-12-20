package net.octacomm.sample.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

import net.octacomm.sample.dao.mapper.ConstructionMapper;
import net.octacomm.sample.domain.Construction;
import net.octacomm.sample.domain.ConstructionParam;


@RequestMapping({"/vimmng"})
@Controller
public class VimMngController extends AbstractVImMngCRUDController<ConstructionMapper, Construction, ConstructionParam, Integer>{

	@Autowired
	@Override
	public void setCRUDMapper(ConstructionMapper mapper) {
		this.mapper = mapper;
	}
    
	@Override
	protected Class<Construction> getDomainClass() {
		return Construction.class;
	}

	@Override
	protected String getRedirectUrl(HttpServletRequest request, HttpSession session) {
		return "redirect:/vimmng/list";
	}
	
	@ModelAttribute
	public void setActiveMenu(Model model) {
	    model.addAttribute("menuIndex", 0);
	}

}
