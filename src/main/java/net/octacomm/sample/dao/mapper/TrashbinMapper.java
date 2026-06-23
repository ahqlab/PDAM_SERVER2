package net.octacomm.sample.dao.mapper;

import java.util.List;

import org.apache.ibatis.annotations.CacheNamespace;
import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import net.octacomm.sample.dao.CRUDMapper;
import net.octacomm.sample.domain.ApiReport;
import net.octacomm.sample.domain.Construction;
import net.octacomm.sample.domain.ConstructionParam;
import net.octacomm.sample.domain.GReport;
import net.octacomm.sample.domain.Report;
import net.octacomm.sample.domain.ReportMaxCount;
import net.octacomm.sample.domain.ReportOneLine;
import net.octacomm.sample.domain.ReportParam;
import net.octacomm.sample.domain.UpdateReport;

@CacheNamespace
public interface TrashbinMapper extends CRUDMapper<Report, ReportParam, Integer> {

	//public String INSERT_FIELDS = " ( deviceIdx, currentDateTime, location, pileNo , drillingDepth , intrusionDepth, balance, connectLength, managedStandard, avgPenetrationValue, totalPenetrationValue, hammaT, fallMeter  )";

	//public String INSERT_VALUES = " ( #{deviceIdx}, #{currentDateTime}, #{location}, #{pileNo} , #{drillingDepth} , #{intrusionDepth}, #{balance}, #{connectLength}, #{managedStandard}, #{avgPenetrationValue}, #{totalPenetrationValue}, #{hammaT}, #{fallMeter})";

	public String TABLE_NAME = " TB_REPORT ";

	public String UPDATE_VALUES = " pileType = #{pileType} ,"
			+ "method = #{method} , "
			+ "location = #{location}, "
			+ "pileNo = #{pileNo} ,"
			+ "pileStandard = #{pileStandard} , "
			+ "drillingDepth = #{drillingDepth} , "
			+ "intrusionDepth = #{intrusionDepth}  , "  
			+ "balance = #{balance}  ,"
			+ "connectLength = #{connectLength}  , "
			+ "totalConnectWidth = #{totalConnectWidth}  ,"
			+ "managedStandard = #{managedStandard}  , "
			+ "hammaT = #{hammaT}  , "
			+ "fallMeter = #{fallMeter} ,"
			+ "ultimateBearingCapacity = #{ultimateBearingCapacity} , "
			+ "hammaEfficiency = #{hammaEfficiency} , "
			+ "crossSection = #{crossSection} , "
			+ "modulusElasticity = #{modulusElasticity} , "
			+ "avgPenetrationValue = #{avgPenetrationValue} ,"
			+ "totalPenetrationValue = #{totalPenetrationValue} , "
			+ "isDuple = (select * from (select IF(count(*) > 1, 1, 0) from TB_REPORT where deviceIdx = #{deviceIdx} and pileNo = #{pileNo} and location = #{location} AND isDel = 0 )  as a ) , "
			+ "bigo = #{bigo} , "
			+ "sprCol1 = #{sprCol1} ";
	public String SELECT_FIELDS = " id, deviceIdx, currentDateTime, location, pileNo , drillingDepth , intrusionDepth, balance, connectLength, managedStandard, avgPenetrationValue, totalPenetrationValue , hammaT, fallMeter, ultimateBearingCapacity, crossSection , hammaEfficiency , modulusElasticity, bigo , sprCol1";

	@Override
	int insert(Report report);
	
	int insertOrigin(Report report);

	@Select("SELECT * FROM " + TABLE_NAME + " WHERE id =  #{id}")
	@Override
	Report get(Integer id);
	
	@Update("UPDATE  " + TABLE_NAME + " SET " + UPDATE_VALUES  + " WHERE id =  #{id}")
	int update(UpdateReport report);

	@Delete("DELETE FROM " + TABLE_NAME + " WHERE id =  #{id}")
	@Override
	int delete(Integer id);

	@Select("SELECT" + SELECT_FIELDS + "FROM " + TABLE_NAME)
	@Override
	public List<Report> getList();
	
	@Override
	List<Report> getListByParam(
			@Param("startRow") int startRow,
			@Param("pageSize") int pageSize,
			@Param("param") ReportParam param);
	
	List<ReportOneLine> getReportOneLineListByParam(
			@Param("startRow") int startRow,
			@Param("pageSize") int pageSize,
			@Param("param") ReportParam param);
	
	
	
	List<Report> getListByParamExcel(@Param("param") ReportParam param);
	
	List<ReportOneLine> getListByParamExcelAll(@Param("param") ReportParam param);
	
	List<ReportOneLine> getListByParamExcelAllBig(@Param("param") ReportParam param);
	
	@Override
	int getCountByParam(@Param("param") ReportParam param);
	
	int getCountByParamNotDelete(@Param("param") ReportParam param);
	
	@Update("UPDATE " + TABLE_NAME + " SET isDel = 1 where id = #{id}")
	int doDelete(int id);
	

	@Update("UPDATE " + TABLE_NAME + " SET isDel = 0 where id = #{id}")
	int doRestore(int id);

	void insert2(Report report);
	
	void insert2Origin(Report report);
	
	int insertG(GReport report);
	
	int insertGOrigin(GReport report);
	
	int insertG2(GReport report);
	
	int insertG2Origin(GReport report);
	
	@Select("SELECT " + 
			" C.name as '현장명', " + 
			" B.machineNumber as  '기기번호', " +
			" A.currentDateTime AS '시공일자', " +
		    " A.location AS '위치', " +
		    " A.pileNo AS '파일번호', " +
		    " A.pileStandard AS '파일규격', " +
		    " A.drillingDepth AS '천공깊이', "+
		    " A.intrusionDepth AS '관입깊이', "+
		    " A.balance AS '파일잔량', "+
		    " A.connectLength AS '이음개소', "+
		    " A.managedStandard AS '관리기준', "+
		    " A.avgPenetrationValue AS '평균관입량', "+
		    " A.totalPenetrationValue AS '최종관입량', "+
		    " A.hammaT AS '헤머무게', "+
		    " A.fallMeter AS '낙하높이', "+
		    " A.pileType AS '파일종류', "+
		    " A.method AS '공법', "+
		    " A.totalConnectWidth AS '최종관입량', "+
		    " A.ultimateBearingCapacity AS '극한지지력', "+
		    " A.crossSection AS '단면적', "+
		    " A.hammaEfficiency AS '헤머효율', "+
		    " A.modulusElasticity AS '탄성계수' "+
			" FROM TB_REPORT A , TB_DEVICE B, TB_CONSTRUCTION C " + 
		    " WHERE A.deviceIdx = B.id AND B.constructionIdx = C.id " + 
			" AND A.deviceIdx IN (" + 
			"  SELECT D.id " +
			"           FROM (SELECT * " +
			"                 FROM TB_CONSTRUCTION " +
			"                 WHERE groupIdx = (SELECT idx " +
			"                                   FROM TB_GROUP " +
			"                                   WHERE TB_GROUP.userId = 'hd0001')) C, " +
			"                TB_DEVICE D " +
			"           WHERE C.id = D.constructionIdx) " +
			" ORDER BY A.deviceIdx ASC, A.createDate DESC ")
	List<ApiReport> getApiReport();
	
	
	@Select("SELECT COUNT(*) FROM (SELECT deviceIdx, pileNo, location FROM " + TABLE_NAME + "  WHERE deviceIdx =  #{id} and isDel = 0 GROUP BY deviceIdx, pileNo, location) A")
	int getCount(ReportParam param);
	

	@Select("        SELECT " + 
			"			      count(distinct deviceIdx,location, pileNo) " + 
			"			    FROM " + 
			"			        TB_REPORT " + 
			"			    WHERE " + 
			"			        deviceIdx IN (SELECT " + 
			"			                id " + 
			"			            FROM " + 
			"			                TB_DEVICE " + 
			"			            WHERE " + 
			"			                constructionIdx = #{constructionIdx} AND isDel = 0) " + 
			"			            AND isDel = 0")
	int getCountByConstruction(@Param("constructionIdx") int constructionIdx);

	
	@Select("SELECT deviceIdx, COUNT(*) AS cnt FROM TB_REPORT GROUP BY deviceIdx ORDER BY COUNT(*) DESC LIMIT 1")
	ReportMaxCount getMaxCount();
	
	
	@Select("SELECT COUNT(*) FROM (" + 
			"SELECT D.reportIdx, COUNT(*) FROM TB_CONSTRUCTION A, TB_DEVICE B , TB_REPORT C , TB_PENETRATION D " + 
			"WHERE A.id = B.constructionIdx " + 
			"AND B.id = C.deviceIdx " + 
			"AND C.id = D.reportIdx " + 
			"AND A.ID = #{constructionIdx} " + 
			"AND D.value > 0 " + 
			"GROUP BY D.reportIdx HAVING  COUNT(*) > 5) A ")
	int isOriginBigAllReports(@Param("constructionIdx") int constructionIdx);
	
	
	int isBigAllReports(@Param("param") ReportParam param);
	
	@Select("SELECT COUNT(*) FROM TB_REPORT WHERE deviceIdx = #{deviceIdx} AND location =  #{location} AND pileNo = #{pileNo} AND isDel = 0 ")
	int isDuplication(Report report2);
	
	
	@Update("UPDATE " + TABLE_NAME + " SET isDuple = 1 where id = #{id}")
	void updateDupl(Report report2);
	
	
	@Update("UPDATE " + TABLE_NAME + " SET isDuple = 0 where id = #{id}")
	void updateDupl2(Report report2);

	@Select("select count(*) from TB_REPORT WHERE TB_REPORT.deviceIdx = TB.deviceIdx and TB_REPORT.pileNo = TB.pileNo and TB_REPORT.location = TB.location and TB_REPORT.isDel = 0" )
	int getIsDuple(Report rp);
	
	@Select("SELECT * FROM TB_REPORT WHERE deviceIdx = #{deviceIdx} AND location =  #{location} AND pileNo = #{pileNo} AND isDel = 0 AND id <> #{id} LIMIT 1")
	Report getDuplicationRepots(Report report);

	@Select("SELECT COUNT(*) FROM TB_REPORT WHERE deviceIdx = #{deviceIdx} AND location =  #{location} AND pileNo = #{pileNo} AND isDel = 0  AND id <> #{id} ")
	int isDuplication2(Report rp);

	
	@Select("SELECT * FROM TB_REPORT WHERE deviceIdx = #{deviceIdx} AND location =  #{location} AND pileNo = #{pileNo} AND isDel = 0 AND id <> #{id}")
	List<Report> getDuplicationRepotsAll(Report rp);
	
	
	@Select("SELECT * FROM TB_REPORT WHERE deviceIdx = #{deviceIdx} AND location =  #{location} AND pileNo = #{pileNo} order by isDuple asc")
	List<Report> getDuplicationRepotsAllReport(UpdateReport rp);

	List<ReportOneLine> getTodayListByPdf(@Param("constructionIdx") int constructionIdx, @Param("machineNumber") String machineNumber, @Param("currentDateTime") String currentDateTime);

	List<ReportOneLine> getMachineListByPdf(@Param("constructionIdx") int constructionIdx, @Param("machineNumber") String machineNumber);

	List<ReportOneLine> getListByParamExcelTen(@Param("param") ReportParam param);
	
	List<ReportOneLine> getListByParamExcelFive(@Param("param") ReportParam param);
	
	@Select("SELECT count(*) as ng_quantity  FROM TB_REPORT WHERE deviceIdx IN (SELECT id FROM TB_DEVICE WHERE constructionIdx = #{constructionIdx} ) AND bigo like '%ng%' AND isDel = 0  ")
	int getNgQuantity(@Param("constructionIdx") int constructionIdx);

	@Select("SELECT COUNT(*) FROM TB_REPORT WHERE deviceIdx = #{deviceIdx} AND location =  #{location} AND pileNo = #{pileNo} AND isDel = 0 ")
	int isGDuplication(GReport report);

	@Update("UPDATE " + TABLE_NAME + " SET isDuple = 1 where id = #{id}")
	void updateGDupl(GReport report);
	
	int getSimpleListCountByParam(@Param("param") ReportParam param);
	
	List<Report> getSimpleListByParam(
			@Param("startRow") int startRow,
			@Param("pageSize") int pageSize,
			@Param("param") ReportParam param);

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}
