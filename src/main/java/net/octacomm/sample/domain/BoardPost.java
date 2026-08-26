package net.octacomm.sample.domain;

import java.util.Date;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class BoardPost implements Domain {
	private Long rowNum;
	
    private Long id;
    private Long boardId;
    
    private String title;
    private String content;
    
    private String fileName1; private byte[] fileData1; private Long fileSize1; private String contentType1;
    private String fileName2; private byte[] fileData2; private Long fileSize2; private String contentType2;
    private String fileName3; private byte[] fileData3; private Long fileSize3; private String contentType3;
    
    private String regUser;
    private Date regDate;
    private Date updateAt;
    private Date deleteAt;
    
    public int getFileCount() {
        int count = 0;
        if (fileName1 != null && !fileName1.isEmpty()) count++;
        if (fileName2 != null && !fileName2.isEmpty()) count++;
        if (fileName3 != null && !fileName3.isEmpty()) count++;
        return count;
    }
}