def plus(n1, n2):
    # 사칙연산 모듈
    return n1 + n2

def minus(n1, n2):
    return n1 - n2

def multiply(n1, n2):
    return n1 * n2

def divide(n1, n2):
    return n1 / n2

if __name__ == '__main__':
    # 아래코드는 main모듈로 실행될 때만 실행
    print('모듈이름')
    print(__name__)  # 파이썬 실행환경이 제공하는 모듈의 이름을 저장하는 변수

    r1 = plus(10, 20)
    r2 = minus(100, 20)
    r3 = multiply(5, 7)
    r4 = divide(10, 2)

    print(r1, r2, r3, r4)
