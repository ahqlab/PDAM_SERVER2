package net.octacomm.sample.dao.mapper;

import org.apache.ibatis.annotations.Param;

public interface ContractSignBackupMapper {

	int insertBackup(@Param("contractIdx") int contractIdx,
	                 @Param("buyerSignature") byte[] buyerSignature,
	                 @Param("contractPdf") byte[] contractPdf,
	                 @Param("signedAt") String signedAt,
	                 @Param("backupBy") String backupBy);
}
