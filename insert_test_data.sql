-- процедура вставляет одну тестовую запись в таблицу album
create or replace procedure insert_test_data_album()
language plpgsql
as $$
declare
    album_name  varchar(40);
   	album_year  smallint;
begin
    select substring('абвгдеёжзийклмнопрстуфхцчшщьыъэюя',1,(random()*13)::integer)||' '||substring('абвгдеёжзийклмнопрстуфхцчшщьыъэюя',1,(random()*7)::integer) 
		   ||' '||substring('абвгдеёжзийклмнопрстуфхцчшщьыъэюя',1,(random()*10)::integer) into album_name;
    select extract ( 'Year' FROM ( now() - interval '1 day' * round(random() * 2000) ) ) into album_year;
	insert into album ("name", "year") values (album_name, album_year);
end;$$
call insert_test_data_album();
select * from album;

-- процедура вставляет одну тестовую запись в таблицу collection
create or replace procedure insert_test_data_collection()
language plpgsql
as $$
declare
    collection_name  varchar(40);
   	collection_year  smallint;
begin
	select substring('абвгдеёжзийклмнопрстуфхцчшщьыъэюя',1,(random()*10)::integer)||' '||substring('абвгдеёжзийклмнопрстуфхцчшщьыъэюя',1,(random()*7)::integer) 
		   ||' '||substring('абвгдеёжзийклмнопрстуфхцчшщьыъэюя',1,(random()*13)::integer) 
      into collection_name;
    select extract ( 'Year' FROM ( now() - interval '1 day' * round(random() * 2000) ) ) into collection_year;
	insert into collection ("name", "year") values (collection_name, collection_year);
end;$$
call insert_test_data_collection();
select * from collection;

-- процедура вставляет одну тестовую запись в таблицу track
create or replace procedure insert_test_data_track()
language plpgsql
as $$
declare
    track_name  varchar(40);
   	duration    integer;
    album_id	integer;
    my_bool     boolean;
begin
	select (random()::integer)::boolean into my_bool;
	if my_bool then
		select  substring('my',1,2)||' '||substring('мой',1,3)||' '||substring('абвгдеёжзийклмнопрстуфхцчшщьыъэюя',1,(random()*24)::integer)
            ||' '||substring('абвгдеёжзийклмнопрстуфхцчшщьыъэюя',1,(random()*7)::integer) into track_name;
    else
    	select  substring('абвгдеёжзийклмнопрстуфхцчшщьыъэюя',1,(random()*32)::integer)
            ||' '||substring('абвгдеёжзийклмнопрстуфхцчшщьыъэюя',1,(random()*7)::integer) into track_name;
    end if;
    select (random()*100 + 180)::integer into duration;
    select a.album_id from album a order by random() limit 1 into album_id;
	insert into track ("name", duration, album_id) values (track_name, duration, album_id);
end;$$
call insert_test_data_track();
select * from track;

-- процедура вставляет одну тестовую запись в таблицу genre
create or replace procedure insert_test_data_genre()
language plpgsql
as $$
declare
    genre_name  varchar(40);
begin
	select substring('абвгдеёжзийклмнопрстуфхцчшщьыъэюя',1,(random()*10)::integer)||' '||substring('абвгдеёжзийклмнопрстуфхцчшщьыъэюя',1,(random()*5)::integer) 
		   ||' '||substring('абвгдеёжзийклмнопрстуфхцчшщьыъэюя',1,(random()*15)::integer) into genre_name;
	insert into genre ("name") values (genre_name);
end;$$
call insert_test_data_genre();
select * from genre;

-- процедура вставляет одну тестовую запись в таблицу performer
create or replace procedure insert_test_data_performer()
language plpgsql
as $$
declare
    performer_name  varchar(40);
begin
	select substring('абвгдеёжзийклмнопрстуфхцчшщьыъэюя',1,(random()*15)::integer)||' '||substring('абвгдеёжзийклмнопрстуфхцчшщьыъэюя',1,(random()*5)::integer) 
		   ||' '||substring('абвгдеёжзийклмнопрстуфхцчшщьыъэюя',1,(random()*14)::integer) into performer_name;
	insert into performer ("name") values (performer_name);
end;$$
call insert_test_data_performer();
select * from performer;

-- процедура вставляет одну тестовую запись в таблицу genre_performer
create or replace procedure insert_test_data_genre_performer()
language plpgsql
as $$
declare
    t_performer_id  int4;
    t_genre_id      int4;
begin
	select performer_id from performer order by random() limit 1 into t_performer_id;
    select genre_id from genre order by random() limit 1 into t_genre_id;
	insert into genre_performer (genre_id, performer_id) values (t_genre_id, t_performer_id);
end;$$
call insert_test_data_genre_performer();
select * from genre_performer;

-- процедура вставляет одну тестовую запись в таблицу collection_track
create or replace procedure insert_test_data_collection_track()
language plpgsql
as $$
declare
    t_collection_id  int4;
    t_track_id      int4;
begin
	select collection_id from collection order by random() limit 1 into t_collection_id;
    select track_id from track order by random() limit 1 into t_track_id;
	insert into collection_track (collection_id, track_id) values (t_collection_id, t_track_id);
end;$$
call insert_test_data_collection_track();
select * from collection_track;

-- процедура вставляет одну тестовую запись в таблицу album_performer
create or replace procedure insert_test_data_album_performer()
language plpgsql
as $$
declare
    t_album_id      int4;
    t_performer_id  int4;
begin
	select album_id from album order by random() limit 1 into t_album_id;
    select performer_id from performer order by random() limit 1 into t_performer_id;
	insert into album_performer (album_id,performer_id) values (t_album_id, t_performer_id);
end;$$
call insert_test_data_album_performer();
select * from album_performer;