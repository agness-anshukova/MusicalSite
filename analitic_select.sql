-- Количество исполнителей в каждом жанре
select g."name", count(gp.performer_id) 
  from genre g 
  left join genre_performer gp on g.genre_id = gp.genre_id 
group by g.genre_id; 

-- Количество треков, вошедших в альбомы 2019–2020 годов
select count(at2.track_id)
  from album a 
  join album_track at2 on a.album_id = at2.album_id 
  where a."year" between 2019 and 2020;
  
 -- Средняя продолжительность треков по каждому альбому
 select a."name", avg(t.duration)
   from album a 
   join album_track at2 on a.album_id = at2.album_id 
   join track t on at2.track_id = t.track_id 
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
   join collection_track ct on c.collection_id = ct.collection_id 
   join album_track at2 on ct.track_id = at2.track_id 
   join album_performer ap on ap.album_id = at2.album_id 
   join performer p on p.performer_id = ap.performer_id 
  where p."name" = 'абвгдеёжзийклмнопр';
  
-- Названия альбомов, в которых присутствуют исполнители более чем одного жанра
select a."name"
  from album a,
       album_performer ap 
 where a.album_id = ap.album_id 
   and ap.performer_id in  ( select gp.performer_id as performer_id 
          					   from genre_performer gp 
        					   group by gp.performer_id
        					   having count(gp.genre_id) > 1 ) ;

        					  
-- Наименования треков, которые не входят в сборники
select t."name" 
  from track t 
  left join collection_track ct on t.track_id = ct.track_id 
  where ct.collection_id is null;
 
 -- Исполнитель или исполнители, написавшие самый короткий по продолжительности трек
 select p."name"  
   from album_performer ap,
        album_track at2,
        performer p 
  where ap.album_id = at2.album_id 
    and ap.performer_id = p.performer_id 
    and at2.track_id in (
    						 select t.track_id 
  							  from track t 
  							  where t.duration <= (
  						 						     select min(t.duration) 
  						 							 from track t
  					  							  )
    					);
    
-- Названия альбомов, содержащих наименьшее количество треков
select ( select a."name" from album a where a.album_id = at3.album_id )
  from album_track at3 
  group by at3.album_id 
  having count(at3.track_id) = (
  									select  min(t.cnt)
   									  from (
		 									 select count(at2.track_id) as cnt
   		   									  from album_track at2  
   		   									  group by at2.album_id 
										  ) t
								);

