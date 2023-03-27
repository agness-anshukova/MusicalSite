-- Название и год выхода альбомов, вышедших в 2018 году
select a."name" , a."year" from album a where a."year" = 2018;
-- Название и продолжительность самого длительного трека
select t."name", t.duration from track t where t.duration = (select max(t1.duration) from track t1);
-- Название треков, продолжительность которых не менее 3,5 минут
select t."name", t.duration from track t where t.duration >= 3.5;
-- Названия сборников, вышедших в период с 2018 по 2020 год включительно
select c."name", c."year" from collection c where c."year" between 2018 and 2020;
-- Исполнители, чьё имя состоит из одного слова
select p."name" from performer p where position(' ' in p."name") = 0;
-- Название треков, которые содержат слово «мой» или «my»
select t."name" from track t where position('мой' in t."name") <> 0 or position('my' in t."name") <> 0;