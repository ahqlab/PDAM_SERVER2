package net.octacomm.sample.domain;

import lombok.Data;

@Data
public class Company {
	private int id;
	private String name;
	private String address;
	private String businessNo;
	private String tel;
	private String representative;
}
