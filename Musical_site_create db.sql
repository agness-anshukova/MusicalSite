create table genre (
	genre_id serial primary key,
	name varchar(40) not null,
	constraint genre_uk unique (name)
);

create table performer (
	performer_id serial primary key,
	name varchar(40) not null,
	constraint performer_uk unique (name)
);

create table genre_performer (
	genre_id integer references genre(genre_id),
	performer_id integer references performer(performer_id),
	constraint genre_performer_pk primary key (genre_id,performer_id)
);

create table track (
	track_id serial primary key,
	name varchar(40) not null,
	duration numeric not null,
	constraint track_uk unique (name)
);

create table album (
	album_id serial primary key,
	name varchar(40) not null,
	year smallint not null,
	constraint album_uk unique (name,year)
);

create table album_track (
	album_id integer references album(album_id),
	track_id integer references track(track_id),
	constraint album_track_pk primary key (album_id,track_id)
);

create table collection (
	collection_id serial primary key,
	name varchar(40) not null,
	year smallint not null,
	constraint collection_uk unique (name,year )
);

create table collection_track (
	collection_id integer references collection(collection_id),
	track_id integer references track(track_id),
	constraint collection_track_pk primary key (collection_id,track_id)
);

create table album_performer (
	album_id integer references album(album_id),
	performer_id integer references performer(performer_id),
	constraint calbum_performer_pk primary key (album_id,performer_id)
);