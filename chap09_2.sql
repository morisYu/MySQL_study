/* 9.2.2 자동으로 생성되는 인덱스 */
/* ------------------------------------------------------------------------ */

DROP DATABASE IF EXISTS chap09;
CREATE DATABASE chap09;
USE chap09;

/* 제약 조건으로 자동 생성되는 인덱스를 확인 */
-- '클러스터형 인덱스' 와 'Primary Key' 인덱스는 거의 동일한 용어로 사용됨.

CREATE TABLE tbl1 (
	a INT PRIMARY KEY,
    b INT,
    c INT
);

-- 구성된 인덱스를 확인
SHOW INDEX FROM tbl1;

-- Primary Key 와 함께 Unique 제약 조건도 생성
CREATE TABLE tbl2 (
	a INT PRIMARY KEY,
    b INT UNIQUE,
    c INT UNIQUE,
    d INT
);

-- 구성된 인덱스를 확인
-- UNIQUE 제약 조건으로 설정하면 보조 인덱스(Secondary Index)가 자동으로 생성됨 
SHOW INDEX FROM tbl2;

-- Primary Key 없이 Unique Key 만 지정
CREATE TABLE tbl3 (
	a INT UNIQUE,
    b INT UNIQUE,
    c INT UNIQUE,
    d INT
);

-- 클러스터형 인덱스가 비었다고 해서 UNIQUE 가 클러스터형 인덱스가 되지는 않음
SHOW INDEX FROM tbl3;

-- UNIQUE 에 클러스터형 인덱스를 지정. (UNIQUE 에 NOT NULL 이 포함되면 클러스터형 인덱스로 지정됨)
CREATE TABLE tbl4 (
	a INT UNIQUE NOT NULL,
    b INT UNIQUE,
    c INT UNIQUE,
    d INT
);

SHOW INDEX FROM tbl4;

-- UNIQUE NOT NULL 과 PRIMARY KEY 를 모두 지정
CREATE TABLE tbl5 (
	a INT UNIQUE NOT NULL,
    b INT UNIQUE,
    c INT UNIQUE,
    d INT PRIMARY KEY
);

-- 클러스터형 인덱스는 테이블당 하나밖에 지정되지 않기 때문에 PRIMARY KEY 로 설정한 열에 우선 클러스터형 인덱스가 지정됨
SHOW INDEX FROM tbl5;

-- 클러스터형 인덱스는 행 데이터를 자신의 열을 기준으로 정렬
USE chap09;
DROP TABLE IF EXISTS usertbl;
CREATE TABLE usertbl (
	userID char(8) NOT NULL PRIMARY KEY,
    name varchar(10) NOT NULL,
    birthday int NOT NULL,
    addr nchar(2) NOT NULL
);
INSERT INTO usertbl VALUES ('LSG', '이승기', 1987, '서울');
INSERT INTO usertbl VALUES ('KBS', '김범수', 1979, '경남');
INSERT INTO usertbl VALUES ('KKH', '김경호', 1971, '전남');
INSERT INTO usertbl VALUES ('JYP', '조용필', 1950, '경기');
INSERT INTO usertbl VALUES ('SSK', '성시경', 1979, '서울');

-- userID 에 클러스터형 인덱스가 생성되었기 때문에 입력 순서와 상관없이 userID 로 데이터가 정렬됨
DESC usertbl;
SELECT * FROM usertbl;

-- userID 열의 PRIMARY KEY 를 제거하고, name 열을 PRIMARY KEY 로 지정
ALTER TABLE usertbl DROP PRIMARY KEY;
ALTER TABLE usertbl
	ADD CONSTRAINT pk_name PRIMARY KEY(name);
    
-- name 을 기준으로 데이터가 정렬됨
DESC usertbl;
SELECT * FROM usertbl;