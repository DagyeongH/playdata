/* *************************************
SQL: 대소문자 구분 안함. (값은 구분)

SELECT 기본 구문 - 연산자, 컬럼 별칭
select 컬럼명, 컬럼명 [, .....]  => 조회할 컬럼 지정. *: 모든 컬럼
from   테이블명                 => 조회할 테이블 지정.


컬럼명 [as 별칭] ==> 컬럼명에서 조회한 것을 별칭에 저장해서 보여준다
*************************************** */
use hr;
-- EMP 테이블의 모든 컬럼의 모든 항목을 조회.
select * from emp;


-- EMP 테이블의 직원 ID(emp_id), 직원 이름(emp_name), 업무(job) 컬럼의 값을 조회.
select  emp_id, 
		emp_name, 
		job 
from emp;

select job, emp_name, emp_id from emp;

-- EMP 테이블의 업무(job) 어떤 값들로 구성되었는지 조회. - 동일한 값은 하나씩만 조회되도록 처리.
select distinct job 
from emp;

-- EMP 테이블의 부서명(dept_name)이 어떤 값들로 구성되었는지 조회 - 동일한 값은 하나씩만 조회되도록 처리.
select distinct dept_name
from emp;

-- EMP 테이블에서 emp_id는 직원ID, emp_name은 직원이름, hire_date는 입사일, salary는 급여, dept_name은 소속부서 별칭으로 조회한다.
select  emp_id as 직원ID,  -- emp_id에서 조회한 것을 직원ID로 보여 
		emp_name as 직원이름,
        hire_date as 입사일,
        salary as 급여,
        dept_name as 소속부서
from emp;

--  별칭에 컬럼명으로 못사용하는 문자(공백)를 쓸 경우 " "로 감싼다. 
select  emp_id as 직원ID,  -- emp_id에서 조회한 것을 직원ID로 보여 
		emp_name as "직원 이름",
        hire_date as 입사일,
        salary as 급여,
        dept_name as 소속부서
from emp;


/* **************************************
연산자 
- 산술 연산자 
	- +, -, *, /, %, mod, div
- date/time/datetime 
    - +, - : 마지막 항목(date:일, time: 초, datetime: 초)의 값을 +/- => 계산 결과가 정수형으로 반환된다. (ex:20100102)
- 여러개 값을 합쳐 문자열로 반환
	- concat(값, 값, ...) 
- 피연산자가 null인경우 결과는 null
- 연산은 그 컬럼의 모든 값들에 일률적으로 적용된다.
- 같은 컬럼을 여러번 조회할 수 있다.
************************************** */
select 10 + 5, 10 - 5, 10 * 5, 10 / 4;
select 10 div 4;  -- 몫 나누기 
select 10 % 4, 10 mod 4;  -- 나머지

select concat('a', 'b', 'c', 'd');
select concat(30, '살');

select 10 + null;
select 10 * 5 + 2 + 10 + null;

-- EMP 테이블에서 직원의 이름(emp_name), 급여(salary) 그리고  급여 + 1000 한 값을 조회.
select  concat(emp_name, '님') as emp_name, 
		salary, salary + 1000 as "급여인상분"
from emp;


-- TODO: EMP 테이블의 업무(job)이 어떤 값들로 구성되었는지 조회 - 동일한 값은 하나씩만 조회되도록 처리
select distinct job from emp;

-- TODO: EMP 테이블에서 직원의 ID(emp_id), 이름(emp_name), 급여(salary), 커미션_PCT(comm_pct), 급여에 커미션_PCT를 곱한 값을 조회.
select  emp_id,
		emp_name,
        salary,
        comm_pct,
        salary * comm_pct as "salary x comm_pct"
from emp;

-- TODO:  EMP 테이블에서 급여(salary)을 연봉으로 조회. (곱하기 12)
select salary * 12 as 연봉 
from emp;

-- TODO: EMP 테이블에서 직원이름(emp_name)과 급여(salary)을 조회. 급여 앞에 $를 붙여 조회.
select  emp_name,
		concat('$', salary) as "salary"
from emp;

/* *************************************
where 절을 이용한 행 선택 
************************************* */
-- EMP 테이블에서 직원_ID(emp_id)가 110인 직원의 이름(emp_name)과 부서명(dept_name)을 조회
-- -- 컬럼: emp_name, dept_name   -- 행: emp_id = 110
select  emp_name,
		dept_name
from 	emp
where 	emp_id = 110;


select * from emp;

-- EMP 테이블에서 'Sales' 부서에 속하지 않은 직원들의 ID(emp_id), 이름(emp_name),  부서명(dept_name)을 조회.
select  emp_id,
		emp_name,
		dept_name
from 	emp
where dept_name <> 'Sales';
-- where	dept_name != 'Sales';

-- EMP 테이블에서 급여(salary)가 $10,000를 초과인 직원의 ID(emp_id), 이름(emp_name)과 급여(salary)를 조회
select 	emp_id,
		emp_name,
		salary
from	emp
where 	salary >= 10000;
-- where	salary > 10000;
 
-- EMP 테이블에서 커미션비율(comm_pct)이 0.2~0.3 사이인 직원의 ID(emp_id), 이름(emp_name), 커미션비율(comm_pct)을 조회.
select	emp_id,
		emp_name,
		comm_pct
from	emp
where	comm_pct between 0.2 and 0.3;
-- where	comm_pct >= 0.2 
-- and		comm_pct <= 0.3


-- EMP 테이블에서 커미션을 받는 직원들 중 커미션비율(comm_pct)이 0.2~0.3 사이가 아닌 직원의 ID(emp_id), 이름(emp_name), 커미션비율(comm_pct)을 조회.
select	emp_id,
		emp_name,
		comm_pct
from 	emp
where	comm_pct not between 0.2 and 0.3;

-- EMP 테이블에서 업무(job)가 'IT_PROG' 거나 'ST_MAN' 인 직원의  ID(emp_id), 이름(emp_name), 업무(job)을 조회.
select 	emp_id,
		emp_name
        job
from 	emp
where	job in ('IT_PROG', 'ST_MAN');
-- where	job = 'IT_PROG'
-- or		job = 'ST_MAN';

-- EMP 테이블에서 업무(job)가 'IT_PROG' 나 'ST_MAN' 가 아닌 직원의  ID(emp_id), 이름(emp_name), 업무(job)을 조회.
select	emp_id,
		emp_name,
		job
from 	emp
where	job not in ('IT_PROG', 'ST_MAN');
-- where	job <> 'IT_PROG'
-- and		job <> 'ST_MAN';

-- EMP 테이블에서 직원 이름(emp_name)이 S로 시작하는 직원의  ID(emp_id), 이름(emp_name)을 조회.
select 	emp_id,
		emp_name
from 	emp
where 	emp_name like 'S%';  -- %: 0개 이상의 모든 글자

-- EMP 테이블에서 직원 이름(emp_name)이 S로 시작하지 않는 직원의  ID(emp_id), 이름(emp_name)을 조회
select 	emp_id,
		emp_name
from 	emp
where	emp_name not like 'S%';

-- EMP 테이블에서 직원 이름(emp_name)이 en으로 끝나는 직원의  ID(emp_id), 이름(emp_name)을 조회
select 	emp_id,
		emp_name
from	emp
where 	emp_name like '%en';

-- EMP 테이블에서 직원 이름(emp_name)의 세 번째 문자가 “e”인 모든 사원의 이름을 조회
select	emp_id,
		emp_name
from	emp
where 	emp_name like '__e%'; -- '_': 한 개의 모든 글자

-- EMP 테이블에서 직원의 이름에 '%' 가 들어가는 직원의 ID(emp_id), 직원이름(emp_name) 조회
-- 패턴문자를 조회조건에서 사용해야 하는 경우 escape 구문을 이용해 패턴문자를 검색문자로 표시하는 특수문자를 지정한다.
select 	emp_id,
		emp_name
from emp
where emp_name like '%#%%' escape '#';	-- #%, #_ 한글자 (%, _를 나타내는 한글자)
 -- %나 _ 자체를 검색하는 문자(상수)로 사용할 경우. 특수문자%, 특수문자_. 특수문자는 escape 다음에 지정
 
 /*
XX로 시작하는지: like 'XX%'
XX가 들어갔는지: like '%XX%'
XX로 끝나는지:  like '%XX'
글자수 -> '_'  like'_AB__BB___가'
*/
 
 -- EMP 테이블에서 부서명(dept_name)이 null인 직원의 ID(emp_id), 이름(emp_name), 부서명(dept_name)을 조회.
select	emp_id,
		emp_name,
		dept_name
from 	emp
where	dept_name is null;

-- 부서명(dept_name) 이 NULL이 아닌 직원의 ID(emp_id), 이름(emp_name), 부서명(dept_name) 조회
select	emp_id,
		emp_name,
		dept_name
from 	emp
where	dept_name is not null;

-- TODO: EMP 테이블에서 업무(job)가 'IT_PROG'인 직원들의 모든 컬럼의 데이터를 조회. 
select 	*
from 	emp
where	job = 'IT_PROG';

-- TODO: EMP 테이블에서 업무(job)가 'IT_PROG'가 아닌 직원들의 모든 컬럼의 데이터를 조회. 
select	*
from 	emp
where	job <> 'IT_PROG';

-- TODO: EMP 테이블에서 이름(emp_name)이 'Peter'인 직원들의 모든 컬럼의 데이터를 조회
select 	*
from 	emp
where	emp_name = 'Peter';

-- TODO: EMP 테이블에서 급여(salary)가 $10,000 이상인 직원의 ID(emp_id), 이름(emp_name)과 급여(salary)를 조회
select 	emp_id, emp_name, salary
from 	emp
where	salary > 10000;

-- TODO: EMP 테이블에서 급여(salary)가 $3,000 미만인 직원의 ID(emp_id), 이름(emp_name)과 급여(salary)를 조회
select	emp_id, emp_name, salary
from	emp
where 	salary < 3000;

-- TODO: EMP 테이블에서 급여(salary)가 $3,000 이하인 직원의 ID(emp_id), 이름(emp_name)과 급여(salary)를 조회
select	emp_id, emp_name, salary
from	emp
where	salary <= 3000;

-- TODO: 급여(salary)가 $4,000에서 $8,000 사이에 포함된 직원들의 ID(emp_id), 이름(emp_name)과 급여(salary)를 조회
select	emp_id, emp_name, salary
from 	emp
where	salary between 4000 and 8000;

-- TODO: 급여(salary)가 $4,000에서 $8,000 사이에 포함되지 않는 모든 직원들의  ID(emp_id), 이름(emp_name), 급여(salary)를 표시
select 	emp_id, emp_name, salary
from 	emp
where	salary not between 4000 and 8000;

-- TODO: EMP 테이블에서 2007년 이후 입사한 직원들의  ID(emp_id), 이름(emp_name), 입사일(hire_date)을 조회.
-- 참고: date/datatime에서 년도만 추출: year(값). ex) year('2020-10-10') => 2020
select 	emp_id, emp_name, hire_date
from	emp
where	year(hire_date) >= 2007;

-- TODO: EMP 테이블에서 2004년에 입사한 직원들의 ID(emp_id), 이름(emp_name), 입사일(hire_date)을 조회.
select 	emp_id, emp_name, hire_date
from	emp
where	year(hire_date) = 2004;

-- TODO: EMP 테이블에서 2005년 ~ 2007년 사이에 입사(hire_date)한 직원들의 ID(emp_id), 이름(emp_name), 업무(job), 입사일(hire_date)을 조회.
select 	emp_id, emp_name, job, hire_date
from 	emp
where	year(hire_date) between 2005 and 2007;

-- TODO: EMP 테이블에서 직원의 ID(emp_id)가 110, 120, 130 인 직원의  ID(emp_id), 이름(emp_name), 업무(job)을 조회
select	emp_id, emp_name, job
from	emp
where	emp_id = 110
or		emp_id = 120
or  	emp_id = 130;

-- TODO: EMP 테이블에서 부서(dept_name)가 'IT', 'Finance', 'Marketing' 인 직원들의 ID(emp_id), 이름(emp_name), 부서명(dept_name)을 조회.
select emp_id, emp_name, dept_name
from emp
where dept_name in ('IT', 'Finance', 'Marketing');

-- TODO: EMP 테이블에서 'Sales' 와 'IT', 'Shipping' 부서(dept_name)가 아닌 직원들의 ID(emp_id), 이름(emp_name), 부서명(dept_name)을 조회.
select emp_id, emp_name, dept_name
from emp
where dept_name not in ('IT', 'Shipping');

-- TODO EMP 테이블에서 업무(job)에 'SA'가 들어간 직원의 ID(emp_id), 이름(emp_name), 업무(job)를 조회
select 	emp_id, emp_name, job
from 	emp
where	job like '%SA%';

-- TODO: EMP 테이블에서 업무(job)가 'MAN'로 끝나는 직원의 ID(emp_id), 이름(emp_name), 업무(job)를 조회
select 	emp_id, emp_name, job
from 	emp
where	job like '%MAN';

-- TODO. EMP 테이블에서 커미션이 없는(comm_pct가 null인)  모든 직원의 ID(emp_id), 이름(emp_name), 급여(salary) 및 커미션비율(comm_pct)을 조회
select 	emp_id, emp_name, salary, comm_pct
from 	emp
where	comm_pct is NULL;

-- TODO: EMP 테이블에서 커미션을 받는 모든 직원의 ID(emp_id), 이름(emp_name), 급여(salary) 및 커미션비율(comm_pct)을 조회
select 	emp_id, emp_name, salary, comm_pct
from 	emp
where 	comm_pct IS NOT NULL;

-- TODO: EMP 테이블에서 관리자 ID(mgr_id)가 없는(상사가 없는) 직원의 ID(emp_id), 이름(emp_name), 업무(job), 소속부서(dept_name)를 조회
select 	emp_id, emp_name, job, dept_name
from 	emp
where	mgr_id IS NULL;

-- TODO : EMP 테이블에서 연봉(salary * 12) 이 200,000 이상인 직원들의 모든 정보를 조회.
select 	*
from	emp
where	(salary * 12) >= 200000;


/* *************************************
 WHERE 조건이 여러개인 경우
 AND OR
 
 참 and 참 -> 참: 조회 결과 행
 거짓 or 거짓 -> 거짓: 조회 결과 행이 아님.
 
 연산 우선순위 : and > or
 
 where 조건1 and 조건2 or 조건3
 1. 조건 1 and 조건2
 2. 1결과 or 조건3
 
 or를 먼저 하려면 where 조건1 and (조건2 or 조건3)
 **************************************/
  
--  EMP 테이블에서 업무(job)가 'SA_REP' 이고 급여(salary)가 $9,000인 직원의 직원의 ID(emp_id), 이름(emp_name), 업무(job), 급여(salary)를 조회.
select	emp_id,
		emp_name,
        job,
        salary
from	emp
where	job = 'SA_REP'
and		salary = 9000;

--  EMP 테이블에서 업무(job)가 'FI_ACCOUNT' 거나 급여(salary)가 $8,000 이상인 직원의 ID(emp_id), 이름(emp_name), 업무(job), 급여(salary)를 조회.
select 	emp_id,
		emp_name,
        job,
        salary
from	emp
where	job = 'FI_ACCOUNT'
or		salary >= 8000;

-- TODO: EMP 테이블에서 부서(dept_name)가 'Sales'이고 업무(job)가 'SA_MAN'이고 급여가 $13,000 이하인 
-- 직원의 ID(emp_id), 이름(emp_name), 업무(job), 급여(salary), 부서(dept_name)를 조회
select 	emp_id, emp_name, job, salary, dept_name
from	emp
where	dept_name = 'Sales'
and		job = 'SA_MAN'
and		salary <= 13000;

-- TODO: EMP 테이블에서 업무(job)에 'MAN'이 들어가는 직원들 중에서 부서(dept_name)가 'Shipping' 이고 2005년이후 입사한 
-- 직원들의  ID(emp_id), 이름(emp_name), 업무(job), 입사일(hire_date),부서(dept_name)를 조회
select  emp_id, emp_name, job, hire_date, dept_name
from	emp
where	job like '%MAN%'
and		dept_name = 'Shipping'
and 	year(hire_date) >= 2005;

-- TODO: EMP 테이블에서 입사년도가 2004년인 직원들과 (입사년도와 상관없이) 급여가 $20,000 이상인 
--  직원들의 ID(emp_id), 이름(emp_name), 입사일(hire_date), 급여(salary)를 조회.
select 	emp_id, emp_name, hire_date, salary
from 	emp
where 	year(hire_date) = 2004
or		salary >= 20000;

-- TODO : EMP 테이블에서, 부서이름(dept_name)이  'Executive'나 'Shipping' 이면서 급여(salary)가 6000 이상인 사원의 모든 정보 조회. 
select 	*
from 	emp
where 	dept_name IN ('Excutive', 'Shipping')
and 	salary >= 6000;

-- TODO: EMP 테이블에서 업무(job)에 'MAN'이 들어가는 직원들 중에서 부서이름(dept_name)이 'Marketing' 이거나 'Sales'인 
-- 직원의 ID(emp_id), 이름(emp_name), 업무(job), 부서(dept_name)를 조회
select 	emp_id, emp_name, job, dept_name
from	emp
where	job like '%MAN%'
and		dept_name IN ('Marketing', 'Sales');


-- TODO: EMP 테이블에서 업무(job)에 'MAN'이 들어가는 직원들 중 급여(salary)가 $10,000 이하이 거나 2008년 이후 입사한 
--  직원의 ID(emp_id), 이름(emp_name), 업무(job), 입사일(hire_date), 급여(salary)를 조회
select 	emp_id, emp_name, job, hire_date, salary
from	emp
where	job like '%MAN%'
and		((salary <= 10000) or (year(hire_date) >= 2008));

/* *******************************************************************
order by를 이용한 정렬
- order by절은 select문의 마지막에 온다.
- order by 정렬기준컬럼 정렬방식 [, ...]
    - 정렬기준컬럼 지정 단위: 컬럼이름, 컬럼의순번(select절의 선언 순서)
     select salary, hire_date from emp ...
	 에서 salary 컬럼 기준 정렬을 설정할 경우. 
     order by salary 또는 1
    - 정렬방식
        - ASC : 오름차순, 기본방식(생략가능)
        - DESC : 내림차순
		
문자열 오름차순 : 숫자 -> 대문자 -> 소문자 -> 한글     
Date 오름차순 : 과거 -> 미래
null 오름차순 : null이 먼저 나온다.

ex)
order by salary asc, emp_id desc
- salary로 전체 정렬을 하고 salary가 같은 행은 emp_id로 정렬.
******************************************************************* */

--  직원들의 전체 정보를 직원 ID(emp_id)가 큰 순서대로 정렬해 조회
select * from emp
order by emp_id desc;

--  직원들의 id(emp_id), 이름(emp_name), 업무(job), 급여(salary)를 
--  업무(job) 순서대로 (A -> Z) 조회하고 업무(job)가 같은 직원들은 급여(salary)가 높은 순서대로 2차 정렬해서 조회.
select	emp_id,
		emp_name,
        job,
        salary
from	emp
order by job asc, salary desc;  
-- order by 3 asc, 4 desc;	-- select 절의 컬럼 순번으로 지정

-- 부서명을 부서명(dept_name)의 오름차순으로 정렬해 조회하시오.
select 	dept_name
from 	emp
order by dept_name;	-- desc
-- null은 가장 작은값(정렬에서)
select 	dept_name as '부서명'
from	emp
order by '부서명';

-- TODO: 급여(salary)가 $5,000을 넘는 직원의 ID(emp_id), 이름(emp_name), 급여(salary)를 급여가 높은 순서부터 조회
select 	emp_id, emp_name, salary
from	emp
where	salary > 5000
order by salary desc;

-- TODO: EMP 테이블에서 직원의 ID(emp_id), 이름(emp_name), 업무(job), 입사일(hire_date)을 입사일(hire_date) 순서로 조회.
select 	emp_id, emp_name, job, hire_date
from 	emp
order by 4 asc;

-- TODO: EMP 테이블에서 ID(emp_id), 이름(emp_name), 급여(salary), 입사일(hire_date)을 
-- 급여(salary) 오름차순으로 정렬하고 급여(salary)가 같은 경우는 먼저 입사한(hire_date) 순서로 정렬.
select 	emp_name, salary, hire_date
from	emp
order by salary asc, hire_date asc;