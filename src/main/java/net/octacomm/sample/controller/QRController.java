package net.octacomm.sample.controller;

import java.awt.Color;
import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;


import net.octacomm.sample.dao.mapper.WeQrcodeMapper;
import net.octacomm.sample.domain.SessionInfo;
import net.octacomm.sample.domain.WeQrcode;
import net.octacomm.sample.domain.WeQrcodeParam;
import net.octacomm.sample.utils.QrPagination;


@RequestMapping("qr")
@Controller
public class QRController {
	
	public static boolean RELEASE_TO_SERVER = false;
	
	@Autowired
	private WeQrcodeMapper weQrcodeMapper;
	
	@RequestMapping(value = "/list")
	public void regist(Model model, @ModelAttribute("domainParam") WeQrcodeParam param, BindingResult result, HttpSession session){
		
		int totalCount = weQrcodeMapper.getCountByParam(param);
		
		QrPagination page;
		
		if (param.getPageSize() > 0 && param.getPageGroupSize() > 0) {
			page = new QrPagination(param.getPageSize(), param.getPageGroupSize(), totalCount, param.getCurrentPage());
		} else {
			page = new QrPagination(totalCount, param.getCurrentPage());
		}
		
		List<WeQrcode> domainList = weQrcodeMapper.getListByParam(page.getStartRow(), page.getPageSize(), param);
	
		System.err.println("Domain List Size : {}" +  domainList.size());
		
		model.addAttribute("page", page);		
		model.addAttribute("domainList", domainList);
	}
	

	@RequestMapping(value = "/view/{id}", method = RequestMethod.GET)
	public String viewQR(@PathVariable("id") int id, Model model) throws Exception {

	    WeQrcode code = weQrcodeMapper.get(id);

	    if (code != null && code.getQrfilename() != null) {
	        // 파일명을 UTF-8로 URL 인코딩
	        String encodedFileName = URLEncoder.encode(code.getQrfilename(), StandardCharsets.UTF_8.toString());
	        // +를 %20으로 변환 (공백 안전 처리)
	        encodedFileName = encodedFileName.replaceAll("\\+", "%20");
	        
	        String fileUrl;
	        
	        if(RELEASE_TO_SERVER) {
	        	 fileUrl = "https://we8104.com/uploads/" + encodedFileName;
	        }else {
	        	 fileUrl = "http://localhost:8080/web-template-mybatis/uploads/" + encodedFileName;
	        }
	        return "redirect:" + fileUrl;
	    } else {
	        return "redirect:/error";
	    }
	}
	
	
	@RequestMapping(value = "/download", method = RequestMethod.GET)
	public void download(@RequestParam("id") int id, HttpServletRequest request, HttpServletResponse response) throws Exception {
        try {
        	WeQrcode domain = weQrcodeMapper.get(id);
        	
        	String path;
        	
        	if(RELEASE_TO_SERVER) {
        		path = request.getServletContext().getRealPath("/uploads") + "/" + domain.getQrSaveFilename();
        	}else {
        		path = "D:/PDGM/uploads/" + domain.getQrSaveFilename();
        	}
        	
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
	
	@RequestMapping(value = "/save", method = RequestMethod.POST)
	@ResponseBody
	public int saveQR(@RequestParam("file") MultipartFile file, @RequestParam("qrId") String qrId, HttpServletRequest request) throws IOException {
		
		int result = 0;
		if (!file.isEmpty()) {
			// 안전한 파일명 생성
			String filename;
			if(RELEASE_TO_SERVER) {
				filename = uploadFile(file, request);
			}else {
				filename = localUploadFile(file, request);
			}
			result = weQrcodeMapper.updateQrCode(qrId, filename);
		}
		return result;
	}
	
	@ResponseBody
	@RequestMapping(value = "/generate", method = RequestMethod.POST)
	public Map<String, Object> generateQR(
			@RequestParam("title") String title,
			@RequestParam("text") String text,
			@RequestParam("link") String link,
			@RequestParam("file") MultipartFile file, HttpServletRequest request) throws Exception {
		
		String qrText = null;
		String qrType = null;
		String qrFilename = null;
		 WeQrcode code;
		
		if (file != null && !file.isEmpty()) {
		    // 파일 업로드 후 URL 생성
			
			String uploadFileName;
		    //String uploadFileName = uploadFile(file, request); 
			if(RELEASE_TO_SERVER) {
				uploadFileName = uploadFile(file, request); 
			}else {
				uploadFileName = localUploadFile(file, request); 
			}
		    qrText = "file";
		    qrType = "file";
		    qrFilename = uploadFileName;
		    code = new WeQrcode(title, qrType, qrText, uploadFileName);
		    int result = weQrcodeMapper.insert(code);
			if(result > 0) {
				if(RELEASE_TO_SERVER) {
					qrText = "https://www.we8104.com/qr/view/" + code.getId();
				} else {
					qrText = "http://localhost:8080/web-template-mybatis/qr/view/" + code.getId();
				}
				
			}   
		} else if (link != null && !link.isEmpty()) {
		    qrText = link;
		    qrType = "link";
		    qrFilename = "link";
		    code = new WeQrcode(title, qrType, qrText, qrFilename);
		    weQrcodeMapper.insert(code);
		} else if (text != null && !text.isEmpty()) {
		    qrText = text;
		    qrType = "text";
		    qrFilename = "text";
		    code = new WeQrcode(title, qrType, qrText, qrFilename);
		    weQrcodeMapper.insert(code);
		} else {
		    qrText = "";  // 또는 기본값
		    qrType = "";
		    qrFilename = "text";
		    code = new WeQrcode(title, qrType, qrText, qrFilename);
		    weQrcodeMapper.insert(code);
		}
	
	    ByteArrayOutputStream out = new ByteArrayOutputStream();
	    // ZXing 등을 사용해서 QR 코드 생성
	    BufferedImage qrImage = createQRImage(qrText);
	    ImageIO.write(qrImage, "png", out);

	    String base64 = Base64.getEncoder().encodeToString(out.toByteArray());

	    Map<String, Object> result2 = new HashMap<>();
	    result2.put("qrBase64", base64);  // 클라이언트에서 <img src="data:image/png;base64,...">
	    result2.put("qrId", code.getId());  // 클라이언트에서 <img src="data:image/png;base64,...">
        return result2;
    }
    
    private BufferedImage createQRImage(String text) throws Exception {
        com.google.zxing.qrcode.QRCodeWriter qrCodeWriter = new com.google.zxing.qrcode.QRCodeWriter();
        java.util.Map<com.google.zxing.EncodeHintType, Object> hints = new java.util.HashMap<>();
        hints.put(com.google.zxing.EncodeHintType.CHARACTER_SET, "UTF-8");
        hints.put(com.google.zxing.EncodeHintType.ERROR_CORRECTION, com.google.zxing.qrcode.decoder.ErrorCorrectionLevel.H);
        hints.put(com.google.zxing.EncodeHintType.MARGIN, 1);

        com.google.zxing.common.BitMatrix bitMatrix = qrCodeWriter.encode(text, com.google.zxing.BarcodeFormat.QR_CODE, 300, 300, hints);

        BufferedImage image = new BufferedImage(300, 300, BufferedImage.TYPE_INT_RGB);
        Graphics2D graphics = image.createGraphics();
        graphics.setColor(Color.WHITE);
        graphics.fillRect(0,0,300,300);
        graphics.setColor(Color.BLACK);

        for (int x = 0; x < 300; x++) {
            for (int y = 0; y < 300; y++) {
                if (bitMatrix.get(x, y)) graphics.fillRect(x, y, 1, 1);
            }
        }
        graphics.dispose();
        return image;
    }
    
    
    private String localUploadFile(MultipartFile file, HttpServletRequest request) throws IOException {
        String savedFileName = null;

        if (file != null && !file.isEmpty()) {
            // ✅ 고정 외부 업로드 경로 (운영 환경에서는 변경 가능)
            String uploadPath = "D:/PDGM/uploads/";

            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdirs();

            // 원본 파일 확장자 추출
            String originalFilename = file.getOriginalFilename();
            String ext = "";
            int dotIndex = originalFilename.lastIndexOf('.');
            if (dotIndex > 0) {
                ext = originalFilename.substring(dotIndex); // .pptx 등
            }

            // 안전한 저장용 파일명 생성 (UUID + 확장자)
            savedFileName = UUID.randomUUID().toString().replaceAll("-", "") + ext;

            File destFile = new File(uploadDir, savedFileName);

            // 파일 저장
            try (InputStream inputStream = file.getInputStream();
                 OutputStream outputStream = new FileOutputStream(destFile)) {

                byte[] buffer = new byte[8192];
                int readBytes;
                while ((readBytes = inputStream.read(buffer)) != -1) {
                    outputStream.write(buffer, 0, readBytes);
                }

            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        return savedFileName; // 서버에 저장된 안전한 이름 리턴
    }
	private String uploadFile(MultipartFile file, HttpServletRequest request) throws IOException {
	    String savedFileName = null;
	
	    if (file != null && !file.isEmpty()) {
	        // 업로드 경로
	        String path = request.getServletContext().getRealPath("/uploads");
	        File uploadDir = new File(path);
	        if (!uploadDir.exists()) uploadDir.mkdirs();
	
	        // 원본 파일 확장자 추출
	        String originalFilename = file.getOriginalFilename();
	        String ext = "";
	        int dotIndex = originalFilename.lastIndexOf('.');
	        if (dotIndex > 0) {
	            ext = originalFilename.substring(dotIndex); // .pptx 등
	        }
	
	        // 안전한 저장용 파일명 생성 (UUID + 확장자)
	        savedFileName = UUID.randomUUID().toString().replaceAll("-", "") + ext;
	
	        File destFile = new File(uploadDir, savedFileName);
	
	        try (InputStream inputStream = file.getInputStream();
	             OutputStream outputStream = new FileOutputStream(destFile)) {
	
	            byte[] buffer = new byte[8192];
	            int readBytes;
	            while ((readBytes = inputStream.read(buffer)) != -1) {
	                outputStream.write(buffer, 0, readBytes);
	            }
	
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    }
	
	    return savedFileName; // 서버에 저장된 안전한 이름 리턴
	}
	
	@ResponseBody
	@RequestMapping(value = "/delete", method = RequestMethod.POST)
	public boolean deleteQR(@RequestParam("id") int id) {
	    try {
	        int result = weQrcodeMapper.delete(id); 
	        return result > 0;
	    } catch (Exception e) {
	        e.printStackTrace();
	        return false;
	    }
	}
	
	@ModelAttribute
	public void setSessionInfo(Model model, HttpSession session) {
		SessionInfo sessionInfo = new SessionInfo();
		sessionInfo.setUserId((String) session.getAttribute("userId"));
		sessionInfo.setUserName((String) session.getAttribute("userName"));
		sessionInfo.setRole((Integer) session.getAttribute("role"));
		sessionInfo.setConstructionIdx((Integer) session.getAttribute("constructionIdx"));
		sessionInfo.setHiddenManager((Boolean) session.getAttribute("isHiddenManager"));
		sessionInfo.setGroupIdx((Integer) session.getAttribute("groupIdx"));	
		sessionInfo.setFcIdx((Integer) session.getAttribute("fcIdx"));	
		sessionInfo.setShowPdfYn((Boolean) session.getAttribute("showPdfYn"));	
	    model.addAttribute("sessionInfo", sessionInfo);
	}
	
}