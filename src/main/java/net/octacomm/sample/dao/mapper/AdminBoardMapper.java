package net.octacomm.sample.dao.mapper;

import java.util.List;
import java.util.Map;
import net.octacomm.sample.domain.AdminBoard;

public interface AdminBoardMapper {

    int getBoardTotalCount(Map<String, Object> paramMap);
    
    List<AdminBoard> getBoardList(Map<String, Object> paramMap);

    int insertBoard(Map<String, Object> paramMap);

    AdminBoard getFile(Long id);
    
    int deleteBoard(Long id);
    
    AdminBoard getBoard(Long id);
    
    int updateBoard(Map<String, Object> paramMap);
}