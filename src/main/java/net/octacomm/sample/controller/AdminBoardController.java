package net.octacomm.sample.controller;

import java.net.URLEncoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import net.octacomm.sample.domain.AdminBoard;
import net.octacomm.sample.domain.SessionInfo;
import net.octacomm.sample.service.AdminBoardService;
import net.octacomm.sample.utils.Pagination;

@Controller
@RequestMapping("/admin/board")
public class AdminBoardController {

    private static final int SYSTEM_ADMIN_ID_OFFSET = 90000000;

    @Autowired
    private AdminBoardService adminBoardService;

    @RequestMapping(value = "/list", method = RequestMethod.GET)
    public ModelAndView getBoardList(
            HttpServletRequest request,
            @RequestParam(value = "page", defaultValue = "1") int page,
            @RequestParam(value = "size", defaultValue = "10") int size,
            @RequestParam(value = "searchType", required = false) String searchType,
            @RequestParam(value = "keyword", required = false) String keyword) {
        
        ModelAndView mav = new ModelAndView();
        HttpSession session = request.getSession();
        
        if (!isSystemAdmin(session)) {
            mav.setViewName("redirect:/login");
            return mav;
        }

        Integer role = (Integer) session.getAttribute("role");
        SessionInfo sessionInfo = (SessionInfo) session.getAttribute("sessionInfo");
        if (sessionInfo == null) {
            sessionInfo = new SessionInfo();
            sessionInfo.setRole(role);
            sessionInfo.setUserId((String) session.getAttribute("userId"));
            sessionInfo.setUserName((String) session.getAttribute("userName"));
            session.setAttribute("sessionInfo", sessionInfo);
        }
        
        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("searchType", searchType);
        paramMap.put("keyword", keyword);

        int totalCount = adminBoardService.getBoardTotalCount(paramMap);

        Pagination pagination = new Pagination(size, 10, totalCount, page);

        paramMap.put("startRow", pagination.getStartRow());
        paramMap.put("size", pagination.getPageSize());

        List<AdminBoard> boardList = adminBoardService.getBoardList(paramMap);

        mav.addObject("boardList", boardList);
        mav.addObject("pagination", pagination);
        mav.setViewName("admin/board/list"); 
        return mav;
    }

    @RequestMapping(value = "/regist", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> createPost(
            HttpServletRequest request,
            @RequestParam("regUser") String regUser,
            @RequestParam("title") String title,
            @RequestParam("content") String content,
            @RequestParam("file") MultipartFile file) {
        
        Map<String, Object> resultMap = new HashMap<>();
        HttpSession session = request.getSession();
        
        if (!isSystemAdmin(session)) {
            resultMap.put("success", false);
            resultMap.put("message", "권한이 없습니다.");
            return resultMap;
        }

        if (file == null || file.isEmpty()) {
            resultMap.put("success", false);
            resultMap.put("message", "첨부파일은 필수입니다.");
            return resultMap;
        }

        try {
            Map<String, Object> boardData = new HashMap<>();
            boardData.put("regUser", regUser);
            boardData.put("title", title);
            boardData.put("content", content);
            
            boardData.put("fileName", file.getOriginalFilename());
            boardData.put("fileData", file.getBytes()); 
            boardData.put("fileSize", file.getSize());
            boardData.put("contentType", file.getContentType());

            adminBoardService.insertBoard(boardData); 

            resultMap.put("success", true);
            resultMap.put("message", "성공적으로 저장되었습니다.");
        } catch (Exception e) {
            resultMap.put("success", false);
            resultMap.put("message", "오류가 발생했습니다: " + e.getMessage());
        }

        return resultMap;
    }

    @RequestMapping(value = "/download", method = RequestMethod.GET)
    public void downloadFile(
            HttpServletRequest request,
            HttpServletResponse response,
            @RequestParam("id") Long id) throws Exception {
        
        HttpSession session = request.getSession();
        
        if (!isSystemAdmin(session)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "권한이 없습니다.");
            return;
        }

        AdminBoard fileDto = adminBoardService.getFile(id);

        if (fileDto != null && fileDto.getFileData() != null) {
            String encodedFileName = URLEncoder.encode(fileDto.getFileName(), "UTF-8").replaceAll("\\+", "%20");
            
            response.setContentType(fileDto.getContentType() != null ? fileDto.getContentType() : "application/octet-stream");
            response.setContentLength(fileDto.getFileData().length);
            response.setHeader("Content-Disposition", "attachment; filename=\"" + encodedFileName + "\";");
            response.setHeader("Content-Transfer-Encoding", "binary");
            
            response.getOutputStream().write(fileDto.getFileData());
            response.getOutputStream().flush();
            response.getOutputStream().close();
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "파일을 찾을 수 없습니다.");
        }
    }
    
    @RequestMapping(value = "/delete", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> deletePost(
            HttpServletRequest request,
            @RequestParam("id") Long id) {
        
        Map<String, Object> resultMap = new HashMap<>();
        HttpSession session = request.getSession();
        
        if (!isSystemAdmin(session)) {
            resultMap.put("success", false);
            resultMap.put("message", "권한이 없습니다.");
            return resultMap;
        }

        try {
            adminBoardService.deleteBoard(id);
            resultMap.put("success", true);
            resultMap.put("message", "성공적으로 삭제되었습니다.");
        } catch (Exception e) {
            resultMap.put("success", false);
            resultMap.put("message", "삭제 중 오류가 발생했습니다: " + e.getMessage());
        }

        return resultMap;
    }

    @RequestMapping(value = "/detail", method = RequestMethod.GET)
    @ResponseBody
    public Map<String, Object> getBoardDetail(
            HttpServletRequest request,
            @RequestParam("id") Long id) {
        
        Map<String, Object> resultMap = new HashMap<>();
        HttpSession session = request.getSession();
        
        if (!isSystemAdmin(session)) {
            resultMap.put("success", false);
            resultMap.put("message", "권한이 없습니다.");
            return resultMap;
        }

        AdminBoard board = adminBoardService.getBoard(id);
        if (board != null) {
            resultMap.put("success", true);
            resultMap.put("board", board);
        } else {
            resultMap.put("success", false);
            resultMap.put("message", "게시글을 찾을 수 없습니다.");
        }
        return resultMap;
    }

    @RequestMapping(value = "/update", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> updatePost(
            HttpServletRequest request,
            @RequestParam("id") Long id,
            @RequestParam("regUser") String regUser,
            @RequestParam("title") String title,
            @RequestParam("content") String content,
            @RequestParam(value = "file", required = false) MultipartFile file) {
        
        Map<String, Object> resultMap = new HashMap<>();
        HttpSession session = request.getSession();
        
        if (!isSystemAdmin(session)) {
            resultMap.put("success", false);
            resultMap.put("message", "권한이 없습니다.");
            return resultMap;
        }

        try {
            Map<String, Object> boardData = new HashMap<>();
            boardData.put("id", id);
            boardData.put("regUser", regUser);
            boardData.put("title", title);
            boardData.put("content", content);
            
            if (file != null && !file.isEmpty()) {
                boardData.put("fileName", file.getOriginalFilename());
                boardData.put("fileData", file.getBytes());
                boardData.put("fileSize", file.getSize());
                boardData.put("contentType", file.getContentType());
            }

            adminBoardService.updateBoard(boardData);
            resultMap.put("success", true);
            resultMap.put("message", "성공적으로 수정되었습니다.");
        } catch (Exception e) {
            resultMap.put("success", false);
            resultMap.put("message", "수정 중 오류가 발생했습니다: " + e.getMessage());
        }

        return resultMap;
    }
    
    private boolean isSystemAdmin(HttpSession session) {
        Object constructionIdx = session.getAttribute("constructionIdx");
        return Integer.valueOf(0).equals(session.getAttribute("role"))
                && constructionIdx instanceof Integer
                && ((Integer) constructionIdx) >= SYSTEM_ADMIN_ID_OFFSET;
    }
}
