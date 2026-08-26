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
import net.octacomm.sample.domain.BoardPost;
import net.octacomm.sample.service.AdminBoardService;
import net.octacomm.sample.service.BoardPostService;
import net.octacomm.sample.utils.Pagination;

@Controller
@RequestMapping("/board")
public class BoardPostController {

    @Autowired
    private BoardPostService boardPostService;
    
    @Autowired
    private AdminBoardService adminBoardService;

    @RequestMapping(value = "/list", method = RequestMethod.GET)
    public ModelAndView getPostList(
            @RequestParam("boardId") Long boardId,
            @RequestParam(value = "page", defaultValue = "1") int page,
            @RequestParam(value = "size", defaultValue = "10") int size,
            @RequestParam(value = "searchType", required = false) String searchType,
            @RequestParam(value = "keyword", required = false) String keyword,
            HttpSession session) {
        
        Object sessionInfoObj = session.getAttribute("sessionInfo");
        Map<String, Object> sessionInfoMap;
        
        if (sessionInfoObj instanceof Map) {
            sessionInfoMap = (Map<String, Object>) sessionInfoObj;
        } else {
            sessionInfoMap = new HashMap<>();
            sessionInfoMap.put("role", session.getAttribute("role"));
            sessionInfoMap.put("constructionIdx", session.getAttribute("constructionIdx"));
            sessionInfoMap.put("userName", session.getAttribute("userName"));
            sessionInfoMap.put("userId", session.getAttribute("userId"));
            sessionInfoMap.put("isHiddenManager", session.getAttribute("isHiddenManager"));
        }
        
        if (sessionInfoMap.get("hiddenManager") == null) {
            sessionInfoMap.put("hiddenManager", session.getAttribute("isHiddenManager"));
        }
        if (sessionInfoMap.get("role") == null) {
            sessionInfoMap.put("role", session.getAttribute("role"));
        }

        session.setAttribute("sessionInfo", sessionInfoMap);
        
        ModelAndView mav = new ModelAndView();
        mav.addObject("sessionInfo", sessionInfoMap);
        mav.addObject("isSystemAdmin", session.getAttribute("isSystemAdmin"));

        AdminBoard boardMaster = adminBoardService.getBoard(boardId);
        
        if (boardMaster == null || "N".equals(boardMaster.getUseYn())) {
            mav.setViewName("redirect:/error?msg=boardDisabled");
            return mav;
        }

        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("boardId", boardId);
        paramMap.put("searchType", searchType);
        paramMap.put("keyword", keyword);

        int totalCount = boardPostService.getPostTotalCount(paramMap);
        Pagination pagination = new Pagination(size, 10, totalCount, page);
        paramMap.put("startRow", pagination.getStartRow());
        paramMap.put("size", pagination.getPageSize());

        List<BoardPost> postList = boardPostService.getPostList(paramMap);

        mav.addObject("boardMaster", boardMaster);
        mav.addObject("postList", postList);
        mav.addObject("pagination", pagination);
        mav.setViewName("admin/board/postList"); 
        
        return mav;
    }

    private void assignFilesToPost(BoardPost post, List<MultipartFile> files) throws Exception {
        if (files == null || files.isEmpty()) return;
        
        for (MultipartFile f : files) {
            if (f.isEmpty()) continue;
            
            if (post.getFileName1() == null) {
                post.setFileName1(f.getOriginalFilename()); post.setFileData1(f.getBytes());
                post.setFileSize1(f.getSize()); post.setContentType1(f.getContentType());
            } else if (post.getFileName2() == null) {
                post.setFileName2(f.getOriginalFilename()); post.setFileData2(f.getBytes());
                post.setFileSize2(f.getSize()); post.setContentType2(f.getContentType());
            } else if (post.getFileName3() == null) {
                post.setFileName3(f.getOriginalFilename()); post.setFileData3(f.getBytes());
                post.setFileSize3(f.getSize()); post.setContentType3(f.getContentType());
            }
        }
    }

    @RequestMapping(value = "/regist", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> createPost(
            @RequestParam("boardId") Long boardId,
            @RequestParam("regUser") String regUser,
            @RequestParam("title") String title,
            @RequestParam("content") String content,
            @RequestParam(value = "files", required = false) List<MultipartFile> files) {
        
        Map<String, Object> resultMap = new HashMap<>();
        try {
            BoardPost post = new BoardPost();
            post.setBoardId(boardId);
            post.setRegUser(regUser);
            post.setTitle(title);
            post.setContent(content);
            
            assignFilesToPost(post, files);

            boardPostService.insertPost(post);
            resultMap.put("success", true);
        } catch (Exception e) {
            resultMap.put("success", false);
            resultMap.put("message", e.getMessage());
        }
        return resultMap;
    }

    @RequestMapping(value = "/detail", method = RequestMethod.GET)
    @ResponseBody
    public Map<String, Object> getPostDetail(@RequestParam("id") Long id) {
        Map<String, Object> resultMap = new HashMap<>();
        BoardPost post = boardPostService.getPost(id);
        if (post != null) {
            resultMap.put("success", true);
            resultMap.put("post", post);
        } else {
            resultMap.put("success", false);
            resultMap.put("message", "게시글을 찾을 수 없습니다.");
        }
        return resultMap;
    }

    @RequestMapping(value = "/update", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> updatePost(
            @RequestParam("id") Long id,
            @RequestParam("title") String title,
            @RequestParam("content") String content,
            @RequestParam(value = "files", required = false) List<MultipartFile> files) {
        
        Map<String, Object> resultMap = new HashMap<>();
        try {
            BoardPost post = boardPostService.getPost(id);
            if(post == null) {
                resultMap.put("success", false);
                resultMap.put("message", "존재하지 않는 게시글입니다.");
                return resultMap;
            }
            
            post.setTitle(title);
            post.setContent(content);
            
            assignFilesToPost(post, files);

            boardPostService.updatePost(post);
            resultMap.put("success", true);
        } catch (Exception e) {
            resultMap.put("success", false);
            resultMap.put("message", e.getMessage());
        }
        return resultMap;
    }

    @RequestMapping(value = "/delete", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> deletePost(@RequestParam("id") Long id) {
        Map<String, Object> resultMap = new HashMap<>();
        try {
            boardPostService.deletePost(id);
            resultMap.put("success", true);
        } catch (Exception e) {
            resultMap.put("success", false);
        }
        return resultMap;
    }

    @RequestMapping(value = "/download", method = RequestMethod.GET)
    public void downloadFile(HttpServletResponse response, 
                             @RequestParam("id") Long id,
                             @RequestParam("slot") int slot) throws Exception {
        BoardPost post = boardPostService.getPost(id);
        if (post == null) return;

        String fileName = null;
        byte[] fileData = null;
        String contentType = null;

        if (slot == 1) { fileName = post.getFileName1(); fileData = post.getFileData1(); contentType = post.getContentType1(); }
        else if (slot == 2) { fileName = post.getFileName2(); fileData = post.getFileData2(); contentType = post.getContentType2(); }
        else if (slot == 3) { fileName = post.getFileName3(); fileData = post.getFileData3(); contentType = post.getContentType3(); }

        if (fileData != null) {
            String encodedFileName = URLEncoder.encode(fileName, "UTF-8").replaceAll("\\+", "%20");
            response.setContentType(contentType != null ? contentType : "application/octet-stream");
            response.setContentLength(fileData.length);
            response.setHeader("Content-Disposition", "attachment; filename=\"" + encodedFileName + "\";");
            response.setHeader("Content-Transfer-Encoding", "binary");
            
            response.getOutputStream().write(fileData);
            response.getOutputStream().flush();
            response.getOutputStream().close();
        }
    }
    
    @RequestMapping(value = "/deleteFile", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> deleteFile(
            @RequestParam("postId") Long postId, 
            @RequestParam("slot") int slot) {
        Map<String, Object> resultMap = new HashMap<>();
        try {
            boardPostService.deleteFileSlot(postId, slot);
            resultMap.put("success", true);
        } catch (Exception e) {
            resultMap.put("success", false);
            resultMap.put("message", e.getMessage());
        }
        return resultMap;
    }
}