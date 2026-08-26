package net.octacomm.sample.dao.mapper;

import java.util.List;
import java.util.Map;
import net.octacomm.sample.domain.BoardPost;

public interface BoardPostMapper {
    int getPostTotalCount(Map<String, Object> paramMap);
    List<BoardPost> getPostList(Map<String, Object> paramMap);
    int insertPost(BoardPost post);
    BoardPost getPost(Long id);
    int updatePost(BoardPost post);
    int deletePost(Long id);
    int deleteFileSlot(Map<String, Object> paramMap);
}