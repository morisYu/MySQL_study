/* 10.4.3 트리거의 개요 */
/* ------------------------------------------------------------------------ */

USE chap10;

-- 간단한 테이블 생성
DROP TABLE IF EXISTS testTBL;
CREATE TABLE testTBL (
	id INT,
    txt VARCHAR(10)
);
INSERT INTO testTBL VALUES (1, '레드벨벳');
INSERT INTO testTBL VALUES (2, '잇지');
INSERT INTO testTBL VALUES (3, '블랙핑크');
SELECT * FROM testTBL;

-- testTBL에 트리거를 부착
-- 삭제 작업 후에 메세지 출력
DROP TRIGGER IF EXISTS testTrg;
DELIMITER //
CREATE TRIGGER testTrg
	AFTER DELETE
    ON testTBL
    FOR EACH ROW
BEGIN
	SET @msg = '가수 그룹이 삭제됨';
END //
DELIMITER ;

-- 데이터를 삽입, 수정, 삭제
SET @msg = '';
INSERT INTO testTBL VALUES(4, '마마무');
SELECT @msg;

UPDATE testTBL SET txt = '블핑' WHERE id = 3;
SELECT @msg;

DELETE FROM testTBL WHERE id = 4;
SELECT @msg;

/* AFTER 트리거 사용 */
-- 회원 테이블에 update 나 delete를 시도하면 수정 또는 삭제된 데이터를 별도의 테이블에 보관하고
-- 변경된 일자와 변경한 사람을 기록
USE chap10;

DROP TABLE buyTBL;
CREATE TABLE backup_userTBL (
	userID CHAR(8) NOT NULL PRIMARY KEY,
    name VARCHAR(10) NOT NULL,
    birthYear INT NOT NULL,
    addr CHAR(2) NOT NULL,
    mobile1 CHAR(3),
    mobile2 CHAR(8),
    height SMALLINT,
    mDate DATE,
    modType CHAR(2),
    modDate DATE,
    modUser VARCHAR(256)
);

-- 변경(update)과 삭제(delete)가 발생할 때 작동하는 트리거를 userTbl에 부착
-- 변경이 발생했을 때 작동하는 트리거 생성
DROP TRIGGER IF EXISTS backUserTbl_UpdateTrg;
DELIMITER //
CREATE TRIGGER backUserTbl_UpdateTrg
	AFTER UPDATE
	ON userTBL
    FOR EACH ROW
BEGIN
	INSERT INTO backup_userTbl VALUES (OLD.userID, OLD.name, OLD.birthYear, OLD.addr,
		OLD.mobile1, OLD.mobile2, OLD.height, OLD.mDate, '수정', CURDATE(), CURRENT_USER());
END //
DELIMITER ;

-- 삭제가 발생했을 때 작동하는 트리거 생성
DROP TRIGGER IF EXISTS backUserTbl_DeleteTrg;
DELIMITER //
CREATE TRIGGER backUserTbl_DeleteTrg
	AFTER DELETE
    ON userTBL
    FOR EACH ROW
BEGIN
	INSERT INTO backup_userTbl VALUES (OLD.userID, OLD.name, OLD.birthYear, OLD.addr,
		OLD.mobile1, OLD.mobile2, OLD.height, OLD.mDate, '삭제', CURDATE(), CURRENT_USER());
END //
DELIMITER ;

-- 데이터를 변경
UPDATE userTbl SET addr = '몽고' WHERE userID = 'JKW';

-- 데이터를 삭제
DELETE FROM userTbl WHERE height >= 177;

-- 수정, 삭제된 내용이 저장되었는지 확인
SELECT * FROM backup_userTbl;

-- DELETE 가 아닌 TRUNCATE 문으로 데이터를 삭제
TRUNCATE TABLE userTBL;

-- 삭제된 내용이 backup_userTbl에 저장이 되지 않음(DELETE 작업에만 트리거를 생성했기 때문)
SELECT * FROM backup_userTbl;

-- userTbl에 새로운 데이터가 입력되지 못하도록 설정
DROP TRIGGER IF EXISTS userTbl_InsertTrg;
DELIMITER //
CREATE TRIGGER userTbl_InsertTrg
	AFTER INSERT
    ON userTbl
    FOR EACH ROW
BEGIN
	-- 사용자가 오류를 강제로 발생시키는 함수(오류 메세지가 출력되면서 작업한 INSERT 가 롤백된다)
	SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = '데이터의 입력을 시도했습니다. 귀하의 정보가 서버에 기록되었습니다.';
END //
DELIMITER ;

INSERT INTO userTBl VALUES ('ABC', '에비씨', 1977, '서울', '011', '11111111', 181, '2019-12-25', '우수고객');

SELECT * FROM userTbl;

/* BEFORE 트리거 사용 */
USE chap10;

-- 출생년도의 데이터를 검사해서 데이터에 문제가 있으면 값을 변경시켜서 입력시키는 트리거 사용
DROP TRIGGER IF EXISTS userTbl_BeforeInsertTrg;
DELIMITER //
CREATE TRIGGER userTbl_BeforeInsertTrg
	BEFORE INSERT
    ON userTBL
    FOR EACH ROW
BEGIN
	IF NEW.birthYear < 1900 THEN
		SET NEW.birthYear = 0;
	ELSEIF NEW.birthYear > YEAR(CURDATE()) THEN
		SET NEW.birthYear = YEAR(CURDATE());
	END IF;
END //
DELIMITER ;

-- 출생년도에 문제가 있는 데이터 입력
INSERT INTO userTBL VALUES
	('AAA', '에이', 1877, '서울', '011', '1112222', 181, '2022-12-25', '일반회원'),
	('BBB', '비이', 2977, '경기', '011', '1113333', 171, '2019-3-25', '일반회원');

-- 문제가 있는 출생년도가 트리거에 의해 처리됨
SELECT * FROM userTBL;

-- 생성된 트리거 확인
SHOW TRIGGERS FROM chap10;

-- 트리거 삭제
DROP TRIGGER userTbl_BeforeInsertTrg;

/* 10.4.4 기타 트리거 사용 */
/* ------------------------------------------------------------------------ */

/* 중첩 트리거 작동 실습 */
USE chap10;

DROP TABLE IF EXISTS orderTbl, prodTbl, deliverTbl; 
CREATE TABLE orderTbl (
	orderNo INT AUTO_INCREMENT PRIMARY KEY,
    userID VARCHAR(5),
    prodName VARCHAR(5),
    orderamount INT
);
CREATE TABLE prodTbl (
	prodName VARCHAR(5),
    account INT
);
CREATE TABLE deliverTbl (
	deliverNo INT AUTO_INCREMENT PRIMARY KEY,
    prodName VARCHAR(5),
    account INT
);

INSERT INTO prodTbl VALUES('사과', 100);
INSERT INTO prodTbl VALUES('배', 100);
INSERT INTO prodTbl VALUES('귤', 100);

-- 물품 테이블에서 개수를 감소시키는 트리거
DROP TRIGGER IF EXISTS orderTrg;
DELIMITER //
CREATE TRIGGER orderTrg
	AFTER INSERT
    ON orderTBL
    FOR EACH ROW
BEGIN
	UPDATE prodTbl SET account = account - NEW.orderamount
		WHERE prodName = NEW.prodName;
END //
DELIMITER ;

-- 배송 테이블에 새 배송 건을 입력하는 트리거
DROP TRIGGER IF EXISTS prodTrg;
DELIMITER //
CREATE TRIGGER prodTrg
	AFTER UPDATE
    ON prodTBL
    FOR EACH ROW
BEGIN
	DECLARE orderAmount INT;
    -- 주문 개수 = (변경 전의 개수 - 변경 후의 개수)
    SET orderAmount = OLD.account - NEW.account;
    INSERT INTO deliverTbl(prodName, account)
		VALUES (NEW.prodName, orderAmount);
END //
DELIMITER ;

-- 고객이 물건을 구매(orderTbl 데이터 입력)
INSERT INTO orderTbl VALUES (NULL, 'JHON', '배', 5);

-- 각 테이블의 변화 확인
SELECT * FROM orderTbl;
SELECT * FROM prodTbl;
SELECT * FROM deliverTbl;

-- 배송 테이블의 열 이름을 변경해서 INSERT가 실패하도록 함
ALTER TABLE deliverTbl CHANGE prodName productName VARCHAR(5);

-- orderTbl에 데이터 입력
-- 트리거는 작동했으나 마지막에 열 이름 때문에 오류가 발생
-- 중첩 트리거에서 마지막 부분의 INSERT가 실패하면 그 앞의 INSERT, UPDATE 도 모두 롤백됨
INSERT INTO orderTbl VALUES (NULL, 'DANG', '사과', 9);