package net.octacomm.sample.dao.mapper;

import org.apache.ibatis.annotations.CacheNamespace;
import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Result;
import org.apache.ibatis.annotations.Results;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import net.octacomm.sample.dao.CRUDMapper;
import net.octacomm.sample.domain.ConstructionSetting;
import net.octacomm.sample.domain.ConstructionSettingParam;

@CacheNamespace
public interface ConstructionSettingMapper extends CRUDMapper<ConstructionSetting, ConstructionSettingParam, Integer> {

    String TABLE_NAME = "TB_CONSTRUCTION_SETTING";

    String INSERT_FIELDS = "("
            + "constructionIdx, "
            + "useAdminReportTime, useGuestReportTime, useAdminOriginData, useGuestOriginData,"
            + "useAdminFileMenu, useGuestFileMenu, useAdminPdf, useGuestPdf,"
            + "useAdminExcel, useGuestExcel, useAdminTrash, useGuestTrash,"
            + "useAdminEditReport, useGuestEditReport, useAdminDeleteReport, useGuestDeleteReport,"
            + "useAdminRestoreReport, useGuestRestoreReport, useAdminEditDai, useGuestEditDai,"
            + "useAdminUbc, useGuestUbc"
            + ")";

    String INSERT_VALUES = "("
            + "#{constructionIdx}, "
            + "#{useAdminReportTime}, #{useGuestReportTime}, #{useAdminOriginData}, #{useGuestOriginData},"
            + "#{useAdminFileMenu}, #{useGuestFileMenu}, #{useAdminPdf}, #{useGuestPdf},"
            + "#{useAdminExcel}, #{useGuestExcel}, #{useAdminTrash}, #{useGuestTrash},"
            + "#{useAdminEditReport}, #{useGuestEditReport}, #{useAdminDeleteReport}, #{useGuestDeleteReport},"
            + "#{useAdminRestoreReport}, #{useGuestRestoreReport}, #{useAdminEditDai}, #{useGuestEditDai},"
            + "#{useAdminUbc}, #{useGuestUbc}"
            + ")";

    String UPDATE_VALUES = "useAdminReportTime=#{useAdminReportTime}, useGuestReportTime=#{useGuestReportTime}, "
            + "useAdminOriginData=#{useAdminOriginData}, useGuestOriginData=#{useGuestOriginData}, "
            + "useAdminFileMenu=#{useAdminFileMenu}, useGuestFileMenu=#{useGuestFileMenu}, "
            + "useAdminPdf=#{useAdminPdf}, useGuestPdf=#{useGuestPdf}, "
            + "useAdminExcel=#{useAdminExcel}, useGuestExcel=#{useGuestExcel}, "
            + "useAdminTrash=#{useAdminTrash}, useGuestTrash=#{useGuestTrash}, "
            + "useAdminEditReport=#{useAdminEditReport}, useGuestEditReport=#{useGuestEditReport}, "
            + "useAdminDeleteReport=#{useAdminDeleteReport}, useGuestDeleteReport=#{useGuestDeleteReport}, "
            + "useAdminRestoreReport=#{useAdminRestoreReport}, useGuestRestoreReport=#{useGuestRestoreReport}, "
            + "useAdminEditDai=#{useAdminEditDai}, useGuestEditDai=#{useGuestEditDai}, "
            + "useAdminUbc=#{useAdminUbc}, useGuestUbc=#{useGuestUbc}";

    
    String SELECT_FIELDS = "id,"
            + "useAdminReportTime, useGuestReportTime, useAdminOriginData, useGuestOriginData,"
            + "useAdminFileMenu, useGuestFileMenu, useAdminPdf, useGuestPdf,"
            + "useAdminExcel, useGuestExcel, useAdminTrash, useGuestTrash,"
            + "useAdminEditReport, useGuestEditReport, useAdminDeleteReport, useGuestDeleteReport,"
            + "useAdminRestoreReport, useGuestRestoreReport, useAdminEditDai, useGuestEditDai,"
            + "useAdminUbc, useGuestUbc";

    @Insert("INSERT INTO " + TABLE_NAME + " " + INSERT_FIELDS + " VALUES " + INSERT_VALUES)
    @Override
    int insert(ConstructionSetting domain);

    @Select("SELECT * FROM " + TABLE_NAME + " WHERE id = #{id} ")
    @Override
    ConstructionSetting get(Integer id);

    @Update("UPDATE " + TABLE_NAME + " SET " + UPDATE_VALUES + " WHERE id = #{id} ")
    @Override
    int update(ConstructionSetting domain);

    @Delete("DELETE FROM " + TABLE_NAME + " WHERE id = #{id} ")
    @Override
    int delete(Integer id);

    @Select("SELECT " + SELECT_FIELDS + " FROM " + TABLE_NAME )
    @Override
    java.util.List<ConstructionSetting> getList();
    
    @Insert("INSERT INTO " + TABLE_NAME + " " + INSERT_FIELDS + " VALUES " + INSERT_VALUES
            + " ON DUPLICATE KEY UPDATE " + UPDATE_VALUES)
    int upsert(ConstructionSetting domain);

    @Select("SELECT * FROM TB_CONSTRUCTION_SETTING_DEFAULT LIMIT 1")
    @Results({
        @Result(column="useAdminReportTime",    property="useAdminReportTime",    javaType=Boolean.class),
        @Result(column="useGuestReportTime",    property="useGuestReportTime",    javaType=Boolean.class),
        @Result(column="useAdminOriginData",    property="useAdminOriginData",    javaType=Boolean.class),
        @Result(column="useGuestOriginData",    property="useGuestOriginData",    javaType=Boolean.class),
        @Result(column="useAdminFileMenu",      property="useAdminFileMenu",      javaType=Boolean.class),
        @Result(column="useGuestFileMenu",      property="useGuestFileMenu",      javaType=Boolean.class),
        @Result(column="useAdminPdf",           property="useAdminPdf",           javaType=Boolean.class),
        @Result(column="useGuestPdf",           property="useGuestPdf",           javaType=Boolean.class),
        @Result(column="useAdminExcel",         property="useAdminExcel",         javaType=Boolean.class),
        @Result(column="useGuestExcel",         property="useGuestExcel",         javaType=Boolean.class),
        @Result(column="useAdminTrash",         property="useAdminTrash",         javaType=Boolean.class),
        @Result(column="useGuestTrash",         property="useGuestTrash",         javaType=Boolean.class),
        @Result(column="useAdminEditReport",    property="useAdminEditReport",    javaType=Boolean.class),
        @Result(column="useGuestEditReport",    property="useGuestEditReport",    javaType=Boolean.class),
        @Result(column="useAdminDeleteReport",  property="useAdminDeleteReport",  javaType=Boolean.class),
        @Result(column="useGuestDeleteReport",  property="useGuestDeleteReport",  javaType=Boolean.class),
        @Result(column="useAdminRestoreReport", property="useAdminRestoreReport", javaType=Boolean.class),
        @Result(column="useGuestRestoreReport", property="useGuestRestoreReport", javaType=Boolean.class),
        @Result(column="useAdminEditDai",       property="useAdminEditDai",       javaType=Boolean.class),
        @Result(column="useGuestEditDai",       property="useGuestEditDai",       javaType=Boolean.class),
        @Result(column="useAdminUbc",           property="useAdminUbc",           javaType=Boolean.class),
        @Result(column="useGuestUbc",           property="useGuestUbc",           javaType=Boolean.class)
    })
    ConstructionSetting getDefault();

    @Select("SELECT * FROM " + TABLE_NAME + " WHERE constructionIdx = #{constructionIdx} ")
    @Results({
        @Result(column="constructionIdx", property="constructionIdx"),
        @Result(column="useAdminReportTime", property="useAdminReportTime", javaType=Boolean.class),
        @Result(column="useGuestReportTime", property="useGuestReportTime", javaType=Boolean.class),
        @Result(column="useAdminOriginData", property="useAdminOriginData", javaType=Boolean.class),
        @Result(column="useGuestOriginData", property="useGuestOriginData", javaType=Boolean.class),
        @Result(column="useAdminFileMenu", property="useAdminFileMenu", javaType=Boolean.class),
        @Result(column="useGuestFileMenu", property="useGuestFileMenu", javaType=Boolean.class),
        @Result(column="useAdminPdf", property="useAdminPdf", javaType=Boolean.class),
        @Result(column="useGuestPdf", property="useGuestPdf", javaType=Boolean.class),
        @Result(column="useAdminExcel", property="useAdminExcel", javaType=Boolean.class),
        @Result(column="useGuestExcel", property="useGuestExcel", javaType=Boolean.class),
        @Result(column="useAdminTrash", property="useAdminTrash", javaType=Boolean.class),
        @Result(column="useGuestTrash", property="useGuestTrash", javaType=Boolean.class),
        @Result(column="useAdminEditReport", property="useAdminEditReport", javaType=Boolean.class),
        @Result(column="useGuestEditReport", property="useGuestEditReport", javaType=Boolean.class),
        @Result(column="useAdminDeleteReport", property="useAdminDeleteReport", javaType=Boolean.class),
        @Result(column="useGuestDeleteReport", property="useGuestDeleteReport", javaType=Boolean.class),
        @Result(column="useAdminRestoreReport", property="useAdminRestoreReport", javaType=Boolean.class),
        @Result(column="useGuestRestoreReport", property="useGuestRestoreReport", javaType=Boolean.class),
        @Result(column="useAdminEditDai", property="useAdminEditDai", javaType=Boolean.class),
        @Result(column="useGuestEditDai", property="useGuestEditDai", javaType=Boolean.class),
        @Result(column="useAdminUbc", property="useAdminUbc", javaType=Boolean.class),
        @Result(column="useGuestUbc", property="useGuestUbc", javaType=Boolean.class)
    })
	ConstructionSetting findByConstructionIdx(int userId);
}