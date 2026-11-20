package net.octacomm.sample.controller;

import java.io.File;
import java.io.IOException;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import net.octacomm.sample.dao.mapper.MemoMapper;
import net.octacomm.sample.domain.Device;
import net.octacomm.sample.domain.Memo;


@RequestMapping("/memo")
@Controller
public class MemoController {
	
	@Autowired
	private MemoMapper memoMapper;

	private static final long MAX_IMAGE_SIZE = 10L * 1024L * 1024L;
	private static final Set<String> ALLOWED_IMAGE_EXTENSIONS = new HashSet<String>(
			Arrays.asList("jpg", "jpeg", "png", "gif", "bmp"));
	
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

	@ResponseBody
	@RequestMapping(value = "/attachments", method = RequestMethod.GET)
	public List<Memo> attachments(@RequestParam("constructionIdx") int constructionIdx) {
		return memoMapper.findAttachmentsByConstructionIdx(constructionIdx);
	}

	@ResponseBody
	@RequestMapping(value = "/attachment/upload", method = RequestMethod.POST)
	public Memo uploadAttachment(@RequestParam("constructionIdx") int constructionIdx,
			@RequestParam("userId") String userId, @RequestParam("attachmentType") String attachmentType,
			@RequestParam("file") MultipartFile file, HttpServletRequest request) throws IOException {
		if (file == null || file.isEmpty()) throw new IllegalArgumentException("이미지 파일을 선택하세요.");
		if (file.getSize() > MAX_IMAGE_SIZE) throw new IllegalArgumentException("이미지는 10MB 이하만 업로드할 수 있습니다.");
		if (!"CARD".equals(attachmentType) && !"PHOTO".equals(attachmentType)) {
			throw new IllegalArgumentException("허용되지 않는 첨부 분류입니다.");
		}

		String originalFilename = file.getOriginalFilename();
		int dot = originalFilename == null ? -1 : originalFilename.lastIndexOf('.');
		String extension = dot > 0 ? originalFilename.substring(dot + 1).toLowerCase() : "";
		if (!ALLOWED_IMAGE_EXTENSIONS.contains(extension)) throw new IllegalArgumentException("이미지 파일만 업로드할 수 있습니다.");

		String uploadPath = QRController.RELEASE_TO_SERVER ? request.getServletContext().getRealPath("/uploads") : "D:/PDGM/uploads";
		File directory = new File(uploadPath);
		if (!directory.exists() && !directory.mkdirs()) throw new IOException("첨부파일 저장 폴더를 만들 수 없습니다.");
		String storedFilename = UUID.randomUUID().toString().replace("-", "") + "." + extension;
		file.transferTo(new File(directory, storedFilename));

		Memo attachment = new Memo();
		attachment.setConstructionIdx(constructionIdx);
		attachment.setUserId(userId);
		attachment.setMemoDate(new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()));
		attachment.setAttachmentType(attachmentType);
		attachment.setOriginalFilename(originalFilename);
		attachment.setStoredFilename(storedFilename);
		attachment.setContentType(file.getContentType());
		attachment.setFileSize(file.getSize());
		memoMapper.insertAttachment(attachment);
		return attachment;
	}

	@ResponseBody
	@RequestMapping(value = "/attachment/delete", method = RequestMethod.POST)
	public boolean deleteAttachment(@RequestParam("id") int id) {
		return memoMapper.delete(id) > 0;
	}
}
