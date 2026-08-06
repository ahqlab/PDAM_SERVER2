CREATE TABLE TB_DAILY_OPERATION_SUMMARY (
    id BIGINT NOT NULL AUTO_INCREMENT,
    snapshotDateTime DATETIME NOT NULL COMMENT '스냅샷 저장 시각',
    constructionCount INT NOT NULL DEFAULT 0 COMMENT '시행 중 협력사 수',
    headquartersDeviceCount INT NOT NULL DEFAULT 0 COMMENT '본사 운영장비 수',
    franchiseDeviceCount INT NOT NULL DEFAULT 0 COMMENT '가맹 운영장비 수',
    spareDeviceCount INT NOT NULL DEFAULT 0 COMMENT '사용 가능한 예비용 장비 수',
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
