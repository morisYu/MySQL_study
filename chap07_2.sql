/* 7.2.1 INNER JOIN(내부 조인) */
/* ------------------------------------------------------------------------ */

-- 구매 테이블 중에서 JYP라는 아이디를 가진 사람의 이름/주소/연락처 등을 조인해서 검색
USE sample01_db;
SELECT * FROM buy_tbl;
SELECT * FROM user_tbl;

SELECT * FROM buy_tbl
	INNER JOIN user_tbl
		ON buy_tbl.userID = user_tbl.userID
	WHERE buy_tbl.userID = 'JYP';

-- 조건절 WHERE 생략
SELECT * FROM buy_tbl
	INNER JOIN user_tbl
		ON buy_tbl.userID = user_tbl.userID;

-- 필요한 열만 추출(SELECT에서 userID가 buy_tbl과 user_tbl 에 모두 있기 때문에 어느 테이블의 userID 를 기준으로 할지 명확하게 표기해야함)
SELECT buy_tbl.userID, name, prodName, addr, CONCAT(mobile1, mobile2) AS '연락처'
	FROM buy_tbl
		INNER JOIN user_tbl
        ON buy_tbl.userID = user_tbl.userID
	ORDER BY num;

-- WHERE 구문으로 INNER JOIN 표현(호환성의 문제로 권장되지 않음)
SELECT buy_tbl.userID, name, prodName, addr, mobile1+mobile2
	FROM buy_tbl, user_tbl
    WHERE buy_tbl.userID = user_tbl.userID
	ORDER BY num;

-- 어느 테이블에 속한 열인지 명확하게 표현(코드가 길어져서 복잡해 보임).
SELECT buy_tbl.userID, user_tbl.name, buy_tbl.prodName, user_tbl.addr,
		CONCAT(user_tbl.mobile1, user_tbl.mobile2) AS '연락처'
	FROM buy_tbl
		INNER JOIN user_tbl
			ON buy_tbl.userID = user_tbl.userID
	ORDER BY buy_tbl.num;

-- 각 테이블에 별칭을 부여(FROM 절에 나오는 테이블 이름 뒤에 별칭을 붙이면 됨)
SELECT B.userID, U.name, B.prodName, U.addr, CONCAT(U.mobile1, U.mobile2) AS '연락처'
	FROM buy_tbl B
		INNER JOIN user_tbl U
			ON B.userID = U.userID
	WHERE U.addr = '서울'
	ORDER BY B.num;

-- INNER JOIN 은 양쪽 테이블에 모두 내용이 있는 것만 조인되는 방식. (한쪽 테이블에 내용이 없는 부분은 조인 안됨)
-- 한번이라도 구매 이력이 있는 회원의 목록을 추출.
SELECT DISTINCT U.userID, U.name, U.addr
	FROM user_tbl U
		INNER JOIN buy_tbl B
			ON U.userID = B.userID
	ORDER BY U.userID;

-- 위 결과를 EXISTS문을 사용해서 표현
SELECT U.userID, U.name, U.addr
	FROM user_tbl U
    WHERE EXISTS(
		SELECT * FROM buy_tbl B
        WHERE U.userID = B.userID);

