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
    
    private String boardName;
    private String useYn;
    private String auth;
    private String allowedExts;
    
    private Date regDate;
    private Date updateAt;
    private Date deleteAt;
}