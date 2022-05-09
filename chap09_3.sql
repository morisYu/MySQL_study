/* 9.3.3 클러스터형 인덱스와 보조 인덱스의 구조 */
/* ------------------------------------------------------------------------ */

DROP DATABASE IF EXISTS chap09;
CREATE DATABASE chap09;
USE chap09;

-- 인덱스 없이 테이블 생성
DROP TABLE IF EXISTS clustertbl;
CREATE TABLE clustertbl (
	userID CHAR(8),
    name VARCHAR(10)
);
INSERT INTO clustertbl VALUES ('LSG', '이승기');
INSERT INTO clustertbl VALUES ('KBS', '김범수');
INSERT INTO clustertbl VALUES ('KKH', '김경호');
INSERT INTO clustertbl VALUES ('JYP', '조용필');
INSERT INTO clustertbl VALUES ('SSK', '성시경');
INSERT INTO clustertbl VALUES ('LJB', '임재범');
INSERT INTO clustertbl VALUES ('YJS', '윤종신');
INSERT INTO clustertbl VALUES ('EJW', '은지원');
INSERT INTO clustertbl VALUES ('JKW', '조관우');
INSERT INTO clustertbl VALUES ('BBK', '바비킴');

-- 입력 순서대로 데이터 정렬됨
SELECT * FROM clustertbl;

-- userID 에 클러스터형 인덱스를 구성
ALTER TABLE clustertbl
	ADD CONSTRAINT PK_clustertbl_userID
		PRIMARY KEY (userID);

-- userID 롤 오름차순 정렬이 됨
SELECT * FROM clustertbl;

-- 보조 인덱스가 있는 테이블 생성
DROP TABLE IF EXISTS secondarytbl;
CREATE TABLE secondarytbl (
	userID CHAR(8),
    name VARCHAR(10)
);

INSERT INTO secondarytbl VALUES ('LSG', '이승기');
INSERT INTO secondarytbl VALUES ('KBS', '김범수');
INSERT INTO secondarytbl VALUES ('KKH', '김경호');
INSERT INTO secondarytbl VALUES ('JYP', '조용필');
INSERT INTO secondarytbl VALUES ('SSK', '성시경');
INSERT INTO secondarytbl VALUES ('LJB', '임재범');
INSERT INTO secondarytbl VALUES ('YJS', '윤종신');
INSERT INTO secondarytbl VALUES ('EJW', '은지원');
INSERT INTO secondarytbl VALUES ('JKW', '조관우');
INSERT INTO secondarytbl VALUES ('BBK', '바비킴');

-- UNIQUE 제약조건으로 보조 인덱스를 생성
ALTER TABLE secondarytbl
	ADD CONSTRAINT UK_secondarytbl_userID
		UNIQUE (userID);

-- 보조 인덱스의 경우 데이터의 정렬이 않음
SELECT * FROM secondarytbl;

/* 실습2. 하나의 테이블에 클러스터형 인덱스와 보조 인덱스를 모두 포함 */
USE chap09;
DROP TABLE IF EXISTS mixedtbl;
CREATE TABLE mixedtbl (
	userID CHAR(8) NOT NULL,
	name VARCHAR(10) NOT NULL,
    addr char(2)
);

INSERT INTO mixedtbl VALUES ('LSG', '이승기', '서울');
INSERT INTO mixedtbl VALUES ('KBS', '김범수', '경남');
INSERT INTO mixedtbl VALUES ('KKH', '김경호', '전남');
INSERT INTO mixedtbl VALUES ('JYP', '조용필', '경기');
INSERT INTO mixedtbl VALUES ('SSK', '성시경', '서울');
INSERT INTO mixedtbl VALUES ('LJB', '임재범', '서울');
INSERT INTO mixedtbl VALUES ('YJS', '윤종신', '경남');
INSERT INTO mixedtbl VALUES ('EJW', '은지원', '경북');
INSERT INTO mixedtbl VALUES ('JKW', '조관우', '경기');
INSERT INTO mixedtbl VALUES ('BBK', '바비킴', '서울');

SELECT * FROM mixedtbl;

-- userID 에 클러스터형 인덱스를 생성
ALTER TABLE mixedtbl
	ADD CONSTRAINT PK_mixedtbl_userID
		PRIMARY KEY (userID);

-- name 에 보조 인덱스 생성
ALTER TABLE mixedtbl
	ADD CONSTRAINT UK_mixedtbl_name
		UNIQUE (name);

-- 인덱스 생성여부 확인
SHOW INDEX FROM mixedtbl;

-- 인덱스는 검색 속도를 빠르게 할 뿐이지 검색 결과와는 관계가 없다.
SELECT addr FROM mixedtbl WHERE name = '임재범';