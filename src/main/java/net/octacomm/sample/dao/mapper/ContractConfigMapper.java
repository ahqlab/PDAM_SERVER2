package net.octacomm.sample.dao.mapper;

import org.apache.ibatis.annotations.Select;

import net.octacomm.sample.domain.ContractConfig;

public interface ContractConfigMapper {

	@Select("SELECT APPLY_FROM_DATE applyFromDate, USE_CONTRACT_YN useContractYn FROM TB_CONTRACT_CONFIG LIMIT 1")
	ContractConfig getConfig();
}
