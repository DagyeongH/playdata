select * from information_schema.table_constraints;
/* ***********************************************************************************
테이블 생성
- 구문
create table 테이블 이름(
  컬럼 설정
)
컬럼 설정
- 컬럼명   데이터타입  [default 값]  [제약조건] 
- 데이터타입
- default : 기본값. 값을 입력하지 않을 때 넣어줄 기본값.

제약조건 설정 
- primary key (PK): 행식별 컬럼. NOT NULL, 유일값(Unique)
- unique Key (uk) : 유일값을 가지는 컬럼. null을 가질 수있다.
- not null (nn)   : 값이 없어서는 안되는 컬럼.
- check key (ck)  : 컬럼에 들어갈 수 있는 값의 조건을 직접 설정.
- foreign key (fk): 다른 테이블의 primary key 컬럼의 값만 가질 수 있는 컬럼. 
                    다른 테이블을 참조할 때 사용하는 컬럼.

- 컬럼 레벨 설정
    - 컬럼 설정에 같이 설정
- 테이블 레벨 설정
    - 컬럼 설정 뒤에 따로 설정

- 기본 문법 : constraint 제약조건이름 제약조건타입(지정할컬럼명) 
- 테이블 제약 조건 조회
    - select * from information_schema.table_constraints;

    
테이블 삭제
- 구분
DROP TABLE 테이블이름;

- 제약조건 해제
   SET FOREIGN_KEY_CHECKS = 0;
- 제약조건 설정
   SET FOREIGN_KEY_CHECKS = 1;   
*********************************************************************************** */
use testdb;

create table parent_tb(
	no	int primary key,
    name varchar(20) not null,  -- not null은 컬럼레벨 설정만 가능
	join_date timestamp default current_timestamp,  -- insert 할 때 일시
    email varchar(100) unique,
    gender char(1) not null check(gender in ('M', 'F'))
);
-- mysql에서 테이블 확인
show tables;

select * from information_schema.table_constraints
where table_schema = 'testdb';
-- where table_name = 'parent_db';

insert into parent_tb values(100, '홍길동', '2022-10-10', 'a@A.com', 'M');
insert into parent_tb (no, name, email, gender) values(200, '김길동', 'b@b.com', 'M');
select * from parent_tb;

create table child_tb(
	no int auto_increment,  -- PK, auto_increment: 자동증가
	jumin_no char(14) not null,  -- UK
    age int not null,  -- CK (0 이상)
    parent_no int, -- FK (parent_tb의 no 컬럼 참조)
	constraint pk_child_tb_no primary key(no), -- constraint pk_child_tb_no 생략가능
	constraint uk_child_tb_jumin_no unique(jumin_no),
    constraint ck_child_tb_age check(age > 0),  -- check(age between 10 and 50)
    constraint fk_child_tb_parent_db_parent_no foreign key(parent_no) references parent_tb(no)
);
-- 제약조건이름(관례): 타입약자_테이블이름_추가정보
show tables;
select * from information_schema.table_constraints
where table_name = 'child_tb';

insert into child_tb (jumin_no, age, parent_no) values ('851207-1234567', 30, 100); -- no(pk) 빠짐 
insert into child_tb (jumin_no, age, parent_no) values ('851207-1234568', 30, 100);
insert into child_tb (no, jumin_no, age, parent_no) values (100, '851207-1234569', 30, 100);
select * from child_tb;

-- 컬럼정보
desc child_tb;
drop table child_tb;
drop table parent_db;
drop table member;
show tables;

SET FOREIGN_KEY_CHECKS = 1;
drop table parent_tb;  -- 참조하는 자식테이블이 있기 때문에 삭제 X
show tables;

-- TODO
-- 출판사(publisher) 테이블
-- 컬럼명                 | 데이터타입        | 제약조건        
-- publisher_no 		| int  			| primary key, 자동증가
-- publisher_name 		| varchar(50)   | not null 
-- publisher_address 	| varchar(100)  |
-- publisher_tel 		| varchar(20)   | not null
create table publisher(
	publisher_no int auto_increment,
    publisher_name varchar(50) not null,
    publisher_address varchar(100),
    publisher_tel varchar(20) not null,
    constraint pk_publisher_no primary key(publisher_no)
);

# 강사님 풀이
create table publisher(
	publisher_no int primary key auto_increment,
    publisher_name varchar(50) not null,
    publisher_address varchar(100),
    publisher_tel varchar(20) not null
);

show tables;

-- 책(book) 테이블
-- 컬럼명 		   | 데이터타입            | 제약 조건         |기타 
-- isbn 		   | varchar(13),       | primary key
-- title 		   | varchar(50) 		| not null 
-- author 		   | varchar(50) 		| not null 
-- page 		   | int 		 		| not null, check key-0이상값
-- price 		   | int 		 		| not null, check key-0이상값 
-- publish_date   | timestamp 			| not null, default-current_timestamp(등록시점 일시)
-- publisher_no   | int 		        | not null, Foreign key-publisher

drop table if exists book;
drop table if exists publisher;

create table book(
	isbn varchar(13),
    title varchar(50) not null,
    author varchar(50) not null,
    page int not null,
    price int not null,
	publish_date timestamp default current_timestamp,
    publisher_no int not null,
    constraint pk_isbn primary key(isbn),
    constraint ck_page check(page >= 0),
    constraint ck_price check(price >= 0),
    constraint fk_publisher_no foreign key(publisher_no) references publisher(publisher_no)
);

# 강사님 풀이
create table book (
	isbn varchar(13),
    title varchar(50) not null,
    author varchar(50) not null,
    page int not null,
    price int not null,
    publish_date timestamp default current_timestamp not null,
    publisher_no int not null,
	primary key(isbn),
	check(page > 0),
    check(price > 0),
    foreign key(publisher_no) references publisher(publisher_no)
);

show tables;

/* ************************************************************************************
ALTER : 테이블 수정

컬럼 관련 수정

- 컬럼 추가
  ALTER TABLE 테이블이름 ADD COLUMN 추가할 컬럼설정 [,ADD COLUMN 추가할 컬럼설정]
  
- 컬럼 수정
  ALTER TABLE 테이블이름 MODIFY COLUMN 수정할컬럼명 타입 null설정 [, MODIFY COLUMN 수정할컬럼명 타입 null설정]
	- 숫자/문자열 컬럼은 크기를 늘릴 수 있다.
		- 크기를 줄일 수 있는 경우 : 열에 값이 없거나 모든 값이 줄이려는 크기보다 작은 경우
	- 데이터가 모두 NULL이면 데이터타입을 변경할 수 있다. (단 CHAR<->VARCHAR 는 가능.)
	- null 설정을 생략하면 nullable이 된다.

- 컬럼 삭제	
  ALTER TABLE 테이블이름 DROP COLUMN 컬럼이름 [CASCADE CONSTRAINTS]
    - CASCADE CONSTRAINTS : 삭제하는 컬럼이 Primary Key인 경우 그 컬럼을 참조하는 다른 테이블의 Foreign key 설정을 모두 삭제한다.
	- 한번에 하나의 컬럼만 삭제 가능.
	
  ALTER TABLE 테이블이름 SET UNUSED (컬럼명 [, ..])
  ALTER TABLE 테이블이름 DROP UNUSED COLUMNS
	- SET UNUSED 설정시 컬럼을 바로 삭제하지 않고 삭제 표시를 한다. 
	- 설정된 컬럼은 사용할 수 없으나 실제 디스크에는 저장되 있다. 그래서 속도가 빠르다.
	- DROP UNUSED COLUMNS 로 SET UNUSED된 컬럼을 디스크에서 삭제한다. 

- 컬럼 이름 바꾸기
  ALTER TABLE 테이블이름 RENAME COLUMN 원래이름 TO 바꿀이름;

**************************************************************************************  
제약 조건 관련 수정
-제약조건 추가
  ALTER TABLE 테이블명 ADD CONSTRAINT 제약조건 설정

- 제약조건 삭제
  ALTER TABLE 테이블명 DROP CONSTRAINT 제약조건이름
  PRIMARY KEY 제거: ALTER TABLE 테이블명 DROP PRIMARY KEY 
	- CASECADE : 제거하는 Primary Key를 Foreign key 가진 다른 테이블의 Foreign key 설정을 모두 삭제한다.

- NOT NULL <-> NULL 변환은 컬럼 수정을 통해 한다.
   - ALTER TABLE 테이블명 MODIFY COLUMN 컬럼명 타입 NOT NULL  
   - ALTER TABLE 테이블명 MODIFY COLUMN 컬럼명 NULL
************************************************************************************ */
use hr_join;
-- customers/orders 테이블의 구조만 복사한 테이블 생성(not null을 제외한 제약 조건은 copy가 안됨)
show tables;
create table cust
as 
select * from customers where 1 = 0;

drop table if exists orders_copy;
create table orders_copy
as 
select * from orders where 1= 0;

show tables;
desc cust;
select * from cust;
select * from information_schema.table_constraints
where table_name = 'cust';

-- 제약조건 추가
-- cust PK 추가
alter table cust add constraint cust_pk primary key(cust_id);
-- orders_copy(cust_id) - cust(cust_id) FK
alter table orders_copy add constraint fk_order_copy_cust foreign key(cust_id) references cust(cust_id);
-- cust.address 를 null 허용컬럼
alter table cust modify column address varchar(40) null;  -- null 허용
alter table cust modify column address varchar(40) not null;  -- not null

-- 제약조건 제거
alter table orders_copy drop constraint fk_order_copy_cust;

desc orders_copy;

-- 컬럼 추가
alter table cust add column age int default 0 not null;
desc cust;

-- 컬럼 수정
alter table cust modify column cust_name varchar(30) not null,
				 modify column address varchar(100);

desc cust;

-- 컬럼 이름 변경
alter table cust rename column age to cust_age;

-- 컬럼 삭제
alter table cust drop column cust_age;
desc cust;

-- TODO: emp 테이블의 구조만 복사해서 emp2를 생성 (이후 TODO 문제들은 emp2 테이블을 가지고 한다.)
create table emp2
as 
select * from emp where 1 = 0;

# 강사님 풀이
create table emp2
as 
select * from emp where 1 = 0;

desc emp2;

-- TODO: gender 컬럼을 추가: type char(1)
alter table emp2 add column gender char(1);

# 강사님 풀이
alter table emp2 add column gender char(1);

desc emp2;

-- TODO: email, jumin_num 컬럼 추가 
--   email varchar(100),  not null  
--   jumin_num char(14),  null 허용 unique
alter table emp2 add column email varchar(100) not null;
alter table emp2 add column jumin_num char(14) unique;

# 풀이
alter table emp2 add column email varchar(100) not null,
				 add column jumin_num char(14) unique;

desc emp2;

-- TODO: emp_id 를 primary key 로 변경
alter table emp2 add constraint primary key(emp_id);  

# 풀이
alter table emp2 add constraint pk_emp2 primary key(emp_id);

desc emp2;

-- TODO: gender 컬럼의 M, F 저장하도록  제약조건 추가
alter table emp2 add constraint check_gender check(gender in ('M', 'F'));

# 풀이
alter table emp2 add constraint ch_emp2_gender check(gender in ('M', 'F'));

select * from information_schema.table_constraints
where table_name = 'emp2';
 
-- TODO: salary 컬럼에 0이상의 값들만 들어가도록 제약조건 추가
alter table emp2 add constraint check_salary check(salary >= 0);

# 풀이
alter table emp2 add constraint ch_emp2_salary check(salary >= 0);

desc emp2;

-- TODO: email 컬럼에 unique 제약조건 추가.
alter table emp2 add constraint unique_email unique(email);

# 풀이
alter table emp2 add constraint uk_emp2_email unique(email);

desc emp2;

-- TODO: emp_name 의 데이터 타입을 varchar(100) 으로 변환
alter table emp2 modify column emp_name varchar(100);

# 풀이
alter table emp2 modify column emp_name varchar(100) not null;

desc emp2;

-- TODO: job_id를 not null 컬럼으로 변경
alter table emp2 modify column job_id int not null;

# 풀이
alter table emp2 modify column job_id varchar(30) not null;

desc emp2;

-- TODO: job_id  를 null 허용 컬럼으로 변경
alter table emp2 modify column job_id int null;

# 풀이
alter table emp2 modify column job_id varchar(30);

desc emp2;

-- TODO: 위에서 지정한 uk_emp2_email 제약 조건을 제거
alter table emp2 drop constraint unique_email;

# 풀이
alter table emp2 drop constraint uk_emp2_email;

desc emp2;

-- TODO: 위에서 지정한 emp_salary_ck 제약 조건을 제거
alter table emp2 drop constraint check_salary;

# 풀이
alter table emp2 drop constraint ch_emp2_salary;

desc emp2;

-- TODO: gender 컬럼제거
alter table emp2 drop column gender;

# 풀이
alter table emp2 drop column gender;

desc emp2;

-- TODO: email 컬럼 제거
alter table emp2 drop column email;

# 풀이
alter table emp2 drop column email;

desc emp2;



