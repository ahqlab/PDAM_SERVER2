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

import net.octacomm.sample.dao.mapper.PileQntPlanMngMapper;
import net.octacomm.sample.domain.PileQntPlanMng;
import net.octacomm.sample.domain.PileQntPlanMngParam;


@RequestMapping("/pqpm")
@Controller
public class PileQntPlanMngController extends AbstractPileQntPlanMngCRUDController<PileQntPlanMngMapper, PileQntPlanMng, PileQntPlanMngParam, Integer>
{
	@Autowired
	public void setCRUDMapper(PileQntPlanMngMapper mapper) {
		this.mapper = mapper;
	}

	@Override
	protected Class<PileQntPlanMng> getDomainClass() {
		return PileQntPlanMng.class;
	}

	@Override
	protected String getRedirectUrl(HttpServletRequest request, HttpSession session) {
		return "redirect:/PileQntPlanMng/list";
	}
	
	@RequestMapping(value = "/download", method = RequestMethod.GET)
	public ResponseEntity<String> download(@RequestParam("constructionIdx") int ConstructionIdx) {
		SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		HttpHeaders header = new HttpHeaders();
		header.add("Content-Type", "text/csv; charset=MS949");
		header.add("Content-Disposition", "attachment; filename=\"" + "PQPM_" + sdf1.format(System.currentTimeMillis()) + ".csv" + "\"");
		String csvHeaderColunm = "위치정보,계획수량,동별참고사항\n";
		StringAppender appender = new StringAppender();
		appender.append(csvHeaderColunm);
		List<PileQntPlanMng> list = mapper.selectByConstructionIdx(ConstructionIdx);
		for (PileQntPlanMng PileQntPlanMng : list) {
			//appender.append()
			appender.append(PileQntPlanMng.getLocalName() + "," + PileQntPlanMng.getPlanCount() + "," + PileQntPlanMng.getLocalReport() + "\n");
		}
		return new ResponseEntity<String>(appender.toString(), header, HttpStatus.CREATED);
	}
	
	@RequestMapping(value = "/regist2", method = RequestMethod.POST)
	public String regist2(RedirectAttributes rttr , @RequestParam("file") MultipartFile file, @RequestParam("constructionIdx") int constructionIdx, HttpSession session) throws IOException {
		
		if(!file.isEmpty()) {
			String extension = FilenameUtils.getExtension(file.getOriginalFilename()); // 3

		    if (!extension.equals("csv")) {
		    	rttr.addFlashAttribute("msg", "csv 엑셀파일만 업로드 해주세요.");
		    	return "redirect:/pqpm/regist";
		    }
		    
		    mapper.deleteByConstructionIdx(constructionIdx);
		    
		    BufferedReader br;
		    List<PileQntPlanMng> list = new ArrayList<PileQntPlanMng>();
		    
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
					PileQntPlanMng PileQntPlanMng = null;
					// header 컬럼 개수를 기준으로 데이터 set
					for(int i = 0; i < stringList.size(); i++){
						PileQntPlanMng = new PileQntPlanMng();
						PileQntPlanMng.setConstructionIdx(constructionIdx);
						PileQntPlanMng.setLocalName(stringList.get(0).isEmpty() ? "" : stringList.get(0));
						PileQntPlanMng.setPlanCount(stringList.get(1).isEmpty() ? "" : stringList.get(1));
						PileQntPlanMng.setLocalReport(stringList.get(2).isEmpty() ? "" : stringList.get(2));
					}
					
					if(num > 0) {
						list.add(PileQntPlanMng);
					}
					num++;
		        }
		        mapper.insertMulti(list);
		        
		    } catch (Exception e) {
		    	System.err.println(e.toString());
		    	rttr.addFlashAttribute("msg", "파일업로드 중 오류가 발생했습니다. csv 파일을 확인하세요.");
				return "redirect:/pqpm/regist?constructionIdx=" + constructionIdx;
		    }
		    return "redirect:/pqpm/list?constructionIdx=" + constructionIdx;
		}
		rttr.addFlashAttribute("msg", "파일이 존재하지 않습니다.");
		return "redirect:/pqpm/regist?constructionIdx=" + constructionIdx;
	}
	
	
	@ResponseBody
	@RequestMapping(value = "/update/fileMulti", method = RequestMethod.POST)
	public boolean updateReportMulti(@RequestBody List<PileQntPlanMng> files) {
		try {
			for (PileQntPlanMng file : files) {  
				updateFiletOne(file);
			}
		}catch (Exception e) {
			return false;
		}
		return true;
	}

	private void updateFiletOne(PileQntPlanMng file) {
		mapper.update(file);
	}
	
	@ResponseBody
	@RequestMapping(value = "/doDelete", method = RequestMethod.POST)
	public boolean doDelete( @RequestParam("id") int id) {
		return mapper.delete(id) > 0;
	}
	
	
}
