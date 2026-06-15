package net.octacomm.sample.utils;


public class PileDriverProjection {
	
	/**
     * 주어진 길이와 각도로 수평 투영 길이를 계산합니다.
     * 예) length = 9m, angleDeg = 5°
     *     → 8.9657523m
     */
	public static double getProjectedLength(double length, double angleDeg) {
		double angleRad = Math.toRadians(angleDeg); // 각도를 라디안으로 변환
		return length * Math.cos(angleRad); // 수평 투영 길이 계산
	}
	/**
     * 주어진 길이와 각도에 따라 수평 투영 차이를 cm로 계산합니다.
     * 예) length = 9m, angleDeg = 5°
     *     → 약 3.42cm
     */
	public static double calculateProjectionDifference(double length, double angleDeg) {
        double angleRad = Math.toRadians(angleDeg); // 각도를 라디안으로 변환
        double projectedLength = length * Math.cos(angleRad); // 수평 투영 길이
        double diffMeters = length - projectedLength; // 차이 (m)
        double diffCm = diffMeters * 100; // m → cm 변환
        return diffCm;
    }
	
	  /**
     * 투영된 길이와 각도를 이용해 실제(기울지 않은) 길이를 계산합니다.
     *
     * @param projectedLength 수평 투영된 길이 (m)
     * @param angleDeg 기울어진 각도 (°)
     * @return 실제 길이 (m)
     */
    public static double getActualLength(double projectedLength, double angleDeg) {
        double angleRad = Math.toRadians(angleDeg); // 라디안 변환
        return projectedLength / Math.cos(angleRad); // 실제 길이 계산
    }
    
    
	public static void main(String[] args) {
		
		double length = 9.0;   // m
		double angle = 3.0;    // °
		
	    double projected = getProjectedLength(length, angle);
		System.out.printf("길이 %.1fm, 각도 %.1f° → 수평 투영 길이: %.7fm%n", length, angle, projected);
		double result = calculateProjectionDifference(length, angle);
		System.out.printf("길이 %.1fm, 각도 %.1f° → 차이: %.4fcm%n", length, angle, result);
		double carLength = getActualLength(projected, angle);
		System.out.printf("투영 %.7fm, 각도 %.1f° → 실제 길이: %.7fm%n", 8.9657523, angle, carLength);
		
	}
}