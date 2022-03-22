-- 기존 데이터베이스가 있으면 데이터베이스 삭제
DROP DATABASE IF EXISTS sample01_db;

-- 데이터베이스 생성 및 사용
CREATE DATABASE sample01_db;
USE sample01_db;

-- user_tbl 생성
CREATE TABLE `user_tbl` (
  `userID` char(8) NOT NULL,
  `name` varchar(10) NOT NULL,
  `birthYear` int NOT NULL,
  `addr` char(2) NOT NULL,
  `mobile1` char(3) DEFAULT NULL,
  `mobile2` char(8) DEFAULT NULL,
  `height` smallint DEFAULT NULL,
  `mDate` date DEFAULT NULL,
  PRIMARY KEY (`userID`)
);

-- buy_tbl 생성
CREATE TABLE `buy_tbl` (
  `num` int NOT NULL AUTO_INCREMENT,
  `userID` char(8) NOT NULL,
  `prodName` char(6) NOT NULL,
  `groupName` char(4) DEFAULT NULL,
  `price` int NOT NULL,
  `amount` smallint NOT NULL,
  PRIMARY KEY (`num`),
  KEY `userID` (`userID`),
  CONSTRAINT `buytbl_ibfk_1` FOREIGN KEY (`userID`) REFERENCES `user_tbl` (`userID`)
);

-- user_tbl 데이터 삽입
INSERT INTO user_tbl VALUES 
('BBK','바비킴',1973,'서울','010','00000000',176,'2013-05-05'),
('EJW','은지원',1972,'경북','011','88888888',174,'2014-03-03'),
('JJH','정지훈',1979,'서울','010','12345678',177,'2012-05-12'),
('JKW','조관우',1965,'경기','018','99999999',172,'2010-10-10'),
('JYP','조용필',1950,'경기','011','44444444',166,'2009-04-04'),
('KBS','김범수',1979,'경남','011','22222222',173,'2012-04-04'),
('KKH','김경호',1971,'전남','019','33333333',177,'2007-07-07'),
('LJB','임재범',1963,'서울','016','66666666',182,'2009-09-09'),
('LSG','이승기',1987,'서울','011','11111111',182,'2008-08-08'),
('SSK','성시경',1979,'서울','','',186,'2013-12-12'),
('YJS','윤종신',1969,'경남','','',170,'2005-05-05');

-- buy_tbl 테이블 데이터 삽입
INSERT INTO buy_tbl VALUES (1,'KBS','운동화','',30,2);
INSERT INTO buy_tbl VALUES (2,'KBS','노트북','전자',1000,1);
INSERT INTO buy_tbl VALUES (3,'JYP','모니터','전자',200,1);
INSERT INTO buy_tbl VALUES (4,'BBK','모니터','전자',200,5);
INSERT INTO buy_tbl VALUES (5,'KBS','청바지','의류',50,3);
INSERT INTO buy_tbl VALUES (6,'BBK','메모리','전자',80,10);
INSERT INTO buy_tbl VALUES (7,'SSK','책','서적',15,5);
INSERT INTO buy_tbl VALUES (8,'EJW','책','서적',15,2);
INSERT INTO buy_tbl VALUES (9,'EJW','청바지','의류',50,1);
INSERT INTO buy_tbl VALUES (10,'BBK','운동화','',30,2);
INSERT INTO buy_tbl VALUES (11,'EJW','책','서적',15,1);
INSERT INTO buy_tbl VALUES (12,'BBK','운동화','',30,2);

-- test_db 에 있는 테이블 목록 확인
SHOW TABLES;

-- user_tbl 에 있는 모든 레코드 확인
SELECT * FROM user_tbl;
