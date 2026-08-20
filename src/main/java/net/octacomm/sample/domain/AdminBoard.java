package net.octacomm.sample.domain;

import java.util.Date;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class AdminBoard implements Domain {

    private Long id;
    private String title;
    private String content;
    
    private String fileName;
    private byte[] fileData; 
    private long fileSize;
    private String contentType;
    
    private String regUser;
    private Date regDate;
    private Date updateAt;
    private Date deleteAt;
}