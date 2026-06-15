package net.octacomm.sample.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import net.octacomm.sample.dao.mapper.ContractClauseMapper;
import net.octacomm.sample.dao.mapper.ContractMapper;
import net.octacomm.sample.domain.Contract;
import net.octacomm.sample.domain.ContractClause;

@Service
public class ContractServiceImpl implements ContractService {

	@Autowired
	private ContractMapper contractMapper;

	@Autowired
	private ContractClauseMapper contractClauseMapper;

	@Autowired
	private ContractPdfService contractPdfService;

	@Override
	@Transactional
	public int createContract(Contract contract, List<Integer> clauseIdxList) {
		int result = contractMapper.insert(contract);
		if (result == 1 && clauseIdxList != null) {
			for (Integer clauseIdx : clauseIdxList) {
				contractMapper.insertClauseConfirm(contract.getContractIdx(), clauseIdx);
			}
		}
		return result;
	}

	@Override
	@Transactional
	public int updateClauses(int contractIdx, List<Integer> clauseIdxList) {
		contractMapper.deleteClauseConfirm(contractIdx);
		if (clauseIdxList != null) {
			for (Integer clauseIdx : clauseIdxList) {
				contractMapper.insertClauseConfirm(contractIdx, clauseIdx);
			}
		}
		return 1;
	}

	@Override
	@Transactional
	public int signContract(int contractIdx, byte[] signatureImageBytes, String siteManager) {
		int result = contractMapper.updateBuyerSignature(contractIdx, signatureImageBytes, siteManager);
		if (result > 0) {
			try {
				Contract contract = contractMapper.getWithBinary(contractIdx);
				List<ContractClause> clauses = contractClauseMapper.getListByContractIdx(contractIdx);
				byte[] pdfBytes = contractPdfService.generatePdf(contract, clauses);
				contractMapper.updateContractPdf(contractIdx, pdfBytes);
			} catch (Exception e) {
				System.err.println("[ContractService] PDF 생성 실패 contractIdx=" + contractIdx + " : " + e.getMessage());
				e.printStackTrace();
			}
		}
		return result;
	}

	@Override
	public List<ContractClause> getClausesByContractIdx(int contractIdx) {
		return contractClauseMapper.getListByContractIdx(contractIdx);
	}
}
