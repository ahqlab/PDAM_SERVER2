package net.octacomm.sample.dao.mapper;

import java.util.List;

import net.octacomm.sample.domain.ContractClause;

public interface ContractClauseMapper {
	int insert(ContractClause clause);
	ContractClause get(int clauseIdx);
	int update(ContractClause clause);
	int delete(int clauseIdx);
	List<ContractClause> getList();
	List<ContractClause> getListByContractType(String contractType);
	List<ContractClause> getListByContractIdx(int contractIdx);
	int getCount();
}
