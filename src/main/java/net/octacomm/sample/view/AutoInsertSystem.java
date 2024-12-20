package net.octacomm.sample.view;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;


public class AutoInsertSystem {

	public static void main(String[] args) throws IOException {
		//System.err.println("test start");
		int i = 0;
		File file = new File("D:\\대광건영 부광건설 평택 브레인시티 도일 1초교 신축공사.txt");
		try {
			try (BufferedReader br = new BufferedReader(new FileReader(file))) {
				String line;
				while ((line = br.readLine()) != null) {
					String[] arr = line.split(",");
					String json = "{\n " + 
							"\"id\":null,\n" +
							"\"currentDateTime\" : \"" + arr[1] + "\",\n" +
							"\"deviceIdx\" : " + arr[2] + " ,\n" +
							"\"pileType\" : \"" + arr[3] + "\",\n" +
							"\"method\" : \"" + arr[4] + "\",\n" +
							"\"location\" : \"" + arr[5] + "\",\n" +
							"\"pileNo\" : \"" + arr[6] + "\",\n" +
							"\"pileStandard\" : \"" + arr[7] + "\",\n" +
							"\"connectLength\" : \"" + (arr[14] == "" ? 0 : arr[14]) + "\",\n" +
							"\"piece\":[\n" +
							"	{\"name\":\"단본\",\"value\":\"" + (arr[8].isEmpty() ? 0 : arr[8]) + "\",\"id\":null,\"reportIdx\":null},\n" +
							"	{\"name\":\"하단\",\"value\":\"" + (arr[9].isEmpty() ? 0 : arr[9]) + "\",\"id\": null,\"reportIdx\":null},\n" +
							"	{\"name\":\"중단\",\"value\":\"" + (arr[10].isEmpty() ? 0 : arr[10]) + "\",\"id\": null,\"reportIdx\":null},\n" +
							"	{\"name\":\"null\",\"value\":\"0\",\"id\":null,\"reportIdx\":null},\n" +
							"	{\"name\":\"상단\",\"value\":\"" +  (arr[12].isEmpty() ? 0 : arr[12]) + "\",\"id\": null,\"reportIdx\":null}\n" +
							"	]\n" +
							",\"penetrations\":[]\n" +
							",\"drillingDepth\":\"" + (arr[15] == "" ? 0 : arr[15]) +"\",\n" +
							"\"intrusionDepth\":\"" + (arr[16] == "" ? 0 : arr[16]) +"\",\n" +
							"\"totalConnectWidth\" : \"" + arr[13] +"\",\n" +
							"\"hammaT\" : \"" + arr[19] + "\",\n" +
							"\"fallMeter\" : \"" + arr[20] + "\",\n" +
							"\"managedStandard\" : \"" + arr[21] + "\",\n" +
							"\"totalPenetrationValue\":\"0\",\n" +
							"\"avgPenetrationValue\":\"0\",\n" +
							"\"crossSection\":\"0\",\n" +
							"\"bigo\":\"system\",\n" +
							"\"hammaEfficiency\":\"0\",\n" +
							"\"modulusElasticity\":\"0\",\n" +
							"\"balance\":\"" +  arr[17] + "\" " +
						"}";
					System.err.println("json : " + json);
					//return;
					String result = send(json);
					System.err.println("PILE NO : " +  arr[6] + ", RESULT : " + result + ", i : " + i);
					i++;
					if(!result.contains("true")) {
						break;
					}
					
					try {
						Thread.sleep(500);
					} catch (InterruptedException e) {
						e.printStackTrace();
					}
				}
			}
		} catch (IOException e) {
			e.printStackTrace();
		}

	}
	
	public static String send(String json) throws IOException {

		URL url = new URL("http://localhost:8080/web-template-mybatis/mobile/regist/report");
		HttpURLConnection httpConn = null;
		httpConn = (HttpURLConnection) url.openConnection();
		httpConn.setRequestMethod("POST");
		httpConn.setRequestProperty("Content-Type", "application/json; utf-8"); 

		httpConn.setDoOutput(true);    
		OutputStreamWriter wr = null;
		wr = new OutputStreamWriter(httpConn.getOutputStream(), "UTF-8");

		String jsonString = json;

		wr.write(jsonString);	

		wr.flush();
		wr.close();
		
		BufferedReader in = new BufferedReader(new InputStreamReader(httpConn.getInputStream()));
		String returnMsg = in.readLine();
		return returnMsg;
		
	}
}
