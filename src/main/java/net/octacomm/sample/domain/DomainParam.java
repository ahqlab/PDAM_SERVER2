package net.octacomm.sample.domain;

import lombok.Data;

@Data
public abstract class DomainParam {
	
	protected int constructionIdx;
	protected int role;
	protected int groupIdx;
	protected int fcIdx;
	protected int currentPage = 1;
	protected int pageSize;
	protected int pageGroupSize;
	
	
}
