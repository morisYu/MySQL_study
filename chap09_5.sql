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
