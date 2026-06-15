package net.octacomm.sample.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URLEncoder;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.support.SessionStatus;

import net.octacomm.sample.dao.mapper.DeviceTestReportMapper;
import net.octacomm.sample.domain.DeviceTestReport;
import net.octacomm.sample.domain.DeviceTestReportParam;


@Controller
@RequestMapping("/treport")
public class DeviceTestReportController extends AbstractCRUDController<DeviceTestReportMapper, DeviceTestReport, DeviceTestReportParam, Integer>{

	@Autowired
	public void setCRUDMapper(DeviceTestReportMapper mapper) {
		this.mapper = mapper;
	}

	@Override
	protected Class<DeviceTestReport> getDomainClass() {
		return DeviceTestReport.class;
	}

	@Override
	protected String getRedirectUrl(HttpServletRequest request, HttpSession session) {
		return "redirect:/treport/list";
	}
	
	@RequestMapping(value = "/regist2", method = RequestMethod.POST)
	public String regist2(DeviceTestReport domain, SessionStatus sessionStatus, HttpServletRequest request, HttpSession session) throws IOException {
		
		if(!domain.getFile().isEmpty()) {
			domain.setFileName(domain.getFile().getOriginalFilename());			
			String path = request.getServletContext().getRealPath("/uploads");
			InputStream inputStream = null;
			OutputStream outputStream = null;
			try {

				if (domain.getFile().getSize() > 0) {
					inputStream = domain.getFile().getInputStream();
					File realUploadDir = new File(path);
					if (!realUploadDir.exists()) {
						realUploadDir.mkdirs();
					}

					String organizedfilePath = path + "/" + domain.getFile().getOriginalFilename();
					outputStream = new FileOutputStream(organizedfilePath);

					int readByte = 0;
					byte[] buffer = new byte[8192];

					while ((readByte = inputStream.read(buffer, 0, 8120)) != -1) {
						outputStream.write(buffer, 0, readByte);

					}
				}
			} catch (Exception e) {
				e.getStackTrace();
			} finally {
				outputStream.close();
				inputStream.close();
			}
		}
		
		if (mapper.insert(domain) == 1){
			sessionStatus.setComplete();
			return getRedirectUrl(request, session);
		} else {
			return URL_REGIST;
		}
	}
	
	
	public void fileDownload() {
		
	}
	
	
	@RequestMapping(value = "/download/test/report", method = RequestMethod.GET)
	public void download(@RequestParam("sn") String sn, HttpServletRequest request, HttpServletResponse response) throws Exception {
        try {
        	DeviceTestReport domain = mapper.getFindBySn(sn);
        	
        	String path = request.getServletContext().getRealPath("/uploads") + "/" + domain.getFileName();
        	System.err.println("path : " + path);
        	File file = new File(path);
        	String filename = URLEncoder.encode(file.getName(), "UTF-8");
        	response.setHeader("Content-Disposition", "attachment;filename=" + filename); // 다운로드 되거나 로컬에 저장되는 용도로 쓰이는지를 알려주는 헤더
        	
        	FileInputStream fileInputStream = new FileInputStream(path); // 파일 읽어오기 
        	OutputStream out = response.getOutputStream();
        	
        	int read = 0;
            byte[] buffer = new byte[1024];
            while ((read = fileInputStream.read(buffer)) != -1) { // 1024바이트씩 계속 읽으면서 outputStream에 저장, -1이 나오면 더이상 읽을 파일이 없음
                out.write(buffer, 0, read);
            }
                
        } catch (Exception e) {
        	e.printStackTrace();
        }
	}
	
	
	@ResponseBody
	@RequestMapping(value = "/is/duplecate/sn", method = RequestMethod.POST)
	public boolean duplicateCheck(@RequestParam("sn") String sn) {
		try {
			if(mapper.getFindBySn(sn) != null) {
				return true;
			}
		}catch (Exception e) {
			return false;
		}
		return false;
	}
	
	
	
//	@RequestMapping(value = "/regist2", method = RequestMethod.POST)
//	public String regist(DeviceTestReport domain, SessionStatus sessionStatus, HttpServletRequest request, HttpSession session) {
//		
//		if(!domain.getFile().isEmpty()) {
//			domain.setFileName(domain.getFile().getOriginalFilename());
//			try {
//				domain.setFileByte(domain.getFile().getBytes());
//			} catch (IOException e) {
//				e.printStackTrace();
//			}
//		}
//		if (mapper.insert(domain) == 1){
//			sessionStatus.setComplete();
//			return getRedirectUrl(request, session);
//		} else {
//			return URL_REGIST;
//		}
//	}
	
//	@RequestMapping(value = "/download/test/report", method = RequestMethod.GET)
//	public void fileDownload(@RequestParam("idx") int idx, HttpServletResponse response) {
//		DeviceTestReport domain = mapper.get(idx);
//		InputStream is = null;
//		try {		
//		    is = new ByteArrayInputStream(domain.getFileByte());
//		    ServletOutputStream os = response.getOutputStream();
//		    int binaryRead;
//		    while ((binaryRead = is.read()) != -1)    {
//		         os.write(binaryRead);
//		    }
//		} catch(Exception e){
//			e.printStackTrace();
//		} finally {
//			if (is != null)
//			try { is.close(); } 
//			catch (IOException ex) { }
//		}
//	}
}
