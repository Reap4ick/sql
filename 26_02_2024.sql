create table Discs (
    DiscId int identity primary key,
    DiscName varchar(255),
    ArtistName varchar(255),
    ReleaseDate date,
    Genre varchar(255),
    Publisher varchar(255)
);
go

create table Styles (
    StyleId int identity primary key,
    StyleName varchar(255)
);
go

create table Artists (
    ArtistId int identity primary key,
    ArtistName varchar(255)
);
go

create table Publishers (
    PublisherId int identity primary key,
    PublisherName varchar(255),
    Country varchar(255)
);
go

create table Songs (
    SongId int identity primary key,
    SongName varchar(255),
    DiscName varchar(255),
    Duration int,
    SongGenre varchar(255),
    ArtistName varchar(255)
);
go




insert into Discs (DiscName, ArtistName, ReleaseDate, Genre, Publisher)
values
('Album1', 'Artist1', '2022-01-01', 'Rock', 'Publisher1'),
('Album1', 'Artist2', '2022-10-01', 'Jazz', 'Publisher2'),
('Album1.1', 'Artist1', '2022-07-01', 'Rock', 'Publisher1.1'),
('Album2', 'Artist2', '2022-02-01', 'Pop', 'Publisher2'),
('Album3', 'Artist3', '2022-03-01', 'Hip Hop', 'Publisher3'),
('Album4', 'Artist4', '2022-04-01', 'Electronic', 'Publisher4'),
('Album5', 'Artist5', '2022-05-01', 'Jazz', 'Publisher5'),
('Album6', 'Artist6', '2010-06-01', 'Blues', 'Publisher6'),
('Album7', 'Artist7', '2022-07-01', 'Country', 'Publisher7'),
('Album8', 'Artist8', '2022-08-01', 'R&B', 'Publisher8'),
('Album9', 'Artist9', '2022-09-01', 'Reggae', 'Publisher9'),
('Album10', 'Artist10', '2022-10-01', 'Classical', 'Publisher10');
go

select* from Discs
DELETE FROM Discs;


insert into Styles (StyleName)
values
('Rock'),
('Pop'),
('Hip Hop'),
('Electronic'),
('Jazz'),
('Blues'),
('Country'),
('R&B'),
('Reggae'),
('Classical');
go

insert into Artists (ArtistName)
values
('Artist1'),
('Artist2'),
('Artist3'),
('Artist4'),
('Artist5'),
('Artist6'),
('Artist7'),
('Artist8'),
('Artist9'),
('Artist10');
go

insert into Publishers (PublisherName, Country)
values
('Publisher1', 'Country1'),
('Publisher2', 'Country2'),
('Publisher3', 'Country3'),
('Publisher4', 'Country4'),
('Publisher5', 'Country5'),
('Publisher6', 'Country6'),
('Publisher7', 'Country7'),
('Publisher8', 'Country8'),
('Publisher9', 'Country9'),
('Publisher10', 'Country10');
go

insert into Songs (SongName, DiscName, Duration, SongGenre, ArtistName)
values
('Song1', 'Album1', 240, 'Metal', 'Artist1'),
('Song2', 'Album1', 180, 'Rock', 'Artist1'),
('Song3', 'Album2', 200, 'Pop', 'Artist2'),
('Song4', 'Album3', 300, 'Hip Hop', 'Artist3'),
('Song5', 'Album4', 250, 'Electronic', 'Artist4'),
('Song6', 'Album5', 220, 'Jazz', 'Artist5'),
('Song7', 'Album6', 210, 'Blues', 'Artist6'),
('Song8', 'Album7', 190, 'Country', 'Artist7'),
('Song9', 'Album8', 270, 'R&B', 'Artist8'),
('Song10', 'Album9', 320, 'Reggae', 'Artist9');
go







create view AllArtists as
select distinct ArtistName from Artists;
go

create view AllSongsInfo as
select SongName, DiscName, Duration, SongGenre, ArtistName from Songs;
go

create view ArtistDiscsInfo as
select * from Discs where ArtistName = 'Artist5';
go

create view MostPopularArtist as
select top 1 ArtistName
from Discs
group by ArtistName
order by count(DiscId) desc;
go

create view Top3PopularArtists as
select top 3 ArtistName, count(DiscId) as DiscCount
from Discs
group by ArtistName
order by DiscCount desc;
go

create view LongestAlbum as
select top 1 DiscName, sum(Duration) as TotalDuration
from Songs
group by DiscName
order by TotalDuration desc;
go

create or alter function GetDiscsByYear(@year int)
returns table
as
return
    select * from Discs
    where year(ReleaseDate) = @year;
GO


create or alter function CountDiscsByStyles()
returns int
as
begin
    declare @count int;
    select @count = count(*) 
    from Discs d
    join Styles s on d.Genre = s.StyleName
    where s.StyleName in ('Rock','Hip Hop');
    return @count;
end;
GO

select dbo.CountDiscsByStyles();
go

create or alter function GetSongsByKeyword(@keyword nvarchar(255))
returns table
as
return
    select * from Songs
    where SongName like '%' + @keyword + '%';
GO

select * from dbo.GetSongsByKeyword('Song1');
go

create or alter function GetAverageSongDurationByArtist(@artistName nvarchar(255))
returns table
as
return
    select @artistName as ArtistName, avg(Duration) as AverageDuration
    from Songs
    where ArtistName = @artistName
    group by ArtistName;
GO

select * from dbo.GetAverageSongDurationByArtist('Artist1');
go

create or alter function GetMinMaxAlbumDuration()
returns table
as
return
    select DiscName, 
           min(TotalDuration) as MinDuration, 
           max(TotalDuration) as MaxDuration
    from (
        select DiscName, sum(Duration) as TotalDuration
        from Songs
        group by DiscName
    ) AlbumDurations
    group by DiscName;
GO

select * from dbo.GetMinMaxAlbumDuration();
go

--з 6 та 7 щось старавсь зробити але взагалі в них не впевнений

create or alter function GetArtistsInMultipleStyles()
returns table
as
return
    select ArtistName, count(distinct Genre) as StyleCount
    from Discs
    group by ArtistName
    having count(distinct Genre) >= 2;
GO

select * from dbo.GetArtistsInMultipleStyles();
go

create or alter function GetDuplicateAlbumNames()
returns table
as
return
    select DiscName, ArtistName
    from Discs
    group by DiscName, ArtistName
    having count(distinct ArtistName) > 1;
GO

select * from dbo.GetArtistsInMultipleStyles();
go


