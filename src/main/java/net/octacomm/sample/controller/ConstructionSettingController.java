package net.octacomm.sample.controller;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import net.octacomm.sample.dao.mapper.ConstructionMapper;
import net.octacomm.sample.dao.mapper.ConstructionSettingMapper;
import net.octacomm.sample.dao.mapper.FranchiseMapper;
import net.octacomm.sample.domain.Construction;
import net.octacomm.sample.domain.ConstructionSetting;
import net.octacomm.sample.domain.SessionInfo;

@Controller
@RequestMapping("/construction/settings")
public class ConstructionSettingController {

    @Autowired
    private ConstructionMapper constructionMapper;

    @Autowired
    private ConstructionSettingMapper settingMapper;

    @Autowired
    private FranchiseMapper franchiseMapper;

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
        Boolean sr = (Boolean) session.getAttribute("settingRequired");
        sessionInfo.setSettingRequired(sr != null && sr);
        model.addAttribute("sessionInfo", sessionInfo);
        model.addAttribute("menuIndex", 0);
    }

    @RequestMapping(method = RequestMethod.GET)
    public String settings(@RequestParam("constructionIdx") int constructionIdx,
                           Model model, HttpSession session) {

        int role = (Integer) session.getAttribute("role");
        boolean isHiddenManager = (Boolean) session.getAttribute("isHiddenManager");
        int myConstructionIdx = (Integer) session.getAttribute("constructionIdx");

        // 접근 권한 체크
        if (role == 0) {
            // admin: 모든 현장 접근 가능
        } else if (role == 1 && isHiddenManager) {
            // hiddenManager: 본인 현장만 접근 가능
            if (constructionIdx != myConstructionIdx) {
                return "redirect:/device/list?constructionIdx=" + myConstructionIdx;
            }
        } else {
            return "redirect:/device/list?constructionIdx=" + myConstructionIdx;
        }

        // 설정 적용 대상 현장인지 확인
        if (constructionMapper.isSettingRequired(constructionIdx) == 0) {
            return "redirect:/construction/list";
        }

        Construction construction = constructionMapper.get(constructionIdx);
        ConstructionSetting setting = settingMapper.findByConstructionIdx(constructionIdx);

        // 설정 레코드 없으면 DB 디폴트값으로 생성
        if (setting == null) {
            setting = settingMapper.getDefault();
            if (setting == null) {
                setting = new ConstructionSetting();
            }
            setting.setConstructionIdx(constructionIdx);
            settingMapper.insert(setting);
        }

        model.addAttribute("construction", construction);
        model.addAttribute("setting", setting);
        model.addAttribute("franchiseList", franchiseMapper.getList());

        return "construction/settings";
    }

    @ResponseBody
    @RequestMapping(value = "/basic", method = RequestMethod.POST)
    public int updateBasicInfo(Construction construction, HttpSession session) {
        int role = (Integer) session.getAttribute("role");
        boolean isHiddenManager = (Boolean) session.getAttribute("isHiddenManager");
        int myConstructionIdx = (Integer) session.getAttribute("constructionIdx");

        if (role == 0) {
            construction.setRole(0);
        } else if (role == 1 && isHiddenManager && construction.getId() == myConstructionIdx) {
            construction.setRole(1);
        } else {
            return 0;
        }
        return constructionMapper.updateBasicInfo(construction);
    }

    @ResponseBody
    @RequestMapping(value = "/permission", method = RequestMethod.POST)
    public int updatePermission(ConstructionSetting setting, HttpSession session) {
        int role = (Integer) session.getAttribute("role");
        boolean isHiddenManager = (Boolean) session.getAttribute("isHiddenManager");
        int myConstructionIdx = (Integer) session.getAttribute("constructionIdx");

        if (role == 0) {
            // admin: 모든 현장 권한 변경 가능
        } else if (role == 1 && isHiddenManager && setting.getConstructionIdx() == myConstructionIdx) {
            // hiddenManager: 본인 현장만 변경 가능
        } else {
            return 0;
        }

        int result = settingMapper.upsert(setting);
        // 세션의 constructionSetting도 갱신
        if (result > 0 && role == 1) {
            session.setAttribute("constructionSetting", setting);
        }
        return result;
    }

    @ResponseBody
    @RequestMapping(value = "/password", method = RequestMethod.POST)
    public int updatePassword(@RequestParam int constructionIdx,
                              @RequestParam String currentPw,
                              @RequestParam String newPw,
                              HttpSession session) {
        int role = (Integer) session.getAttribute("role");
        boolean isHiddenManager = (Boolean) session.getAttribute("isHiddenManager");
        int myConstructionIdx = (Integer) session.getAttribute("constructionIdx");

        if (role != 0 && !(role == 1 && isHiddenManager && constructionIdx == myConstructionIdx)) {
            return 0;
        }

        Construction con = constructionMapper.get(constructionIdx);
        if (con == null || !currentPw.equals(con.getPassword())) {
            return -1;
        }
        return constructionMapper.updatePasswordById(constructionIdx, newPw);
    }

    @ResponseBody
    @RequestMapping(value = "/secretCode", method = RequestMethod.POST)
    public int updateSecretCode(@RequestParam int constructionIdx,
                                @RequestParam String currentCode,
                                @RequestParam String newCode,
                                HttpSession session) {
        int role = (Integer) session.getAttribute("role");
        boolean isHiddenManager = (Boolean) session.getAttribute("isHiddenManager");
        int myConstructionIdx = (Integer) session.getAttribute("constructionIdx");

        if (role != 0 && !(role == 1 && isHiddenManager && constructionIdx == myConstructionIdx)) {
            return 0;
        }

        Construction con = constructionMapper.get(constructionIdx);
        if (con == null || !currentCode.equals(con.getSecretCode())) {
            return -1;
        }
        return constructionMapper.updateSecretCodeById(constructionIdx, newCode);
    }

}
