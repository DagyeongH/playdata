/* ****************************************************
집합 연산자 (결합 쿼리)
- 둘 이상의 select 결과를 합치는 연산
- 구문
 select문  집합연산자 select문 [집합연산자 select문 ...] [order by 정렬컬럼 정렬방식]

-연산자
  - UNION: 두 select 결과를 하나로 결합한다. 단 중복되는 행은 제거한다. 
  - UNION ALL : 두 select 결과를 하나로 결합한다. 중복되는 행을 포함한다. 
   
 - 규칙
  - 연산대상 select 문의 컬럼 수가 같아야 한다. 
  - 연산대상 select 문의 컬럼의 타입이 같아야 한다.   -> 항목이 같을 필요는 없다
  - 연산 결과의 컬럼이름은 첫번째 select문의 것을 따른다.
  - order by 절은 구문의 마지막에 넣을 수 있다.
*******************************************************/

-- emp 테이블의 salary 최대값와 salary 최소값, salary 평균값 조회
select max(salary), min(salary), avg(salary) from emp; -- 이거를 한 행씩 보고싶다면

select '최댓값' as "label 1", max(salary) as "집계 결과" from emp
union
select '최솟값', min(salary) from emp
union
select '평균', round(avg(salary), 2) from emp;


-- full outer join 정의
-- from A full outer join B on 조건  -> mysql은 지원을 하지 않음 => 따라서 left join과 right join 한것을 union을 사용해서 결합한다
select * from emp e left join dept d on e.dept_id = d.dept_id
union
select * from emp e right join dept d on e.dept_id = d.dept_id;

-- 만약 union 과 union all 이 상관이 없다면 union all사용하는것이 좋다 (겹치는 것을 빼야하는 경우가 아니라면) -> 결과를 보여주는 속도가 더 빠름
-- order by를 사용하고 싶다면 union 사용 후에 마지막에 추가

-- with rollup
select dept_id, sum(salary) as "급여 합계"
from emp
group by dept_id 
union all
select '총집계', sum(salary) from emp;  -- with rollup을 이러한 방식으로도 사용 가능


