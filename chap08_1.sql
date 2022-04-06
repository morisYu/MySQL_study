/* 8.1.1 테이블 만들기 */
/* ------------------------------------------------------------------------ */

/* 실습2. SQL을 이용해서 테이블 생성 */

DROP DATABASE IF EXISTS tabledb;
CREATE DATABASE tabledb;
USE tabledb;

-- 테이블의 기본틀 구성
DROP TABLE IF EXISTS usertbl, buytbl;
CREATE TABLE usertbl (
	userID	CHAR(8),
    name 	VARCHAR(10),
    birthYear	INT,
    addr	CHAR(2),
    mobile1	CHAR(3),
    mobile2	CHAR(8),
    height	SMALLINT,
    mDate	DATE
);

CREATE TABLE buytbl (
	num	INT,
    userid CHAR(8),
    prodName CHAR(6),
    groupName CHAR(4),
    price INT,
    amount SMALLINT
);
DESC usertbl;
EXPLAIN buytbl;

-- NULL 옵션을 추가해서 다시 생성
DROP TABLE IF EXISTS usertbl, buytbl;
CREATE TABLE usertbl (
	userID	CHAR(8) NOT NULL,
    name 	VARCHAR(10) NOT NULL,
    birthYear	INT NOT NULL,
    addr	CHAR(2) NOT NULL,
    mobile1	CHAR(3) NULL,
    mobile2	CHAR(8) NULL,
    height	SMALLINT NULL,
    mDate	DATE NULL
);

CREATE TABLE buytbl (
	num	INT NOT NULL,
    userid CHAR(8) NOT NULL,
    prodName CHAR(6) NOT NULL,
    groupName CHAR(4) NULL,
    price INT NOT NULL,
    amount SMALLINT NOT NULL
);
DESC usertbl;
EXPLAIN buytbl;

-- 각 테이블에 기본 키를 설정, buytbl에 AUTO_INCREMENT 설정
DROP TABLE IF EXISTS usertbl, buytbl;
CREATE TABLE usertbl (
	userID	CHAR(8) NOT NULL PRIMARY KEY,
    name 	VARCHAR(10) NOT NULL,
    birthYear	INT NOT NULL,
    addr	CHAR(2) NOT NULL,
    mobile1	CHAR(3) NULL,
    mobile2	CHAR(8) NULL,
    height	SMALLINT NULL,
    mDate	DATE NULL
);

CREATE TABLE buytbl (
	num	INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    userid CHAR(8) NOT NULL,
    prodName CHAR(6) NOT NULL,
    groupName CHAR(4) NULL,
    price INT NOT NULL,
    amount SMALLINT NOT NULL
);
DESC usertbl;
EXPLAIN buytbl;

-- buytbl 의 아이디 열을 usertbl 의 아이디 열의 외래 키로 설정
DROP TABLE IF EXISTS usertbl, buytbl;
CREATE TABLE usertbl (
	userID	CHAR(8) NOT NULL PRIMARY KEY,
    name 	VARCHAR(10) NOT NULL,
    birthYear	INT NOT NULL,
    addr	CHAR(2) NOT NULL,
    mobile1	CHAR(3) NULL,
    mobile2	CHAR(8) NULL,
    height	SMALLINT NULL,
    mDate	DATE NULL
);

CREATE TABLE buytbl (
	num	INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    userid CHAR(8) NOT NULL,
    prodName CHAR(6) NOT NULL,
    groupName CHAR(4) NULL,
    price INT NOT NULL,
    amount SMALLINT NOT NULL,
    FOREIGN KEY (userid) REFERENCES usertbl(userID)
);
DESC usertbl;
EXPLAIN buytbl;

-- 테이블 데이터 입력
INSERT INTO usertbl VALUES ('LSG', '이승기', 1987, '서울', '011', '11111111', 182, '2008-8-8');
INSERT INTO usertbl VALUES ('KBS', '김범수', 1979, '경남', '011', '22222222', 173, '2012-4-4');
INSERT INTO usertbl VALUES ('KKH', '김경호', 1971, '전남', '019', '33333333', 177, '2007-7-7');

INSERT INTO buytbl VALUES (NULL, 'KBS', '운동화', NULL, 30, 2);
INSERT INTO buytbl VALUES (NULL, 'KBS', '노트북', '전자', 1000, 1);
-- 'JYP'는 아직 회원 테이블에 존재하지 않아서 오류가 발생(userid 가 FOREIGN KEY 로 설정되어있어서 오류 발생)
INSERT INTO buytbl VALUES (NULL, 'JYP', '모니터', '전자', 200, 1);



/* 8.1.2 제약 조건 */
/* ------------------------------------------------------------------------ */

/* PRIMARY KEY 설정 */
USE tabledb;
DROP TABLE IF EXISTS usertbl, buytbl;
CREATE TABLE usertbl (
	userID CHAR(8) NOT NULL PRIMARY KEY,
    name VARCHAR(10) NOT NULL,
    birthYear INT NOT NULL
);
DESCRIBE usertbl;

-- PRIMARY KEY의 이름(PK_userTBL_userID)을 설정
DROP TABLE IF EXISTS userTBL;
CREATE TABLE userTBL (
	userID CHAR(8) NOT NULL,
    name VARCHAR(10) NOT NULL,
    birthYear INT NOT NULL,
	CONSTRAINT PRIMARY KEY PK_userTBL_userID (userID)
);
DESCRIBE userTBL;

-- PRIMARY KEY 는 이름을 설정해도 항상 PRIMARY 로 이름이 나옴. FOREIGN KEY 의 경우 이름을 설정하면 관리가 쉬움
SHOW KEYS FROM userTBL;

-- 이미 만들어진 테이블을 수정해서 PRIMARY KEY 설정
DROP TABLE IF EXISTS usertbl;
CREATE TABLE usertbl (
	userID CHAR(8) NOT NULL,
    name VARCHAR(10) NOT NULL,
    birthYear INT NOT NULL
);
SHOW KEYS FROM userTBL;

ALTER TABLE usertbl
	ADD CONSTRAINT PK_usertbl_userID PRIMARY KEY (userID);
SHOW KEYS FROM userTBL;

-- 하나의 열만 PRIMARY KEY로 설정하면 중복될 가능성이 있는 경우, 두개의 열을 합쳐서 PRIMARY KEY로 설정 가능
DROP TABLE IF EXISTS prodtbl;
CREATE TABLE prodtbl (
	prodCode CHAR(3) NOT NULL,
    prodID CHAR(4) NOT NULL,
    prodDate DATETIME NOT NULL,
    prodCur CHAR(10) NULL
);
ALTER TABLE prodtbl
	ADD CONSTRAINT PRIMARY KEY (prodCode, prodID);
SHOW KEYS FROM prodtbl;

DROP TABLE IF EXISTS prodtbl;
CREATE TABLE prodtbl (
	prodCode CHAR(3) NOT NULL,
    prodID CHAR(4) NOT NULL,
    prodDate DATETIME NOT NULL,
    prodCur CHAR(10) NULL,
    CONSTRAINT PK_prodtbl_prodCode_prodID PRIMARY KEY (prodCode, prodID) 
);
SHOW KEYS FROM prodtbl;

/* 외래 키 제약 조건 */

-- buytbl 에서 FOREIGN KEY 설정
DROP TABLE IF EXISTS usertbl, buytbl;
CREATE TABLE usertbl (
	userID CHAR(8) NOT NULL PRIMARY KEY,
    name VARCHAR(10) NOT NULL,
    birthYear INT NOT NULL
);
CREATE TABLE buytbl (
	num INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    userID CHAR(8) NOT NULL,
    prodName CHAR(6) NOT NULL,
    FOREIGN KEY(userID) REFERENCES usertbl(userID)
);
SHOW KEYS FROM buytbl;

-- FOREIGN KEY 이름 설정
DROP TABLE IF EXISTS buytbl;
CREATE TABLE buytbl (
	num INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    userID CHAR(8) NOT NULL,
    prodName CHAR(6) NOT NULL,
    CONSTRAINT FK_usertbl_buytbl FOREIGN KEY (userID) REFERENCES usertbl(userID)
);
SHOW KEYS FROM buytbl;

-- 테이블 생성 후 ALTER 문으로 FOREIGN KEY 설정
DROP TABLE IF EXISTS buytbl;
CREATE TABLE buytbl (
	num INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    userID CHAR(8) NOT NULL,
    prodName CHAR(6) NOT NULL
);
SHOW KEYS FROM buytbl;
ALTER TABLE buytbl
	ADD CONSTRAINT FK_usertbl_buytbl
	FOREIGN KEY (userID)
    REFERENCES usertbl(userID);
SHOW KEYS FROM buytbl;
SHOW INDEX FROM buytbl;

-- 기준 테이블의 데이터가 변경되었을 때 외래 키 테이블도 자동으로 적용
ALTER TABLE buytbl
	DROP FOREIGN KEY FK_usertbl_buytbl;
ALTER TABLE buytbl
	ADD CONSTRAINT FK_usertbl_buytbl
	FOREIGN KEY (userID)
    REFERENCES usertbl(userID)
    ON UPDATE CASCADE;

/* UNIQUE 제약 조건 */
-- 중복되지 않는 유일한 값을 입력하지만 NULL 도 허용함.
-- 기존 회원 테이블에 E-Mail 추가
USE tabledb;
DROP TABLE IF EXISTS usertbl, buytbl;
CREATE TABLE usertbl (
	userID CHAR(8) NOT NULL PRIMARY KEY,
    name VARCHAR(10) NOT NULL,
    birthYear INT NOT NULL,
    email CHAR(30) NULL UNIQUE
);

DROP TABLE IF EXISTS usertbl;
CREATE TABLE usertbl (
	userID CHAR(8) NOT NULL PRIMARY KEY,
    name VARCHAR(10) NOT NULL,
    birthYear INT NOT NULL,
    email CHAR(30) NULL,
    CONSTRAINT AK_email UNIQUE (email)
);
DESC usertbl;
SHOW KEYS FROM usertbl;

/* CHECK 제약 조건 */
-- 입력되는 데이터를 점검하는 기능

-- CHECK 제약 조건 설정
DROP TABLE IF EXISTS usertbl;
CREATE TABLE usertbl (
	userID CHAR(8) PRIMARY KEY,
    name VARCHAR(10),
    birthYear INT CHECK (birthYear >= 1900 AND birthYear <= 2023),
    mobile1 char(3) NULL,
    CONSTRAINT CK_name CHECK (name IS NOT NULL)
);

-- mobile1 에 CHECK 제약조건 추가
ALTER TABLE usertbl
	ADD CONSTRAINT CK_mobile1
	CHECK (mobile1 IN ('010', '011', '016', '017', '018', '019'));
    
-- CHECK 범위에 벗어난 값을 입력 시 오류 발생
INSERT INTO usertbl VALUES ('WB', '원빈', 1882, '019');

/* DEFAULT 정의 */

-- 값을 입력하지 않았을 떄 자동으로 입력되는 값을 정의
DROP TABLE IF EXISTS usertbl;
CREATE TABLE usertbl (
	userID CHAR(8) NOT NULL PRIMARY KEY,
    name VARCHAR(10) NOT NULL,
    birthYear INT NOT NULL DEFAULT -1,
    addr CHAR(2) NOT NULL DEFAULT '서울',
    mobile1 CHAR(3) NULL,
    mobile2 CHAR(8) NULL,
    height SMALLINT NULL DEFAULT 170,
    mDate DATE NULL
);

-- ALTER COLUMN 문으로 DEFAULT 정의
DROP TABLE IF EXISTS usertbl;
CREATE TABLE usertbl (
	userID CHAR(8) NOT NULL PRIMARY KEY,
    name VARCHAR(10) NOT NULL,
    birthYear INT NOT NULL,
    addr CHAR(2) NOT NULL,
    mobile1 CHAR(3) NULL,
    mobile2 CHAR(8) NULL,
    height SMALLINT NULL,
    mDate DATE NULL
);
ALTER TABLE usertbl
	ALTER COLUMN birthYear SET DEFAULT -1;
ALTER TABLE usertbl
	ALTER COLUMN addr SET DEFAULT '서울';
ALTER TABLE usertbl
	ALTER COLUMN height SET DEFAULT 170;

-- default 문은 DEFAULT로 설정된 값을 자동 입력한다.
INSERT INTO usertbl VALUES ('LHL', '이해리', default, default, '011', '1234567', default, '2023.12.12');

-- 열 이름이 명시되지 않으면 DEFAULT 로 설정된 값을 자동 입력한다.
INSERT INTO usertbl(userID, name) VALUES ('KAY', '김아영');

-- 값이 직접 명기되면 DEFAULT 로 설정된 값은 무시된다.
INSERT INTO usertbl VALUES ('WB', '원빈', 1982, '대전', '019', '9876543', 176, '2020.5.5');
SELECT * FROM usertbl;



/* 8.1.3 테이블 압축 */
/* ------------------------------------------------------------------------ */

/* 실습3. 테이블 압축 기능 확인 */

DROP DATABASE IF EXISTS compressdb;
CREATE DATABASE compressdb;
USE compressdb;

-- 일반 테이블 생성
CREATE TABLE normaltbl (
	emp_no INT,
    first_name VARCHAR(14)
);

-- 압축 테이블 생성(데이터 입력 시 압축되면서 데이터가 입력되기 때문에 시간이 조금 더 걸림)
CREATE TABLE compresstbl (
	emp_no INT,
    first_name VARCHAR(14)
)ROW_FORMAT=COMPRESSED;

-- 데이터 입력
INSERT INTO normaltbl
	SELECT emp_no, first_name FROM employees.employees;
INSERT INTO compresstbl
	SELECT emp_no, first_name FROM employees.employees;

-- 테이블 상태 확인(압축된 테이블이 Avg_row_length 와 Data_length 가 훤씬 작은 것을 확인 가능)
SHOW TABLE STATUS FROM compressdb;



/* 8.1.6 테이블 수정 */
/* ------------------------------------------------------------------------ */

/* 실습5. 테이블의 제약조건 및 수정 방법 */

CREATE DATABASE IF NOT EXISTS tabledb;
USE tabledb;
DROP TABLE IF EXISTS buytbl, usertbl;

-- 테이블 생성 
CREATE TABLE usertbl (
	userID CHAR(8),
    name VARCHAR(10),
    birthYear INT,
    addr CHAR(2),
    mobile1 CHAR(3),
    mobile2 CHAR(8),
    height SMALLINT,
    mDate DATE
);

CREATE TABLE buytbl (
	num INT AUTO_INCREMENT PRIMARY KEY,
    userid CHAR(8),
    prodName CHAR(6),
    groupName CHAR(4),
    price INT,
    amount SMALLINT
);

-- 데이터 입력
INSERT INTO usertbl VALUES('LSG', '이승기', 1987, '서울', '011', '11111111', 182, '2008-8-8');
INSERT INTO usertbl VALUES('KBS', '김범수', NULL, '경남', '011', '22222222', 173, '2012-4-4');
INSERT INTO usertbl VALUES('KKH', '김경호', 1871, '전남', '019', '33333333', 177, '2007-7-7');
INSERT INTO usertbl VALUES('JYP', '조용필', 1950, '경기', '011', '44444444', 166, '2009-4-4');

INSERT INTO buytbl VALUES (NULL, 'KBS', '운동화', NULL, 30, 2), (NULL, 'KBS', '노트북', '전자', 1000, 1),
                          (NULL, 'JYP', '모니터', '전자', 200, 1), (NULL, 'BBK', '모니터', '전자', 200, 5);
                    
-- 제약조건 생성
ALTER TABLE usertbl
	ADD CONSTRAINT PK_usertbl_userID
    PRIMARY KEY (userID);
DESC usertbl;

-- 외래키 설정
-- 참조해야 할 'BBK' 가 없기 때문에 오류가 발생함
ALTER TABLE buytbl
	ADD CONSTRAINT FK_usertbl_buytbl
    FOREIGN KEY (userid)
    REFERENCES usertbl (userID);

-- 문제가 되는 'BBK' 행 삭제 후 다시 외래키 설정
DELETE FROM buytbl WHERE userid = 'BBK';
ALTER TABLE buytbl
	ADD CONSTRAINT FK_usertbl_buytbl
	FOREIGN KEY (userid)
    REFERENCES usertbl (userID);

-- 'BBK' 데이터 다시 입력
-- 외래키가 설정된 상태이기 때문에 참조하는 usertbl에 'BBK'가 있어야 buytbl에 입력 가능
INSERT INTO buytbl VALUES (NULL, 'BBK', '모니터', '전자', 200, 5);

-- usertbl에 먼저 입력 후 buytbl에 입력해도 되지만, 대량의 buytbl 데이터를 먼저 입력해야 하는 경우에는
-- 외래키 제약조건을 비활성화 시키고, 데이터를 입력 후 다시 외래키 제약조건을 활성화 시킬 수도 있다.
SET foreign_key_checks = 0;
INSERT INTO buytbl VALUES (NULL, 'BBK', '모니터', '전자', 200, 5);
INSERT INTO buytbl VALUES (NULL, 'KBS', '청바지', '의류', 200, 5);
INSERT INTO buytbl VALUES (NULL, 'BBK', '메모리', '전자', 200, 5);
INSERT INTO buytbl VALUES (NULL, 'SSK', '책', '서적', 200, 5);
INSERT INTO buytbl VALUES (NULL, 'EJW', '책', '서적', 200, 5);
INSERT INTO buytbl VALUES (NULL, 'EJW', '청바지', '의류', 200, 5);
INSERT INTO buytbl VALUES (NULL, 'BBK', '운동화', NULL, 200, 5);
INSERT INTO buytbl VALUES (NULL, 'EJW', '책', '서적', 200, 5);
INSERT INTO buytbl VALUES (NULL, 'BBK', '운동화', NULL, 200, 5);
SET foreign_key_checks = 1;
SELECT * FROM buytbl;

-- CHECK 제약조건을 설정
-- '김범수' 는 생년이 NULL 로 되어있고, '김경호' 는 생년이 범위를 벗어나기 때문에 오류가 발생한다.
ALTER TABLE usertbl
	ADD CONSTRAINT CK_birthYear
    CHECK ( (birthYear >= 1900 AND birthYear <= 2023) AND (birthYear IS NOT NULL));

-- '김범수' 와 '김경호' 의 생년을 수정 후 CHECK 제약조건을 다시 설정
UPDATE usertbl SET birthYear = 1979 WHERE userID = 'KBS';
UPDATE usertbl SET birthYear = 1971 WHERE userID = 'KKH';
ALTER TABLE usertbl
	ADD CONSTRAINT CK_birthYear
    CHECK ( (birthYear >= 1900 AND birthYear <= 2023) AND (birthYear IS NOT NULL));

-- 나머지 usertbl의 정상적인 데이터를 입력
INSERT INTO usertbl VALUES ('SSK', '성시경', 1979, '서울', NULL, NULL, 186, '2013-12-12');
INSERT INTO usertbl VALUES ('LJB', '임재범', 1963, '서울', '016', '66666666', 182, '2009-9-9');
INSERT INTO usertbl VALUES ('YJS', '윤종신', 1969, '경남', NULL, NULL, 170, '2005-5-5');
INSERT INTO usertbl VALUES ('EJW', '은진원', 1972, '경북', '011', '88888888', 174, '2014-3-3');
INSERT INTO usertbl VALUES ('JKW', '조관우', 1965, '경기', '018', '99999999', 172, '2010-10-10');
INSERT INTO usertbl VALUES ('BBK', '바비킴', 1973, '서울', '010', '00000000', 176, '2013-5-5');

SELECT * FROM usertbl;
SELECT * FROM buytbl;

-- usertbl 에서 'BBK' 를 'VVK' 로 변경
-- 이미 buytbl 에서 'BBK' 로 구매내역이 있기 때문에 바뀌지 않는다.
-- 따라서 잠깐 제약조건을 비활성화 후 데이터를 변경하고 다시 제약조건을 활성화하면 된다.
SET foreign_key_checks = 0;
UPDATE usertbl SET userID = 'VVK' WHERE userID = 'BBK';
SET foreign_key_checks = 1;

-- buytbl 과 usertbl 을 조인
SELECT B.userid, U.name, B.prodName, U.addr, CONCAT(U.mobile1, U.mobile2) AS '연락처'
	FROM buytbl B
		INNER JOIN usertbl U
			ON B.userid = U.userID;

-- 구매 내역을 카운트
-- 위에서 조인한 결과와 카운트가 맞지 않는다.
SELECT COUNT(*) FROM buytbl;

-- 외부조인으로 구매 테이블의 내용을 모두 출력
-- 위에서 나온 결과와 다르게 'BBK'가 출력된다.
-- 'BBK' 는 'VVK' 로 수정했기 때문에 name, addr, 연락처가 없다.
SELECT B.userid, U.name, B.prodName, U.addr, CONCAT(U.mobile1, U.mobile2) AS '연락처'
	FROM buytbl B
		LEFT OUTER JOIN usertbl U
			ON B.userid = U.userID
	ORDER BY B.userid;

-- '바비킴'의 아이디를 원래대로 복구
-- 외래키 설정을 비활성화해서 데이터를 수정할 경우 위와 같은 사항을 주의해야 한다.
SET foreign_key_checks = 0;
UPDATE usertbl SET userID = 'BBK' WHERE userID = 'VVK';
SET foreign_key_checks = 1;

-- usertbl의 userID 가 변경될 경우 buytbl에서 userid가 자동으로 변경되도록 외래키 제약조건 새로 설정
ALTER TABLE buytbl
	DROP FOREIGN KEY FK_usertbl_buytbl;
ALTER TABLE buytbl
	ADD CONSTRAINT FK_usertbl_buytbl
		FOREIGN KEY (userid)
        REFERENCES usertbl (userID)
		ON UPDATE CASCADE;

-- usertbl의 '바비킴' 의 ID 를 다시 변경하고, buytbl에도 바뀌었는지 확인
UPDATE usertbl SET userID = 'VVK' WHERE userID = 'BBK';
SELECT B.userid, U.name, B.prodName, U.addr, CONCAT(U.mobile1, U.mobile2) AS '연락처'
	FROM buytbl B
		INNER JOIN usertbl U
			ON B.userid = U.userID
	ORDER BY B.userid;

-- '바비킴' 이 usertbl에서 삭제되면 buytbl에서도 삭제되는지 확인
-- 외래 키 제약조건 때문에 삭제가 되지 않음
DELETE FROM usertbl WHERE userid = 'VVK';

-- usertbl의 user의 기록이 삭제된 경우 buytbl 에서도 관련된 데이터도 삭제되도록 설정
ALTER TABLE buytbl
	DROP FOREIGN KEY FK_usertbl_buytbl;
ALTER TABLE buytbl
	ADD CONSTRAINT FK_usertbl_buytbl
		FOREIGN KEY (userid)
		REFERENCES usertbl (userID)
		ON UPDATE CASCADE
        ON DELETE CASCADE;

-- 다시 usertbl 에서 '바비킴' 을 삭제 후 buytbl 에도 데이터가 삭제 되었는지 확인
DELETE FROM usertbl WHERE userID = 'VVK';
SELECT * FROM buytbl ORDER BY userid DESC;

-- 출생년도 열을 삭제
-- MySQL은 제약조건을 무시하고 전부 삭제, 다른 DBMS는 CHECK 제약조건이 설정된 열은 삭제되지 않음.
ALTER TABLE usertbl
	DROP COLUMN birthYear;