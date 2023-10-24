# 파이썬 코드를 실행하는 방법

# 1. python script 파일 => 파이썬 실행파일 ==> 확장자 '.py' ==> 일괄처리
## 실행하려는 명령문들(파이썬 구문)을 순서대로 작성하고 한 번에 실행
## 실행: python 스크립트파일.py

# 2. REPL (Read, Evaluate, Print, Loop) ===> 명령문별(단위)로 실행
## python  => 파이썬 SHELL을 실행
## >>> 코드
## 처리결과

#### 프로그램 시작
def plus(n1, n2):
    print('덧셈을 실행')
    return n1 + n2

a = 10
b = 20
c = int(input('정수'))
print(a + b + c)

r1 = plus(a, b)
r2 = plus(b, c)
r3 = plus(a, 100)
print(r1, r2, r3)
#### 프로그램 종료