
import pymysql
from datetime import datetime, date
def insert_member(name:str, email:str, tall:float, birthday:datetime.date) -> int:
    '''
    회원정보를 insert하는 함수
    [parameter]
    [return]
        int: insert된 행수
    [exception]
    '''
    sql='insert into member (name, email, tall, birthday, created_at) values (%s, %s, %s, %s, now())'
    with pymysql.connect(host='localhost', port=3306, user='playdata', password='1111', db='testdb') as conn:
        with conn.cursor() as cursor:
            cursor.execute(sql, [name, email, tall, birthday])
            conn.commit()
            return cnt

def update_member(id, name, email, tall, birthday):
    '''
    ID의 회원의 name, email, tall, birthday를 update
    [return]
        int: update된 행수
    '''
    sql = 'update member set name = %s, email = %s, tall = %s, birthday = %s where id = %s'
    with pymysql.connect(host='localhost', port=3306, user='playdata', password='1111', db='testdb') as conn:
        with conn.cursor() as cursor:
            cnt = cursor.execute(sql, [name, email, tall, birthday, id])
            conn.commit()
            return cnt
    
def delete_member_by_id(id):
    '''
    ID의 회원정보를 delete
    [return]
        int: 삭제한 행수
    '''
    sql = 'delete from member where id = %s'
    with pymysql.connect(host='localhost', port=3306, user='playdata', password='1111', db='testdb') as conn:
        with conn.cursor() as cursor:
            cnt = cursor.execute(sql, (id, ))
            conn.commit()
            return cnt
        
def delete_member_by_name(name):
    '''
    ID의 회원정보를 delete
    [return]
        int: 삭제한 행수
    '''
    sql = 'delete from member where name = %s'
    with pymysql.connect(host='localhost', port=3306, user='playdata', password='1111', db='testdb') as conn:
        with conn.cursor() as cursor:
            cnt = cursor.execute(sql, (name, ))
            conn.commit()
            return cnt

def select_member_by_id(id):
    '''
    ID로 회원정보 조회
    [return]
        tuple: 조회한 결과
    '''
    sql = 'select * from member where id = %s'
    with pymysql.connect(host='localhost', port=3306, user='playdata', password='1111', db='testdb') as conn:
        with conn.cursor() as cursor:
            cursor.execute(sql, [id])
            # pk 조회 -> 결과행: 0, 1
            return cursor.fetchone()  # 1행: tuple, 0행 None

def select_member_by_name(name):
    '''
    이름으로 회원정보 조회
    [return]
        tuple: 조회한 결과
    '''
    sql = 'select * from member where name like %s'
    name = f'%{name}%'
    with pymysql.connect(host='localhost', port=3306, user='playdata', password='1111', db='testdb') as conn:
        with conn.cursor() as cursor:
            cursor.execute(sql, [name])
            return cursor.fetchall() 

def select_member_by_birthday(birthday = None):
    '''
    생일로 회원정보 조회
    [parameter]
        birthday: date - 조회할 생일. None: 생일이 null인 행을 조회
    [return]
        tuple: 조회한 결과
    '''
    sql = 'select * from member where birthday {}'
    if birthday is None: # null인 것 조회
        sql = sql.format('is null')
    else:
        sql.format('= %s')
        
    with pymysql.connect(host='localhost', port=3306, user='playdata', password='1111', db='testdb') as conn:
        with conn.cursor() as cursor:
            if birthday is None:
                cursor.execute(sql)  # birthday is null
            else:
                cursor.execute(sql, [birthday])  # birthday = %s
            return cursor.fetchall()

def select_member_by_tall_range(start_tall, end_tall):
    '''
    키의 범위로 회원정보 조회
    [parameter]
        start_tall: float
        end_tall: float
            start_tall <= tall <= end_tall 범위의 회원을 조회
    '''    
    sql = 'select * from member where tall between %s and %s'
    with pymysql.connect(host='localhost', port=3306, user='playdata', password='1111', db='testdb') as conn:
        with conn.cursor() as cursor:
            cursor.execute(sql, [start_tall, end_tall])
            return cursor.fetchall()
        
def select_all_member():
    sql = 'select * from member order by id desc'
    with pymysql.connect(host='localhost', port=3306, user='playdata', password='1111', db='testdb') as conn:
        with conn.cursor() as cursor:
            cursor.execute(sql)
            return cursor.fetchall()
