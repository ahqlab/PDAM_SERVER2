package net.octacomm.sample.view;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.WriterException;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.QRCodeWriter;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.nio.file.FileSystems;
import java.nio.file.Path;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;

public class QRCodeGenerator {

	  public static byte[] generateQRCodeImage(String text, int width, int height) throws WriterException, IOException {
	        QRCodeWriter qrCodeWriter = new QRCodeWriter();
	        BitMatrix bitMatrix = qrCodeWriter.encode(text, BarcodeFormat.QR_CODE, width, height);

	        BufferedImage qrImage = MatrixToImageWriter.toBufferedImage(bitMatrix);
	        ByteArrayOutputStream baos = new ByteArrayOutputStream();
	        ImageIO.write(qrImage, "PNG", baos);
	        return baos.toByteArray();
	    }

	    // 파일로 저장하고 싶다면 이 메서드 사용
	    public static void generateQRCodeImageToFile(String text, int width, int height, String filePath) throws WriterException, IOException {
	        QRCodeWriter qrCodeWriter = new QRCodeWriter();
	        BitMatrix bitMatrix = qrCodeWriter.encode(text, BarcodeFormat.QR_CODE, width, height);
	        Path path = FileSystems.getDefault().getPath(filePath);
	        MatrixToImageWriter.writeToPath(bitMatrix, "PNG", path);
	    }
}
