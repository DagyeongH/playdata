-- 주석
/* block 주석 */
-- 사용자 계정 생성
-- local 접속 계정
CREATE USER 'playdata'@localhost IDENTIFIED BY '1111';
-- 원격 접속 계정
CREATE USER 'playdata'@'%' IDENTIFIED BY '1111';
-- 같은 이름으로 local, 원격 두 개 생성하면 하나에 권한이 두 개인겨 아님 두 개의 계정이 생성되는겨,, -> 두 개가 따로 생성되는 듯,, 
-- 조회 할 때도 따로 되는거 보면,,

-- 등록된 사용자계정 조회
SELECT user, host FROM mysql.user;

-- 게정에 권한 부여
grant all privileges on *.* to 'playdata'@localhost;
grant all privileges on *.* to 'playdata'@'%';

-- database 생성
create database testdb;  -- 이름 testdb인 database 생성
-- database 확인
show databases;

use testdb;

-- table 생성 - 회원(member) 테이블 생성
-- 속성이름   데이터타입   제약조건
drop table member;
create table member (
	id varchar(10) primary key,
    password varchar(10) not null,
    name varchar(50) not null,
    point int default 1000,
    email varchar(100) unique key,
    gender char(1) check (gender in ('m', 'f')),
    age int check (age > 0),
    join_date timestamp not null default current_timestamp
);

-- table 확인
show tables;
-- table의 속성(컬럼)들을 확인
desc member;
-- member 테이블에 데이터를 insert
insert into member values ('id-111', '1111', '홍길동', 3000, 'a@a.com', 'm', 20, '2010-2-3 10:20:30');

-- 일부컬럼의 값을 insert ==> 생략할 수 있는 컬럼: nullable, default값이 있는 컬럼
insert into member (id, password, name) values ('id-222', '1212', '강감찬');

-- 제약조건 테스트
-- email: Unique key 제약조건
insert into member (id, password, name, email) values ('id-3333', '1111', '유관순', null);
-- gender: check ==> 'm', 'f', age: check 양수
insert into member (id, password, name, gender, age) values ('id-5555', '1111', '유재석', 'm', 30);

select * from member;














