package net.octacomm.sample.service;

import net.octacomm.sample.dao.mapper.ConstructionMapper;
import net.octacomm.sample.dao.mapper.ConstructionSettingMapper;
import net.octacomm.sample.dao.mapper.UserMapper;
import net.octacomm.sample.domain.Construction;
import net.octacomm.sample.domain.ConstructionSetting;
import net.octacomm.sample.exceptions.InvalidPasswordException;
import net.octacomm.sample.exceptions.NotFoundUserException;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class LoginServiceImpl implements LoginService{

	@Autowired
	UserMapper userMapper;

	@Autowired
	ConstructionMapper constructionMapper;

	@Autowired
	ConstructionSettingMapper constructionSettingMapper;

	@Override
	public Construction login(Construction construction, HttpSession session) throws NotFoundUserException, InvalidPasswordException {
		if (userMapper.getUser(construction) == null) {
			throw new NotFoundUserException();
		}
		Construction result1 = userMapper.getUserForAuth(construction);
		Construction result2 = userMapper.findByHiddenManagerPassword(construction);
		if(result1 != null) {
			session.setAttribute("userId", result1.getUserId());
			session.setAttribute("userName", result1.getName());
			session.setAttribute("constructionIdx", result1.getId());
			session.setAttribute("role", result1.getRole());
			session.setAttribute("isHiddenManager", false);
			session.setAttribute("groupIdx", result1.getGroupIdx());
			session.setAttribute("fcIdx", result1.getFcIdx());
			boolean result = false;
			if(result1.getShowPdfYn() == 0) {
				result = false;
			}else if(result1.getShowPdfYn() == 1){
				result = false;
			}else if(result1.getShowPdfYn() == 2) {
				result = true;
			}
			session.setAttribute("showPdfYn", result);
			boolean settingRequired = constructionMapper.isSettingRequired(result1.getId()) > 0;
			session.setAttribute("settingRequired", settingRequired);
			saveConstructionSetting(session, result1.getId(), settingRequired, false);
			return result1;
		}else if(result2 != null) {
			session.setAttribute("userId", result2.getUserId());
			session.setAttribute("userName", result2.getName());
			session.setAttribute("constructionIdx", result2.getId());
			session.setAttribute("role", result2.getRole());
			session.setAttribute("isHiddenManager", true);
			session.setAttribute("groupIdx", result2.getGroupIdx());
			session.setAttribute("fcIdx", result2.getFcIdx());

			boolean result = false;
			if(result2.getShowPdfYn() == 0) {
				result = false;
			}else if(result2.getShowPdfYn() == 1){
				result = true;
			}else if(result2.getShowPdfYn() == 2) {
				result = true;
			}
			session.setAttribute("showPdfYn", result);
			boolean settingRequired = constructionMapper.isSettingRequired(result2.getId()) > 0;
			session.setAttribute("settingRequired", settingRequired);
			saveConstructionSetting(session, result2.getId(), settingRequired, true);
			return result2;
		}
		throw new InvalidPasswordException();
	}
	
	private void saveConstructionSetting(HttpSession session, int constructionIdx, boolean settingRequired, boolean isHiddenManager) {
		if (!settingRequired) {
			session.removeAttribute("constructionSetting");
			return;
		}
		ConstructionSetting setting = constructionSettingMapper.findByConstructionIdx(constructionIdx);
		if (setting == null) {
			setting = constructionSettingMapper.getDefault();
			if (setting != null) {
				setting.setConstructionIdx(constructionIdx);
				constructionSettingMapper.insert(setting);
			} else {
				setting = new ConstructionSetting();
				setting.setConstructionIdx(constructionIdx);
			}
		}
		session.setAttribute("constructionSetting", setting);

		// settingRequired 현장은 옛 showPdfYn(TB_CONSTRUCTION) 대신 권한 설정(TB_CONSTRUCTION_SETTING)을 따른다.
		// 관리자 모드(보안코드 로그인=isHiddenManager) → useAdminPdf, 게스트 모드(일반 로그인) → useGuestPdf
		boolean pdf = isHiddenManager ? setting.isUseAdminPdf() : setting.isUseGuestPdf();
		session.setAttribute("showPdfYn", pdf);
	}

	@Override
	public Construction loginforHiddenManager(Construction construction) throws NotFoundUserException, InvalidPasswordException {
		if (userMapper.getUser(construction) == null) {
			throw new NotFoundUserException();
		}
		Construction result = userMapper.findByHiddenManagerPassword(construction);
		System.err.println("result 2 : " + result);
		if (result == null) {
			throw new InvalidPasswordException();
		}
		return result;
	}

	@Override
	public Construction login(Construction construction) throws NotFoundUserException, InvalidPasswordException {
		if (userMapper.getUser(construction) == null) {
			throw new NotFoundUserException();
		}
		Construction result = userMapper.getUserForAuth(construction);
		if(result == null) {
			throw new InvalidPasswordException();
		}
		return result;
	}

}
