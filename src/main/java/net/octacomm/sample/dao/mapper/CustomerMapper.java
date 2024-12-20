package net.octacomm.sample.dao.mapper;

import java.util.List;

import org.apache.ibatis.annotations.CacheNamespace;
import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import net.octacomm.sample.domain.Customer;
import net.octacomm.sample.domain.Device;

@CacheNamespace
public interface CustomerMapper {
	
	public String INSERT_FIELDS = " ( id, groupName , conName , conLocation , conManager , conContact )";
	
	public String INSERT_VALUES = " ( id, #{groupName} , #{conName} , #{conLocation} , #{conManager} , #{conContact} )";
	
	public String TABLE_NAME = " TB_CUSTOMER ";
	
	public String UPDATE_VALUES = " groupName = #{groupName} , conName = #{conName} , conLocation = #{conLocation}, conManager = #{conManager}, conContact = #{conContact} ";
	
	public String SELECT_FIELDS = " id, constructionIdx , deviceIdx, operDate, erpDiv, dmiCol, preDay, today, dSum, bigo ";
	
	@Select(" SELECT * FROM TB_CUSTOMER_VIEW ORDER BY ID DESC")
	List<Customer> getLsit();
	
	@Insert("INSERT INTO " + TABLE_NAME + " " + INSERT_FIELDS + " VALUES " + INSERT_VALUES)
	int insert(Customer customer);

	@Update("UPDATE  " + TABLE_NAME + " SET " + UPDATE_VALUES  + " WHERE id =  #{id}")
	int update(Customer customer);
	
	@Delete("DELETE FROM " + TABLE_NAME + " WHERE  id =  #{id}")
	int delete(int id);
}
