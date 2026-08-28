package net.octacomm.sample.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import net.octacomm.sample.dao.mapper.BoardPostMapper;
import net.octacomm.sample.domain.BoardPost;

@Service
public class BoardPostServiceImpl implements BoardPostService {

    @Autowired
    private BoardPostMapper boardPostMapper;

    @Override
    public int getPostTotalCount(Map<String, Object> paramMap) { 
        return boardPostMapper.getPostTotalCount(paramMap); 
    }

    @Override
    public List<BoardPost> getPostList(Map<String, Object> paramMap) { 
        return boardPostMapper.getPostList(paramMap); 
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void insertPost(BoardPost post) throws Exception { 
        boardPostMapper.insertPost(post); 
    }

    @Override
    public BoardPost getPost(Long id) { 
        return boardPostMapper.getPost(id); 
    }
    
    @Override
    public BoardPost getPostFileData(Long id) {
        return boardPostMapper.getPostFileData(id);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void updatePost(BoardPost post) throws Exception { 
        boardPostMapper.updatePost(post); 
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void deletePost(Long id) throws Exception { 
        boardPostMapper.deletePost(id); 
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void deleteFileSlot(Long postId, int slot) throws Exception {
        Map<String, Object> map = new HashMap<>();
        map.put("postId", postId);
        map.put("slot", slot);
        boardPostMapper.deleteFileSlot(map);
    }
}