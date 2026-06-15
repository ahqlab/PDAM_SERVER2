package net.octacomm.sample.interceptor;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import net.octacomm.sample.dao.mapper.ContractConfigMapper;
import net.octacomm.sample.dao.mapper.ContractMapper;
import net.octacomm.sample.dao.mapper.ConstructionMapper;
import net.octacomm.sample.domain.Contract;
import net.octacomm.sample.domain.ContractConfig;

@Component
public class ContractInterceptor extends HandlerInterceptorAdapter {

	@Autowired
	private ContractMapper contractMapper;

	@Autowired
	private ContractConfigMapper contractConfigMapper;

	@Autowired
	private ConstructionMapper constructionMapper;

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {

		HttpSession session = request.getSession(false);
		if (session == null) return true;

		Integer role = (Integer) session.getAttribute("role");
		// role=0 (관리자) 및 role!=1 은 계약 로직 대상 아님
		if (role == null || role != 1) return true;

		Integer constructionIdx = (Integer) session.getAttribute("constructionIdx");
		if (constructionIdx == null) return true;

		// AJAX 요청은 리다이렉트하지 않음
		if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) return true;

		// 0. 이용요금 미납으로 인한 접속 차단 여부 확인
		if (constructionMapper.getBlockedYn(constructionIdx) == 1) {
			response.sendRedirect(request.getContextPath() + "/contract/blocked");
			return false;
		}

		// 1. 전역 계약 기능 활성 여부 확인
		ContractConfig config = contractConfigMapper.getConfig();
		if (config == null || config.getUseContractYn() == 0) return true;

		// 2. 이 공사가 계약 로직 대상인지 확인 (APPLY_FROM_DATE 이후 등록 여부)
		if (constructionMapper.isContractRequired(constructionIdx) == 0) return true;

		// 3. 계약서 서명 대기 상태 → 서명 페이지
		Contract draft = contractMapper.getDraftByConstructionIdx(constructionIdx);
		if (draft != null) {
			response.sendRedirect(request.getContextPath() + "/contract/sign-view");
			return false;
		}

		// 4. 계약서 자체가 없음 → 접근 차단
		List<Contract> contracts = contractMapper.getListByConstructionIdx(constructionIdx);
		if (contracts.isEmpty()) {
			response.sendRedirect(request.getContextPath() + "/contract/required");
			return false;
		}

		return true;
	}
}
