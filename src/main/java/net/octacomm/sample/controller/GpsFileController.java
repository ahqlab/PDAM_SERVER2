package net.octacomm.sample.controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.io.FilenameUtils;
import org.mvel2.util.StringAppender;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import net.octacomm.sample.dao.mapper.GpsFileMapper;
import net.octacomm.sample.domain.Device;
import net.octacomm.sample.domain.GpsFile;
import net.octacomm.sample.domain.GpsFileParam;
import net.octacomm.sample.domain.UpdateReport;


@RequestMapping("/gpsfile")
@Controller
public class GpsFileController extends AbstractGpsFileCRUDController<GpsFileMapper, GpsFile, GpsFileParam, Integer>
{
	@Autowired
	public void setCRUDMapper(GpsFileMapper mapper) {
		this.mapper = mapper;
	}

	@Override
	protected Class<GpsFile> getDomainClass() {
		return GpsFile.class;
	}

	@Override
	protected String getRedirectUrl(HttpServletRequest request, HttpSession session) {
		return "redirect:/gpsfile/list";
	}
	
	@RequestMapping(value = "/download", method = RequestMethod.GET)
	public ResponseEntity<String> download(@RequestParam("constructionIdx") int ConstructionIdx) {
		SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		HttpHeaders header = new HttpHeaders();
		header.add("Content-Type", "text/csv; charset=MS949");
		header.add("Content-Disposition", "attachment; filename=\"" + "GPS_" + sdf1.format(System.currentTimeMillis()) + ".csv" + "\"");
		String csvHeaderColunm = "POINT,x(N),y(E),z(h),CODE\n";
		StringAppender appender = new StringAppender();
		appender.append(csvHeaderColunm);
		List<GpsFile> list = mapper.selectByConstructionIdx(ConstructionIdx);
		for (GpsFile gpsFile : list) {
			appender.append(gpsFile.getPoint() + "," + gpsFile.getXAxis() + "," + gpsFile.getYAxis() + "," + gpsFile.getZAxis() + "," + gpsFile.getCode() + "\n");
		}
		return new ResponseEntity<String>(appender.toString(), header, HttpStatus.CREATED);
	}
	
	@RequestMapping(value = "/regist2", method = RequestMethod.POST)
	public String regist2(RedirectAttributes rttr , @RequestParam("file") MultipartFile file, @RequestParam("constructionIdx") int constructionIdx, HttpSession session) throws IOException {
		
		if(!file.isEmpty()) {
			String extension = FilenameUtils.getExtension(file.getOriginalFilename()); // 3

		    if (!extension.equals("csv")) {
		    	rttr.addFlashAttribute("msg", "csv 엑셀파일만 업로드 해주세요.");
		    	return "redirect:/gpsfile/regist";
		    }
		    
		    mapper.deleteByConstructionIdx(constructionIdx);
		    
		    BufferedReader br;
		    List<GpsFile> list = new ArrayList<GpsFile>();
		    
		    try{
		    	InputStream is = file.getInputStream();
		    	br = new BufferedReader(new InputStreamReader(is,"utf-8"));
		        String line = "";
		        int num = 0;
		        while((line = br.readLine()) != null){
					List<String> stringList = new ArrayList<String>();
					String stringArray[] = line.split(",");
					stringList = Arrays.asList(stringArray);
					// csv 1열 데이터를 header로 인식
					GpsFile gpsFile = null;
					// header 컬럼 개수를 기준으로 데이터 set
					for(int i = 0; i < stringList.size(); i++){
						gpsFile = new GpsFile();
						gpsFile.setConstructionIdx(constructionIdx);
						gpsFile.setPoint(stringList.get(0).isEmpty() ? "" : stringList.get(0));
						gpsFile.setXAxis(stringList.get(1).isEmpty() ? "" : stringList.get(1));
						gpsFile.setYAxis(stringList.get(2).isEmpty() ? "" : stringList.get(2));
						gpsFile.setZAxis(stringList.get(3).isEmpty() ? "" : stringList.get(3));
						gpsFile.setCode(stringList.get(4).isEmpty() ? "" : stringList.get(4));
					}
					if(num > 0) {
						list.add(gpsFile);
						//mapper.insert(gpsFile);
					}
					num++;
		        }
		        mapper.insertMulti(list);
		        
		    } catch (Exception e) {
		    	System.err.println(e.toString());
		    	rttr.addFlashAttribute("msg", "파일업로드 중 오류가 발생했습니다. csv 파일을 확인하세요.");
				return "redirect:/gpsfile/regist?constructionIdx=" + constructionIdx;
		    }
		    return "redirect:/gpsfile/list?constructionIdx=" + constructionIdx;
		}
		rttr.addFlashAttribute("msg", "파일이 존재하지 않습니다.");
		return "redirect:/gpsfile/regist?constructionIdx=" + constructionIdx;
	}
	
	
	@ResponseBody
	@RequestMapping(value = "/update/fileMulti", method = RequestMethod.POST)
	public boolean updateReportMulti(@RequestBody List<GpsFile> files) {
		try {
			for (GpsFile file : files) {  
				updateFiletOne(file);
			}
		}catch (Exception e) {
			return false;
		}
		return true;
	}

	private void updateFiletOne(GpsFile file) {
		System.err.println("file : " + file);
		mapper.update(file);
	}
	
	@ResponseBody
	@RequestMapping(value = "/doDelete", method = RequestMethod.POST)
	public boolean doDelete( @RequestParam("id") int id) {
		return mapper.delete(id) > 0;
	}
	
	
}
