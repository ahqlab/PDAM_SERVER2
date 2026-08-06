CREATE TABLE TB_DAILY_OPERATION_SUMMARY (
    id BIGINT NOT NULL AUTO_INCREMENT,
    snapshotDate DATE NOT NULL COMMENT '집계 기준일',
    snapshotAt DATETIME NOT NULL COMMENT '실제 집계 시각',
    constructionCount INT NOT NULL DEFAULT 0 COMMENT '시행 중 협력사 수',
    headquartersDeviceCount INT NOT NULL DEFAULT 0 COMMENT '본사 운영장비 수',
    franchiseDeviceCount INT NOT NULL DEFAULT 0 COMMENT '가맹 운영장비 수',
    spareDeviceCount INT NOT NULL DEFAULT 0 COMMENT '사용 가능한 예비용 장비 수',
    createDate DATETIME NOT NULL,
    lastModifiedDate DATETIME NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY UK_DAILY_OPERATION_SUMMARY_DATE (snapshotDate)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
