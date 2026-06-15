package net.octacomm.sample.view;

public class ProjectionCalculator {

    /**
     * 사각형 물체의 바닥 투영 길이를 계산
     * @param length 실제 길이 (m)
     * @param tiltDeg 기울기 각도 (°), 뒤로 올리면 양수, 뒤로 내리면 음수
     * @return 바닥에서 보는 투영 길이 (m)
     */
    public static double projectedLength(double length, double tiltDeg) {
        // 각도를 라디안으로 변환
        double tiltRad = Math.toRadians(tiltDeg);
        // 수평 투영 길이 계산
        return length * Math.cos(tiltRad);
    }

    public static void main(String[] args) {
        double length = 9.0;      // 사각형 길이 9m
        double tiltDeg = 5.0;     // 뒤로 5도 올림

        double projLength = projectedLength(length, tiltDeg);
        System.out.printf("기울기 %.2f°일 때 바닥 투영 길이: %.4f cm%n", tiltDeg, (length - projLength) * 100);

        // 예: 뒤로 내리면 음수
        tiltDeg = -5.0;
        projLength = projectedLength(length, tiltDeg);
        System.out.printf("기울기 %.2f°일 때 바닥 투영 길이: %.4f cm%n", tiltDeg, (length - projLength) * 100);
    }
}
