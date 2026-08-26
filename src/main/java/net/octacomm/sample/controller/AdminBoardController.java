package net.octacomm.sample.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
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
        SessionInfo sessionInfo = null;
        Object sessionInfoObj = session.getAttribute("sessionInfo");

        if (sessionInfoObj instanceof SessionInfo) {
            sessionInfo = (SessionInfo) sessionInfoObj;
        } else if (sessionInfoObj instanceof Map) {
            @SuppressWarnings("unchecked")
            Map<String, Object> map = (Map<String, Object>) sessionInfoObj;
            
            sessionInfo = new SessionInfo();
            Object mapRole = map.get("role");
            if (mapRole instanceof Integer) {
                sessionInfo.setRole((Integer) mapRole);
            } else {
                sessionInfo.setRole(role);
            }
            sessionInfo.setUserId((String) map.get("userId"));
            sessionInfo.setUserName((String) map.get("userName"));

            session.setAttribute("sessionInfo", sessionInfo);
        }

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
    public Map<String, Object> createPost(HttpServletRequest request, AdminBoard board) {
        Map<String, Object> resultMap = new HashMap<>();
        HttpSession session = request.getSession();
        
        if (!isSystemAdmin(session)) {
            resultMap.put("success", false);
            resultMap.put("message", "권한이 없습니다.");
            return resultMap;
        }

        try {
            adminBoardService.insertBoard(board); 
            resultMap.put("success", true);
            resultMap.put("message", "게시판이 성공적으로 생성되었습니다.");
        } catch (Exception e) {
            resultMap.put("success", false);
            resultMap.put("message", "오류가 발생했습니다: " + e.getMessage());
        }

        return resultMap;
    }

    @RequestMapping(value = "/delete", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> deletePost(HttpServletRequest request, @RequestParam("id") Long id) {
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
    public Map<String, Object> getBoardDetail(HttpServletRequest request, @RequestParam("id") Long id) {
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
            resultMap.put("message", "게시판 정보를 찾을 수 없습니다.");
        }
        return resultMap;
    }

    @RequestMapping(value = "/update", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> updatePost(HttpServletRequest request, AdminBoard board) {
        Map<String, Object> resultMap = new HashMap<>();
        HttpSession session = request.getSession();
        
        if (!isSystemAdmin(session)) {
            resultMap.put("success", false);
            resultMap.put("message", "권한이 없습니다.");
            return resultMap;
        }

        try {
            adminBoardService.updateBoard(board);
            resultMap.put("success", true);
            resultMap.put("message", "게시판 설정이 성공적으로 수정되었습니다.");
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