/* 실습2. 영화사이트 데이터베이스 구축 */

-- 실습파일 다운로드
-- http://download.hanbit.co.kr/mysql/8.0/ 에서 movies.zip 파일 다운로드 후 실습

-- 영화 데이터베이스 및 영화 테이블 생성
DROP DATABASE IF EXISTS moviedb;
CREATE DATABASE moviedb;
USE moviedb;
CREATE TABLE movietbl(
	movie_id INT,
    movie_title VARCHAR(30),
    movie_director VARCHAR(20),
    movie_star VARCHAR(20),
    movie_script LONGTEXT,
    movie_film LONGBLOB
) DEFAULT CHARSET = utf8mb4;

-- 최대 패킷 크기가 설정된 시스템 변수값보다 파일의 크기가 크면 파일이 입력되지 않는다.
INSERT INTO movietbl VALUES (1, '쉰들러 리스트', '스필버그', '리암 니슨', 
	LOAD_FILE('C:\SQL\Movies\Schindler.txt'), LOAD_FILE('C:\SQL\Movies\Schindler.mp4')
);

SELECT * FROM movietbl;

-- 최대 패킷 크기 확인
SHOW VARIABLES LIKE 'max_allowed_packet';
-- 파일을 업로드/다운로드할 폴더 경로를 별도로 허용해야 함
SHOW VARIABLES LIKE 'secure_file_priv';
/* 설정 변경 방법(우선 워크벤치를 끄고 해야함)
	1. 관리자 모드로 cmd 실행
    2. cd %PROGRAMDATA%  > cd MySQL  >  cd "MySQL Server 8.0"  순서대로 이동
    3. dir 로 파일목록 확인 후 NOTEPAD my.ini 실행해서 메모장 파일을 실행
    4. ctrl+f 로 max_allowed_packet 검색해서 값을 1024M 로 변경 후 저장
    5. ctrl+f 로 secure-file-priv 검색해서 파일 경로 추가 (secure-file-priv="C:/SQL/Movies")
    6. MySQL을 중지했다가 재시작(NET STOP MySQL  >  NET START MySQL) */

-- 위의 두 작업이 완료된 후(CMD에서 진행) 다시 대용량 파일 입력
USE moviedb;
TRUNCATE movietbl;

INSERT INTO movietbl VALUES (1, '쉰들러 리스트', '스필버그', '리암 니슨',
	LOAD_FILE('C:/SQL/Movies/Schindler.txt'), LOAD_FILE('C:/SQL/Movies/Schindler.mp4')
);
INSERT INTO movietbl VALUES (2, '쇼생크 탈출', '프랭크 다라본트', '팀 로빈스',
	LOAD_FILE('C:/SQL/Movies/Shawshank.txt'), LOAD_FILE('C:/SQL/Movies/Shawshank.mp4')
);
INSERT INTO movietbl VALUES (3, '라스트 모히칸', '마이클 만', '다니엘 데이 루이스', 
	LOAD_FILE('C:/SQL/Movies/Mohican.txt'), LOAD_FILE('C:/SQL/Movies/Mohican.mp4')
);

SELECT * FROM movietbl;

-- 입력된 데이터(LONGTEXT)를 파일로 내려받기
SELECT movie_script FROM movietbl WHERE movie_id = 1
	INTO OUTFILE 'C:/SQL/Movies/Schindler_out.txt'
    LINES TERMINATED BY '\\n';  -- 줄바꿈 문자도 그대로 저장하기 위한 옵션

-- LONGBLOB 형식인 동영상 파일 내려받기
SELECT movie_film FROM movietbl WHERE movie_id = 3
	INTO DUMPFILE 'C:/SQL/Movies/Mohican_out.mp4';


