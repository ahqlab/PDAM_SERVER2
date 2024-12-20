package net.octacomm.sample.dao.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import net.octacomm.sample.dao.CRUDMapper;
import net.octacomm.sample.domain.DefaultParam;
import net.octacomm.sample.domain.PileQntPlanMng;
import net.octacomm.sample.domain.PileQntPlanMngParam;

public interface PileQntPlanMngMapper extends CRUDMapper<PileQntPlanMng, PileQntPlanMngParam, Integer> {
	
	public String INSERT_FIELDS = " ( id , constructionIdx, localName, planCount, localReport  , createDate, lastModifiedDate )";
	
	public String INSERT_VALUES = " ( null, #{constructionIdx} , #{localName}, #{planCount}, #{localReport}, now(),  now() )";
	
	public String TABLE_NAME = " TB_PILE_QNT_PLAN_MNG ";
	
	public String UPDATE_VALUES = " localName = #{localName} , planCount = #{planCount} , localReport = #{localReport} , lastModifiedDate = now() ";
	
	public String SELECT_FIELDS = "  constructionIdx, localName, planCount, localReport  , createDate, lastModifiedDate ";

	
	@Insert("INSERT INTO " + TABLE_NAME + " " + INSERT_FIELDS + " VALUES " + INSERT_VALUES)
	@Override
	int insert(PileQntPlanMng PileQntPlanMng);
	
	@Select("SELECT * FROM " + TABLE_NAME + " WHERE constructionIdx =  #{constructionIdx}")
	@Override
	PileQntPlanMng get(Integer id);

	@Update("UPDATE  " + TABLE_NAME + " SET " + UPDATE_VALUES  + " WHERE id =  #{id}")
	@Override
	int update(PileQntPlanMng PileQntPlanMng);
	
	@Delete("DELETE FROM " + TABLE_NAME + " WHERE id =  #{id}")
	@Override
	int delete(Integer id);

	@Select("SELECT * FROM " + TABLE_NAME)
	@Override
	List<PileQntPlanMng> getList();
	
	
	@Delete("DELETE FROM " + TABLE_NAME + " WHERE  constructionIdx =  #{constructionIdx}")
	void deleteByConstructionIdx(@Param("constructionIdx") int constructionIdx);
	
	@Select("SELECT * FROM " + TABLE_NAME + " WHERE constructionIdx =  #{constructionIdx} order by id asc")
	List<PileQntPlanMng>  selectByConstructionIdx(int constructionIdx);
	
	int insertMulti(@Param("list") List<PileQntPlanMng> list);
}
