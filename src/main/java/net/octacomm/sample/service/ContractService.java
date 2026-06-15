package net.octacomm.sample.service;

import java.util.List;

import net.octacomm.sample.domain.Contract;
import net.octacomm.sample.domain.ContractClause;

public interface ContractService {
	int createContract(Contract contract, List<Integer> clauseIdxList);
	int updateClauses(int contractIdx, List<Integer> clauseIdxList);
	int signContract(int contractIdx, byte[] signatureImageBytes, String siteManager);
	List<ContractClause> getClausesByContractIdx(int contractIdx);
}
