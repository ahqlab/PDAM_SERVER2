package net.octacomm.sample.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import net.octacomm.sample.dao.mapper.MemoMapper;
import net.octacomm.sample.domain.Device;
import net.octacomm.sample.domain.Memo;


@RequestMapping("/memo")
@Controller
public class MemoController {
	
	@Autowired
	private MemoMapper memoMapper;
	
	@ResponseBody
	@RequestMapping(value = "/list", method = RequestMethod.GET)
	private List<Memo> getFindByConstructionIdxAndOrderBy(@RequestParam("constructionIdx") int constructionIdx){
		return memoMapper.findByConstructionIdx(constructionIdx);
	}
	
	@ResponseBody
	@RequestMapping(value = "/registAjax", method = RequestMethod.POST)
	public int registAjax(@RequestBody Memo memo) {
		return memoMapper.insert(memo);
	}
	
	
	@ResponseBody
	@RequestMapping(value = "/updateAjax", method = RequestMethod.POST)
	public int updateAjax(@RequestBody Memo memo) {
		return memoMapper.update(memo);
	}
	
	
	@ResponseBody
	@RequestMapping(value = "/deleteAjax", method = RequestMethod.POST)
	public boolean doDelete(@RequestParam("id") int id) {
		return memoMapper.delete(id) > 0;
	}
}
