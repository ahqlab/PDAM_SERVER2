package net.octacomm.sample.service;

import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import net.octacomm.sample.dao.mapper.AdminBoardMapper;
import net.octacomm.sample.domain.AdminBoard;

@Service
public class AdminBoardServiceImpl implements AdminBoardService {

    @Autowired
    private AdminBoardMapper adminBoardMapper;

    @Override
    public int getBoardTotalCount(Map<String, Object> paramMap) {
        return adminBoardMapper.getBoardTotalCount(paramMap);
    }

    @Override
    public List<AdminBoard> getBoardList(Map<String, Object> paramMap) {
        return adminBoardMapper.getBoardList(paramMap);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void insertBoard(Map<String, Object> paramMap) throws Exception {
        adminBoardMapper.insertBoard(paramMap);
    }

    @Override
    public AdminBoard getFile(Long id) {
        return adminBoardMapper.getFile(id);
    }
    
    @Override
    @Transactional(rollbackFor = Exception.class)
    public void deleteBoard(Long id) throws Exception {
        adminBoardMapper.deleteBoard(id);
    }
    
    @Override
    public AdminBoard getBoard(Long id) {
        return adminBoardMapper.getBoard(id);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void updateBoard(Map<String, Object> paramMap) throws Exception {
        adminBoardMapper.updateBoard(paramMap);
    }
}