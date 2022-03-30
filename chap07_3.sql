/* 7.3.1 IF...ELSE */
/* ------------------------------------------------------------------------ */

USE employees;
DROP PROCEDURE IF EXISTS ifProc;
DELIMITER $$
CREATE PROCEDURE ifProc()
BEGIN
	DECLARE var1 INT;
    SET var1 = 100;
    
    IF var1 = 100 THEN
		SELECT '100입니다.' AS '결과값';
	ELSE
		SELECT '100이 아닙니다.';
	END IF;
END $$
DELIMITER ;
CALL ifProc();

-- employees 테이블에서 직원번호 10001번에 해당하는 직원의 입사일이 5년이 넘었는지 확인
USE employees;
SELECT * FROM employees;
DROP PROCEDURE IF EXISTS ifProc2;

DELIMITER $$
CREATE PROCEDURE ifProc2()
BEGIN
	DECLARE hireDATE DATE;
    DECLARE curDATE DATE;
    DECLARE days INT;
    
    SELECT hire_date INTO hireDATE
		FROM employees.employees
        WHERE emp_no = 10001;
	
    SET curDATE = CURRENT_DATE();
    SET days = DATEDIFF(curDATE, hireDATE);
    
    IF(days/5) > 5 THEN
		SELECT hireDATE, CONCAT('입사한지 ', days, '일이나 지났습니다. 축하합니다!') AS '경과일';
	ELSE
		SELECT '입사한지 ' + days + '일밖에 안되었네요. 열심히 일하세요';
	END IF;
END $$
DELIMITER ;
CALL ifProc2();
    


/* 7.3.2 CASE */
/* ------------------------------------------------------------------------ */

-- IF 문을 사용해서 점수에 따라 학점을 출력
DROP PROCEDURE IF EXISTS ifProc3;
DELIMITER $$
CREATE PROCEDURE ifProc3()
BEGIN
	DECLARE point INT;
    DECLARE credit CHAR(1);
    SET point = 77;
    
    IF point >= 90 THEN
		SET credit = 'A';
	ELSEIF point >= 80 THEN
		SET credit = 'B';
	ELSEIF point >= 70 THEN
		SET credit = 'C';
	ELSEIF point >= 60 THEN
		SET credit = 'D';
	ELSE
		SET credit = 'F';
	END IF;
    SELECT CONCAT('취득점수==>', point) AS '취득점수', CONCAT('학점==>',credit) AS '학점';
END $$
DELIMITER ;
CALL ifProc3();

-- CASE 문을 사용해서 점수에 따라 학점을 출력
DROP PROCEDURE IF EXISTS caseProc;

DELIMITER $$
CREATE PROCEDURE caseProc()
BEGIN
	DECLARE point INT;
    DECLARE credit CHAR(1);
    SET point = 77;
    
    CASE
		WHEN point >= 90 THEN
			SET credit = 'A';
		WHEN point >= 80 THEN
			SET credit = 'B';
		WHEN point >= 70 THEN
			SET credit = 'C';
		WHEN point >= 60 THEN
			SET credit = 'D';
		ELSE
			SET credit = 'F';
	END CASE;
    SELECT CONCAT('취득점수==>', point) AS '취득점수', CONCAT('학점==>',credit) AS '학점';
END $$
DELIMITER ;
CALL caseProc();

/* 실습7. CASE문을 활용하는 SQL 프로그래밍 */

-- sample01_db는 초기화 후 다시 사용할 것
USE sample01_db;

-- buy_tbl 에서 구매액을 사용자 아이디별로 그룹화, 구매액 순으로 정렬
SELECT userID, SUM(price*amount) AS '총구매액'
	FROM buy_tbl
    GROUP BY userID
    ORDER BY SUM(price*amount) DESC;
    
select * from user_tbl;
select * from buy_tbl;
-- INNER JOIN을 사용해서 사용자 이름도 출력(구매내역 없는 사람은 출력되지 않음)

SELECT B.userID, U.name, SUM(price*amount) AS '총구매액'
	FROM buy_tbl B
		INNER JOIN user_tbl U
			ON B.userID = U.userID
	GROUP BY userID
    ORDER BY SUM(price*amount) DESC;

-- OUTER JOIN을 사용해서 구매내역이 없는 사용자 이름도 출력
-- B.userID 를 출력하기 때문에 구매내역이 없는 사용자는 userID도 NULL 이 나옴
SELECT B.userID, U.name, SUM(price*amount) AS '총구매액'
	FROM buy_tbl B
		RIGHT OUTER JOIN user_tbl U
			ON B.userID = U.userID
		GROUP BY B.userID, U.name
        ORDER BY SUM(price*amount) DESC;

-- 구매내역이 없는 사용자도 userID를 출력하기 위해서 B.userID가 아닌 U.userID 를 선택
SELECT U.userID, U.name, SUM(price*amount) AS '총구매액'
	FROM buy_tbl B
		RIGHT OUTER JOIN user_tbl U
			ON B.userID = U.userID
		GROUP BY U.userID, U.name
        ORDER BY SUM(price*amount) DESC;

-- 구매금액에 따른 고객 분류를 위해 CASE 문 적용
SELECT U.userID, U.name, SUM(price*amount) AS '총구매액', 
		CASE
			WHEN (SUM(price*amount) >= 10000) THEN '최우수고객'
			WHEN (SUM(price*amount) >= 5000) THEN '우수고객'
			WHEN (SUM(price*amount) >= 1) THEN '일반고객'
			ELSE '유령고객'
		END AS '고객등급'
	FROM buy_tbl B
		RIGHT OUTER JOIN user_tbl U
			ON B.userID = U.userID
	GROUP BY U.userID, U.name
    ORDER BY SUM(price*amount) DESC;



/* 7.3.3 WHILE과 ITERATE/LEAVE */
/* ------------------------------------------------------------------------ */

-- 1에서 100까지의 값을 모두 더하는 기능 구현
DROP PROCEDURE IF EXISTS whileProc;
DELIMITER $$
CREATE PROCEDURE whileProc()
BEGIN
	DECLARE i INT;
    DECLARE hap INT;
	SET i = 1;
    SET hap = 0;
    
		WHILE (i<=100) DO
			SET hap = hap + i;
            SET i = i + 1;
		END WHILE;
        
        SELECT hap;
END $$
DELIMITER ;
CALL whileProc();

-- 1에서 100까지의 합계에서 7의 배수를 제외, 합계가 1000 초과 시 반복문 종료
DROP PROCEDURE IF EXISTS whileProc2;
DELIMITER $$
CREATE PROCEDURE whileProc2()
BEGIN
	DECLARE i INT;
    DECLARE hap INT;
    SET i = 1;
    SET hap = 0;
    
		myWhile: while(i <= 100) DO
			IF (i % 7 = 0) THEN
				SET i = i + 1;
                ITERATE myWhile;
			ELSE
				SET hap = hap + i;
                SET i = i + 1;
			END IF;
            
            IF (hap > 1000) THEN
				LEAVE myWhile;
			END IF;
            
		END WHILE;
	SELECT hap;
END $$
DELIMITER ;
CALL whileProc2();

-- 1부터 1000까지의 숫자 중에서 3의 배수 또는 8의 배수만 더하는 스토어드 프로시저 생성
DROP PROCEDURE IF EXISTS proc38;
DELIMITER $$
CREATE PROCEDURE proc38()
BEGIN
	DECLARE i INT;
    DECLARE hap INT;
    SET i = 1;
    SET hap = 0;
	
		WHILE (i <= 1000) DO
			IF (i % 3 = 0 OR i % 8 = 0) THEN
				SET hap = hap + i;
			END IF;
			SET i = i + 1;
		END WHILE;
        
	SELECT hap;
END $$
DELIMITER ;
CALL proc38();



/* 7.3.4 오류 처리 */
/* ------------------------------------------------------------------------ */

-- 기존 오류 발생 시 오류 메세지 확인
SELECT * FROM noTable;

-- 테이블이 없을 경우에 오류를 직접 처리.
DROP PROCEDURE IF EXISTS errorProc;
DELIMITER $$
CREATE PROCEDURE errorProc()
BEGIN
	DECLARE CONTINUE HANDLER FOR 1146 SELECT '테이블이 없어요 ㅠㅠ' AS '메세지';
    SELECT * FROM noTable;
END $$
DELIMITER ;
CALL errorProc();

-- 기본키로 지정된 아이디를 중복 생성했을 때 오류 발생 시 롤백
DROP PROCEDURE IF EXISTS errorProc2;
DELIMITER $$
CREATE PROCEDURE errorProc2()
BEGIN
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
		-- 에러 내용을 보여줌
		SHOW ERRORS;
        
        -- 발생된 오류의 개수를 출력
        SHOW COUNT(*) ERRORS;
        
        -- 경고에 대한 코드와 메시지 출력
        SHOW WARNINGS;
        
        -- 에러 발생 시 메시지 출력
        SELECT '오류가 발생했네요. 작업은 취소시켰습니다' AS '메시지';
        
        -- 오류 발생 시 작업을 롤백(진행중인 작업을 취소)시킴
        ROLLBACK;
	END;
    -- 이미 기본키인 'LSG' 존재하고 있음
    INSERT INTO user_tbl VALUE ('LSG', '이상구', 1988, '서울', NULL, NULL, 170, CURRENT_DATE());
END $$
DELIMITER ;
CALL errorProc2();

EXECUTE myQuery;

/* 7.3.5 동적 SQL */
/* ------------------------------------------------------------------------ */

-- PREPARE 는 SQL문을 실행하지 않고 미리 준비만 하고, EXECUTE문으로 준비한 쿼리문을 실행
USE sample01_db;
PREPARE myQuery
	FROM 'SELECT * FROM user_tbl WHERE userID = "EJW"';
EXECUTE myQuery;

-- 미리 준비된 Query 문장을 해제
DEALLOCATE PREPARE myQuery;

-- PREPARE 문에서 ? 으로 향후에 입력될 값을 비워놓고, EXECUTE 에서 값을 전달
DROP TABLE IF EXISTS myTable;
CREATE TABLE myTable (
	id INT AUTO_INCREMENT PRIMARY KEY,
    mDate DATETIME
);
SET @curDATE = CURRENT_TIMESTAMP();

PREPARE myQuery FROM 'INSERT INTO myTable VALUES (NULL, ?)';
EXECUTE myQuery USING @curDATE;
DEALLOCATE PREPARE myQuery;

SELECT * FROM myTable;
