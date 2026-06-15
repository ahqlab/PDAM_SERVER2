package net.octacomm.sample.view;

public class RectangleProjection {
	
	/**
     * 직사각형의 대각선 수평 투영 길이 계산
     * @param width 가로 길이
     * @param height 세로 길이
     * @param pitchDeg 앞뒤 기울기 (degrees)
     * @param rollDeg 좌우 기울기 (degrees)
     * @return 수평면에 투영된 대각선 길이
     */
    public static double diagonalProjectedLength(double width, double height, double pitchDeg, double rollDeg) {
        // 1. 원래 직사각형 대각선 길이 계산
        double diagonal = Math.sqrt(width * width + height * height);

        // 2. 각도를 라디안으로 변환
        double pitchRad = Math.toRadians(pitchDeg);
        double rollRad  = Math.toRadians(rollDeg);

        // 3. 수평 투영
        double projected = diagonal * Math.cos(pitchRad) * Math.cos(rollRad);

        return projected;
    }

    public static void main(String[] args) {
        double width = 9.0;    // 가로 9m
        double height = 2.0;   // 세로 2m
        double pitch = 0.0;    // 앞뒤 5도
        double roll  = 0.0;    // 좌우 3도

        double projLength = diagonalProjectedLength(width, height, pitch, roll);
        System.out.printf("수평 투영 대각선 길이: %.4f m\n", projLength);
    }

    
    //2  ~ 34 가지 19일로 넘기고 33개가 된다
    
    //6 ~ 7  
    
    
    
}
