package net.octacomm.sample.dao.mapper;

import org.apache.ibatis.annotations.Select;

import net.octacomm.sample.domain.ConstructionSettingConfig;

public interface ConstructionSettingConfigMapper {

    @Select("SELECT APPLY_FROM_DATE applyFromDate FROM TB_CONSTRUCTION_SETTING_CONFIG LIMIT 1")
    ConstructionSettingConfig getConfig();
}
