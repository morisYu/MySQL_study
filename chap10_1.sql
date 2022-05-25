/* 10.1.1 스토어드 프로시저의 개요 */
/* ------------------------------------------------------------------------ */

DROP DATABASE IF EXISTS chap10;
CREATE DATABASE chap10;
USE chap10;

/* 실습. 스토어드 프로시저 내용을 실습 */

-- 1 개의 매개변수가 있는 스토어드 프로시저 생성(user_tbl 미리 생성)
DROP PROCEDURE IF EXISTS userProc1;
DELIMITER $$
CREATE PROCEDURE userProc1 (IN userName VARCHAR(10))
BEGIN
	SELECT * FROM user_tbl WHERE name = userName;
END $$
DELIMITER ;

CALL userProc1('조관우');

-- 2 개의 매개변수가 있는 스토어드 프로시저를 생성
DROP PROCEDURE IF EXISTS userProc2;
DELIMITER $$
CREATE PROCEDURE userProc2 (
	IN userBirth INT,
    IN userHeight INT
)
BEGIN
	SELECT * FROM user_tbl
		WHERE birthYear > userBirth AND height > userHeight;
END $$
DELIMITER ;

CALL userProc2(1970, 178);

-- 출력 매개변수를 설정해서 사용
-- testTBL 이라는 테이블은 없지만 프로시저는 정상적으로 생성됨
DROP PROCEDURE IF EXISTS userProc3;
DELIMITER $$
CREATE PROCEDURE userProc3(
	IN txtValue CHAR(10),
    OUT outValue INT
)
BEGIN
	INSERT INTO testTBL VALUES(NULL, txtValue);
    SELECT MAX(id) INTO outValue FROM testTBL;
END $$
DELIMITER ;

-- 프로시저를 사용하기 전에는 테이블이 존재해야 오류가 발생하지 않음
CREATE TABLE IF NOT EXISTS testTBL(
	id INT AUTO_INCREMENT PRIMARY KEY,
    txt CHAR(10)
);

-- 프로시저 내에 값이 삽입되기 때문에 변수 @myValue 에 저장되는 출력값은
-- 프로시저를 실행할 때마다 1 씩 증가한다.
CALL userProc3 ('테스트값', @myValue);
SELECT CONCAT('현재 입력된 ID 값: ', @myValue) AS '출력값';

-- 스토어드 프로시저 안에 SQL 프로그래밍을 활용
-- IF ... ELSE 문 사용
DROP PROCEDURE IF EXISTS ifelseProc;
DELIMITER $$
CREATE PROCEDURE ifelseProc(
	IN userName VARCHAR(10)
)
BEGIN
	-- bYear 변수 선언
	DECLARE bYear INT;
    SELECT birthYear INTO bYear FROM user_tbl
		WHERE name = userName;
	IF (bYear >= 1890) THEN
		SELECT '아직 젊군요';
	ELSE
		SELECT '나이가 지긋하시네요';
	END IF;
END $$
DELIMITER ;

CALL ifelseProc('조용필');

-- CASE 문 사용
DROP PROCEDURE IF EXISTS caseProc;
DELIMITER $$
CREATE PROCEDURE caseProc(
	IN userName VARCHAR(10)
)
BEGIN
	DECLARE bYear INT;
    DECLARE tti CHAR(3);
    SELECT birthYear INTO bYear FROM user_tbl
		WHERE name = userName;
	CASE
		WHEN (bYear%12 = 0) THEN SET tti = '원숭이';
        WHEN (bYear%12 = 1) THEN SET tti = '닭';
        WHEN (bYear%12 = 2) THEN SET tti = '개';
        WHEN (bYear%12 = 3) THEN SET tti = '돼지';
        WHEN (bYear%12 = 4) THEN SET tti = '쥐';
        WHEN (bYear%12 = 5) THEN SET tti = '소';
        WHEN (bYear%12 = 6) THEN SET tti = '호랑이';
        WHEN (bYear%12 = 7) THEN SET tti = '토끼';
        WHEN (bYear%12 = 8) THEN SET tti = '용';
        WHEN (bYear%12 = 9) THEN SET tti = '뱀';
        WHEN (bYear%12 = 10) THEN SET tti = '말';
        ELSE SET tti = '양';
	END CASE;
    SELECT  bYear AS '연도', CONCAT(userName, '의 띠 ==>', tti) AS '띠 확인';
END $$
DELIMITER ;

CALL caseProc('김범수');

-- WHILE 문 활용하여 구구단을 문자열로 생성해서 테이블에 입력
DROP TABLE IF EXISTS guguTBL;
CREATE TABLE guguTBL (txt VARCHAR(100));

DROP PROCEDURE IF EXISTS whileProc;
DELIMITER $$
CREATE PROCEDURE whileProc()
BEGIN
	DECLARE str VARCHAR(100);
    DECLARE i INT;
    DECLARE k INT;
    SET i = 2;
    
    WHILE(i < 10) DO
		SET str = '';
        SET k = 1;
        WHILE(k < 10) DO
			SET str = CONCAT(str, '  ', i, 'x', k, '=', i*k);
            SET k = k + 1;
		END WHILE;
        INSERT INTO guguTBL VALUES(str);
        SET i = i + 1;
	END WHILE;
END $$
DELIMITER ;

CALL whileProc();
SELECT * FROM guguTBL;

-- DECLARE ~ HANDLER 를 이용해서 오류 처리
DROP PROCEDURE IF EXISTS errorProc;
DELIMITER $$
CREATE PROCEDURE errorProc()
BEGIN
	DECLARE i INT;
    DECLARE hap INT;
    DECLARE saveHap INT;

	-- INT 형 오버플로우 발생 시 실행 될 부분
	DECLARE EXIT HANDLER FOR 1264
    BEGIN
		SELECT CONCAT('INT 오버플로우 직전의 합계: ', saveHap);
        SELECT CONCAT('1+2+3+4+...+', i, '=오버플로우');
	END;

	SET i = 1;
    SET hap = 0;
    
    -- 무한 루프 실행
    WHILE(TRUE) DO
		SET saveHap = hap;
        SET hap = hap + i;
        SET i = i + 1;
	END WHILE;
END $$
DELIMITER ;

CALL errorProc();

-- 현재 저장된 프로시저의 이름 및 내용을 확인
SELECT routine_name, routine_definition FROM INFORMATION_SCHEMA.ROUTINES
	WHERE routine_schema = 'chap10' AND routine_type = 'PROCEDURE';

-- 'userProc3' 에 사용되는 파라미터를 확인
SELECT parameter_mode, parameter_name, dtd_identifier
	FROM INFORMATION_SCHEMA.PARAMETERS
    WHERE specific_name = 'userProc3';

-- 테이블 이름을 파라미터로 전달
-- 테이블 이름을 직접 매개변수로 사용할 수 없음(오류 발생)
DROP PROCEDURE IF EXISTS nameProc;
DELIMITER $$
CREATE PROCEDURE nameProc(
	IN tblName VARCHAR(20)
)
BEGIN
	SELECT * FROM tblName;
END $$
DELIMITER ;

CALL nameProc('user_tbl');

-- 테이블 이름으로 조회하는 것을 변수에 저장해서 사용(동적 SQL)
DROP PROCEDURE IF EXISTS nameProc;
DELIMITER $$
CREATE PROCEDURE nameProc(
	IN tblName VARCHAR(20)
)
BEGIN
	SET @sqlQuery = CONCAT('SELECT * FROM ', tblName);
    PREPARE myQuery FROM @sqlQuery;
    EXECUTE myQuery;
    DEALLOCATE PREPARE myQuery;
END $$
DELIMITER ;

CALL nameProc('user_tbl');

-- 보안상의 이유도 테이블의 일부 정보만 노출해야 하는 경우에도 프로시저를 활용할 수 있음
-- 택배기사의 경우 사용자 아이디를 검색하면 해당 인물의 일부 정보를 확인할 수 있음
DROP PROCEDURE IF EXISTS delivProc;
DELIMITER $$
CREATE PROCEDURE delivProc(
	IN id VARCHAR(10)
)
BEGIN
	SELECT userID, name, addr, mobile1, mobile2
		FROM user_tbl
        WHERE userID = id;
END $$
DELIMITER ;
CALL delivProc('LJB');





