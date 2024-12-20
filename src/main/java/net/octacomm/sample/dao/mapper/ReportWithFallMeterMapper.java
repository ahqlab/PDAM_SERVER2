package net.octacomm.sample.dao.mapper;


import java.util.List;

import org.apache.ibatis.annotations.CacheNamespace;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import net.octacomm.sample.dao.CRUDMapper;
import net.octacomm.sample.domain.FallMeter;
import net.octacomm.sample.domain.ReportParam;
import net.octacomm.sample.domain.ReportWithFallMeter;

@CacheNamespace
public interface ReportWithFallMeterMapper extends CRUDMapper<ReportWithFallMeter, ReportParam, Integer> {

	void insert2(ReportWithFallMeter report);
	
	int insertOrigin(ReportWithFallMeter report);
	
	void insert2Origin(ReportWithFallMeter report);
	
	@Select("SELECT COUNT(*) FROM TB_REPORT WHERE deviceIdx = #{deviceIdx} AND location =  #{location} AND pileNo = #{pileNo} AND isDel = 0 ")
	int isDuplication(ReportWithFallMeter report);
	
	@Update("UPDATE TB_REPORT SET isDuple = 1 where id = #{id}")
	void updateDupl(ReportWithFallMeter report);
	
	@Select("SELECT id, reportIdx, name , value FROM TB_FALL_METER where reportIdx = #{reportIdx}")
	List<FallMeter> getListByReportIdxOfCopy(@Param("reportIdx") int reportIdx);
	
	

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}
