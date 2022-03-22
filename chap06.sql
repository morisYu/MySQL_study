USE sample01_db;

/* 6.1.1 원하는 데이터를 가져와 주는 기본적인 <SELECT ... FROM> */
/* ------------------------------------------------------------------------ */

-- 각 테이블 전체 레코드 확인
SELECT * FROM user_tbl;
SELECT * FROM buy_tbl;

-- user_tbl 에서 userID, name, addr 만 출력
SELECT userID, name, addr FROM user_tbl;



/* 6.1.2 특정한 조건의 데어터만 조회하는 <SELECT ... FROM ... WHERE> */
/* ------------------------------------------------------------------------ */

-- user_tbl 에서 이름이 '김경호' 인 회원의 데이터를 출력 
SELECT * FROM user_tbl WHERE name = '김경호';

-- 1970년 이후에 출생하고 신장이 182 이상인 회원의 아이디와 이름을 출력
SELECT userID, name FROM user_tbl WHERE birthYear > 1970 AND height >= 182;

-- 1970년 이후에 출생했거나, 신장이 182 이상인 회원의 아이디와 이름을 출력
SELECT userID, name FROM user_tbl WHERE birthYear > 1970 OR height >= 182;

-- 키가 177~182인 사람을 조회
SELECT name, height FROM user_tbl WHERE height >= 177 AND height <=182;
SELECT name, height FROM user_tbl WHERE height BETWEEN 177 AND 182;

-- 지역이 '경남', '전남', '경북' 인 사람의 정보를 조회
SELECT name, addr FROM user_tbl WHERE addr = '경남' OR addr = '전남' OR addr = '경북';
SELECT name, addr FROM user_tbl WHERE addr IN('경남', '전남', '경북');

-- 성이 '김'씨인 사람의 정보를 조회
SELECT * FROM user_tbl WHERE name LIKE '김%';

-- 성이 한 글자이고 이름이 '종신'인 사람의 정보를 조회
SELECT * FROM user_tbl WHERE name LIKE '_종신';

-- 김경호보다 키가 크거나 같은 사람의 정보를 조회(김경호의 키를 찾아야 함)
SELECT name, height FROM user_tbl 
	WHERE height >= (SELECT height FROM user_tbl WHERE name = '김경호');
    
-- '경남'에 사는 사람보다 키가 크거나 같은 사람의 정보를 조회(서브쿼리의 결과는 1 개만 나와야 함)
/* SELECT name, height, addr FROM user_tbl
	WHERE height >= (SELECT height FROM user_tbl WHERE addr = '경남'); */

-- 서브쿼리의 결과값이 2 개 이상이라면 ANY, SOME을 사용해야 함 (서브쿼리의 결과값 중 하나라도 만족하면 해당 결과를 출력)
SELECT name, height, addr FROM user_tbl
	WHERE height >= ANY (SELECT height FROM user_tbl WHERE addr = '경남');
    
SELECT name, height, addr FROM user_tbl
	WHERE height >= SOME (SELECT height FROM user_tbl WHERE addr = '경남');

-- 서브쿼리의 결과값을 모두 만족하는 결과를 출력하기 위해서는 ALL 을 사용하면 됨
SELECT name, height, addr FROM user_tbl
	WHERE height >= ALL (SELECT height FROM user_tbl WHERE addr = '경남');

-- 사용자를 이름을 기준으로 오름차순 정렬
SELECT * FROM user_tbl ORDER BY name ASC;
SELECT * FROM user_tbl ORDER BY name;

-- 사용자를 userID를 기준으로 내림차순 정렬
SELECT * FROM user_tbl ORDER BY userID DESC;

-- 회원의 거주지역을 중복을 제외하고 확인
SELECT DISTINCT addr FROM user_tbl ORDER BY addr;

-- 회원의 정보가 출력되는 수를 제한(7명만 출력)
SELECT * FROM user_tbl LIMIT 7;

-- 회원의 정보가 출력되는 수를 제한(3번쨰 회원부터 5명만 출력)
SELECT * FROM user_tbl LIMIT 3, 5;

-- buy_tbl 을 복사하여 buy_tbl2를 생성
-- 내용을 그대로 복사가 되지만 키 설정은 복사되지 않음
CREATE TABLE buy_tbl2 (SELECT * FROM buy_tbl);
DESC buy_tbl2;
SELECT * FROM buy_tbl2;

-- 원하는 필드만 선택하여 테이블 복사 가능
CREATE TABLE buy_tbl3 (SELECT num, userID FROM buy_tbl);
EXPLAIN buy_tbl3;
SELECT * FROM buy_tbl3;



/* 6.1.3 GROUP BY 및 HAVING 그리고 집계 함수 */
/* ------------------------------------------------------------------------ */

-- userID 기준으로 오름차순 정렬
SELECT userID, amount FROM buy_tbl ORDER BY userID ASC;
-- userID 기준으로 내림차순 정렬
SELECT userID, amount FROM buy_tbl ORDER BY userID DESC;

-- userID 로 그룹을 만들어서 구매수량의 합계(SUM)를 표시
SELECT userID, SUM(amount) FROM buy_tbl GROUP BY userID;

-- 별칭(Alias) 을 사용
SELECT userID AS '사용자 아이디', SUM(amount) AS '총 구매 개수' FROM buy_tbl GROUP BY userID;

-- 구매액(수량*단가)의 총합 계산
SELECT userID AS '사용자 아이디', SUM(amount*price) AS '총 구매액' FROM buy_tbl GROUP BY userID;

-- 전체 구매자가 구매한 물품의 개수의 평균
SELECT AVG(amount) AS '평균 구매 개수' FROM buy_tbl;

-- 각 사용자별 한 번 구매시 구매한 물품의 평균 개수
SELECT userID, AVG(amount) AS '평균 구매 개수' FROM buy_tbl GROUP BY userID;

-- 가장 큰 키와 가장 작은 키의 회원 이름과 키를 출력
SELECT name, height FROM user_tbl WHERE 
	height = (SELECT MAX(height) FROM user_tbl) OR
	height = (SELECT MIN(height) FROM user_tbl);

-- 휴대폰이 있는 사용자(mobile1, 2에 레코드가 있음)의 수를 카운트
SELECT COUNT(mobile1) FROM user_tbl;

-- 키(height)가 175 이상인 사람이 몇명인지 출력
SELECT COUNT(*) FROM user_tbl WHERE height >= 175;

-- 중복을 제외한 userID 개수 카운트
SELECT COUNT(DISTINCT userID) FROM buy_tbl;

-- SUM()을 사용해서 사용자별 총 구매액 출력
SELECT userID, SUM(price*amount) AS '총 구매액'
	FROM buy_tbl
	GROUP BY userID;

-- HAVING은 WHERE와 비슷한 개념이지만 집계함수에 대해서 조건을 제한함.
-- 사용자별 총 구매액이 1000 넘는 사용자를 출력

-- SUM() 은 WHERE 절 안에서 사용 불가
/* SELECT userID, SUM(price*amount) AS '총 구매액'
FROM buy_tbl
WHERE SUM(price*amount) > 1000
GROUP BY userID; */

SELECT userID, SUM(price*amount) AS '총 구매액'
	FROM buy_tbl
	GROUP BY userID
	HAVING SUM(price*amount) > 1000;

-- 충 구매액을 기준으로 오름차순 정렬
SELECT userID, SUM(price*amount) AS '총 구매액'
	FROM buy_tbl
	GROUP BY userID
	HAVING SUM(price*amount) > 1000
	ORDER BY SUM(price*amount) ASC;

-- 총합 또는 중간 합계
SELECT num, groupName, SUM(price*amount) AS '비용'
	FROM buy_tbl
    GROUP BY groupName, num
    WITH ROLLUP;

-- 소합계 및 총 합계만 출력
SELECT groupName, SUM(price*amount) AS '비용'
	FROM buy_tbl
    GROUP BY groupName
    WITH ROLLUP;
    


/* 6.2.1 데이터의 삽입: INSERT */
/* ------------------------------------------------------------------------ */

-- 테이블 생성
CREATE TABLE testTbl1 (id int, userName char(3), age int);

-- 테이블이 정의된 열 순서와 동일하면 테이블 이름 다음에 나오는 열은 생략 가능
INSERT INTO testTbl1 VALUES (1, '홍길동', 25);

-- id, userName 만 입력하고자 한다면 테이블 이름 뒤에 입력할 열의 목록을 나열
INSERT INTO testTbl1(id, userName) VALUES (2, '설현');

-- 열의 순서를 바꿔서 입력할 때는 열 이름은 입력할 순서에 맞춰 나열해야 함
INSERT INTO testTbl1(userName, age, id) VALUES ('하니', 26, 3);

-- 테이블 생성
CREATE TABLE testTbl2
	(id int AUTO_INCREMENT PRIMARY KEY,
	userName char(3),
	age int);

-- 데이터 삽입(자동 증가되는 id는 NULL 로 작성)
INSERT INTO testTbl2 VALUES (NULL, '지민', 25);
INSERT INTO testTbl2 VALUES (NULL, '유나', 22);
INSERT INTO testTbl2 VALUES (NULL, '유경', 21);

SELECT * FROM testTbl2;

-- 마지막에 입력된 값 확인
SELECT last_insert_id();
