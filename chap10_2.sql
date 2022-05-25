/* 10.2.2 스토어드 함수 실습 */
/* ------------------------------------------------------------------------ */

USE chap10;

-- 테이블 생성
DROP TABLE IF EXISTS userTBL;
CREATE TABLE userTBL (SELECT * FROM sample01_db.user_tbl);
SELECT * FROM userTBL;

-- MySQL이 함수 생성에 제약을 강제할 수 있기 때문에 해당 설정을 1(ON)로 바꾸지 않으면 함수 생성이 안됨.
SET GLOBAL log_bin_trust_function_creators = 1;

-- 출생년도를 입력하면 나이가 출력되는 함수 생성
DROP FUNCTION IF EXISTS getAgeFunc;
DELIMITER $$
CREATE FUNCTION getAgeFunc(bYear INT)
	RETURNS INT
BEGIN
	DECLARE age INT;
    SET age = YEAR(CURDATE()) - bYear;
    RETURN age;
END $$
DELIMITER ;

-- 함수 호출
SELECT getAgeFunc(1979);

-- 함수로 생성된 나이를 이용해서 두 사람 나이차를 계산
SELECT getAgeFunc(1979) INTO @age1979;
SELECT getAgeFunc(1997) INTO @age1997;
SELECT CONCAT('1979년과 1997년의 나이차 =>', (@age1979-@age1997)) '나이';

-- user_tbl 에서 출생년도를 이용해서 회원의 만 나이 조회
SELECT userID, name, getAgeFunc(birthYear) '만 나이' FROM userTBL;

-- 현재 저장된 스토어드 함수의 이름 및 내용을 확인
SHOW CREATE FUNCTION getAgeFunc;

