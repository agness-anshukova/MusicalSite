-- Количество исполнителей в каждом жанре
select g."name", count(gp.performer_id) 
  from genre g 
  left join genre_performer gp on g.genre_id = gp.genre_id 
group by g.genre_id; 

-- Количество треков, вошедших в альбомы 2019–2020 годов
select count(at2.track_id)
  from album a 
  join track at2 on a.album_id = at2.album_id 
  where a."year" between 2019 and 2020;
  
 -- Средняя продолжительность треков по каждому альбому
 select a."name", avg(t.duration)
   from album a 
   join track t on a.album_id = t.album_id  
 group by a."name";
 
-- Все исполнители, которые не выпустили альбомы в 2020 году
select p."name" 
  from performer p 
 where p.performer_id not in (
 								 select er.performer_id 
   								   from album_performer er 
   								   join album a on er.album_id = a.album_id 
								  where a."year" = 2020
 						     );
 						    
 -- Названия сборников, в которых присутствует конкретный исполнитель (выберите его сами)
 select c."name"
   from collection c 
   join collection_track ct using(collection_id)
   join track t using(track_id) 
   join album a using(album_id)
  where album_id in (
  						 select ap.album_id 
  						   from performer p 
  						   join album_performer ap on p.performer_id = ap.performer_id 
  						  where p."name" = 'абвгдеёжз абвг абвгдеёжзийкл' 						    
  					  );
  
-- Названия альбомов, в которых присутствуют исполнители более чем одного жанра
-- count 40.05
explain analyse  					 
with cte as  ( select gp.performer_id as performer_id 
          					   from genre_performer gp 
        					   group by gp.performer_id
        					   having count(gp.genre_id) > 1 ) 
select (select a."name" from album a where a.album_id = ap.album_id )
  from album_performer ap 
  join cte on cte.performer_id = ap.performer_id 
group by ap.album_id;

-- count 63.80
explain analyse  
select distinct a."name" 
  from album a 
  join album_performer ap on ap.album_id = a.album_id             -- уникальные значения a.album_id (album) связываем с неуникальными значениями ap.album_id (таблица album_performer). Получаем "временную таблицу" с неуникальными  ap.album_id и неуникальными ap.performer_id   
  join genre_performer gp on gp.performer_id = ap.performer_id    -- неуникальные значения gp.performer_id (genre_performer) связываем с неуникальными значениями ap.performer_id из album_performer ("временная таблица", полученная в результате первого join)
  join performer p on gp.performer_id = p.performer_id 			  -- неуникальные значения gp.performer_id ( "временная таблица", полученная в результате второго join ) связываем с уникальными значениями p.performer_id 	(performer)	
group by a."name", p.performer_id 
having count(gp.genre_id) > 1;
			  
-- Наименования треков, которые не входят в сборники
select t."name" 
  from track t 
  left join collection_track ct on t.track_id = ct.track_id 
  where ct.collection_id is null;
 
 -- Исполнитель или исполнители, написавшие самый короткий по продолжительности трек
 -- Вариант 1 
 explain analyse
 select p."name" 
   from performer p 
   join album_performer ap on p.performer_id = ap.performer_id   -- уникальные значения (p.performer_id) с неуникальными (ap.performer_id). "Временная таблица" с неуникальными (ap.album_id)
   join album a on a.album_id = ap.album_id 					 -- уникальные значения (a.album_id) с неуникальными (ap.album_id). "Временная таблица" с неуникальными (ap.album_id)
   join track t on t.album_id = ap.album_id 					 -- неуникальные значения (t.album_id) с неуникальными (ap.album_id )
   where t.duration = (select min(t2.duration) from track t2 );
 
 -- Вариант 2
 explain analyse 	
 select p."name" 
   from album_performer ap     									 
   join performer p on p.performer_id = ap.performer_id 		 -- уникальные значения performer_id из performer с неуникальными значениям ap.performer_id из album_performer
where ap.album_id in (											 -- уникальные значения t.album_id 	
						select t.album_id                     
  						  from track t 			 
 						 where t.duration = (select min(t2.duration) from track t2) 
 						 group by t.album_id 
					 );
  

  
-- Названия альбомов, содержащих наименьшее количество треков
select a2."name" 
  from album a2 
  join track t on t.album_id = a2.album_id  
  group by a2.album_id
  having count(t.track_id) = (
  								select count(t2.track_id)
  								  from track t2 
  								 group by t2.album_id 
  								 order by 1
  								 limit 1
 							 );