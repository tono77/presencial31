1. Crear una base de datos llamada call_list
---

Last login: Mon Mar  5 12:59:23 on ttys000
~ % psql
psql (10.1, server 10.3)
Type "help" for help.

edgardo=# create database call_list
edgardo-# ;
CREATE DATABASE
edgardo=# \c call_list
psql (10.1, server 10.3)
You are now connected to database "call_list" as user "edgardo".
call_list=# \d
Did not find any relations.



2. En la base de datos recien creada, crear la tabla users con los campos id (clave primaria), first_name, email.
---
                                                                ^
call_list=# create table users(id integer primary key, first_name varchar(50), email varchar(50));
CREATE TABLE
call_list=# \d
        List of relations
 Schema | Name  | Type  |  Owner  
--------+-------+-------+---------
 public | users | table | edgardo
(1 row)

call_list=# \d users
                        Table "public.users"
   Column   |         Type          | Collation | Nullable | Default 
------------+-----------------------+-----------+----------+---------
 id         | integer               |           | not null | 
 first_name | character varying(50) |           |          | 
 email      | character varying(50) |           |          | 
Indexes:
    "users_pkey" PRIMARY KEY, btree (id)

3. Ingresar un usuario, llamado Carlos (el resto de los datos deben inventarlos).
---
call_list=# insert into users values (1,'Carlos','carlos@gmail.com');
INSERT 0 1

4. Ingresar un usuario, llamada Laura (el resto de los datos deben inventarlos).
---

call_list=# insert into users values (2,'Laura','laura@gmail.com');
INSERT 0 1
call_list=# select * from users;
 id | first_name |      email       
----+------------+------------------
  1 | Carlos     | carlos@gmail.com
  2 | Laura      | laura@gmail.com
(2 rows)

5. Crear una tabla llamada calls con los campos id (clave primaria), phone, date, user_id (foreign key relacionado a users).
---
                                                             ^
call_list=# create table calls(id integer primary key, phone varchar(10), date date, user_id integer references users (id));
CREATE TABLE
call_list=# \d calls
                       Table "public.calls"
 Column  |         Type          | Collation | Nullable | Default 
---------+-----------------------+-----------+----------+---------
 id      | integer               |           | not null | 
 phone   | character varying(10) |           |          | 
 date    | date                  |           |          | 
 user_id | integer               |           |          | 
Indexes:
    "calls_pkey" PRIMARY KEY, btree (id)
Foreign-key constraints:
    "calls_user_id_fkey" FOREIGN KEY (user_id) REFERENCES users(id)

6. Agregar a la tabla users el campo last_name.
---

call_list=# alter table users add column last_name varchar(50);
ALTER TABLE
call_list=# select * from users
call_list-# ;
 id | first_name |      email       | last_name 
----+------------+------------------+-----------
  1 | Carlos     | carlos@gmail.com | 
  2 | Laura      | laura@gmail.com  | 
(2 rows)

7. Ingresar el apellido del usuario Carlos.
---
                                   ^                                   ^
call_list=# update users set last_name = 'Ochoa'  where id = 1
;
UPDATE 1

8. Ingresar el apellido del usuario Laura.
---

call_list=# update users set last_name = 'Villena'  where id = 2
;
UPDATE 1
call_list=# select * from users
call_list-# ;
 id | first_name |      email       | last_name 
----+------------+------------------+-----------
  1 | Carlos     | carlos@gmail.com | Ochoa
  2 | Laura      | laura@gmail.com  | Villena
(2 rows)


9. Ingresar 6 llamadas asociadas al usuario Laura.
---
10. Ingresar 4 llamadas asociadas al usuario Carlos.
---


call_list=# insert into calls values (1,'996457366','20180305',2);
INSERT 0 1
call_list=# insert into calls values (2,'996457366','20180305',2);
INSERT 0 1
call_list=# insert into calls values (3,'996457366','20180305',2);
INSERT 0 1
call_list=# insert into calls values (4,'996457366','20180305',2);
INSERT 0 1
call_list=# insert into calls values (5,'996457366','20180305',2);
INSERT 0 1
call_list=# insert into calls values (6,'996457366','20180305',2);
INSERT 0 1
call_list=# insert into calls values (7,'90993021','20180304',1);
INSERT 0 1
call_list=# insert into calls values (8,'90993021','20180304',1);
INSERT 0 1
call_list=# insert into calls values (9,'90993021','20180304',1);
INSERT 0 1
call_list=# insert into calls values (10,'90993021','20180304',1);
INSERT 0 1
call_list=# select * from calls;
 id |   phone   |    date    | user_id 
----+-----------+------------+---------
  1 | 996457366 | 2018-03-05 |       2
  2 | 996457366 | 2018-03-05 |       2
  3 | 996457366 | 2018-03-05 |       2
  4 | 996457366 | 2018-03-05 |       2
  5 | 996457366 | 2018-03-05 |       2
  6 | 996457366 | 2018-03-05 |       2
  7 | 90993021  | 2018-03-04 |       1
  8 | 90993021  | 2018-03-04 |       1
  9 | 90993021  | 2018-03-04 |       1
 10 | 90993021  | 2018-03-04 |       1
(10 rows)

11.Crear un nuevo usuario.
---

call_list=# \d users
                        Table "public.users"
   Column   |         Type          | Collation | Nullable | Default 
------------+-----------------------+-----------+----------+---------
 id         | integer               |           | not null | 
 first_name | character varying(50) |           |          | 
 email      | character varying(50) |           |          | 
 last_name  | character varying(50) |           |          | 
Indexes:
    "users_pkey" PRIMARY KEY, btree (id)
Referenced by:
    TABLE "calls" CONSTRAINT "calls_user_id_fkey" FOREIGN KEY (user_id) REFERENCES users(id)


call_list=# insert into users values (3,'Pedro', 'pedro@gmail.com', 'Zegers');
INSERT 0 1
call_list=# select * from users;
 id | first_name |      email       | last_name 
----+------------+------------------+-----------
  1 | Carlos     | carlos@gmail.com | Ochoa
  2 | Laura      | laura@gmail.com  | Villena
  3 | Pedro      | pedro@gmail.com  | Zegers
(3 rows)

12. Seleccionar la cantidad de llamados de cada uno de los usuarios (nombre de usuario y cantidad de llamadas).
---

call_list=# select first_name, count(phone) from users left join calls on users.id = calls.user_id group by first_name 
;
 first_name | count 
------------+-------
 Carlos     |     4
 Pedro      |     0
 Laura      |     6
(3 rows)


13. Seleccionar los llamados del usuario llamado Carlos ordenados por fecha en orden descendente.
---

call_list=# select b.* from users a right join calls b on  a.id = b.user_id where a.first_name like 'Carlos%' order by b.date desc;
 id |  phone   |    date    | user_id 
----+----------+------------+---------
  7 | 90993021 | 2018-03-04 |       1
  8 | 90993021 | 2018-03-04 |       1
  9 | 90993021 | 2018-03-04 |       1
 10 | 90993021 | 2018-03-04 |       1
(4 rows)


