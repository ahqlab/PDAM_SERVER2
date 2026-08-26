package net.octacomm.sample.service;

import java.util.List;
import java.util.Map;
import net.octacomm.sample.domain.BoardPost;

public interface BoardPostService {
    int getPostTotalCount(Map<String, Object> paramMap);
    List<BoardPost> getPostList(Map<String, Object> paramMap);
    void insertPost(BoardPost post) throws Exception;
    BoardPost getPost(Long id);
    void updatePost(BoardPost post) throws Exception;
    void deletePost(Long id) throws Exception;
    void deleteFileSlot(Long postId, int slot) throws Exception;
}