/* 9.4.2 인덱스 제거 */
/* ------------------------------------------------------------------------ */

DROP DATABASE IF EXISTS chap09;
CREATE DATABASE chap09;
USE chap09;

/* 실습3. 인덱스를 생성하고 사용하는 실습 */
DROP TABLE IF EXISTS usertbl;
CREATE TABLE usertbl (
  userID char(8) NOT NULL,
  name varchar(10) NOT NULL,
  birthYear int NOT NULL,
  addr char(2) NOT NULL,
  mobile1 char(3) DEFAULT NULL,
  mobile2 char(8) DEFAULT NULL,
  height smallint DEFAULT NULL,
  mDate date DEFAULT NULL,
  PRIMARY KEY (userID)
);

INSERT INTO usertbl VALUES 
('BBK','바비킴',1973,'서울','010','00000000',176,'2013-05-05'),
('EJW','은지원',1972,'경북','011','88888888',174,'2014-03-03'),
('JJH','정지훈',1979,'서울','010','12345678',177,'2012-05-12'),
('JKW','조관우',1965,'경기','018','99999999',172,'2010-10-10'),
('JYP','조용필',1950,'경기','011','44444444',166,'2009-04-04'),
('KBS','김범수',1979,'경남','011','22222222',173,'2012-04-04'),
('KKH','김경호',1971,'전남','019','33333333',177,'2007-07-07'),
('LJB','임재범',1963,'서울','016','66666666',182,'2009-09-09'),
('LSG','이승기',1987,'서울','011','11111111',182,'2008-08-08'),
('SSK','성시경',1979,'서울',NULL,NULL,186,'2013-12-12'),
('YJS','윤종신',1969,'경남',NULL,NULL,170,'2005-05-05');

SELECT * FROM usertbl;

DROP TABLE IF EXISTS buytbl;
CREATE TABLE `buytbl` (
  `num` int NOT NULL AUTO_INCREMENT,
  `userID` char(8) NOT NULL,
  `prodName` char(6) NOT NULL,
  `groupName` char(4) DEFAULT NULL,
  `price` int NOT NULL,
  `amount` smallint NOT NULL,
  PRIMARY KEY (`num`),
  KEY `userID` (`userID`),
  CONSTRAINT `buytbl_ibfk_1` FOREIGN KEY (`userID`) REFERENCES `usertbl` (`userID`)
);

-- 인덱스 이름 확인
SHOW INDEX FROM usertbl;

-- 인덱스 크기 확인(Data_length)
-- MySQL의 페이지 크기는 기본적으로 16KB 이므로 클러스터형 인덱스는 1 페이지(16348/(16*1024))가 할당되어 있음
SHOW TABLE STATUS LIKE 'usertbl';

-- 단순 보조 인덱스 생성(UNIQUE와 반대로 중복을 허용함)
CREATE INDEX idx_usertbl_addr
	ON usertbl (addr);

-- 생성된 인덱스 이름을 확인
SHOW INDEX FROM usertbl;

-- 생성한 인덱스를 실제 적용시키려면 테이블을 분석/처리해줘야 한다.
ANALYZE TABLE usertbl;

-- 분석/처리 후 보조 인덱스의 크기가 생기는 것을 확인
SHOW TABLE STATUS LIKE 'usertbl';

-- 출생년도에 고유 보조 인덱스를 생성
-- birthYear는 중복값이 존재하기 때문에 에러 발생
CREATE UNIQUE INDEX idx_usertbl_birthYear
	ON usertbl (birthYear);

-- 이름에 고유 보조 인덱스를 생성
CREATE UNIQUE INDEX idx_usertbl_name
	ON usertbl (name);

SHOW INDEX FROM usertbl;

-- 김범수와 이름이 같은 사람을 입력 시 에러 발생
-- 고유 인덱스는 업무 절차상 절대롤 중복되지 않을 경우에만 UNIQUE 설정을 사용해야 함
INSERT INTO usertbl VALUES('GPS', '김범수', 1983, '미국', NULL, NULL, 162, NULL);

-- name 에 설정된 인덱스를 삭제하고, name 과 birthYear 를 조합해서 인덱스를 생성
DROP INDEX idx_usertbl_name ON usertbl;
CREATE INDEX idx_usertbl_name_birthYear
	ON usertbl (name, birthYear);

SHOW INDEX FROM usertbl;

-- 결과창 우측에 있는 'Execution Plan' 을 선택해보면 어떤 인덱스를 사용해서 결과를 찾았는지 확인 가능
SELECT * FROM usertbl WHERE name = '윤종신' AND birthYear = '1969';

-- 인덱스 삭제 시에는 보조 인덱스를 먼저 삭제하는 것이 좋음
DROP INDEX idx_usertbl_addr ON usertbl;
-- ALTER TABLE 로 인덱스 삭제 가능
ALTER TABLE usertbl
	DROP INDEX idx_usertbl_name_birthYear;

-- PRIMARY KEY에 설정된 인덱스는 ALTER TABLE 로만 삭제가 가능
-- 다른 테이블에서 해당 열을 참조하고 있는 경우 외래 키 관계를 제거한 후에 PRIMARY KEY 제거 가능
ALTER TABLE usertbl
	DROP PRIMARY KEY;

-- 외래 키 제약조건을 확인
SELECT table_name, constraint_name
	FROM information_schema.referential_constraints
    WHERE constraint_schema = 'chap09';

-- buy_tbl에서 외래키를 먼저 제거하고 usertbl에서 기본 키를 제거
ALTER TABLE buy_tbl DROP FOREIGN KEY buytbl_ibfk_1;
ALTER TABLE usertbl
	DROP PRIMARY KEY;