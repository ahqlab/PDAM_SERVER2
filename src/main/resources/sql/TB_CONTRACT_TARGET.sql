-- 계약서 적용 대상 지정 테이블
-- 관리자가 버튼으로 지정한 현장만 계약 프로세스 적용 (targetYn = 1)
-- 운영 DB에 직접 실행 필요.
CREATE TABLE IF NOT EXISTS TB_CONTRACT_TARGET (
    constructionIdx INT NOT NULL PRIMARY KEY,
    targetYn TINYINT NOT NULL DEFAULT 0,
    regDate  DATETIME DEFAULT CURRENT_TIMESTAMP,
    modDate  DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
