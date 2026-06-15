package net.octacomm.sample.dao.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import net.octacomm.sample.domain.Company;

public interface CompanyMapper {

	List<Company> getList();

	Company getById(@Param("id") int id);

	Company getByName(@Param("name") String name);

	int insert(Company company);

	int update(Company company);

	int delete(@Param("id") int id);
}
