package net.octacomm.sample.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import net.octacomm.sample.dao.mapper.ReportMapper;
import net.octacomm.sample.dao.mapper.TotalWorkQuantityMapper;
import net.octacomm.sample.domain.TotalWorkQuantity;


@RequestMapping("/quantity")
@Controller
public class TotalWorkQuantityController {
	
	@Autowired
	private ReportMapper reportMapper;
	
	@Autowired
	private TotalWorkQuantityMapper totalWorkQuantityMapper;
	
	@ResponseBody
	@RequestMapping(value = "/get", method = RequestMethod.POST)
	public TotalWorkQuantity get(TotalWorkQuantity totalWorkQuantity) {
		return totalWorkQuantityMapper.get(totalWorkQuantity.getQuantity());
	}
	
	@ResponseBody
	@RequestMapping(value = "/set", method = RequestMethod.POST)
	public int set(TotalWorkQuantity totalWorkQuantity) {
		try{
			int quantityLeft = reportMapper.getCountByConstruction(totalWorkQuantity.getConstructionIdx());
			double x2 = quantityLeft;
			double y2 = totalWorkQuantity.getQuantity();
			int processRate = (int) (x2 / y2 * 100.0);
			totalWorkQuantity.setProcessRate(processRate);
			totalWorkQuantity.setQuantityLeft( (int) (y2 - x2));
			if(totalWorkQuantityMapper.get(totalWorkQuantity.getConstructionIdx()) != null) {			
				return totalWorkQuantityMapper.update(totalWorkQuantity);
			}else {
				return totalWorkQuantityMapper.insert(totalWorkQuantity);
			}
		}catch(Exception e) {
			return 0;
		}
	}
}
