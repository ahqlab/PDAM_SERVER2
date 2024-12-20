package net.octacomm.sample.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import net.octacomm.sample.dao.mapper.PdfSignroomMapper;
import net.octacomm.sample.domain.PdfSignroom;

@RequestMapping("/signroom")
@Controller
public class PdfSignroomController {
	
	@Autowired
	private PdfSignroomMapper pdfSignroomMapper;
	
	@ResponseBody
	@RequestMapping(value = "/get/list", method = RequestMethod.POST)
	private List<PdfSignroom> findByConstructionIdx(@RequestParam("constructionIdx") int constructionIdx){
		System.err.println("constructionIdx : " + constructionIdx);
		return pdfSignroomMapper.getFindByConstructionIdx(constructionIdx);
	}
	
	@ResponseBody
	@RequestMapping(value = "/get/order/list", method = RequestMethod.POST)
	private List<PdfSignroom> getFindByConstructionIdxAndOrderBy(@RequestParam("constructionIdx") int constructionIdx){
		return pdfSignroomMapper.getFindByConstructionIdxAndOrderBy(constructionIdx);
	}
	
	@ResponseBody
	@RequestMapping(value = "/update/all", method = RequestMethod.POST)
	private boolean updateMulti(@RequestBody List<PdfSignroom> signrooms){
		int result = 0;
		for (int i = 0; i < signrooms.size(); i++) {
			if(signrooms.get(i).getId() <= 0) {
				result = pdfSignroomMapper.insert(signrooms.get(i));
			}else {
				result = pdfSignroomMapper.update(signrooms.get(i));
			}
		}
		return signrooms.size() != result;
	}
	
	@ResponseBody
	@RequestMapping(value = "/regist/all", method = RequestMethod.POST)
	private boolean insertMulti(@RequestBody List<PdfSignroom> signrooms){
		return pdfSignroomMapper.registAll(signrooms) > 1;
	}
	
}
