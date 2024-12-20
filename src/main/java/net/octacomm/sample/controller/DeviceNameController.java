package net.octacomm.sample.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import net.octacomm.sample.dao.mapper.DeviceNameMapper;
import net.octacomm.sample.domain.DeviceName;
import net.octacomm.sample.domain.GpsFile;

@RequestMapping("/device/name")
@Controller
public class DeviceNameController {

	
	@Autowired
	private DeviceNameMapper mapper;
	

	@ResponseBody
	@RequestMapping(value = "/list", method = RequestMethod.POST)
	public List<DeviceName> getDeviceList(@RequestParam("deviceIdx") int deviceIdx) {
		return mapper.getListByDeviceIdx(deviceIdx);
	}
	
	
	@ResponseBody
	@RequestMapping(value = "/update/multi", method = RequestMethod.POST)
	public boolean updateReportMulti(@RequestBody List<DeviceName> deviceName) {
		try {
			for (DeviceName name : deviceName) {  
				updateDeviceNameOne(name);
			}
		}catch (Exception e) {
			return false;
		}
		return true;
	}
	
	
	private void updateDeviceNameOne(DeviceName deviceName) {
		int isReg = mapper.findByDeviceIdx(deviceName.getDeviceIdx());
		if(isReg > 0) {
			mapper.update(deviceName);
		}else {
			mapper.insert(deviceName);
		}
		
	}
}
