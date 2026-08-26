package net.octacomm.sample.service;

import java.util.List;
import java.util.Map;
import net.octacomm.sample.domain.AdminBoard;

public interface AdminBoardService {
    int getBoardTotalCount(Map<String, Object> paramMap);
    List<AdminBoard> getBoardList(Map<String, Object> paramMap);
    void insertBoard(AdminBoard board) throws Exception;
    AdminBoard getBoard(Long id);
    void updateBoard(AdminBoard board) throws Exception;
    void deleteBoard(Long id) throws Exception;
}