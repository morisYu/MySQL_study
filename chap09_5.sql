/* 9.5 인덱스의 성능 비교 */
/* ------------------------------------------------------------------------ */

DROP DATABASE IF EXISTS chap09;
CREATE DATABASE chap09;
USE chap09;

/* 실습4. 인덱스가 없을 때, 클러스터형 인덱스만 있을 때, 보조 인덱스만 있을때의 성능 비교 */
-- employees의 employees 갯수를 파악
SELECT COUNT(*) FROM employees.employees;

-- 테이블을 3 개로 복사(정렬 순서는 RAND() 함수로 임의 정렬)
CREATE TABLE emp SELECT * FROM employees.employees ORDER BY RAND();
CREATE TABLE emp_c SELECT * FROM employees.employees ORDER BY RAND();
CREATE TABLE emp_Se SELECT * FROm employees.employees ORDER BY RAND();

-- 테이블의 정렬 순서 확인
SELECT * FROM emp LIMIT 5;
SELECT * FROM emp_c LIMIT 5;
SELECT * FROM emp_Se LIMIT 5;

-- CREATE TABLE ... SELECT 문은 제약 조건의 인덱스 등을 모두 제외하고 테이블의 데이터만 복사함
-- 따라서 세 테이블 모두 인덱스가 없는 상태임
SHOW TABLE STATUS;

-- emp_c 에는 클러스터형 인덱스를 생성
ALTER TABLE emp_c
	ADD PRIMARY KEY (emp_no);
    
-- emp_Se 에는 보조 인덱스를 생성
ALTER TABLE emp_Se
	ADD INDEX idx_emp_no (emp_no);

-- 다시 테이블 확인(클러스터형 인덱스를 생성한 emp_c 만 데이터가 정렬됨)
SELECT * FROM emp LIMIT 5;
SELECT * FROM emp_c LIMIT 5;
SELECT * FROM emp_Se LIMIT 5;

-- 생성한 인덱스를 실제로 적용
ANALYZE TABLE emp, emp_c, emp_Se;

-- 테이블의 인덱스 확인
SHOW INDEX FROM emp;
SHOW INDEX FROM emp_c;
SHOW INDEX FROM emp_Se;
SHOW TABLE STATUS;

-- MySQL 전체의 시스템 상태 초기화 후 다음 진행

USE chap09;

-- 인덱스가 없는 emp 테이블 조회
-- 쿼리 실행 전의 읽은 페이지 수
SHOW GLOBAL STATUS LIKE 'Innodb_pages_read';

-- 해당 데이터를 찾기 위해서 (쿼리 실행 후 페이지수 - 쿼리 실행 전 페이지수) 만큼의 페이지를 읽음
-- 'Execution Plan' 을 선택해보면 Full Table Scan을 했음
SELECT * FROM emp WHERE emp_no = 100000;

-- 쿼리 실행 후에 읽은 페이지 수
SHOW GLOBAL STATUS LIKE 'Innodb_pages_read';

-- 클러스터형 인덱스가 있는 emp_c 테이블 조회
-- 쿼리 실행 전의 읽은 페이지 수
SHOW GLOBAL STATUS LIKE 'Innodb_pages_read';

-- 해당 데이터를 찾기 위해서 (쿼리 실행 후 페이지수 - 쿼리 실행 전 페이지수) 만큼의 페이지를 읽음
-- 'Execution Plan' 을 선택해보면 Full Table Scan을 했음
SELECT * FROM emp_c WHERE emp_no = 100000;

-- 쿼리 실행 후에 읽은 페이지 수
SHOW GLOBAL STATUS LIKE 'Innodb_pages_read';

-- 보조 인덱스가 있는 테이블 조회
-- 쿼리 실행 전 읽은 페이지 수
SHOW GLOBAL STATUS LIKE 'Innodb_pages_read';

SELECT * FROM emp_Se WHERE emp_no = 100000;

-- 쿼리 실행 후 읽은 페이지 수
SHOW GLOBAL STATUS LIKE 'Innodb_pages_read';

-- 인덱스가 없는 테이블을 범위로 조회
SHOW GLOBAL STATUS LIKE 'Innodb_pages_read';
-- 인덱스가 없다면 하나를 조회하든 범위로 조회하든 읽은 페이지 수는 별 차이가 없음(Full Table Scan)
SELECT * FROM emp WHERE emp_no < 11000;
SHOW GLOBAL STATUS LIKE 'Innodb_pages_read';

-- 클러스터형 인덱스 테이블을 범위로 조회
SHOW GLOBAL STATUS LIKE 'Innodb_pages_read';
-- 클러스터형 인덱스 사용 시 정렬이 되기 때문에 범위로 조회를 해도 읽은 페이지 수는 훨씩 적음(Index Range Scan)
SELECT * FROM emp_c WHERE emp_no < 11000;
SHOW GLOBAL STATUS LIKE 'Innodb_pages_read';

-- 클러스터형 인덱스 테이블에서 전체 데이터를 조회
SHOW GLOBAL STATUS LIKE 'Innodb_pages_read';
-- emp_no 최대값이 499999 이기 때문에 전체 데이터를 조회
-- 전체 데이터를 조회하지만 WHERE 절 때문에 Index Range Scan 이 나옴
SELECT * FROM emp_c WHERE emp_no < 500000;
SHOW GLOBAL STATUS LIKE 'Innodb_pages_read';

-- 인덱스 힌트를 사용해서 인덱스를 사용하지 못하도록 강제로 지정(Full Table Scan)
SHOW GLOBAL STATUS LIKE 'Innodb_pages_read';
-- 전체 데이터를 읽는 경우에는 인덱스를 사용하지 않는 것이 데이터를 적게 읽어 효율적임
SELECT * FROM emp_c IGNORE INDEX(PRIMARY) WHERE emp_no < 500000 LIMIT 100000;
SHOW GLOBAL STATUS LIKE 'Innodb_pages_read';

-- WHERE 절이 없는 전체 데이터를 조회
SHOW GLOBAL STATUS LIKE 'Innodb_pages_read';
-- 전체 데이터에 접근해야 하기 때문에 Index Range Scan 이 아닌 Full Table Scan 을 실행함
SELECT * FROM emp_c LIMIT 100000;
SHOW GLOBAL STATUS LIKE 'Innodb_pages_read';

-- 보조 인덱스 테이블을 범위로 조회
SHOW GLOBAL STATUS LIKE 'Innodb_pages_read';
-- 인덱스를 사용하지 않은 것보다는 적은 페이지를 읽었지만 많은 페이지를 읽음
SELECT * FROM emp_Se WHERE emp_no < 11000;
SHOW GLOBAL STATUS LIKE 'Innodb_pages_read';

-- 강제로 인덱스를 사용하지 못하도록 하고 조회
SHOW GLOBAL STATUS LIKE 'Innodb_pages_read';
SELECT * FROM emp_Se IGNORE INDEX(idx_emp_no) WHERE emp_no < 11000;
SHOW GLOBAL STATUS LIKE 'Innodb_pages_read';

-- 범위를 대폭 늘려서 조회
SHOW GLOBAL STATUS LIKE 'Innodb_pages_read';
-- 보조 인덱스 사용 시 조회할 데이터가 어느 수준 이상이 되면(전체 데이터의 약 15 %) 인덱스를 사용하지 않음(Full Table Scan)
SELECT * FROM emp_Se WHERE emp_no < 500000;
SHOW GLOBAL STATUS LIKE 'Innodb_pages_read';

-- 인덱스를 사용해야 하는데도, 쿼리문을 잘못 작성해서 인덱스를 사용하지 않는 경우
SHOW GLOBAL STATUS LIKE 'Innodb_pages_read';
-- WHERE절에서 조건에 1을 곱해준 것만으로 읽은 페이지가 엄청 늘어남(Full Table Scan)
SELECT * FROM emp_c WHERE emp_no * 1 = 100000;
SHOW GLOBAL STATUS LIKE 'Innodb_pages_read';

-- 인덱스가 생성된 열은 함수나 연산을 하지 않도록 해야 함
SHOW GLOBAL STATUS LIKE 'Innodb_pages_read';
-- 연산을 해야할 경우 연산하는 부분은 우측으로 넘기면 됨
SELECT * FROM emp_c WHERE emp_no = 100000/1;
SHOW GLOBAL STATUS LIKE 'Innodb_pages_read';

-- 인덱스를 만들지 않은 emp 테이블의 gender 열에 인덱스를 생성
ALTER TABLE emp
	ADD INDEX idx_gender (gender);
-- 생성한 인덱스를 통계에 적용
ANALYZE TABLE emp;
-- cardinality 가 높을수록 중복도가 낮은데 1이 나오기 때문에 중복도가 상당히 높음을 알 수 있음
SHOW INDEX FROM emp;
-- 남성(M)을 조회(Non-Unique Key Lookup)
SELECT * FROM emp WHERE gender = 'M' LIMIT 500000;

-- 강제로 인덱스를 사용하지 못하도록 한 후, 다시 조회
-- 중복도가 높은 경우 인덱스를 사용하는 것이 효율성은 있지만, 인덱스 관리 비용과 INSERT 등의 구문에서는 오히려 성능이 저하됨
SELECT * FROM emp IGNORE INDEX(idx_gender) WHERE gender = 'M' LIMIT 500000;