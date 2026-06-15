package net.octacomm.sample.service;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.util.Base64;
import java.util.List;

import javax.servlet.ServletContext;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.openhtmltopdf.pdfboxout.PdfRendererBuilder;

import net.octacomm.sample.domain.Contract;
import net.octacomm.sample.domain.ContractClause;

@Service
public class ContractPdfService {

	@Autowired
	private ServletContext servletContext;

	public byte[] generatePdf(Contract contract, List<ContractClause> clauses) throws Exception {
		String html = buildHtml(contract, clauses);
		ByteArrayOutputStream os = new ByteArrayOutputStream();
		PdfRendererBuilder builder = new PdfRendererBuilder();
		builder.useFastMode();
		builder.withHtmlContent(html, null);
		File fontFile = resolveFont();
		if (fontFile != null) {
			builder.useFont(fontFile, "MalgunGothic");
		}
		builder.toStream(os);
		builder.run();
		return os.toByteArray();
	}

	private File resolveFont() {
		// 1. Windows 로컬 경로
		File win = new File("C:/Windows/Fonts/malgun.ttf");
		if (win.exists()) return win;
		// 2. classpath 번들 폰트 (서버 배포 시)
		try (InputStream is = getClass().getResourceAsStream("/fonts/malgun.ttf")) {
			if (is != null) {
				File tmp = File.createTempFile("malgun", ".ttf");
				tmp.deleteOnExit();
				Files.copy(is, tmp.toPath(), StandardCopyOption.REPLACE_EXISTING);
				return tmp;
			}
		} catch (Exception e) {
			// 폰트 없이 진행
		}
		return null;
	}

	private String buildHtml(Contract contract, List<ContractClause> clauses) {
		String sigBase64 = "";
		if (contract.getBuyerSignature() != null) {
			sigBase64 = Base64.getEncoder().encodeToString(contract.getBuyerSignature());
		}
		String sealBase64 = getSealBase64();

		String typeStr = "DAILY".equals(contract.getContractType()) ? "일사용료" : "월사용료";

		StringBuilder sb = new StringBuilder();
		sb.append("<!DOCTYPE html><html><head><meta charset='UTF-8'/><style>");
		sb.append("@page{size:A4;margin:9mm 13mm;}");
		sb.append("body{font-family:'MalgunGothic','SegoeSymbol',serif;font-size:12px;margin:0;}");
		sb.append("h2{font-size:18px;text-align:center;margin:0 0 1px;}");
		sb.append(".sub{text-align:center;color:#555;margin:0 0 5px;font-size:11px;}");
		sb.append("table{width:100%;border-collapse:collapse;margin-bottom:4px;table-layout:fixed;}");
		sb.append("th{border:1px solid #ccc;padding:5px 7px;background:#f5f5f5;width:15%;font-size:11.5px;line-height:1.3;}");
		sb.append("td{border:1px solid #ccc;padding:5px 7px;font-size:11.5px;width:35%;line-height:1.3;}");
		sb.append(".hdr{background:#f0f0f0;font-weight:bold;width:50%;}");
		sb.append(".clause{font-size:11px;margin-bottom:3px;line-height:1.4;}.chk{font-size:9px;color:#28a745;font-weight:bold;white-space:nowrap;}");
		sb.append(".note{font-size:11px;color:#333;line-height:1.5;margin-top:12px;border-top:1px solid #ccc;padding-top:9px;}");
		sb.append(".note p{margin:1px 0;}");
		sb.append(".foot-text{text-align:center;font-weight:bold;font-size:11.5px;margin:7px 0 2px;}");
		sb.append(".foot-date{text-align:center;font-weight:bold;font-size:11.5px;margin-bottom:3px;}");
		sb.append("</style></head><body>");

		sb.append("<h2>PDAM 시스템 공급 계약서</h2>");
		sb.append("<p class='sub'>계약번호: ").append(esc(contract.getContractNo())).append("</p>");

		sb.append("<table><colgroup><col style='width:15%'/><col style='width:35%'/><col style='width:15%'/><col style='width:35%'/></colgroup>");
		sb.append("<tr><th>계약유형</th><td>").append(typeStr).append("</td><th>상태</th><td>서명완료</td></tr>");
		sb.append("<tr><th>현장명</th><td>").append(esc(contract.getSiteName())).append("</td><th>회사명</th><td>").append(esc(contract.getCompanyName())).append("</td></tr>");
		sb.append("<tr><th>모델명</th><td>").append(esc(contract.getModelName())).append("</td><th>공급기간</th><td>").append(esc(contract.getSupplyDeadline())).append("</td></tr>");
		sb.append("<tr><th>사용료</th><td colspan='3'>").append(esc(contract.getDailyFee())).append("</td></tr>");
		sb.append("</table>");

		boolean isMonthly = !"DAILY".equals(contract.getContractType());
		if (isMonthly) {
			sb.append("<p style='font-size:14px;font-weight:bold;margin:13px 0 8px;'>※ 계약 조건 - PDAM시스템 1개월 이상 사용조건</p>");
		} else {
			sb.append("<p style='font-size:14px;font-weight:bold;margin:13px 0 8px;'>※ 계약 조건 - PDAM시스템 1개월 미만 사용 조건</p>");
		}
		sb.append("<p style='font-size:16px;font-weight:bold;margin:0 0 4px;'>계약 조항</p>");
		for (ContractClause cl : clauses) {
			sb.append("<p class='clause'><strong>제").append(cl.getClauseNo()).append("조</strong>&#160;&#160;").append(bold(cl.getClauseContent())).append("&#160;<span class='chk'>[V]</span></p>");
		}

		sb.append("<div class='note'>");
		if (isMonthly) {
			sb.append("<p>※ 동일사업장 PDAM시스템 SET 추가시 계약서 및 계약조건은 위 내용과 동일하다.</p>");
		} else {
			sb.append("<p>※ PDAM 시스템 SET 추가 시, 계약서 및 계약 조건은 위 내용과 동일합니다.</p>");
		}
		sb.append("<p style='margin-top:4px;'>※ 협조 및 유의 사항</p>");
		sb.append("<p style='padding-left:10px;'>약정된 결제 기간(30일) 이내에 대금이 납부되지 않을 경우, 현장 기기 사용은 가능하나 서버 접속 및 데이터 연동이 제한될 수 있습니다.</p>");
		sb.append("<p style='padding-left:10px;'>원활한 서비스 이용을 위해 기한 내 납부를 부탁드립니다.</p>");
		sb.append("</div>");

		String footDate = (contract.getSignedAt() != null && !contract.getSignedAt().isEmpty())
				? contract.getSignedAt() : contract.getCreatedAt();
		sb.append("<div style='margin-top:12px;border-top:2px solid #333;padding-top:4px;'>");
		sb.append("<p class='foot-text'>본 계약문서에 의하여 계약을 체결하고 신의에 따라 성실히 계약상의 의무를 이행할 것을 확약하며,</p>");
		sb.append("<p class='foot-text' style='margin-top:1px;'>이 계약의 증거로서 계약서를 작성하여 당사자가 기명, 날인한 후 각각 1통 씩 보관한다.</p>");
		sb.append("<p class='foot-date'>").append(esc(footDate)).append("</p>");

		sb.append("<table><colgroup><col style='width:13%'/><col style='width:12%'/><col style='width:13%'/><col style='width:12%'/><col style='width:15%'/><col style='width:35%'/></colgroup>");
		sb.append("<tr><td colspan='4' class='hdr'>수 요 자 (을)</td><td colspan='2' class='hdr'>공 급 자 (갑)</td></tr>");
		sb.append("<tr><th>상&#160;호</th><td colspan='3'>").append(esc(contract.getReqTradeName())).append("</td><th>상&#160;호</th><td>우리기술 주식회사</td></tr>");
		sb.append("<tr><th>사업자번호</th><td colspan='3'>").append(esc(contract.getReqBusinessNo())).append("</td><th>사업자번호</th><td>787-88-01517</td></tr>");
		sb.append("<tr><th>주&#160;소</th><td colspan='3'>").append(esc(contract.getReqAddress())).append("</td><th>주&#160;소</th><td>대전광역시 대덕구 신탄동로 105 304호(신일동,벤처타운)</td></tr>");
		sb.append("<tr><th>T E L</th><td colspan='3'>").append(esc(contract.getReqTel())).append("</td><th>T E L</th><td>(070) 4334-8000</td></tr>");
		sb.append("<tr><th>대&#160;표</th><td colspan='3'>").append(esc(contract.getReqRepresentative())).append("</td><th rowspan='2'>대&#160;표</th><td rowspan='2' style='vertical-align:middle;'>조상훈</td></tr>");
		sb.append("<tr><th>담&#160;당</th><td colspan='3'>").append(esc(contract.getSiteManager())).append("</td></tr>");
		sb.append("<tr><th>서&#160;명</th><td colspan='3' style='text-align:center;height:68px;'>");
		if (!sigBase64.isEmpty()) {
			sb.append("<img src='data:image/png;base64,").append(sigBase64).append("' style='max-height:60px;max-width:100%;'/>");
		}
		sb.append("</td><th>직&#160;인</th><td style='text-align:center;height:68px;'>");
		if (!sealBase64.isEmpty()) {
			sb.append("<img src='data:image/png;base64,").append(sealBase64).append("' style='max-height:60px;max-width:100%;'/>");
		}
		sb.append("</td></tr></table></div></body></html>");
		return sb.toString();
	}

	private String getSealBase64() {
		try {
			String realPath = servletContext.getRealPath("/resources/new/img/woori_dojang.png");
			File f = new File(realPath);
			if (!f.exists()) return "";
			FileInputStream fis = new FileInputStream(f);
			byte[] bytes = new byte[(int) f.length()];
			fis.read(bytes);
			fis.close();
			return Base64.getEncoder().encodeToString(bytes);
		} catch (Exception e) {
			return "";
		}
	}

	private String esc(String s) {
		if (s == null) return "";
		return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;").replace("\"", "&quot;");
	}

	private String bold(String s) {
		return esc(s).replaceAll("\\*\\*(.+?)\\*\\*", "<b>$1</b>");
	}
}
