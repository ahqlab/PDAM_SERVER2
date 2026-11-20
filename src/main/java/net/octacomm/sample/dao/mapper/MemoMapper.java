package net.octacomm.sample.dao.mapper;

import java.util.List;

import org.apache.ibatis.annotations.CacheNamespace;
import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import net.octacomm.sample.domain.Memo;

@CacheNamespace
public interface MemoMapper {
	
	public String INSERT_FIELDS = " (   id,   constructionIdx ,   userId ,   content,   memoDate, createDate, modifyDate )";
	
	public String INSERT_VALUES = " ( null, #{constructionIdx}, #{userId}, #{content}, #{memoDate},    now(),    now()   )";
	
	public String TABLE_NAME = " TB_MEMO ";
	
	@Insert("INSERT INTO " + TABLE_NAME + " " + INSERT_FIELDS + " VALUES " + INSERT_VALUES)
	int insert(Memo memo);
	
	@Select("SELECT * FROM TB_MEMO WHERE constructionIdx = #{constructionIdx} AND attachmentType IS NULL AND content IS NOT NULL AND content <> '' AND content NOT LIKE '[[ATTACHMENT|%' order by createDate desc")
	List<Memo> findByConstructionIdx(@Param("constructionIdx") int constructionIdx);

	@Select("SELECT * FROM TB_MEMO WHERE constructionIdx = #{constructionIdx} AND attachmentType IS NOT NULL ORDER BY createDate DESC")
	List<Memo> findAttachmentsByConstructionIdx(@Param("constructionIdx") int constructionIdx);

	@Insert("INSERT INTO TB_MEMO (constructionIdx, userId, content, memoDate, attachmentType, originalFilename, storedFilename, contentType, fileSize, createDate, modifyDate) "
			+ "VALUES (#{constructionIdx}, #{userId}, '', #{memoDate}, #{attachmentType}, #{originalFilename}, #{storedFilename}, #{contentType}, #{fileSize}, NOW(), NOW())")
	int insertAttachment(Memo memo);

	@Update("UPDATE  " + TABLE_NAME + " SET memoDate = #{memoDate} , content = #{content} , modifyDate = now() WHERE id = #{id}")
	int update(Memo memo);
	
	@Delete("DELETE FROM TB_MEMO WHERE id = #{id}")
	int delete(int id);

}
