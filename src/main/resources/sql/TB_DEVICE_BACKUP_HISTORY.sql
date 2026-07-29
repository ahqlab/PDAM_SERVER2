CREATE TABLE IF NOT EXISTS TB_DEVICE_BACKUP_HISTORY (
    id               INT          NOT NULL AUTO_INCREMENT PRIMARY KEY,
    constructionIdx  INT          NOT NULL,
    deviceId         INT          NOT NULL,
    versionNo        INT          NOT NULL,
    createdAt        DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    workType         VARCHAR(50)  NOT NULL,
    snapshotData     LONGTEXT     NULL,
    UNIQUE KEY UK_DEVICE_BACKUP_VERSION (deviceId, versionNo),
    KEY IX_DEVICE_BACKUP_HISTORY (constructionIdx, deviceId, versionNo)
);
