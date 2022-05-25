/* 10.3.1 커서 활용 */
/* ------------------------------------------------------------------------ */

-- 커서를 활용해서 고객의 평균 키를 구하는 스토어드 프로시저 작성
USE chap10;

CREATE TABLE userTBL (SELECT * FROM sample01_db.user_tbl);
CREATE TABLE buyTBL (SELECT * FROM sample01_db.buy_tbl);

DROP PROCEDURE IF EXISTS cursorProc;
DELIMITER $$
CREATE PROCEDURE cursorProc()
BEGIN 
	DECLARE userHeight INT;
    DECLARE cnt INT DEFAULT 0;
    DECLARE totalHeight INT DEFAULT 0;
    
    DECLARE endOfRow BOOLEAN DEFAULT FALSE;
    
    -- 커서 선언
    DECLARE userCursor CURSOR FOR
		SELECT height FROM userTBL;
	
    -- 행의 끝이면 endOfRow 변수에 TRUE 를 대입
    DECLARE CONTINUE HANDLER
		FOR NOT FOUND SET endOfRow = TRUE;
	
    OPEN userCursor;
    
    cursor_loop: LOOP
		-- 고객 키 1 개를 대입
        FETCH userCursor INTO userHeight;
        
        IF endOfRow THEN
			LEAVE cursor_loop;
		END IF;
        
        SET cnt = cnt + 1;
        SET totalHeight = totalHeight + userHeight;
	END LOOP cursor_loop;
    
    -- 고객 키의 평균을 출력
    SELECT CONCAT('고객 키의 평균 ==> ', (totalHeight/cnt));
    
    CLOSE userCursor;
END $$
DELIMITER ;

CALL cursorProc();

-- 고객 테이블에 고객 등급 열을 추가
ALTER TABLE userTbl ADD grade VARCHAR(5);

-- 테이블 업데이트를 위해 세이프 모드 OFF
SET SQL_SAFE_UPDATES = 0;

-- 구매 총액에 따라 고객 등급 열에 값을 입력
DROP PROCEDURE IF EXISTS gradeProc;
DELIMITER $$
CREATE PROCEDURE gradeProc()
BEGIN
	DECLARE id VARCHAR(10);
    DECLARE hap BIGINT;
    DECLARE userGrade CHAR(5);
    
    DECLARE endOfRow BOOLEAN DEFAULT FALSE;
    
    DECLARE userCursor CURSOR FOR
		SELECT U.userid, sum(price*amount)
			FROM buyTbl B
				RIGHT OUTER JOIN userTbl U
                ON B.userid = U.userid
			GROUP BY U.userid, U.name;
	
    DECLARE CONTINUE HANDLER
		FOR NOT FOUND SET endOfRow = TRUE;
	
    OPEN userCursor;
    grade_loop: LOOP
		FETCH userCursor INTO id, hap;
        IF endOfRow THEN
			LEAVE grade_loop;
		END IF;
        
        CASE
			WHEN (hap >= 1500) THEN SET userGrade = '최우수고객';
            WHEN (hap >= 1000) THEN SET userGrade = '우수고객';
            WHEN (hap >= 1) THEN SET userGrade = '일반고객';
            ELSE SET userGrade = '유령고객';
		END CASE;
        
        UPDATE userTbl SET grade = userGrade WHERE userID = id;
	END LOOP grade_loop;
    
    CLOSE userCursor;
END $$
DELIMITER ;
    
-- 스토어드 프로시저를 호출하고, 고객 등급이 완성되었는지 확인
CALL gradeProc();
SELECT * FROM userTbl;
        
        
        
        
        
        
        
        
        
        