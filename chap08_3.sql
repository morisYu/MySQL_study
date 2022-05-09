/* 8.3.2 성능 향상을 위한 테이블스페이스 추가 */
/* ------------------------------------------------------------------------ */

/* 실습7. 대용량의 데이터를 운영한다는 가정하에, 테이블스페이스를 분리해서 사용 */
-- 대용량의 데이터를 운용하는 경우 성능 향상을 위해 테이블스페이스를 분리하는 것이 좋음

-- 시스템 테이블스페이스에 대한 정보 확인
SHOW VARIABLES LIKE 'innodb_data_file_path';

-- 각 테이블이 테이블스페이스에 저장되도록 시스템 변수를 ON 설정(기본으로 ON 설정되어있음)
SET GLOBAL innodb_file_per_table = ON;
SHOW VARIABLES LIKE 'innodb_file_per_table';

-- 테이블스페이스 생성(테이블스페이스는 데이터베이스와 관련 없기때문에 데이터베이스를 선택할 필요 없음)
-- C:\ProgramData\MySQL\MySQL Server 8.0\Data 에서 생성된 데이터파일을 확인 가능
CREATE TABLESPACE ts_a ADD DATAFILE 'ts_a.ibd';
CREATE TABLESPACE ts_b ADD DATAFILE 'ts_b.ibd';
CREATE TABLESPACE ts_c ADD DATAFILE 'ts_c.ibd';

-- 각 테이블스페이스에 테이블 생성
DROP DATABASE IF EXISTS chap08;
CREATE DATABASE IF NOT EXISTS chap08;
USE chap08;

CREATE TABLE table_a (id INT) TABLESPACE ts_a;
SELECT * FROM table_a;

-- 테이블 생성 후 ALTER TABLE문으로 테이블스페이스를 변경할 수 있음
CREATE TABLE table_b (id INT);
ALTER TABLE table_b TABLESPACE ts_b;

-- 대용량의 테이블을 복사 후, 테이블스페이스를 지정
CREATE TABLE table_c (SELECT * FROM employees.salaries);
ALTER TABLE table_c TABLESPACE ts_c;


