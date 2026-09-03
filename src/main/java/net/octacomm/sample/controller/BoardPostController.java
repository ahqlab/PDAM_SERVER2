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
import net.octacomm.sample.domain.SessionInfo;
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

    @RequestMapping(value = "/postList", method = RequestMethod.GET)
    public ModelAndView getPostList(
            @RequestParam("boardId") Long boardId,
            @RequestParam(value = "page", defaultValue = "1") int page,
            @RequestParam(value = "size", defaultValue = "10") int size,
            @RequestParam(value = "searchType", required = false) String searchType,
            @RequestParam(value = "keyword", required = false) String keyword,
            HttpSession session) {
        
        // sessionInfo는 AbstractCRUDController.setSessionInfo()와 동일하게 요청마다
        // 새로 만들어 View 모델에만 넣는다. HttpSession에 저장하면(예: 이전 구현의
        // session.setAttribute("sessionInfo", map)) 다른 컨트롤러가 이 세션 attribute를
        // SessionInfo 빈으로 기대하고 읽다가 값이 섞이거나 필드가 유실될 수 있다.
        SessionInfo sessionInfo = new SessionInfo();
        sessionInfo.setUserId((String) session.getAttribute("userId"));
        sessionInfo.setUserName((String) session.getAttribute("userName"));
        sessionInfo.setRole((Integer) session.getAttribute("role"));
        sessionInfo.setConstructionIdx((Integer) session.getAttribute("constructionIdx"));
        sessionInfo.setHiddenManager(Boolean.TRUE.equals(session.getAttribute("isHiddenManager")));
        sessionInfo.setGroupIdx((Integer) session.getAttribute("groupIdx"));
        sessionInfo.setFcIdx((Integer) session.getAttribute("fcIdx"));
        sessionInfo.setShowPdfYn(Boolean.TRUE.equals(session.getAttribute("showPdfYn")));

        ModelAndView mav = new ModelAndView();
        mav.addObject("sessionInfo", sessionInfo);
        mav.addObject("isSystemAdmin", session.getAttribute("isSystemAdmin"));

        AdminBoard boardMaster = adminBoardService.getBoard(boardId);

        if (boardMaster == null || "N".equals(boardMaster.getUseYn())) {
            mav.setViewName("redirect:/error?msg=boardDisabled");
            return mav;
        }
        if (!hasBoardAccess(boardMaster, session)) {
            mav.setViewName("redirect:/error?msg=boardForbidden");
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

    // postList.jsp의 canWrite 계산과 동일한 규칙(board.auth에 'ALL', 시스템관리자, 또는
    // 세션 role이 콤마구분 문자열로 포함)을 서버에서도 적용한다. 이 게시판 모델은 읽기/쓰기를
    // auth 하나로 함께 게이팅하므로 조회/작성/수정/삭제/다운로드 전부 이 체크를 통과해야 한다.
    private boolean hasBoardAccess(AdminBoard board, HttpSession session) {
        if (board == null || board.getAuth() == null) {
            return false;
        }
        if (Boolean.TRUE.equals(session.getAttribute("isSystemAdmin"))) {
            return true;
        }
        String authStr = "," + board.getAuth() + ",";
        if (authStr.contains(",ALL,")) {
            return true;
        }
        if (Boolean.TRUE.equals(session.getAttribute("isResearchAdmin")) && authStr.contains(",RESEARCH_ADMIN,")) {
            return true;
        }
        Object role = session.getAttribute("role");
        return role != null && authStr.contains("," + role + ",");
    }

    // postList.jsp의 클라이언트 검증(확장자 화이트리스트, 최대 3개 슬롯)과 동일한 규칙을
    // 서버에서도 적용한다. 직접 API를 호출하면 클라이언트 검증을 우회할 수 있기 때문이다.
    private void assignFilesToPost(AdminBoard board, BoardPost post, List<MultipartFile> files) throws Exception {
        if (files == null || files.isEmpty()) return;

        List<String> allowedExts = parseAllowedExts(board.getAllowedExts());

        for (MultipartFile f : files) {
            if (f.isEmpty()) continue;

            if (allowedExts.isEmpty() || !allowedExts.contains(getExtension(f.getOriginalFilename()))) {
                throw new IllegalArgumentException("업로드할 수 없는 파일 형식입니다: " + f.getOriginalFilename());
            }

            if (post.getFileName1() == null) {
                post.setFileName1(f.getOriginalFilename()); post.setFileData1(f.getBytes());
                post.setFileSize1(f.getSize()); post.setContentType1(f.getContentType());
            } else if (post.getFileName2() == null) {
                post.setFileName2(f.getOriginalFilename()); post.setFileData2(f.getBytes());
                post.setFileSize2(f.getSize()); post.setContentType2(f.getContentType());
            } else if (post.getFileName3() == null) {
                post.setFileName3(f.getOriginalFilename()); post.setFileData3(f.getBytes());
                post.setFileSize3(f.getSize()); post.setContentType3(f.getContentType());
            } else {
                throw new IllegalArgumentException("첨부파일은 최대 3개까지만 업로드할 수 있습니다.");
            }
        }
    }

    private List<String> parseAllowedExts(String allowedExtsStr) {
        List<String> result = new java.util.ArrayList<>();
        if (allowedExtsStr == null || allowedExtsStr.trim().isEmpty()) {
            return result;
        }
        for (String ext : allowedExtsStr.split(",")) {
            String trimmed = ext.trim().toLowerCase();
            if (!trimmed.isEmpty()) {
                result.add(trimmed);
            }
        }
        return result;
    }

    private String getExtension(String fileName) {
        if (fileName == null) return "";
        int idx = fileName.lastIndexOf('.');
        return idx >= 0 ? fileName.substring(idx).toLowerCase() : "";
    }

    @RequestMapping(value = "/regist", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> createPost(
            @RequestParam("boardId") Long boardId,
            @RequestParam("regUser") String regUser,
            @RequestParam("title") String title,
            @RequestParam("content") String content,
            @RequestParam(value = "files", required = false) List<MultipartFile> files,
            HttpSession session) {

        Map<String, Object> resultMap = new HashMap<>();
        AdminBoard board = adminBoardService.getBoard(boardId);
        if (!hasBoardAccess(board, session)) {
            resultMap.put("success", false);
            resultMap.put("message", "게시글 작성 권한이 없습니다.");
            return resultMap;
        }
        try {
            BoardPost post = new BoardPost();
            post.setBoardId(boardId);
            post.setRegUser(regUser);
            post.setTitle(title);
            post.setContent(content);

            assignFilesToPost(board, post, files);

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
    public Map<String, Object> getPostDetail(@RequestParam("id") Long id, HttpSession session) {
        Map<String, Object> resultMap = new HashMap<>();
        BoardPost post = boardPostService.getPost(id);
        if (post == null) {
            resultMap.put("success", false);
            resultMap.put("message", "게시글을 찾을 수 없습니다.");
            return resultMap;
        }
        if (!hasBoardAccess(adminBoardService.getBoard(post.getBoardId()), session)) {
            resultMap.put("success", false);
            resultMap.put("message", "게시글을 찾을 수 없습니다.");
            return resultMap;
        }
        resultMap.put("success", true);
        resultMap.put("post", post);
        return resultMap;
    }

    @RequestMapping(value = "/update", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> updatePost(
            @RequestParam("id") Long id,
            @RequestParam("title") String title,
            @RequestParam("content") String content,
            @RequestParam(value = "files", required = false) List<MultipartFile> files,
            HttpSession session) {

        Map<String, Object> resultMap = new HashMap<>();
        try {
            BoardPost post = boardPostService.getPost(id);
            if(post == null) {
                resultMap.put("success", false);
                resultMap.put("message", "존재하지 않는 게시글입니다.");
                return resultMap;
            }
            AdminBoard board = adminBoardService.getBoard(post.getBoardId());
            if (!hasBoardAccess(board, session)) {
                resultMap.put("success", false);
                resultMap.put("message", "게시글 수정 권한이 없습니다.");
                return resultMap;
            }

            BoardPost filePost = boardPostService.getPostFileData(id);
            if (filePost != null) {
                post.setFileData1(filePost.getFileData1());
                post.setFileData2(filePost.getFileData2());
                post.setFileData3(filePost.getFileData3());
            }

            post.setTitle(title);
            post.setContent(content);

            assignFilesToPost(board, post, files);

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
    public Map<String, Object> deletePost(@RequestParam("id") Long id, HttpSession session) {
        Map<String, Object> resultMap = new HashMap<>();
        try {
            BoardPost post = boardPostService.getPost(id);
            if (post == null) {
                resultMap.put("success", false);
                resultMap.put("message", "존재하지 않는 게시글입니다.");
                return resultMap;
            }
            if (!hasBoardAccess(adminBoardService.getBoard(post.getBoardId()), session)) {
                resultMap.put("success", false);
                resultMap.put("message", "게시글 삭제 권한이 없습니다.");
                return resultMap;
            }
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
                             @RequestParam("slot") int slot,
                             HttpSession session) throws Exception {
        BoardPost post = boardPostService.getPost(id);
        if (post == null) return;
        if (!hasBoardAccess(adminBoardService.getBoard(post.getBoardId()), session)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        BoardPost filePost = boardPostService.getPostFileData(id);
        if (filePost == null) return;

        String fileName = null;
        byte[] fileData = null;
        String contentType = null;

        if (slot == 1) {
        	fileName = filePost.getFileName1();
        	fileData = filePost.getFileData1();
        	contentType = filePost.getContentType1();
        } else if (slot == 2) {
        	fileName = filePost.getFileName2();
        	fileData = filePost.getFileData2();
        	contentType = filePost.getContentType2();
        } else if (slot == 3) {
        	fileName = filePost.getFileName3();
        	fileData = filePost.getFileData3();
        	contentType = filePost.getContentType3();
        }

        if (fileData != null && fileName != null) {
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
            @RequestParam("slot") int slot,
            HttpSession session) {
        Map<String, Object> resultMap = new HashMap<>();
        try {
            BoardPost post = boardPostService.getPost(postId);
            if (post == null) {
                resultMap.put("success", false);
                resultMap.put("message", "존재하지 않는 게시글입니다.");
                return resultMap;
            }
            if (!hasBoardAccess(adminBoardService.getBoard(post.getBoardId()), session)) {
                resultMap.put("success", false);
                resultMap.put("message", "파일 삭제 권한이 없습니다.");
                return resultMap;
            }
            boardPostService.deleteFileSlot(postId, slot);
            resultMap.put("success", true);
        } catch (Exception e) {
            resultMap.put("success", false);
            resultMap.put("message", e.getMessage());
        }
        return resultMap;
    }
}