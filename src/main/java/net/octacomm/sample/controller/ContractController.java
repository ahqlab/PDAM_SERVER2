package net.octacomm.sample.controller;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;
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
import net.octacomm.sample.dao.mapper.ContractMapper;
import net.octacomm.sample.dao.mapper.ContractSignBackupMapper;
import net.octacomm.sample.domain.Contract;
import net.octacomm.sample.domain.ContractClause;
import net.octacomm.sample.domain.ContractParam;
import net.octacomm.sample.domain.SessionInfo;
import net.octacomm.sample.service.ContractService;

@Controller
@RequestMapping("/contract")
public class ContractController {

	@Autowired
	private ContractMapper contractMapper;

	@Autowired
	private ContractSignBackupMapper contractSignBackupMapper;

	@Autowired
	private ContractClauseMapper contractClauseMapper;

	@Autowired
	private ContractService contractService;

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
	public String list(@ModelAttribute("param") ContractParam param, Model model, HttpSession session) {
		int role = (int) session.getAttribute("role");
		if (role == 1) {
			param.setConstructionIdx((int) session.getAttribute("constructionIdx"));
		}
		param.setRole(role);
		int totalCount = contractMapper.getCountByParam(param);
		List<Contract> list = contractMapper.getListByParam(param);
		model.addAttribute("domainList", list);
		model.addAttribute("totalCount", totalCount);
		model.addAttribute("param", param);
		return "contract/list";
	}

	@RequestMapping(value = "/regist", method = RequestMethod.GET)
	public String registForm(
			@RequestParam(value = "constructionIdx", defaultValue = "0") int constructionIdx,
			Model model) {
		List<ContractClause> dailyClauses   = contractClauseMapper.getListByContractType("DAILY");
		List<ContractClause> monthlyClauses = contractClauseMapper.getListByContractType("MONTHLY");
		model.addAttribute("dailyClauses",   dailyClauses);
		model.addAttribute("monthlyClauses", monthlyClauses);
		model.addAttribute("domain", new Contract());
		model.addAttribute("constructionIdx", constructionIdx);
		if (constructionIdx > 0) {
			java.util.Map<String, Object> construction = contractMapper.getConstructionBasic(constructionIdx);
			model.addAttribute("construction", construction);
		}
		return "contract/regist";
	}

	@RequestMapping(value = "/regist", method = RequestMethod.POST)
	public String regist(@ModelAttribute Contract contract,
			@RequestParam(value = "clauseIdxList", required = false) List<Integer> clauseIdxList) {
		contractService.createContract(contract, clauseIdxList);
		return "redirect:/contract/list";
	}

	@RequestMapping(value = "/view", method = RequestMethod.GET)
	public String view(@RequestParam("contractIdx") int contractIdx, Model model) {
		Contract contract = contractMapper.get(contractIdx);
		List<ContractClause> clauses = contractService.getClausesByContractIdx(contractIdx);
		model.addAttribute("domain", contract);
		model.addAttribute("clauses", clauses);
		return "contract/view";
	}

	@RequestMapping(value = "/update", method = RequestMethod.GET)
	public String updateForm(@RequestParam("contractIdx") int contractIdx, Model model) {
		Contract contract = contractMapper.get(contractIdx);
		List<ContractClause> allClauses      = contractClauseMapper.getList();
		List<ContractClause> selectedClauses = contractService.getClausesByContractIdx(contractIdx);
		model.addAttribute("domain", contract);
		model.addAttribute("allClauses", allClauses);
		model.addAttribute("selectedClauses", selectedClauses);
		return "contract/update";
	}

	@RequestMapping(value = "/update", method = RequestMethod.POST)
	public String update(@ModelAttribute Contract contract,
			@RequestParam(value = "clauseIdxList", required = false) List<Integer> clauseIdxList) {
		contractMapper.update(contract);
		contractService.updateClauses(contract.getContractIdx(), clauseIdxList);
		return "redirect:/contract/view?contractIdx=" + contract.getContractIdx();
	}

	@RequestMapping(value = "/delete", method = RequestMethod.GET)
	public String delete(@RequestParam("contractIdx") int contractIdx) {
		Contract contract = contractMapper.get(contractIdx);
		if (contract != null && "SIGNED".equals(contract.getStatus())) {
			return "redirect:/contract/list";
		}
		contractMapper.delete(contractIdx);
		return "redirect:/contract/list";
	}

	@RequestMapping(value = "/required", method = RequestMethod.GET)
	public String required() {
		return "contract/no-contract";
	}

	@RequestMapping(value = "/blocked", method = RequestMethod.GET)
	public String blocked() {
		return "contract/blocked";
	}

	@RequestMapping(value = "/sign-view", method = RequestMethod.GET)
	public String signView(HttpSession session, Model model) {
		Integer constructionIdx = (Integer) session.getAttribute("constructionIdx");
		if (constructionIdx == null) return "redirect:/login";
		Contract contract = contractMapper.getDraftByConstructionIdx(constructionIdx);
		if (contract == null) {
			session.setAttribute("contractStatus", "SIGNED");
			return "redirect:/device/list?constructionIdx=" + constructionIdx;
		}
		List<ContractClause> clauses = contractService.getClausesByContractIdx(contract.getContractIdx());
		model.addAttribute("contract", contract);
		model.addAttribute("clauses", clauses);
		return "contract/sign";
	}

	@RequestMapping(value = "/manage", method = RequestMethod.GET)
	public String manage(@RequestParam("constructionIdx") int constructionIdx, Model model, HttpSession session) {
		int role = (int) session.getAttribute("role");
		if (role == 1) {
			Integer sessionCIdx = (Integer) session.getAttribute("constructionIdx");
			if (sessionCIdx == null || sessionCIdx != constructionIdx) {
				return "redirect:/contract/manage?constructionIdx=" + (sessionCIdx != null ? sessionCIdx : constructionIdx);
			}
		}
		List<Contract> list = contractMapper.getListByConstructionIdx(constructionIdx);
		java.util.Map<String, Object> construction = contractMapper.getConstructionBasic(constructionIdx);
		model.addAttribute("contractList", list);
		model.addAttribute("constructionIdx", constructionIdx);
		model.addAttribute("construction", construction);
		return "contract/manage";
	}

	@ResponseBody
	@RequestMapping(value = "/ajax/list", method = RequestMethod.GET)
	public List<Contract> ajaxList(@RequestParam("constructionIdx") int constructionIdx) {
		return contractMapper.getListByConstructionIdx(constructionIdx);
	}

	@ResponseBody
	@RequestMapping(value = "/ajax/detail", method = RequestMethod.GET)
	public Map<String, Object> ajaxDetail(@RequestParam("contractIdx") int contractIdx) {
		Contract contract = contractMapper.get(contractIdx);
		List<ContractClause> clauses = contractService.getClausesByContractIdx(contractIdx);
		Map<String, Object> result = new LinkedHashMap<>();
		result.put("contract", contract);
		result.put("clauses", clauses);
		return result;
	}

	@ResponseBody
	@RequestMapping(value = "/ajax/regist", method = RequestMethod.POST)
	public Map<String, Object> ajaxRegist(@ModelAttribute Contract contract,
			@RequestParam(value = "clauseIdxList", required = false) List<Integer> clauseIdxList) {
		Map<String, Object> result = new LinkedHashMap<>();
		Contract existingDraft = contractMapper.getDraftByConstructionIdx(contract.getConstructionIdx());
		if (existingDraft != null) {
			result.put("success", false);
			result.put("message", "이미 작성 중인 계약서가 있습니다. 서명 완료 후 변경 계약서를 등록하세요.");
			return result;
		}
		contractService.createContract(contract, clauseIdxList);
		result.put("success", true);
		result.put("contractIdx", contract.getContractIdx());
		return result;
	}

	@ResponseBody
	@RequestMapping(value = "/ajax/nextContractNo", method = RequestMethod.GET)
	public String nextContractNo(@RequestParam("constructionIdx") int constructionIdx) {
		java.time.LocalDate today = java.time.LocalDate.now();
		String prefix = String.format("WE-%d-%02d-%02d", today.getYear(), today.getMonthValue(), today.getDayOfMonth());
		int count = contractMapper.countByDatePrefix(prefix + "%");
		return prefix + String.format("-%02d", count + 1);
	}

	@ResponseBody
	@RequestMapping(value = "/ajax/resetToDraft", method = RequestMethod.POST)
	public boolean resetToDraft(@RequestParam("contractIdx") int contractIdx, HttpSession session) {
		Contract contract = contractMapper.getWithBinary(contractIdx);
		if (contract == null || !"SIGNED".equals(contract.getStatus())) return false;

		String backupBy = (String) session.getAttribute("userId");
		contractSignBackupMapper.insertBackup(
			contractIdx,
			contract.getBuyerSignature(),
			contract.getContractPdf(),
			contract.getSignedAt(),
			backupBy
		);

		contractMapper.resetToDraft(contractIdx);
		return true;
	}

	@ResponseBody
	@RequestMapping(value = "/ajax/update", method = RequestMethod.POST)
	public boolean ajaxUpdate(@ModelAttribute Contract contract,
			@RequestParam(value = "clauseIdxList", required = false) List<Integer> clauseIdxList) {
		Contract existing = contractMapper.get(contract.getContractIdx());
		if (existing == null || "SIGNED".equals(existing.getStatus())) {
			return false;
		}
		contractMapper.update(contract);
		contractService.updateClauses(contract.getContractIdx(), clauseIdxList);
		return true;
	}

	@RequestMapping(value = "/pdf", method = RequestMethod.GET)
	public void downloadPdf(@RequestParam("contractIdx") int contractIdx, HttpServletResponse response) {
		try {
			Contract contract = contractMapper.getWithBinary(contractIdx);
			if (contract == null || contract.getContractPdf() == null) {
				response.sendError(HttpServletResponse.SC_NOT_FOUND);
				return;
			}
			Map<String, Object> info = contractMapper.getFilenameInfo(contractIdx);
			String groupName       = sanitize((String) info.getOrDefault("groupName", ""));
			String constructionName = sanitize((String) info.getOrDefault("constructionName", ""));
			String locationName    = sanitize((String) info.getOrDefault("locationName", ""));
			String contractNo      = sanitize((String) info.getOrDefault("contractNo", "contract_" + contractIdx));
			String filename = groupName + "_" + constructionName + "_" + locationName + "_" + contractNo + ".pdf";
			String encodedFilename = java.net.URLEncoder.encode(filename, "UTF-8").replace("+", "%20");
			response.setContentType("application/pdf");
			response.setHeader("Content-Disposition",
					"attachment; filename=\"" + encodedFilename + "\"; filename*=UTF-8''" + encodedFilename);
			response.setContentLength(contract.getContractPdf().length);
			response.getOutputStream().write(contract.getContractPdf());
			response.getOutputStream().flush();
		} catch (Exception e) {
			try { response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR); } catch (Exception ignored) {}
		}
	}

	private String sanitize(String s) {
		if (s == null) return "";
		return s.replaceAll("시공사|현장", "").replaceAll("[\\\\/:*?\"<>|]", "").trim();
	}

	@ResponseBody
	@RequestMapping(value = "/sign", method = RequestMethod.POST)
	public boolean sign(@RequestParam("contractIdx") int contractIdx,
			@RequestParam("signatureData") String signatureBase64,
			@RequestParam(value = "siteManager", required = false, defaultValue = "") String siteManager,
			javax.servlet.http.HttpSession session) {
		try {
			String base64 = signatureBase64.replaceFirst("data:image/\\w+;base64,", "");
			byte[] signatureBytes = java.util.Base64.getDecoder().decode(base64);
			contractService.signContract(contractIdx, signatureBytes, siteManager);
			session.setAttribute("contractStatus", "SIGNED");
			return true;
		} catch (Exception e) {
			return false;
		}
	}
}
