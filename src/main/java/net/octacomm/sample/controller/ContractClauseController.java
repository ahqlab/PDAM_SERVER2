package net.octacomm.sample.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import net.octacomm.sample.dao.mapper.ContractClauseMapper;
import net.octacomm.sample.domain.ContractClause;
import net.octacomm.sample.domain.SessionInfo;

@Controller
@RequestMapping("/contractClause")
public class ContractClauseController {

	@Autowired
	private ContractClauseMapper contractClauseMapper;

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

	@RequestMapping(value = "/list", method = RequestMethod.GET)
	public String list(Model model) {
		List<ContractClause> list = contractClauseMapper.getList();
		model.addAttribute("domainList", list);
		return "contractClause/list";
	}

	@RequestMapping(value = "/delete", method = RequestMethod.GET)
	public String delete(@RequestParam("clauseIdx") int clauseIdx) {
		contractClauseMapper.delete(clauseIdx);
		return "redirect:/contractClause/list";
	}

	@ResponseBody
	@RequestMapping(value = "/get/list", method = RequestMethod.GET)
	public List<ContractClause> getList(
			@RequestParam(value = "contractType", required = false) String contractType) {
		if (contractType != null && !contractType.isEmpty()) {
			return contractClauseMapper.getListByContractType(contractType);
		}
		return contractClauseMapper.getList();
	}

	@ResponseBody
	@RequestMapping(value = "/ajax/save", method = RequestMethod.POST)
	public int ajaxSave(@ModelAttribute ContractClause clause) {
		if (clause.getClauseIdx() == 0) {
			contractClauseMapper.insert(clause);
		} else {
			contractClauseMapper.update(clause);
		}
		return clause.getClauseIdx();
	}

	@ResponseBody
	@RequestMapping(value = "/ajax/delete", method = RequestMethod.POST)
	public boolean ajaxDelete(@RequestParam("clauseIdx") int clauseIdx) {
		return contractClauseMapper.delete(clauseIdx) > 0;
	}
}
