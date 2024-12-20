package net.octacomm.sample.domain;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString(callSuper = true)
public class WeManager implements Domain{
	
	private int id;
	
	private String name;
	
	private String position;
	
	private String phone;
	
}
