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
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import net.octacomm.sample.dao.mapper.FileBrokenInventoryMapper;
import net.octacomm.sample.dao.mapper.FileInventoryMapper;
import net.octacomm.sample.domain.FileInventory;
import net.octacomm.sample.domain.FileInventoryParam;

@RequestMapping("/fileinventory")
@Controller
public class FileInventoryController
		extends AbstractFileInventoryCRUDController<FileInventoryMapper, FileInventory, FileInventoryParam, Integer> {

	@Autowired
	private FileBrokenInventoryMapper fileBrokenInventoryMapper;
	
	@Autowired
	public void setCRUDMapper(FileInventoryMapper mapper) {
		this.mapper = mapper;
	}

	@Override
	protected Class<FileInventory> getDomainClass() {
		return FileInventory.class;
	}

	@RequestMapping(value = "/regist2", method = RequestMethod.POST)
	public String regist2(@ModelAttribute("domain") FileInventory domain, SessionStatus sessionStatus, HttpServletRequest request, HttpSession session) {
		
		if (mapper.insert(domain) == 1) {
			sessionStatus.setComplete();
			return getRedirectUrl(request, session, domain);
		} else {
			return URL_REGIST;
		}
	}
	
	@RequestMapping(value = "/broken/regist", method = RequestMethod.POST)
	public String regist(@ModelAttribute("domain") FileInventory domain, SessionStatus sessionStatus, HttpServletRequest request, HttpSession session) {
	
		if (fileBrokenInventoryMapper.insert(domain) == 1) {
			sessionStatus.setComplete();
			return getRedirectUrl(request, session, domain);
		} else {
			return URL_REGIST;
		}
	}
	
	@RequestMapping(value = "/broken/update", method = RequestMethod.POST)
	public String brokenUpdate(@ModelAttribute("domain") FileInventory domain, RedirectAttributes redirectAttributes, HttpServletRequest request, HttpSession session) {
		
		FileInventory obj = fileBrokenInventoryMapper.get(domain.getFiIdx());
		
		if(obj != null) {
			if (fileBrokenInventoryMapper.update(domain) == 1) {
				return getRedirectUrl(request, session, domain);
			} else {
				return URL_UPDATE;
			}
		}else {
			if (fileBrokenInventoryMapper.insert(domain) == 1) {
				return getRedirectUrl(request, session, domain);
			} else {
				return URL_REGIST;
			}
		}
		
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
	@RequestMapping(value = "/get/broken/info")
	public FileInventory brokenInfo(@RequestParam("fiIdx") int fiIdx) {
		FileInventory result = fileBrokenInventoryMapper.get(fiIdx);
		return result;
	}
		
		
	@ResponseBody
	@RequestMapping(value = "/get/pile/type/list")
	public List<FileInventory> getPileTypeList(FileInventory inventory) {
		List<FileInventory> result = mapper.getPileTypeList(inventory);
		return result;
	}
	
	
	@ResponseBody
	@RequestMapping(value = "/check/broken/duplicate")
	public boolean checkBrokenDuplicate(@RequestParam("registDate") String registDate ,  @RequestParam("pileType") String pileType,  @RequestParam("pileStandard") String pileStandard, @RequestParam("constructionIdx") int constructionIdx, @RequestParam("fileWeight") String fileWeight, @RequestParam("maker") String maker) {
		FileInventory inventory;
		if(fileWeight != "") {
			inventory = fileBrokenInventoryMapper.getFileInventory1(registDate, maker, pileType, pileStandard, constructionIdx, fileWeight);
		} else {
			inventory = fileBrokenInventoryMapper.getFileInventory2(registDate, maker, pileType, pileStandard, constructionIdx);
		}
		return inventory != null ? false : true;
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
