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
