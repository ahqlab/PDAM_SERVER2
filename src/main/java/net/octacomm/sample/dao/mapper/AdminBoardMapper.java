package net.octacomm.sample.dao.mapper;

import java.util.List;
import java.util.Map;
import net.octacomm.sample.domain.AdminBoard;

public interface AdminBoardMapper {

    int getBoardTotalCount(Map<String, Object> paramMap);
    
    List<AdminBoard> getBoardList(Map<String, Object> paramMap);

    int insertBoard(AdminBoard board);
    
    int deleteBoard(Long id);
    
    AdminBoard getBoard(Long id);
    
    int updateBoard(AdminBoard board);
}