package net.octacomm.sample.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

import net.octacomm.sample.domain.AdminBoard;
import net.octacomm.sample.service.AdminBoardService;

@ControllerAdvice
public class BoardMenuController {

    @Autowired
    private AdminBoardService adminBoardService;

    @ModelAttribute("globalBoardList")
    public List<AdminBoard> getBoardMenuList() {
        Map<String, Object> param = new HashMap<>();
        param.put("startRow", 0);
        param.put("size", 100);
        
        return adminBoardService.getBoardList(param);
    }
}