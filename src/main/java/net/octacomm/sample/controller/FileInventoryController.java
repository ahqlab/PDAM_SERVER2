	package net.octacomm.sample.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import net.octacomm.sample.dao.mapper.FileInventoryMapper;
import net.octacomm.sample.domain.FileInventory;
import net.octacomm.sample.domain.FileInventoryParam;

@RequestMapping("/fileinventory")
@Controller
public class FileInventoryController
		extends AbstractFileInventoryCRUDController<FileInventoryMapper, FileInventory, FileInventoryParam, Integer> {
//	
//	
//	@RequestMapping(value = "/regist")
//	public void regist(Model model , @RequestParam("constructionIdx") int constructionIdx) {
//		model.addAttribute("constructionIdx", constructionIdx);
//	}
//	
//	
//	@ResponseBody
//	@RequestMapping(value = "/regist", method = RequestMethod.POST)
//	public boolean registFileinventory(@RequestBody FileInventory fileInventory) {
//		System.err.println("fileInventory : " + fileInventory);
//		return mapper.insert(fileInventory) != 0 ? true : false;
//	}
//	
//	@ResponseBody
//	@RequestMapping(value = "/update", method = RequestMethod.POST)
//	public boolean updateFileinventory(@RequestBody FileInventory fileInventory) {
//		System.err.println("fileInventory : " + fileInventory);
//		return mapper.update(fileInventory) != 0 ? true : false;
//	}

	@Autowired
	@Override
	public void setCRUDMapper(FileInventoryMapper mapper) {
		this.mapper = mapper;
	}

	@Override
	protected Class<FileInventory> getDomainClass() {
		return FileInventory.class;
	}

	@RequestMapping(value = "/regist2", method = RequestMethod.GET)
	public void regist2(Model model, @ModelAttribute("domainParam") FileInventoryParam param)
			throws InstantiationException, IllegalAccessException {
		model.addAttribute("domain", new FileInventory());
		model.addAttribute("param", param);
	}
	
	@RequestMapping(value = { URL_UPDATE + "2", URL_DETAIL }, method = RequestMethod.GET)
	public String form(Model model, @RequestParam("id") int id) {
		FileInventory obj = mapper.get(id);
		model.addAttribute("domain", obj);
		if(obj.getPileType().equals("PHC") || obj.getPileType().equals("UHC") || obj.getPileType().equals("UPHC")) {
			return "fileinventory/updatePhc";
		}else {
			return "fileinventory/updateSteel";
		}
		
	}

	@Override
	protected String getRedirectUrl(HttpServletRequest request, HttpSession session, FileInventory domain) {	
		return "redirect:/fileinventory/list?constructionIdx=" + domain.getConstructionIdx();
	}
	
	@ResponseBody
	@RequestMapping(value = "/get")
	public FileInventory list(FileInventory inventory) {
		FileInventory result = mapper.getDate(inventory);
		return result;
	}
	
	
	@ResponseBody
	@RequestMapping(value = "/get/info")
	public FileInventory list(@RequestParam("fiIdx") int fiIdx) {
		FileInventory result = mapper.get(fiIdx);
		return result;
	}
		
	@ResponseBody
	@RequestMapping(value = "/get/pile/type/list")
	public List<FileInventory> getPileTypeList(FileInventory inventory) {
		List<FileInventory> result = mapper.getPileTypeList(inventory);
		return result;
	}
	
	@ResponseBody
	@RequestMapping(value = "/check/duplicate")
	public boolean checkDuplicate(@RequestParam("registDate") String registDate ,  @RequestParam("pileType") String pileType,  @RequestParam("pileStandard") String pileStandard, @RequestParam("constructionIdx") int constructionIdx, @RequestParam("fileWeight") String fileWeight, @RequestParam("maker") String maker) {
		FileInventory inventory;
		if(fileWeight != "") {
			inventory = mapper.getFileInventory1(registDate, maker, pileType, pileStandard, constructionIdx, fileWeight);
		} else {
			inventory = mapper.getFileInventory2(registDate, maker, pileType, pileStandard, constructionIdx);
		}
		return inventory != null ? false : true;
	}
}
