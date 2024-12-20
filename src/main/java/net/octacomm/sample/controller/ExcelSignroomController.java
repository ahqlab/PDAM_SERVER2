package net.octacomm.sample.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import net.octacomm.sample.dao.mapper.ExcelSignroomMapper;
import net.octacomm.sample.domain.ExcelSignroom;

@RequestMapping("/excel/signroom")
@Controller
public class ExcelSignroomController {
	
	@Autowired
	private ExcelSignroomMapper excelSignroomMapper;
	
	@ResponseBody
	@RequestMapping(value = "/get/list", method = RequestMethod.POST)
	private List<ExcelSignroom> findByConstructionIdx(@RequestParam("constructionIdx") int constructionIdx){
		System.err.println("constructionIdx : " + constructionIdx);
		return excelSignroomMapper.getFindByConstructionIdx(constructionIdx);
	}
	
	@ResponseBody
	@RequestMapping(value = "/get/order/list", method = RequestMethod.POST)
	private List<ExcelSignroom> getFindByConstructionIdxAndOrderBy(@RequestParam("constructionIdx") int constructionIdx){
		return excelSignroomMapper.getFindByConstructionIdxAndOrderBy(constructionIdx);
	}
	
	@ResponseBody
	@RequestMapping(value = "/update/all", method = RequestMethod.POST)
	private boolean updateMulti(@RequestBody List<ExcelSignroom> signrooms){
		int result = 0;
		for (int i = 0; i < signrooms.size(); i++) {
			if(signrooms.get(i).getId() <= 0) {
				result = excelSignroomMapper.insert(signrooms.get(i));
			}else {
				result = excelSignroomMapper.update(signrooms.get(i));
			}
		}
		return signrooms.size() != result;
	}
	
	@ResponseBody
	@RequestMapping(value = "/regist/all", method = RequestMethod.POST)
	private boolean insertMulti(@RequestBody List<ExcelSignroom> signrooms){
		return excelSignroomMapper.registAll(signrooms) > 1;
	}
	
}
