package net.octacomm.sample.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import net.octacomm.sample.dao.mapper.CommonErpMapper;
import net.octacomm.sample.domain.CommonErp;
import net.octacomm.sample.domain.CommonErpParam;

//Equipment usage status --장비 사용 현황
//Oil use status --오일 사용 현황
//Material input status --재료 투입 현황 

@RequestMapping({"/oiluse", "/eus", "/mis"})
@Controller
public class CommonErpController extends AbstractCommonErpController<CommonErpMapper, CommonErp, CommonErpParam, Integer>{
	
	@Autowired
	@Qualifier("commonErpMapper")
	public void setCRUDMapper(CommonErpMapper mapper) {
		this.mapper = mapper;
	}
	
	@Override
	protected Class<CommonErp> getDomainClass() {
		return CommonErp.class;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	@Override
	protected String getRedirectUrl(HttpServletRequest request, HttpSession session, CommonErp domain) {
		switch (domain.getErpDiv()){
		case 1:
			return "redirect:/eus/list?deviceIdx=" + domain.getDeviceIdx() + "&constructionIdx=" + domain.getConstructionIdx() + "&erpDiv=" + domain.getErpDiv();
		case 2:
			return "redirect:/oiluse/list?deviceIdx=" + domain.getDeviceIdx() + "&constructionIdx=" + domain.getConstructionIdx() + "&erpDiv=" + domain.getErpDiv();
		case 3:	
			return "redirect:/mis/list?deviceIdx=" + domain.getDeviceIdx() + "&constructionIdx=" + domain.getConstructionIdx() + "&erpDiv=" + domain.getErpDiv();
		default:
			return null;
		}
	}
}
