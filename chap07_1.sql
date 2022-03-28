USE sample01_db;

/* 7.1.2 변수의 사용 */
/* ------------------------------------------------------------------------ */

-- 변수를 지정하고, 변수에 값을 대입 후 출력
USE sample01_db;

SET @myVar1 = 5;
SET @myVar2 = 3;
SET @myVar3 = 4.25;
SET @myVar4 = '가수 이름==>';

SELECT @myVar1;
SELECT @myVar2 + @myVar3;

SELECT @myVar4, Name FROM user_tbl WHERE height > 180;

-- LIMIT에는 원칙적으로 변수를 사용할 수 없으나 PREPARE 와 EXECUTE 문을 활용해서 변수 활용 가능
SET @myVar1 = 3;

-- SELECT Name, height FROM user_tbl ORDER BY height LIMIT @myVar1; <= 오류 발생

-- ? 에 변수 @myVar1 이 대입됨
PREPARE myQuery
	FROM 'SELECT Name, height FROM user_tbl ORDER BY height LIMIT ?';
EXECUTE myQuery USING @myVar1;



/* 7.1.3 변수의 사용 */
/* ------------------------------------------------------------------------ */

-- 구매 테이블에서 평균 구매 개수 출력
USE sample01_db;
-- 평균은 실수로 출력됨
SELECT AVG(amount) AS '평균 구매 개수' FROM buy_tbl;

-- 구매 개수는 소수점이 나올 수 없기 때문에 정수로 형 변환을 해야함.(CAST 또는 CONVERT 사용)
SELECT CAST(AVG(amount) AS SIGNED INTEGER) AS '평균 구매 개수' FROM buy_tbl;
SELECT CONVERT(AVG(amount), SIGNED INTEGER) AS '평균 구매 개수' FROM buy_tbl;

-- 다양한 구분자를 날짜 형식으로 변경
SELECT CAST('2020$12$12' AS DATE);
SELECT CAST('20221212' AS DATE);
SELECT CAST('2022/01/10' AS DATE);
SELECT CAST('2021@1@10' AS DATE);

-- 단가와 수량을 곱한 실제 구매액을 보기좋게 출력
SELECT num,
	CONCAT(CAST(price AS CHAR(10)), ' X ', CAST(amount AS CHAR(4)), '=') AS '단가 x 수량',
    price*amount AS '구매액'
    FROM buy_tbl;

-- CAST(), CONVERT() 를 사용하지 않고 형변환 되는 암시적인 변환

-- 문자와 문자를 더함(정수로 변환되어 처리됨)
SELECT '100' + '200';

-- 문자와 문자를 연결(문자로 처리)
SELECT CONCAT('100', '200');

-- 정수와 문자를 연결(정수가 문자로 변환되어 처리됨)
SELECT CONCAT(100, '200');

-- 정수로 변환되어 비교됨(결과값은 0(false))
SELECT 1 > '2mega';

-- 문자는 정수 0 으로 변환됨(결과값은 1(true))
SELECT 0 = 'mega2';



/* 7.1.4 MySQL 내장 함수 */
/* ------------------------------------------------------------------------ */

/* 제어 흐름 함수 */

-- IF(수식이 참 또는 거짓인지 결과에 따라서 2중 분기한다)
SELECT IF (100 > 200, '참이다', '거짓이다') AS 'IF(100 > 200)';

-- IFNULL(수식1이 NULL이 아니면 수식1이 반환되고, 수식1이 NULL이면 수식2가 반환된다)
SELECT IFNULL('수식1','수식2'), IFNULL(NULL, '수식2');

-- NULLIF(수식1과 수식2가 같으면 NULL을 반환하고, 다르면 수식1을 반환한다.)
SELECT NULLIF('수식1=수식2', '수식1=수식2'), NULLIF('수식1', '수식2');

-- CASE ~ WHEN ~ ELSE ~ END(CASE는 내장 함수는 아니면 연산자로 분류됨)
SELECT CASE 10
	WHEN 1 THEN '일'
	WHEN 5 THEN '오'
    WHEN 10 THEN '십'
    ELSE '모름'
END AS 'CASE 연습';

/* 문자열 함수 */

-- ASCII(아스키 코드), CHAR(숫자)(문자의 아스키코드값을 돌려주거나 아스키코드값에 해당하는 문자를 돌려줌
SELECT ASCII('A'), CHAR(65);

-- BIT_LENGTH, CHAR_LENGTH, LENGTH(할당된 Bit 크기 또는 문자 크기를 반환한다)
-- MySQL 은 기본적으로 UTF-8 코드를 사용하기 때문에 영문은 3Byte, 한글은 9Byte를 할당한다.
SELECT BIT_LENGTH('abc'), CHAR_LENGTH('abc'), LENGTH('abc');
SELECT BIT_LENGTH('가나다'), CHAR_LENGTH('가나다'), LENGTH('가나다');

-- CONCAT, CONCAT_WS(문자열을 이어준다. CONCAT_WS는 구분자와 함께 문자열을 이어준다.)
SELECT CONCAT('2022년 ','03월 ','24일'), CONCAT_WS('/', '2022', '03', '24');

-- ELT(위치, 문자열1, 문자열2, ...)(위치 번째에 해당하는 문자열을 반환한다.)
SELECT ELT(3, 'first', 'second', 'third');

-- FIELD(찾을 문자열, 문자열1, 문자열2, ...)(찾을 문자열의 위치를 찾아서 반환한다.)
SELECT FIELD('HELLO', 'first', 'HELLO', 'HHELLO');

-- FIND_IN_SET(찾을 문자열, 문자열 리스트)(찾을 문자열을 문자열 리스트에서 찾아서 위치를 반환한다.)
SELECT FIND_IN_SET('HI', 'hello,good,hi,bye');

-- INSTR(기준 문자열, 부분 문자열), LOCATE(부분 문자열, 기준 문자열)(기준 문자열에서 부분 문자열을 찾아서 시작 위치를 반환한다.)
SELECT INSTR('하나둘셋', '둘'), LOCATE('둘', '하나삼넷둘');

-- FORMAT(숫자, 소수점 자리수)
SELECT FORMAT(1234567.0123456, 3);

-- BIN, HEX, OCT(2진수, 16진수, 8진수의 값을 반환한다.)
SELECT BIN(31), HEX(31), OCT(31);

-- INSERT(기준 문자열 위치, 위치, 길이, 삽입할 문자열)(기준 문자열의 위치부터 길이만큼 지우고 삽입할 문자열을 넣는다)
SELECT INSERT('abcdefghij', 3, 4, '@@@@'), INSERT('abcdefghij', 3, 0, '@@@@');

-- LEFT(문자열, 길이), RIGHT(문자열, 길이)(왼쪽 또는 오른쪽에서 문자열의 길이만큼 반환한다.)
SELECT LEFT('abcdefg', 3), RIGHT('abcdefg', 3);

-- UPPER, LOWER(대문자 또는 소문자로 변경한다.)
SELECT UPPER('abdfFEDSA'), UCASE('ABCdef');
SELECT LOWER('ABCDefgh'), LCASE('ACDBFwer');

-- LPAD(문자열, 길이, 채울 문자열), RPAD(문자열, 길이, 채울 문자열)(문자열을 길이만큼 늘린 후, 빈 곳을 채울 문자열로 채운다.)
SELECT LPAD('자바다', 6, '#'), RPAD('이것이', 6, '#');

-- LTRIM, RTIM(문자열의 왼쪽/오른쪽 공백을 제거한다)
SET @var1 = LTRIM('   abc   ');
SET @var2 = RTRIM('   abc   ');
SET @varLtrim = CONCAT('#', @var1, '#');
SET @varRtrim = CONCAT('#', @var2, '#');
SELECT @varLtrim AS 'LTRIM', @varRtrim AS 'RTRIM';

-- TRIM(문자열), TRIM(방향 자를문자열 FROM 문자열)(앞뒤 공백 또는 지정한 방향의 문자열을 제거한다)
SET @var3 = TRIM('   ddd   ');
SET @varTrim = CONCAT('#', @var3, '#');
SELECT @varTrim AS 'TRIM';

SELECT TRIM(LEADING 'ㅋ' FROM 'ㅋㅋㅋㅋ재밌어요ㅋㅋㅋㅋ') AS 'LEADING TRIM';
SELECT TRIM(BOTH 'ㅋㅋ' FROM 'ㅋㅋㅋㅋㅋ재밌어요ㅋㅋㅋㅋㅋ') AS 'BOTH TRIM';
SELECT TRIM(TRAILING 'ㅋ' FROM 'ㅋㅋㅋㅋ재밌어요ㅋㅋㅋㅋ') AS 'TRAILING TRIM';

-- REPEAT(문자열을 횟수만큼 반복한다.)
-- SELECT REPEAT('이것이 ', 3) AS 'REPEAT'; 

-- REPLACE(문자열, 원래 문자열, 바꿀 문자열)
SET @str = '이것이 MySQL이다.';
SELECT @str, REPLACE(@str, '이것이', 'This is');

-- REVERSE(문자열의 순서를 거꾸로 만든다.)
SELECT REVERSE('MySQL');

-- SPACE(길이)(길이만큼의 공백을 반환한다.)
SELECT CONCAT('이것이', SPACE(5), 'MySQL이다');

-- SUBSTRING(문자열, 시작위치, 길이), SUBSTRING(문자열 FROM 시작위치 FOR 길이)
SELECT SUBSTRING('안녕하세요.반갑습니다.',7,6);
SELECT SUBSTRING('안녕하세요.반갑습니다.' FROM 7 FOR 6);

-- SUBSTRING_INDEX(문자열, 구분자, 횟수)(구분자가 횟수 번째 나오면 그 이후는 버린다.(양수는 왼쪽부터, 음수는 오른쪽부터))
SELECT SUBSTRING_INDEX('cafe.naver.com', '.', 2);
SELECT SUBSTRING_INDEX('cafe.naver.com', '.', -2);

/* 수학 함수 */

-- ABS(숫자의 절댓값을 계산)
SELECT ABS(-100);

-- DEGREES, RADIANS, PI(각도값, 라디안 값, 3.1415)
SELECT PI(), DEGREES(pi()), RADIANS(180);

-- 삼각함수
SELECT ACOS(0), ASIN(1), ATAN(1), ATAN2(0.1,0), SIN(pi()/2), COS(pi()), TAN(pi()/2);

-- CEILING, FLOOR, ROUND(올림, 내림, 반올림을 계산한다.)
SELECT CEILING(3.3), FLOOR(3.7), ROUND(3.7);

-- CONV(숫자, 원래 진수, 변환할 진수)
SELECT CONV('AA', 16, 2), CONV(100, 10, 8);

-- 지수, 로그함수
SELECT EXP(1), LN(EXP(1)), LOG(EXP(3)), LOG(10, 10), LOG2(4), LOG10(100);

-- 거듭제곱 및 제곱근
SELECT POW(2, 3), SQRT(16);

-- RAND(0 이상 1 미만의 실수를 구한다.)
SET @ran = RAND();
SELECT @ran, FLOOR((@ran*10)+1) AS '1에서 10 사이 숫자';

-- SIGN(숫자가 양수, 0, 음수인지를 구한다)
SELECT SIGN(100), SIGN(0), SIGN(-200);

-- TRUNCATE(숫자를 소수점을 기준으로 정수 위치까지 구하고 나머지는 버린다.)
SELECT TRUNCATE(12345.12345, 2), TRUNCATE(12345.12345, -3);

/* 날짜 및 시간 함수 */

-- ADDDATE(날짜, 차이), SUBDATE(날짜, 차이)(날짜를 기준으로 차이를 더하거나 뺀 날짜를 구한다.)
SELECT ADDDATE('2025-01-01', INTERVAL 31 DAY),
	ADDDATE('2022-03-24', INTERVAL 5 MONTH),
    ADDDATE('2020-10-10', INTERVAL 1 YEAR);
SELECT DATE_ADD('2025-01-01', INTERVAL 31 DAY),
	DATE_ADD('2022-03-24', INTERVAL 5 MONTH),
    DATE_ADD('2020-10-10', INTERVAL 1 YEAR);
    
SELECT SUBDATE('2025-01-01', INTERVAL 31 DAY),
	SUBDATE('2022-03-24', INTERVAL 2 MONTH),
    SUBDATE('2021-10-10', INTERVAL 2 YEAR);
SELECT DATE_SUB('2025-01-01', INTERVAL 31 DAY),
	DATE_SUB('2022-03-24', INTERVAL 2 MONTH),
    DATE_SUB('2021-10-10', INTERVAL 2 YEAR);

-- ADDTIME(날짜/시간, 시간), SUBTIME(날짜/시간, 시간)(날짜/시간을 기준으로 시간을 더하거나 뺀 결과를 구한다)
SELECT ADDTIME('2025-01-01 23:59:59', '1:1:1'), ADDTIME('15:00:00', '2:10:10');
SELECT SUBTIME('2025-01-01 23:59:59', '1:1:1'), SUBTIME('15:00:00', '2:10:10');

-- 현재 날짜, 시간
SELECT CURDATE(), CURRENT_DATE(), CURTIME(), CURRENT_TIME();
SELECT NOW(), LOCALTIME(), LOCALTIMESTAMP(), SYSDATE();

-- 날짜 또는 시간에서 연, 월, 일, 시, 분, 초, 밀리초를 구한다.
SELECT YEAR(CURDATE()), MONTH(CURDATE()), DAYOFMONTH(CURDATE());
SELECT HOUR(CURTIME()), MINUTE(CURTIME()), SECOND(CURTIME()), MICROSECOND(CURRENT_TIME);

SELECT YEAR(NOW()), MONTH(NOW()), DAYOFMONTH(NOW());
SELECT HOUR(NOW()), MINUTE(NOW()), SECOND(NOW()), MICROSECOND(NOW());

-- DATETIME 형식에서 연-월-일 및 시:분:초만 추출한다.
SELECT DATE(NOW()), TIME(NOW());

-- DATEDIFF(날짜1, 날짜2), TIMEDIFF(날짜1 또는 시간1, 날짜1 또는 시간2)
SELECT DATEDIFF('2025-01-01', NOW()), TIMEDIFF('23:23:59', TIME(NOW()));

-- 요일(1:일, 2:월~7:토) 및 1년 중 몇 번째 날짜인지를 구한다.
SELECT DAYOFWEEK(CURDATE()), MONTHNAME(CURDATE()), DAYOFYEAR(CURDATE());

SET @var13 = (SELECT CASE DAYOFWEEK(CURDATE())
	WHEN 1 THEN '일'
    WHEN 2 THEN '월'
    WHEN 3 THEN '화'
    WHEN 4 THEN '수'
    WHEN 5 THEN '목'
    WHEN 6 THEN '금'
    WHEN 7 THEN '토'
    END);

SELECT MONTHNAME(CURDATE()) AS '월', CONCAT(@var13,'요일') AS '요일', DAYOFYEAR(CURDATE()) AS '올해 지난날';

-- 주어진 날짜의 마지막 날짜를 구한다. 주로 그 달이 몇 일까지 있는지 확인
SELECT LAST_DAY('2024-02-01');

-- MAKEDATE(연도, 정수)(연도에서 정수만큼 지난 날짜를 구한다.)
SELECT MAKEDATE(2025, 30);
-- 현재 날짜가 올해 시작부터 몇일이 지났는지를 대입해서 결과는 오늘 날짜가 나옴
SELECT MAKEDATE(2025, DAYOFYEAR(CURDATE()));

-- NAKETIME(시, 분, 초)('시:분:초'의 TIME 형식을 만든다.)
SELECT MAKETIME(10,20,50);

-- PERIOD_ADD(연월, 개월수), PERIOD_DIFF(연월1, 연월2)(연월에서 개월이 지난 연월을 구하거나, 연월1-연월2 개월수를 반환)
SELECT PERIOD_ADD(202203, 11), PERIOD_DIFF(202305, 202306);

-- QUARTER(날짜가 4분기 중 몇 분기인지 구한다.)
SELECT QUARTER(20220210);
SELECT QUARTER('2022-06-24');

-- TIME_TO_SEC(시간을 초 단위로 구한다.)
SELECT TIME_TO_SEC('12:11:10');
SELECT TIME_TO_SEC('1:00:00');

/* 시스템 정보 함수 */

-- USER, DATABASE(현재 사용자 및 현재 선택된 데이터베이스를 구한다.)
SELECT USER();
USE sample01_db;
SELECT DATABASE();

-- FOUND_ROWS(바로 앞의 SELECT 문에서 조회된 행의 개수를 구한다.)
SELECT * FROM buy_tbl;
SELECT FOUND_ROWS();

-- ROW_COUNT(바로 앞의 INSERT, UPDATE, DELETE 문에서 입력, 수정, 삭제된 행의 개수를 구한다.)
SELECT * FROM buy_tbl;
UPDATE buy_tbl SET price = price * 2 WHERE num <> 0;
SELECT ROW_COUNT();

-- VERSION(현재 MySQL의 버전을 구한다.)
SELECT VERSION();

-- SLEEP(쿼리의 실행을 잠깐 멈춘다)
SELECT SLEEP(3);
SELECT '5 초 후에 이게 보여요';

/* 피벗의 구현 */
-- 피벗은 한 열에 포함된 여러 값을 출력하고, 이를 여러 열로 변환하여 테이블 반환 식을 회전하고 필요하면 집계까지 수행하는 것

USE sample01_db;
CREATE TABLE pivotTest (
	uName CHAR(3),
    season CHAR(2),
    amount INT
);

INSERT INTO pivotTest VALUES
	('김범수', '겨울', 10), ('윤종신', '여름', 15), ('김범수', '가을', 25), ('김범수', '봄', 3),
    ('김범수', '봄', 37), ('윤종신', '겨울', 40), ('김범수', '여름', 14), ('김범수', '겨울', 22),
    ('윤종신', '여름', 64);
SELECT * FROM pivotTest;

SELECT uName,
	SUM(IF(season='봄', amount, 0)) AS '봄',
    SUM(IF(season='여름', amount, 0)) AS '여름',
    SUM(IF(season='가을', amount, 0)) AS '가을',
    SUM(IF(season='겨울', amount, 0)) AS '겨울',
    SUM(amount) AS '합계' FROM pivotTest GROUP BY uName;

/* JSON 데이터 */
-- 속성과 키 값으로 쌍을 이루며 구성됨.

-- JSON 내장함수로 user_tbl에서 키가 180 이상인 사람의 이름과 키를 JSON으로 변환
USE sample01_db;
SELECT name, height FROM user_tbl;
SELECT JSON_OBJECT('name', name, 'height', height) AS 'JSON 값'
	FROM user_tbl WHERE height >= 180;
    
-- JSON 관련 함수

-- @json 변수에 JSON 데이터를 우선 대입하면서 테이블의 이름은 usertbl로 지정
SET @json = '{"usertbl" : 
	[
		{"name":"임재범", "height":182},
        {"name" : "이승기", "height" : 182},
        {"name" : "성시경", "height" : 186}
	]
}';

-- 문자열이 JSON 형식을 만족하면 1, 그렇지 않으면 0을 반환.
SELECT JSON_VALID(@json) AS JSON_VALID;

-- 세 번째 파라미터에 주어진 문자열의 위치를 반환.
-- 두 번째 파라미터는 one, all 만 가능(처음 매치되는 하나만 반환할지 매치되는 모든 것을 반환할지 결정)
SELECT JSON_SEARCH(@json, 'one', '임재범') AS JSON_SEARCH;

-- 지정된 위치값을 추출
SELECT JSON_EXTRACT(@json, '$.usertbl[2].name') AS JSON_EXTRACT;

-- 새로운 값을 추가
SELECT JSON_INSERT(@json, '$.usertbl[0].mDate', '2009-09-09') AS JSON_INSERT;

-- 값을 변경
SELECT JSON_REPLACE(@json, '$.usertbl[0].name', '홍길동') AS JSON_REPLACE;

-- 지정된 항목 삭제
SELECT JSON_REMOVE(@json, '$.usertbl[0]') AS JSON_REMOVE;




