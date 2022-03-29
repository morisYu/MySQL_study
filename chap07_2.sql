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

/* 실습4. 세 개테이블의 조인 */
-- 테이블 생성
USE sample01_db;
DROP TABLE IF EXISTS stdTbl, clubTbl, stdclubTbl;
CREATE TABLE stdTbl (
	stdName VARCHAR(10) NOT NULL PRIMARY KEY,
    addr CHAR(4) NOT NULL
);
CREATE TABLE clubTbl (
	clubName VARCHAR(10) NOT NULL PRIMARY KEY,
    roomNo CHAR(4) NOT NULL
);
CREATE TABLE stdclubTbl (
	num int AUTO_INCREMENT NOT NULL PRIMARY KEY,
    stdName VARCHAR(10) NOT NULL,
    clubName VARCHAR(10) NOT NULL,
    FOREIGN KEY(stdName) REFERENCES stdtbl(stdName),
    FOREIGN KEY(clubName) REFERENCES clubtbl(clubName)
);

INSERT INTO stdtbl VALUES ('김범수', '경남'), ('성시경', '서울'), ('조용필', '경기'), ('은지원', '경북'), ('바비킴', '서울');
INSERT INTO clubtbl VALUES ('수영', '101호'), ('바둑', '102호'), ('축구', '103호'), ('봉사', '104호');
INSERT INTO stdclubtbl VALUES (NULL, '김범수', '바둑'), (NULL, '김범수', '축구'), (NULL, '조용필', '축구'),
							  (NULL, '은지원', '축구'), (NULL, '은지원', '봉사'), (NULL, '바비킴', '봉사');

-- 학생을 기준으로 학생 이름/지역/가입한 동아리/동아리방 출력
SELECT S.stdName, S.addr, C.clubName, C.roomNo
	FROM stdtbl S
		INNER JOIN stdclubtbl SC
			ON S.stdName = SC.stdName
		INNER JOIN clubtbl C
			ON SC.clubName = C.clubName
	ORDER BY S.stdName;

-- 동아리를 기준으로 가입한 학생의 목록을 출력
SELECT C.clubName, C.roomNo, S.StdName, S.addr
	FROM stdtbl S
		INNER JOIN stdclubtbl SC
			ON S.stdName = SC.stdName
		INNER JOIN clubtbl C
			ON SC.clubName = C.clubName
	ORDER BY C.clubName;



/* 7.2.2 OUTER JOIN(외부 조인) */
/* ------------------------------------------------------------------------ */

-- 구매 기록이 없는 회원을 포함한 전체 회원의 구매기록
-- LEFT OUTER JOIN은 왼쪽 테이블의 것을 모두 출력
USE sample01_db;
SELECT U.userID, U.name, B.prodName, U.addr, CONCAT(U.mobile1, U.mobile2) AS '연락처'
	FROM user_tbl U
		LEFT OUTER JOIN buy_tbl B
			ON U.userID = B.userID
	ORDER BY U.userID;

-- RIGHT OUTER JOIN은 오른쪽 테이블의 것을 모두 출력
SELECT U.userID, U.name, B.prodName, U.addr, CONCAT(U.mobile1, U.mobile2) AS '연락처'
	FROM user_tbl U
		RIGHT OUTER JOIN buy_tbl B
			ON U.userID = B.userID
	ORDER BY U.userID;

-- 한 번도 구매한 적이 없는 회원의 목록을 출력
SELECT U.userID, U.name, B.prodName, U.addr, CONCAT(U.mobile1, U.mobile2) AS '연락처'
	FROM user_tbl U
		LEFT OUTER JOIN buy_tbl B
			ON U.userID = B.userID
	WHERE B.prodName IS NULL
    ORDER BY U.userID;

/* 실습5. LEFT/RIGHT/FULL OUTER JOIN 실습 */

-- OUTER JOIN으로 학생을 기준으로 동아리에 가입하지 않은 학생도 출력
USE sample01_db;
SELECT S.stdName, S.addr, C.clubName, C.roomNo
	FROM stdtbl S
		LEFT OUTER JOIN stdclubtbl SC
			ON S.stdName = SC.stdName
		LEFT OUTER JOIN clubtbl C
			ON SC.clubName = C.clubName
	ORDER BY S.stdName;

-- 동아리를 기준으로 학생을 출력하되, 가입 학생이 하나도 없는 동아리도 출력
SELECT C.clubname, C.roomNo, S.stdName, S.addr
	FROM stdtbl S
		LEFT OUTER JOIN stdclubtbl SC
			ON SC.stdName = S.stdName
		RIGHT OUTER JOIN clubtbl C
			ON SC.clubName = C.clubName
	ORDER BY C.clubName;

-- 위의 두 결과를 하나로 합쳐서 출력. 동아리에 가입하지 않은 학생과, 학생이 없는 동아리도 출력
SELECT S.stdName, S.addr, C.clubName, C.roomNo
	FROM stdtbl S
		LEFT OUTER JOIN stdclubtbl SC
			ON S.stdName = SC.stdName
		LEFT OUTER JOIN clubtbl C
			ON SC.clubName = C.clubName
UNION -- 위의 테이블과 아래의 테이블을 합쳐줌
SELECT S.stdName, S.addr, C.clubName, C.roomNo
	FROM stdtbl S
		LEFT OUTER JOIN stdclubtbl SC
			ON SC.stdName = S.stdName
		RIGHT OUTER JOIN clubtbl C
			ON SC.clubName = C.clubName;



/* 7.2.3 CROSS JOIN(상호 조인) */
/* ------------------------------------------------------------------------ */

-- 상호 조인은 한쪽 테이블의 모든 행들과 다른쪽 테이블의 모든 행을 조인시킴
-- 결과 개수는 두 테이블 개수를 곱한 개수가 되기 때문에 데이터를 조회하면 너무 많은 용량으로 시스템이 다운될 수 있음
USE employees;
SELECT COUNT(*) AS '데이터 개수'
	FROM employees
		CROSS JOIN titles;



/* 7.2.4 SELF JOIN(상호 조인) */
/* ------------------------------------------------------------------------ */

/* 실습6. 하나의 테이블에서 SELF JOIN 을 활용 */
-- 조직도 테이블을 정의하고 데이터를 입력
USE sample01_db;
DROP TABLE IF EXISTS empTbl;
CREATE TABLE IF NOT EXISTS empTbl (
	emp CHAR(3),
    manager CHAR(3),
    empTel VARCHAR(8)
);
INSERT INTO empTbl
	VALUES ('나사장', NULL, '0000'), ('김재무', '나사장', '2222'), ('김부장', '김재무', '2222-1'), ('이부장', '김재무', '2222-2'),
		   ('우대리', '이부장', '2222-2-1'), ('지사원', '이부장', '2222-2-2'), ('이영업', '나사장', '1111'), ('한과장', '이영업', '1111-1'),
           ('최정보', '나사장', '3333'), ('윤차장', '최정보', '3333-1'), ('이주임', '윤차장', '3333-1-1');

-- 우대리 상관의 연락처를 확인하고 싶다면 다음과 같이 사용 가능
SELECT A.emp AS '부하직원', B.emp AS '직속상관', B.empTel AS '직속상관연락처'
	FROM empTbl A
		INNER JOIN empTbl B
			ON A.manager = B.emp
	WHERE A.emp = '우대리';



/* 7.2.5 UNION/UNION ALL/NOT IN/IN */
/* ------------------------------------------------------------------------ */

-- 중복된 열은 제거되고 데이터가 정렬되어 나옴.
USE sample01_db;
SELECT stdName, addr From stdtbl
	UNION
SELECT clubName, roomNo FROM clubtbl;

-- 중복된 열까지 포함된 데이터가 정렬되어 나옴.
USE sample01_db;
SELECT stdName, addr From stdtbl
	UNION ALL
SELECT clubName, roomNo FROM clubtbl;

-- 첫 번째 쿼리의 결과 중에서, 두 번째 쿼리에 해당하는 것을 제외
SELECT name, CONCAT(mobile1, mobile2) AS '전화번호' FROM user_tbl
	WHERE name NOT IN (SELECT name FROM user_tbl WHERE mobile1 IS NULL);

-- 첫 번째 쿼리의 결과 중에서, 두 번째 쿼리에 해당하는 것만 조회
SELECT name, CONCAT(mobile1, mobile2) AS '전화번호' FROM user_tbl
	WHERE name IN (SELECT name FROM user_tbl WHERE mobile1 IS NULL);

