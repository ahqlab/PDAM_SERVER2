-- 시스템 관리자 전용 로그인 테이블: 특정 현장(TB_CONSTRUCTION)에 종속되지 않는 독립 계정.
-- UserMapper.getUser/getUserForAuth의 유니온 쿼리에 포함되어 로그인되며, role은 항상 0(최고권한)으로 취급된다.
-- id는 TB_CONSTRUCTION.id와 충돌하지 않도록 로그인 시 90000000 offset이 더해져 세션 constructionIdx로 들어간다
-- (LoginServiceImpl.SYSTEM_ADMIN_ID_OFFSET, UserMapper 쿼리와 값이 일치해야 함).
CREATE TABLE IF NOT EXISTS TB_SYSTEM_ADMIN (
    id          INT          NOT NULL AUTO_INCREMENT PRIMARY KEY,
    userId      VARCHAR(50)  NOT NULL UNIQUE,
    password    VARCHAR(255) NOT NULL,
    name        VARCHAR(50)  DEFAULT NULL,
    isDel       TINYINT      NOT NULL DEFAULT 0,
    createDate  DATETIME     DEFAULT CURRENT_TIMESTAMP,
    lastModifiedDate DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 시스템관리자 계정 등록 예시:
-- INSERT INTO TB_SYSTEM_ADMIN (userId, password, name) VALUES ('sysadmin', '비밀번호', '홍길동');
