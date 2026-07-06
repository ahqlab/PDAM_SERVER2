package net.octacomm.sample.domain;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

/**
 * BLE 장비 매핑: blueNo(예 "1"~"431") ↔ BLE MAC 주소.
 * 기존 안드로이드 하드코딩(BluetoothDeviceConfig)을 서버 DB(TB_BLE_DEVICE_MAP)로 이관하기 위한 도메인.
 */
@Getter
@Setter
@ToString
public class BleDeviceMap {

	private String blueNo;

	private String macAddress;

	private String createDate;

}
