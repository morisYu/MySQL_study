DROP DATABASE IF EXISTS sample02_db;
CREATE DATABASE IF NOT EXISTS sample02_db;
USE sample02_db;
DROP TABLE IF EXISTS author_tbl, dormant_tbl, topic_tbl, comment_tbl, write_tbl;

-- 저자 테이블
CREATE TABLE author_tbl (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(15),
    profile VARCHAR(100),
    created DATETIME
);

-- 휴면계정 테이블
CREATE TABLE dormant_tbl (
	author_id INT,
    created DATETIME,
    CONSTRAINT fk_author_dormant_id FOREIGN KEY (author_id) REFERENCES author_tbl (id)
);

-- 게시글 테이블
CREATE TABLE topic_tbl (
	id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(30),
    description LONGTEXT,
    created DATETIME
);

-- 댓글 테이블
CREATE TABLE comment_tbl (
	id INT PRIMARY KEY AUTO_INCREMENT,
	author_id INT,
    topic_id INT,
    description MEDIUMTEXT,
    created DATETIME,
    CONSTRAINT fk_author_comment_id FOREIGN KEY (author_id) REFERENCES author_tbl (id),
    CONSTRAINT fk_topic_comment_id FOREIGN KEY (topic_id) REFERENCES topic_tbl (id)
);

-- 저자와 게시글의 연결테이블
CREATE TABLE write_tbl (
	author_id INT,
    topic_id INT
);
ALTER TABLE write_tbl
	ADD CONSTRAINT fk_author_write_id
    FOREIGN KEY (author_id)
    REFERENCES author_tbl (id)
    ON DELETE CASCADE;
    
ALTER TABLE write_tbl
	ADD CONSTRAINT fk_topic_write_id 
    FOREIGN KEY (topic_id) 
    REFERENCES topic_tbl (id)
    ON UPDATE CASCADE
    ON DELETE CASCADE;

-- 전체 테이블 목록 확인
SHOW TABLES;

-- 저자 데이터 입력
DESC author_tbl;
SELECT * FROM author_tbl;
INSERT author_tbl VALUES (NULL, '김지민', '여자 개그우먼', '2021-10-1');
INSERT author_tbl VALUES (NULL, '김준호', '남자 개그맨', '2001-12-15');
INSERT author_tbl VALUES (NULL, '김종민', '코요테 리더', '1988-12-10');
INSERT author_tbl VALUES (NULL, '서장훈', '농구선수 출신 아는형님', '2019-3-5');
INSERT author_tbl VALUES (NULL, '민경훈', '버즈 출신 아는형님', '1990-5-5');
INSERT author_tbl VALUES (NULL, '나영석', '1박2일 메인PD', '1995-1-1');
INSERT author_tbl VALUES (NULL, '강호동', '천하장사 출신 희극인', '1970-10-15');
INSERT author_tbl VALUES (NULL, '유재석', '무한도전 국민MC', '1973-12-5');
INSERT author_tbl VALUES (NULL, '김국진', '라디오스타 메인MC', '1965-3-2');
INSERT author_tbl VALUES (NULL, '이미주', '오마이걸 요즘대세', '1998-5-15');

-- 휴면계정 데이터 입력
DESC dormant_tbl;
SELECT * FROM dormant_tbl;
INSERT dormant_tbl VALUES (3, '1999-10-5');
INSERT dormant_tbl VALUES (5, '2000-5-10');
INSERT dormant_tbl VALUES (7, '2010-5-10');

-- 게시글 데이터 입력
DESC topic_tbl;
SELECT * FROM topic_tbl;
INSERT topic_tbl VALUES (NULL, '개그콘서트', '김준호, 박성호, 김대희, 김지민', '2021-3-5');
INSERT topic_tbl VALUES (NULL, '아는형님', '강호동, 이상민, 민경훈 등', '2021-5-15');
INSERT topic_tbl VALUES (NULL, '라디오스타', '김국진, 윤종신, 김구라 외', '2021-6-10');
INSERT topic_tbl VALUES (NULL, '신서유기', '강호동, 은지원, 이수근', '2021-10-3');
INSERT topic_tbl VALUES (NULL, '쿵쿵따', '유재석, 강호동', '2021-11-20');
INSERT topic_tbl VALUES (NULL, '무한도전', '유재석, 박명수, 정준하 외', '2000-1-20');
INSERT topic_tbl VALUES (NULL, '1박2일', '강호동, 이수근, 김종민 외', '2003-5-22');
INSERT topic_tbl VALUES (NULL, '식스센스', '유재석, 이미주, 오나라, 제시 외', '2020-10-1');

-- 연결테이블 데이터 입력
DESC write_tbl;
SELECT * FROM write_tbl;
INSERT write_tbl VALUES (1, 1);
INSERT write_tbl VALUES (2, 1);
INSERT write_tbl VALUES (3, 7);
INSERT write_tbl VALUES (6, 7);
INSERT write_tbl VALUES (7, 7);
INSERT write_tbl VALUES (4, 2);
INSERT write_tbl VALUES (5, 3);
INSERT write_tbl VALUES (8, 4);
INSERT write_tbl VALUES (10, 5);

-- 댓글 테이블 데이터 입력
DESC comment_tbl;
SELECT * FROM comment_tbl;
INSERT comment_tbl VALUES (NULL, 1, 3, '재미있네요', '2022-1-1');
INSERT comment_tbl VALUES (NULL, 2, 3, '팬입니다', '2022-2-13');
INSERT comment_tbl VALUES (NULL, 3, 1, '반갑습니다', '2022-3-11');
INSERT comment_tbl VALUES (NULL, 4, 2, '강호동 너무 재밌음', '2022-3-21');
INSERT comment_tbl VALUES (NULL, 5, 5, '이거 내글인데 1', '2022-4-11');
INSERT comment_tbl VALUES (NULL, 6, 5, '이거 내글인데 2', '2022-4-11');
INSERT comment_tbl VALUES (NULL, 7, 4, '신서유기 개꿀잼', '2022-4-11');
INSERT comment_tbl VALUES (NULL, 8, 6, '무한도전 포에버', '2022-4-11');
INSERT comment_tbl VALUES (NULL, 9, 8, '역시 유재석', '2022-4-11');
INSERT comment_tbl VALUES (NULL, 10, 8, '식센 요즘 핫함', '2022-4-11');