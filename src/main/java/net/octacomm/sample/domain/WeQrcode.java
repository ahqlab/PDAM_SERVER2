package net.octacomm.sample.domain;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString(callSuper = true)
public class WeQrcode implements Domain{
	
	WeQrcode(){
		
	}
	
	public WeQrcode(String qrtype, String qrtext){
		this.qrtype = qrtype;
		this.qrtext = qrtext;
	}
	
	public WeQrcode(String title, String qrtype, String qrtext, String qrfilename){
		this.title = title;
		this.qrtype = qrtype;
		this.qrtext = qrtext;
		this.qrfilename = qrfilename;
	}
	
	private int id;
	
	private String title;
	
	private String qrtype;
	
	private String qrtext;
	
	private String qrfilename;
	
	private String qrSaveFilename;
}
