package net.octacomm.sample.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import net.octacomm.sample.dao.mapper.ContractConfigMapper;
import net.octacomm.sample.dao.mapper.ContractMapper;
import net.octacomm.sample.dao.mapper.ConstructionMapper;
import net.octacomm.sample.dao.mapper.FranchiseMapper;
import net.octacomm.sample.dao.mapper.GroupMapper;
import net.octacomm.sample.dao.mapper.SurveyMapper;
import net.octacomm.sample.domain.Contract;
import net.octacomm.sample.domain.Construction;
import net.octacomm.sample.domain.ContractConfig;
import net.octacomm.sample.domain.Franchise;
import net.octacomm.sample.domain.Group;
import net.octacomm.sample.domain.Survey;
import net.octacomm.sample.exceptions.InvalidPasswordException;
import net.octacomm.sample.exceptions.NotFoundUserException;
import net.octacomm.sample.service.LoginService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.Errors;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
public class LoginController {
	
	public static final String LOGIN_URL = "/login";
	
	public static final String SURVEY_URL = "/survey";
	
	public static final String DEFAULT_GROUP_TARGET_URL = "/construction/list";
	
	public static final String DEFAULT_ADMIN_TARGET_URL = "/group/list";
	
	public static final String DEFAULT_FC_TARGET_URL = "/construction/list";
	
	public static final String DEFAULT_TARGET_URL = "/device/list";

	@Autowired
	private LoginService loginService;

	@Autowired
	private ContractMapper contractMapper;

	@Autowired
	private ContractConfigMapper contractConfigMapper;

	@Autowired
	private ConstructionMapper conMapper;
	
	@Autowired
	private GroupMapper groupMapper;
	
	@Autowired
	private FranchiseMapper franchiseMapper;
	
	@Autowired
	private SurveyMapper surveyMapper;
	

	@RequestMapping(value = {"", "/"}, method = RequestMethod.GET)
	public String index() {
		return "redirect:" + LOGIN_URL;
	}
	/**
	 * 로그인
	 * 
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/login", method = RequestMethod.GET)
	public String login(Model model) {
		model.addAttribute("domain", new Construction());
		return LOGIN_URL;
	}
	/**
	 * 로그인 진행
	 * 
	 * @param model
	 * @param session
	 * @param user
	 * @param errors
	 * @return
	 */
//	@RequestMapping(value = "/login", method = RequestMethod.POST)
//	public String login(Model model, HttpSession session, Construction construction, Errors errors) {
//		try {
//			Construction result = loginService.login(construction, session);
//			if(result != null) {
//				if(result.getRole() == 0) {
//					return "redirect:" + DEFAULT_ADMIN_TARGET_URL;
//				}else if(result.getRole() == 2) {
//					Group group = groupMapper.selectByUserId(result.getUserId());
//					//return "redirect:" + DEFAULT_GROUP_TARGET_URL + "?groupIdx=" + group.getIdx();
//					return "redirect:" + DEFAULT_GROUP_TARGET_URL;
//				}else if(result.getRole() == 3) {
//					Franchise franchise = franchiseMapper.selectByUserId(result.getUserId());
//					return "redirect:" + DEFAULT_GROUP_TARGET_URL + "?fcIdx=" + franchise.getIdx();
//				}else if(result.getRole() == 4) {
//					//Group group = groupMapper.selectByUserId(result.getUserId());
//					return "redirect:" + DEFAULT_GROUP_TARGET_URL;
//				}
//				return "redirect:" + DEFAULT_TARGET_URL + "?constructionIdx=" + result.getId();
//			}
//			model.addAttribute("errorMessage", "아이디가 비밀번호를 확인하세요.");
//			model.addAttribute("domain", new Construction());
//			return LOGIN_URL;
//		} catch (NotFoundUserException nfe) {
//			model.addAttribute("domain", new Construction());
//			model.addAttribute("errorMessage", "아이디가 존재하지 않습니다.");
//			errors.reject("test", "아이디가 존재하지 않습니다.");
//		} catch (InvalidPasswordException ipe) {
//			model.addAttribute("domain", new Construction());
//			model.addAttribute("errorMessage", "비밀번호가 일치하지 않습니다.");
//			errors.reject("test", "비밀번호가 일치하지 않습니다.");
//		}
//		return LOGIN_URL;
//	}
	
	
	
	/**
	 * 로그인 진행
	 * 
	 * @param model
	 * @param session
	 * @param user
	 * @param errors
	 * @return
	 */
	@RequestMapping(value = "/login", method = RequestMethod.POST)
	public String login(Model model, HttpSession session, Construction construction, RedirectAttributes redirectAttributes, Errors errors) {
		try {
			Construction result = loginService.login(construction, session);
			
			if(result != null) {
				//현장이 시작되고 2주가 흘렀는지 확인
				//2주가 흘렀다면 설문 대상임.
				Construction yes = conMapper.findByIdAndCreateDate(result.getId());
				if(yes != null) {
					List<Survey> surveyCount = surveyMapper.findByConstructioIdx(result.getId(), yes.getConManager());
					//로그인한 아이디 현장이 이미 설문을 등록했는지 아니면 같은 이름이 소장이 먼저 등록을 했는지
					if(surveyCount.size() == 0) {
						//설문등록하지 않았다면 설문페이지로 이동
						//System.err.println("getConManager() : " + result.getConManager());
						redirectAttributes.addFlashAttribute("constructionIdx", result.getId());
						//redirectAttributes.addFlashAttribute("userId", result.getUserId());
						redirectAttributes.addFlashAttribute("userId", construction.getUserId());
						redirectAttributes.addFlashAttribute("userName", construction.getName());
						redirectAttributes.addFlashAttribute("conManager", yes.getConManager());
						//redirectAttributes.addFlashAttribute("password", result.getPassword());
						redirectAttributes.addFlashAttribute("password", construction.getPassword());
						return "redirect:" +  SURVEY_URL;
					}
				}
				
				if(result.getRole() == 0) {
					return "redirect:" + DEFAULT_ADMIN_TARGET_URL;
				}else if(result.getRole() == 2) {
					Group group = groupMapper.selectByUserId(result.getUserId());
					//return "redirect:" + DEFAULT_GROUP_TARGET_URL + "?groupIdx=" + group.getIdx();
					return "redirect:" + DEFAULT_GROUP_TARGET_URL;
				}else if(result.getRole() == 3) {
					Franchise franchise = franchiseMapper.selectByUserId(result.getUserId());
					return "redirect:" + DEFAULT_GROUP_TARGET_URL + "?fcIdx=" + franchise.getIdx();
				}else if(result.getRole() == 4) {
					//Group group = groupMapper.selectByUserId(result.getUserId());
					return "redirect:" + DEFAULT_GROUP_TARGET_URL;
				}
				// 계약 기능 비활성 / 기존 공사(APPLY_FROM_DATE 이전 등록) / 계약 우회 지정 현장이면 바로 통과
				ContractConfig contractConfig = contractConfigMapper.getConfig();
				if (contractConfig == null || contractConfig.getUseContractYn() == 0
						|| conMapper.isContractRequired(result.getId()) == 0
						|| conMapper.getContractSkipYn(result.getId()) == 1) {
					return "redirect:" + DEFAULT_TARGET_URL + "?constructionIdx=" + result.getId();
				}

				// 계약 로직 대상 공사
				List<Contract> contracts = contractMapper.getListByConstructionIdx(result.getId());
				if (!contracts.isEmpty()) {
					Contract draft = contractMapper.getDraftByConstructionIdx(result.getId());
					if (draft != null) {
						session.setAttribute("contractStatus", "DRAFT");
						return "redirect:/contract/sign-view";
					}
					session.setAttribute("contractStatus", "SIGNED");
					return "redirect:" + DEFAULT_TARGET_URL + "?constructionIdx=" + result.getId();
				}

				// 계약서 없음 → 접근 차단 페이지
				return "redirect:/contract/required";
			}

			model.addAttribute("errorMessage", "아이디가 비밀번호를 확인하세요.");
			model.addAttribute("domain", new Construction());
			return LOGIN_URL;
			//return SURVEY_URL;
		} catch (NotFoundUserException nfe) {
			model.addAttribute("domain", new Construction());
			model.addAttribute("errorMessage", "아이디가 존재하지 않습니다.");
			errors.reject("test", "아이디가 존재하지 않습니다.");
		} catch (InvalidPasswordException ipe) {
			model.addAttribute("domain", new Construction());
			model.addAttribute("errorMessage", "비밀번호가 일치하지 않습니다.");
			errors.reject("test", "비밀번호가 일치하지 않습니다.");
		}
		return LOGIN_URL;
		//return SURVEY_URL;
	}
	
	/**
	 * 로그아웃
	 * 
	 * @param httpSession
	 * @return
	 */
	@RequestMapping(value = "/logout", method = RequestMethod.GET)
	public String logout(HttpSession httpSession) {
		httpSession.invalidate();
		return "redirect:" + LOGIN_URL;
	}
	
	
	
	@RequestMapping(value = "/jump", method = RequestMethod.GET)
	public String jump(HttpSession httpSession) {
		return "redirect:" + "/group/list";
	}
	
	
	@RequestMapping(value = "/survey", method = RequestMethod.GET)
	public String surveyView() {
		return "survey";
	}
	
	
	@RequestMapping(value = "/survey", method = RequestMethod.POST)
	public String surveyRegist(Survey survey,  HttpSession session) {
		int rst = 0;
		try {
			rst = surveyMapper.insert(survey);
		} catch (Exception e) {
			rst = -1;
		}
		
		
		if(rst > 0) {
			Construction construction = new Construction();
			construction.setUserId(survey.getUserId());
			construction.setPassword(survey.getPassword());

			Construction result = loginService.login(construction, session);
			if(result != null) {
				if(result.getRole() == 0) {
					return "redirect:" + DEFAULT_ADMIN_TARGET_URL;
				}else if(result.getRole() == 2) {
					Group group = groupMapper.selectByUserId(result.getUserId());
					return "redirect:" + DEFAULT_GROUP_TARGET_URL;
				}else if(result.getRole() == 3) {
					Franchise franchise = franchiseMapper.selectByUserId(result.getUserId());
					return "redirect:" + DEFAULT_GROUP_TARGET_URL + "?fcIdx=" + franchise.getIdx();
				}else if(result.getRole() == 4) {
					return "redirect:" + DEFAULT_GROUP_TARGET_URL;
				}
				Contract draft = contractMapper.getDraftByConstructionIdx(result.getId());
				if (draft != null) {
					return "redirect:/contract/sign-view";
				}
				return "redirect:" + DEFAULT_TARGET_URL + "?constructionIdx=" + result.getId();
			}
		}else if(rst < 0) {
			//say goodBye
			Construction construction = new Construction();
			construction.setUserId(survey.getUserId());
			construction.setPassword(survey.getPassword());

			Construction result = loginService.login(construction, session);
			if(result != null) {
				if(result.getRole() == 0) {
					return "redirect:" + DEFAULT_ADMIN_TARGET_URL;
				}else if(result.getRole() == 2) {
					Group group = groupMapper.selectByUserId(result.getUserId());
					return "redirect:" + DEFAULT_GROUP_TARGET_URL;
				}else if(result.getRole() == 3) {
					Franchise franchise = franchiseMapper.selectByUserId(result.getUserId());
					return "redirect:" + DEFAULT_GROUP_TARGET_URL + "?fcIdx=" + franchise.getIdx();
				}else if(result.getRole() == 4) {
					return "redirect:" + DEFAULT_GROUP_TARGET_URL;
				}
				Contract draft2 = contractMapper.getDraftByConstructionIdx(result.getId());
				if (draft2 != null) {
					return "redirect:/contract/sign-view";
				}
				return "redirect:" + DEFAULT_TARGET_URL + "?constructionIdx=" + result.getId();
			}
		}
		return "redirect:" + LOGIN_URL;
	}
	
}
