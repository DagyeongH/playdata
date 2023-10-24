/* *********************************************************************
INSERT 문 - 행 추가
구문
 - 한행추가 :
   - INSERT INTO 테이블명 (컬럼 [, 컬럼]) VALUES (값 [, 값[])
   - 모든 컬럼에 값을 넣을 경우 컬럼 지정구문은 생략 할 수 있다.
​
 - 조회결과(select)를 INSERT 하기 (subquery 이용)
   - INSERT INTO 테이블명 (컬럼 [, 컬럼])  SELECT 구문
	 - INSERT할 컬럼과 조회한(subquery) 컬럼의 개수와 타입이 맞아야 한다.
	 - 모든 컬럼에 다 넣을 경우 컬럼 설정은 생략할 수 있다.
************************************************************************ */
use hr_join;
insert into emp (emp_id, emp_name, job_id, mgr_id, 
				 hire_date, salary, comm_pct, dept_id)
values ('500', '홍길동', 'AC_ACCOUNT', 100, '2023-9-7', 5000.23, null, 100);                 
​
insert into emp 
values ('501', '이직원', 'AC_ACCOUNT', 100, '2023-9-7', 5000.23, null, 110); 
​
insert into emp (emp_id, emp_name, mgr_id, hire_date, salary)
values (502, '박직원', 102, '2023-08-10', 2500);
​
-- 에러나는 것
insert into emp (emp_id, emp_name, mgr_id, hire_date)
values (502, '박직원', 102, '2023-08-10'); -- not null 컬럼(salary)에 값을 안넣는 경우.
​
insert into emp (emp_id, emp_name, mgr_id, hire_date, salary)
values (502, '박직원', 102, '2023-08-10', 2500); -- pk(emp_id) 로 존재하는 값을 insert
​
insert into emp (emp_id, emp_name, mgr_id, hire_date, salary)
values (503, '박직원', 700, '2023-08-10', 2500);
-- mgr_id는 emp.emp_id를 참조하는 FK 컬럼. emp.emp_id에 없는 값을 넣으려고 해서 error.
​
insert into emp (emp_id, emp_name, mgr_id, hire_date, salary)
values (503, '박직원', 100, '2023-08-10', 2500000);
-- salary  decimal(7, 2) xxxxx.00
​
select * from emp
order by emp_id desc;
​
-- 직원들 중 10, 20 30 번 부서의 소속된 직원들의 id, 이름, 급여를 저장하는 테이블
create table emp_copy(
	emp_id int,
    emp_name varchar(20),
    salary decimal(7,2)
);
​
insert into emp_copy (emp_id, emp_name, salary) 
select emp_id, emp_name, salary 
from emp 
where dept_id in (10, 20, 30)
order by emp_id;
​
​
select * from emp_copy;
​
-- TODO 부서별 직원의 급여에 대한 통계 테이블 생성. 
-- emp의 다음 조회결과를 insert. 집계: 합계, 평균, 최대, 최소, 분산, 표준편차
​
create table salary_stat(
	dept_id int,
    salary_sum decimal(15, 2),
    salary_avg decimal(10, 2),
    salary_max decimal(10, 2), 
    salary_min decimal(10, 2),
    salary_var decimal(10, 2),
    salary_std decimal(10, 2)
);
select * from salary_stat;
insert into salary_stat
select  dept_id,   -- ifnull(dept_id, '미배치'),
		sum(salary), 
        round(avg(salary), 2), 
		max(salary), min(salary), 
        round(variance(salary), 2), 
        round(stddev(salary), 2)
from    emp
group by dept_id;
​
​
/*
Edit > Preferences > SQL Editor 에서 맨 아래 Safe Update .... 체크 해제
여러행을 삭제 또는 수정하는 것을 막는 설정 (check되면)
*/
 /*
 Auto commit 설정을 해제.
 commit: insert, delete, update 된 데이터를 실제 물리 디비에 영구적으로 적용.
 */
select @@autocommit; 
-- 1: auto commit   - I/U/D 쿼리가 실행되면 바로 적용
-- 0: manual commit - I/U/D 쿼리가 실행되도 바로 적용하지 않고 commit 명령을 직접
-- 					  실행해야 적용된다.
--     - commit; -> 적용, rollback; -> 마지막 commit 상태로 복원.
SET AUTOCOMMIT = 1;
select @@autocommit;
​
use hr;
select * from emp;
delete from emp where dept_name = 'Executive';
​
select count(*) from emp;
​
rollback;
select * from emp;
​
​
​
use hr_join;
set autocommit = 0;
select @@autocommit;
-- 직원 ID가 200인 직원의 급여를 5000으로 변경
update emp
set salary = 5000;
-- 이러면 전부 다 바뀐거라 잘못
-- rollback라기
rollback;
​
update emp
set salary = 5000
where emp_id = 200;
​
select * from emp where emp_id = 200;
commit;
​
-- 직원 ID가 200인 직원의 급여를 10% 인상한 값으로 변경.
update emp
set salary = salary * 1.1
where emp_id = 200;
​
select * from emp where emp_id = 200;
commit;
​
​
-- 부서 ID가 100인 직원의 커미션 비율을 0.2로 salary는 3000을 더한 값으로, 상사_id는 100 변경.
update emp
set comm_pct = 0.2,
	salary = salary + 3000,
    mgr_id = 100
where dept_id = 100;
​
select * from emp where dept_id = 100;
commit;
​
-- 부서 ID가 100인 직원의 커미션 비율을 null 로 변경.
update emp
set comm_pct = null -- where 절에서는 is null 사용했지만  이건 이 자리에 null을 넣으라는 것이므로 걍 null쓰기
where dept_id = 100;
-- null 값 대입 시 = 사용
select * from emp where dept_id = 100;
commit;
 
​
-- TODO: 부서 ID가 100인 직원들의 급여를 100% 인상
update emp
set salary = salary * 2
where dept_id = 100;
select * from emp where dept_id = 100;
commit;
​
-- TODO: IT 부서의 직원들의 급여를 3배 인상
update emp
set salary = salary * 3
where dept_id = (select dept_id from dept where dept_name = 'IT');
​
select dept_id from dept where dept_name = 'IT' ;
select * from emp where dept_id = 60;
commit;  --  commit은 하나의 작업이 끝났다라는 것 - 현재 하고있는 특정 작업 완효 후 하기
​
-- TODO: EMP 테이블의 모든 데이터를 MGR_ID는 NULL로 HIRE_DATE 는 현재일시로 COMM_PCT는 0.5로 수정.
update emp
set mgr_id = null,
	hire_date = curdate(),
    comm_pct = 0.5;
select * from emp;
​
/* *********************************************************************
DELETE : 테이블의 행을 삭제
구문 
 - DELETE FROM 테이블명 [WHERE 제약조건]
   - WHERE: 삭제할 행을 선택
************************************************************************ */
​
-- 부서테이블에서 부서_ID가 200인 부서 삭제
delete from dept; -- 이거는 싹 다 지워버림
rollback;
delete from dept where dept_id = 200;
select * from dept where dept_id = 200;
commit;
​
-- 부서테이블에서 부서_ID가 10인 부서 삭제
delete from dept where dept_id = 10;
​
select * from dept where dept_id = 10;
--  만약 처음 table ㅇ르 만들 떄 on delete set null 설정을 해 두면 나중에 자울 수 없다 (지워지는거 막음) 안쓰면 지울 수 있음
​
-- TODO: 부서 ID가 없는 직원들을 삭제
delete from emp where dept_id is null;
select * from emp where dept_id is null;
​
-- TODO: 담당 업무(emp.job_id)가 'SA_MAN'이고 급여(emp.salary) 가 12000 미만인 직원들을 삭제. 
delete from emp where job_id = 'SA_MAN' and salary < 12000;
​
select * from emp where job_id = 'SA_MAN' and salary < 12000;
​
​
-- TODO: comm_pct 가 null이고 job_id 가 IT_PROG인 직원들을 삭제
​
delete from emp where comm_pct is null and job_id = 'IT_PROG';
​
select * from emp where comm_pct is null and job_id = 'IT_PROG';
​
-- DELETE 관련 하나만 더
​
select count(*) from emp;
select @@autocommit;
set autocommit = 0;
​
delete from emp;
select count(*) from emp;
rollback;
​
-- 테이블의 데이터를 모두 삭제 할 경우 위처럼도 가능 하지만..
-- truncate table 테이블명; 을 사용 할 수 있다
​
truncate table emp;
select * from emp;
-- delete와 비슷하지만 rollback을 해도 다시 살릴 수 없음