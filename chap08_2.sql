/* 8.2.2 뷰의 장점 */
/* ------------------------------------------------------------------------ */

/* 실습6. 뷰를 생성해서 활용 */

USE sample01_db;

-- 기본적인 뷰를 생성
DROP VIEW IF EXISTS v_userbuytbl;
CREATE VIEW v_userbuytbl
AS
	SELECT U.userID AS 'USER ID', U.name AS 'USER NAME', B.prodName AS 'PRODUCT NAME',
		   U.addr, CONCAT(U.mobile1, U.mobile2) AS 'MOBILE PHONE'
		FROM user_tbl U
	INNER JOIN buy_tbl B
		ON U.userID = B.userID;

-- 뷰를 확인할 때는 테이블처럼 확인하면 됨.
SELECT * FROM v_userbuytbl;

-- 생성된 뷰에서 열을 선택할 때는 백틱(`)을 사용해야함.
SELECT `USER ID`, `USER NAME` FROM v_userbuytbl;

-- 뷰의 수정은 ALTER VIEW 구문으로 가능.
-- 호환성 문제로 한글 열 이름은 권장되지 않음.
ALTER VIEW v_userbuytbl
AS
	SELECT U.userID AS '사용자 아이디', U.name AS '이름', B.prodName AS '제품 이름',
		   U.addr, CONCAT(U.mobile1, U.mobile2) AS '전화번호'
		FROM user_tbl U
			INNER JOIN buy_tbl B
				ON U.userID = B.userID;

SELECT `이름`, `전화번호` FROM v_userbuytbl;

-- 간단한 뷰를 다시 생성
-- CRETE OR REPLACE VIEW 는 기존에 뷰가 있으면 덮어쓰는 효과를 내기 때문에 오류가 발생하지 않는다.
USE sample01_db;
CREATE OR REPLACE VIEW v_usertbl
AS
	SELECT userid, name, addr FROM user_tbl;
SELECT * FROM v_usertbl;
DESC v_usertbl;

-- 뷰의 소스코드 확인
SHOW CREATE VIEW v_usertbl;

-- 뷰를 통해서 데이터를 변경
UPDATE v_usertbl SET addr = '부산' WHERE userID = 'JKW';

-- 뷰의 데이터와 참조하는 테이블까지 데이터가 수정되었음.
SELECT * FROM v_usertbl WHERE userID = 'JKW';
SELECT * FROM user_tbl WHERE userID = 'JKW';

-- v_usertbl 이 참조하는 데이블 user_tbl 의 열 중에 birthYear 열은 NOT NULL 로 설정되어있어서 반드시 값이 있어야 함.
-- v_usertbl 에 birthYear 열을 추가해서 값을 입력하도록 하거나, user_tbl 에서 NOT NULL 설정을 바꾸거나 DEFAULT 를 설정해야 함.
INSERT INTO v_usertbl(userid, name, addr) VALUES ('KBM', '김병만', '충북');
DESC user_tbl;

-- 그룹함수를 포함하는 뷰를 생성
CREATE VIEW v_sum
AS
	SELECT userid AS 'userid', SUM(price*amount) AS 'total'
		FROM buy_tbl GROUP BY userid;
SELECT * FROM v_sum;

-- 뷰의 정보 확인
-- IS_UPDATABLE 이 NO로 되어있으므로, 이 뷰를 통해서는 데이터를 변경(INSERT, UPDATE, DELETE) 할 수 없다.
SELECT * FROM INFORMATION_SCHEMA.VIEWS
	WHERE TABLE_SCHEMA = 'sample01_db' AND TABLE_NAME = 'v_sum';

-- 지정한 범위로 뷰를 생성하고 데이터를 입력
CREATE VIEW v_height177
AS
	SELECT * FROM user_tbl WHERE height >= 177;

SELECT * FROM v_height177;

-- 키가 177 미만인 데이터를 입력
-- 참조하는 user_tbl에는 데이터가 추가되었지만, 뷰에는 추가되지 않음(키가 177 미만이기 때문에)
INSERT INTO v_height177 VALUES ('KBM', '김병만', 1977, '경기', '010', '55555555', 158, '2023-01-01');
SELECT * FROM v_height177;
SELECT * FROM user_tbl;

-- 키가 177 이상의 데이터만 입력받을 수 있게 설정(WITH CHECK OPRION)
-- 키가 177 미만인 데이터가 입력되면 오류가 발생
ALTER VIEW v_height177
AS
	SELECT * FROM user_tbl WHERE height >= 177
		WITH CHECK OPTION;

INSERT INTO v_height177 VALUES('SJH', '서장훈', 2006, '서울', '010', '33333333', 155, '2023-3-3');

-- 두 개 이상의 테이블이 관련되는 복합 뷰를 생성하고 데이터를 입력.
DROP VIEW IF EXISTS v_userbuytbl;
CREATE VIEW v_userbuytbl
AS
	SELECT U.userid, U.name, B.prodName, U.addr, CONCAT(U.mobile1, U.mobile2) AS mobile
		FROM user_tbl U
			INNER JOIN buy_tbl B
				ON U.userid = B.userid;
-- 두 개 이상의 테이블이 관련된 뷰는 업데이트할 수 없음.
INSERT INTO v_userbuytbl VALUES('PKL', '박경림', '운동화', '경기', '00000000000', '2023-2-2');

-- 뷰가 참조하는 테이블을 삭제하면 참조테이블이 없기 떄문에 뷰가 조회되지 않음.
DROP TABLE user_tbl, buy_tbl;
SELECT * FROM v_userbuytbl;