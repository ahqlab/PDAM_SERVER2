CREATE TABLE TB_DUPLICATE_CHECK_CONFIG (
    id INT NOT NULL AUTO_INCREMENT,
    constructionIdx INT NOT NULL DEFAULT 0 COMMENT '0=전체 현장 공통',
    deviceIdx INT NOT NULL DEFAULT 0 COMMENT '0=해당 현장 내 전체 호기 공통',
    usePileStandard TINYINT(1) NOT NULL DEFAULT 0 COMMENT '중복판정에 파일규격(pileStandard) 포함 여부',
    usePileType TINYINT(1) NOT NULL DEFAULT 0 COMMENT '중복판정에 파일종류(pileType) 포함 여부',
    useMethod TINYINT(1) NOT NULL DEFAULT 0 COMMENT '중복판정에 시공공법(method) 포함 여부',
    createDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_scope (constructionIdx, deviceIdx)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 전역 기본값: constructionIdx=0, deviceIdx=0 인 행이 최종 폴백(fallback) 기본값.
-- usePileStandard=1로 시작 = 전체 현장에 기본 반영. 문제 생기면 이 값만 0으로 바꾸면 즉시 롤백.
INSERT INTO TB_DUPLICATE_CHECK_CONFIG (constructionIdx, deviceIdx, usePileStandard, usePileType, useMethod) VALUES (0, 0, 1, 0, 0);

-- 기존 테이블에 컬럼만 추가할 때(마이그레이션):
-- ALTER TABLE TB_DUPLICATE_CHECK_CONFIG
--   ADD COLUMN usePileType TINYINT(1) NOT NULL DEFAULT 0 COMMENT '중복판정에 파일종류(pileType) 포함 여부' AFTER usePileStandard,
--   ADD COLUMN useMethod TINYINT(1) NOT NULL DEFAULT 0 COMMENT '중복판정에 시공공법(method) 포함 여부' AFTER usePileType;
