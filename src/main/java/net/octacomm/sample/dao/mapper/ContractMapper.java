package net.octacomm.sample.dao.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import net.octacomm.sample.domain.Contract;
import net.octacomm.sample.domain.ContractParam;

public interface ContractMapper {
	int insert(Contract contract);
	Contract get(int contractIdx);
	Contract getWithBinary(int contractIdx);
	int update(Contract contract);
	int delete(int contractIdx);
	List<Contract> getListByParam(@Param("param") ContractParam param);
	int getCountByParam(@Param("param") ContractParam param);
	List<Contract> getListByConstructionIdx(int constructionIdx);
	Contract getDraftByConstructionIdx(int constructionIdx);
	Map<String, Object> getConstructionBasic(int constructionIdx);
	int insertClauseConfirm(@Param("contractIdx") int contractIdx, @Param("clauseIdx") int clauseIdx);
	int deleteClauseConfirm(int contractIdx);
	int resetToDraft(int contractIdx);
	int updateStatus(@Param("contractIdx") int contractIdx, @Param("status") String status);
	int updateBuyerSignature(@Param("contractIdx") int contractIdx, @Param("buyerSignature") byte[] buyerSignature, @Param("siteManager") String siteManager);
	int updateContractPdf(@Param("contractIdx") int contractIdx, @Param("contractPdf") byte[] contractPdf);
	int countByDatePrefix(@Param("datePrefix") String datePrefix);
	Map<String, Object> getFilenameInfo(int contractIdx);
}
