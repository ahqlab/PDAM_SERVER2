package net.octacomm.sample.controller;

import java.util.List;
import java.util.Map;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import net.octacomm.sample.dao.mapper.SpareDeviceMapper;
import net.octacomm.sample.domain.SpareDevice;

@RequestMapping("/spare/device")
@Controller
public class SpareDeviceController {
	
	@Autowired
	private SpareDeviceMapper mapper;
	
	@ResponseBody
	@RequestMapping(value = "/get/list", method = RequestMethod.POST)
	public List<SpareDevice> getList(SpareDevice spareDevice) {
		if(spareDevice.getType() == 2) {
			return mapper.getListByChageDevice(spareDevice);
		}
		return mapper.getListBySpareDevice(spareDevice);
	}
	
	@ResponseBody
	@RequestMapping(value = "/not/change/list", method = RequestMethod.POST)
	public List<SpareDevice> notChangeList(SpareDevice spareDevice) {
		return mapper.getNotChangeListBySpareDevice(spareDevice);
	}
	
	@ResponseBody
	@RequestMapping(value = "/registAjax", method = RequestMethod.POST)
	public int registAjax(@RequestBody SpareDevice spareDevice) {
		return mapper.insert(spareDevice);
	}
	
	
	@ResponseBody
	@RequestMapping(value = "/update/multi", method = RequestMethod.POST)
	public boolean updateReportMulti(@RequestBody List<SpareDevice> spareDevice, @RequestParam("constructionIdx") int constructionIdx, @RequestParam("type") int type, @RequestParam("status") int status) {
		mapper.deleteByConstructionIdxAndType(constructionIdx, type, status);
		try {
			for (SpareDevice sd : spareDevice) {  
				mapper.insert(sd);
			}
		}catch (Exception e) {
			return false;
		}
		return true;
	}
	
	
	@ResponseBody
	@RequestMapping(value = "/delete", method = RequestMethod.POST)
	public boolean delete(@RequestParam("id") int id) {
		if (mapper.delete(id) == 1) {
			return true;
		} else {
			return false;
		}
	}
	
	
	@ResponseBody
	@RequestMapping(value = "/use/quantity", method = RequestMethod.POST)
	public Map<String, String> setTotalWorkQuantity(@RequestParam("constructionIdx") int constructionIdx) {
		Map<String, String> map = mapper.getRegQuantity(constructionIdx);
		return map;
	}
	
	@ResponseBody
	@RequestMapping(value = "/change", method = RequestMethod.POST)
	public boolean spareDiviceChange(@RequestParam("constructionIdx") int constructionIdx
			, @RequestParam("targetId") int targetId
			, @RequestParam("changeId") int changeId) {
		
		mapper.leftToRight(constructionIdx, targetId, 1);
		int result = mapper.doChangeDevice(targetId, changeId);
		if(result == 1) {
			if(mapper.deleteByIdx(changeId) == 1) {
				return true;
			}
		}
		return false;
	}
	
	@ResponseBody
	@RequestMapping(value = "/set/tripodcount", method = RequestMethod.POST)
	public int setTripodCount(@RequestParam("constructionIdx") int constructionIdx, @RequestParam("quantity") int quantity) {
		int count = mapper.tripodFindByConstructionIdxAndType(constructionIdx, 0);
		if(count > 0) {
			return mapper.setTripodCount(constructionIdx, quantity,0);
		}else{
			SpareDevice sd = new SpareDevice();
			sd.setConstructionIdx(constructionIdx);
			sd.setType(1);
			sd.setQuantity(quantity);
			sd.setStatus("0");
			return mapper.insert(sd);
		}
	}
	
	
	@ResponseBody
	@RequestMapping(value = "/set/change/tripodcount", method = RequestMethod.POST)
	public int setChangeTripodCount(@RequestParam("constructionIdx") int constructionIdx, @RequestParam("quantity") int quantity) {
		int count = mapper.tripodFindByConstructionIdxAndType(constructionIdx, 1);
		if(count > 0) {
			return mapper.setTripodCount(constructionIdx, quantity, 1);
		}else{
			SpareDevice sd = new SpareDevice();
			sd.setConstructionIdx(constructionIdx);
			sd.setType(1);
			sd.setQuantity(quantity);
			sd.setStatus("1");
			return mapper.insert(sd);
		}
	}
}
