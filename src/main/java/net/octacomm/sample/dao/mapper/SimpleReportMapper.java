package net.octacomm.sample.dao.mapper;

import java.util.List;

import org.apache.ibatis.annotations.CacheNamespace;
import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import net.octacomm.sample.dao.CRUDMapper;
import net.octacomm.sample.domain.ApiReport;
import net.octacomm.sample.domain.Report;
import net.octacomm.sample.domain.ReportParam;
import net.octacomm.sample.domain.SimpleReport;
import net.octacomm.sample.domain.SimpleReportParam;
import net.octacomm.sample.domain.UpdateReport;

@CacheNamespace
public interface SimpleReportMapper extends CRUDMapper<Report, ReportParam, Integer> {

	// 총 시공량(전체 파일 수): 목록 조건과 동일, GROUP BY 없이 전체 COUNT
	int getTotalConstruction(@Param("param") ReportParam param);

}
