-- drop database if exists my_service; 
create database if not exists my_service; -- Создал бд
use my_service; -- Выбрал созданную бд
create table if not exists users -- Создал таблицу(сущность) users в выбранной бд my_service
( -- Добавил поля (атрибуты)
id int primary key auto_increment, 
password_hash varchar(30) not null,
email varchar(50),
phone varchar(18) not null,
first_name varchar(50) not null,
last_name varchar(50) null,
registration_date datetime not null default now()
);


create table if not exists factories
(
id int primary key auto_increment,
title varchar(100) not null,
adress varchar(70) not null,
registration_date datetime not null default now()
);


create table if not exists products
(
id int primary key auto_increment,
title varchar(50) not null,
price int unsigned not null,
discount tinyint unsigned not null default 0,
factory_id int,
constraint product_factory_fk 						
foreign key (factory_id) references factories(id)		 
on update cascade								
);


create table if not exists shops
(
id int primary key auto_increment,
title varchar(50) not null,
adress varchar(70) not null,
working_hours varchar(10) not null
);


create table if not exists shops_products
(
shop_id int,
product_id int,
primary key (shop_id, product_id),
constraint shop_product_shop_fk
foreign key (shop_id) references shops(id)
on update cascade on delete cascade,
constraint shop_product_product_fk
foreign key (product_id) references products(id)
on update cascade on delete cascade
);


create table if not exists orders
(
id int primary key auto_increment,
total_without_discount int unsigned not null,
order_datetime datetime not null default now(),
user_id int,
constraint order_users_fk 						-- Добавил ограничение 
foreign key (user_id) references users(id)		-- Внешний ключ user_id таблицы orders ссылается на первичный ключ id таблицы users
on update cascade								-- При обновлении таблицы users, таблица orders тоже изменится
);


create table if not exists orders_products		-- реализовал связь многие ко многим через промежуточную таблицу
(
order_id int,
product_id int,
primary key (order_id, product_id),
foreign key (order_id) references orders(id)
on update cascade on delete cascade,
foreign key (product_id) references products(id)
on update cascade on delete cascade
);

create table if not exists buckets
(
user_id int,
product_id int,
primary key (user_id, product_id),
foreign key (user_id) references users(id)
on update cascade on delete cascade,
foreign key (product_id) references products(id)
on update cascade on delete cascade
);

create table if not exists favourite_products -- Создал таблицу favourite_products 
( -- Добавил поля
user_id int,
product_id int,
primary key (user_id, product_id), -- Cоставной ключ
foreign key (user_id) references users(id)
on update cascade on delete cascade,
foreign key (product_id) references products(id)
on update cascade on delete cascade
);

create table if not exists favourite_shops
(
user_id int,
shop_id int,
primary key(user_id, shop_id),
foreign key (user_id) references users(id)
on update cascade on delete cascade,
foreign key (shop_id) references shops(id)
on update cascade on delete cascade
);


alter table users  -- Добавил поле username в таблицу users
add username varchar(15) not null default 'пользователь' after id;

-- Добавил в таблицу users столбец birthdate
alter table users 
add birthdate date not null after last_name;

-- create index price ON products(price);

-- select * from products order by price;

--  Заполнил поля таблицы users
insert into users (username, email, phone, password_hash, registration_date, first_name, last_name, birthdate)
values ( 'test', 'test@mail.ru','999-999-99-99', 'md5 hash', '2021-01-01', 'Test', 'Test', '2021-01-01'),
	   ( 'test2', 'test2@mail.ru','999-999-99-99', 'md5 hash', '2021-01-02', 'Test2', 'Test2', '2021-01-02'),
       ( 'test3', 'test3@mail.ru','999-999-99-99', 'md5 hash', '2021-01-03', 'Test3', 'Test3', '2021-01-03')
 ;
-- --  Заполнил поля таблицы orders
insert into orders (total_without_discount, order_datetime, user_id) 
values ('1111', '2022-01-01 01:01:01', '1'),
	   ('2222', '2022-02-02 02:02:02', '2'),
       ('3333', '2022-03-03 03:03:03', '2'),
	   ('3333', '2022-03-03 03:03:04', '3')
;

insert into factories(title,adress,registration_date)
values('test0','test_adress','2022-02-02 02:02:02'),
	  ('test01','test_adress1','2023-03-03 03:03:03')
       ;

insert into products(title, price, discount, factory_id)
values('test','100','5', '1'),
	  ('test2','100','5', '1'),
      ('test3','100','5', '1'),
      ('test4','400','33', '1'),
      ('test5','500','43', '2'),
	  ('test6','100','52', '2')
;

-- select now(); -- возвращают текущую локальную дату и время на основе системных часов
-- select round(rand()) as randome_result; -- числовые функции округления результата и генерации случайного числа от 0 до 1
-- select title , ucase('title') as 'BIG TITLE'from products ; -- строковая функция, переводит текст в верхний регистр.
-- select title from products union select title from factories; -- Объединение выборок из полей title таблиц products и factories
-- select * from factories; -- вывести все записи таблицы factories
-- select * from orders;	-- вывести все записи таблицы orders
-- select * from users;		-- вывести все записи таблицы users
-- select * from users limit 2 -- вывести две записи таблицы users 
-- select price - discount as TotalSum from products order by TotalSum; -- цена-скидка, выводится, как TotalSum и сортируется по TotalSum
-- select title, price from products; -- вывести только price и totle из таблицы products
-- select first_name as 'Имя' from users ; -- вывести столбец first_name, как Имя из таблицы users
-- select * from users where id = 1;   -- выборка из таблицы юзер, где id = 1
-- select title,price, count(*) as ProductCount from products where price < '500' group by title, price order by price; -- группировка по названию и цене, сортировка по цене если цена < 400 