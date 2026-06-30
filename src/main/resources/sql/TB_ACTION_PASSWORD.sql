-- 관리자 보호 버튼(계약서 관리 / 이용제한 설정) 공통 비밀번호 테이블
-- 행은 항상 1개(id=1)만 존재. password 컬럼에 비밀번호를 직접 INSERT 후 사용.
CREATE TABLE IF NOT EXISTS TB_ACTION_PASSWORD (
    id          TINYINT NOT NULL PRIMARY KEY DEFAULT 1,
    password    VARCHAR(255) NOT NULL,
    description VARCHAR(100) DEFAULT NULL,
    regDate     DATETIME DEFAULT CURRENT_TIMESTAMP,
    modDate     DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT chk_single_row CHECK (id = 1)
);

-- 비밀번호 등록 예시 (값은 직접 지정)
-- INSERT INTO TB_ACTION_PASSWORD (id, password, description) VALUES (1, '여기에_비밀번호', '계약서관리/이용제한 보호 비번');
-- 비밀번호 변경 시
-- UPDATE TB_ACTION_PASSWORD SET password = '새비밀번호' WHERE id = 1;
