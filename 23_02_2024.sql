create table assistants (
    id int identity primary key,
    teacher_id int not null,
    foreign key (teacher_id) references teachers(id)
);

create table curators (
    id int identity primary key,
    teacher_id int not null,
    foreign key (teacher_id) references teachers(id)
);

create table deans (
    id int identity primary key,
    teacher_id int not null,
    foreign key (teacher_id) references teachers(id)
);

create table departments (
    id int identity primary key,
    building int not null check (building between 1 and 5),
    name nvarchar(100) not null unique,
    faculty_id int not null,
    head_id int not null,
    foreign key (faculty_id) references faculties(id),
    foreign key (head_id) references heads(id)
);

create table faculties (
    id int identity primary key,
    building int not null check (building between 1 and 5),
    name nvarchar(100) not null unique,
    dean_id int not null,
    foreign key (dean_id) references deans(id)
);

create table groups (
    id int identity primary key,
    name nvarchar(10) not null unique,
    year int not null check (year between 1 and 5),
    department_id int not null,
    foreign key (department_id) references departments(id)
);

create table groups_curators (
    id int identity primary key,
    curator_id int not null,
    group_id int not null,
    foreign key (curator_id) references curators(id),
    foreign key (group_id) references groups(id)
);

create table groups_lectures (
    id int identity primary key,
    group_id int not null,
    lecture_id int not null,
    foreign key (group_id) references groups(id),
    foreign key (lecture_id) references lectures(id)
);

create table heads (
    id int identity primary key,
    teacher_id int not null,
    foreign key (teacher_id) references teachers(id)
);

create table lecture_rooms (
    id int identity primary key,
    building int not null check (building between 1 and 5),
    name nvarchar(10) not null unique
);

create table lectures (
    id int identity primary key,
    subject_id int not null,
    teacher_id int not null,
    foreign key (subject_id) references subjects(id),
    foreign key (teacher_id) references teachers(id)
);

create table schedules (
    id int identity primary key,
    class int not null check (class between 1 and 8),
    day_of_week int not null check (day_of_week between 1 and 7),
    week int not null check (week between 1 and 52),
    lecture_id int not null,
    lecture_room_id int not null,
    foreign key (lecture_id) references lectures(id),
    foreign key (lecture_room_id) references lecture_rooms(id)
);

create table subjects (
    id int identity primary key,
    name nvarchar(100) not null unique
);

create table teachers (
    id int identity primary key,
    name nvarchar(max) not null,
    surname nvarchar(max) not null
);




-- Дані для таблиці assistants
insert into assistants (teacher_id) values
    (1),
    (4),
    (7);

-- Дані для таблиці curators
insert into curators (teacher_id) values
    (2),
    (5),
    (8);

-- Дані для таблиці deans
insert into deans (teacher_id) values
    (3),
    (6),
    (9);

-- Дані для таблиці departments
insert into departments (building, name, faculty_id, head_id) values
    (1, 'Computer Science', 6, 6),
    (2, 'Electrical Engineering', 7, 7),
    (3, 'Mechanical Engineering', 8, 8);

-- Дані для таблиці faculties
insert into faculties (building, name, dean_id) values
    (1, 'Computer Science', 1),
    (2, 'Engineering', 2),
    (3, 'Mechanical Sciences', 3);

-- Дані для таблиці groups
insert into groups (name, year, department_id) values
    ('F505', 1, 12),
    ('E202', 2, 13),
    ('M101', 3, 14);

-- Дані для таблиці groups_curators
insert into groups_curators (curator_id, group_id) values
    (1, 7),
    (2, 8),
    (3, 9);

-- Дані для таблиці groups_lectures
insert into groups_lectures (group_id, lecture_id) values
    (7, 1),
    (8, 2),
    (9, 3);

-- Дані для таблиці heads
insert into heads (teacher_id) values
    (10),
    (11),
    (12);

-- Дані для таблиці lecture_rooms
insert into lecture_rooms (building, name) values
    (1, 'A101'), (2, 'B202'), (3, 'C303'),
    (4, 'D404'), (5, 'E505'), (1, 'A104'),
    (2, 'B205'), (3, 'C306'), (4, 'D407'),
    (5, 'E508'), (1, 'A311'), (2, 'B212');

-- Дані для таблиці lectures
insert into lectures (subject_id, teacher_id) values
    (1, 1),
    (2, 4),
    (3, 7);

-- Дані для таблиці schedules
insert into schedules (class, day_of_week, week, lecture_id, lecture_room_id) values
    (1, 1, 2, 1, 1),
    (2, 2, 2, 2, 2),
    (3, 3, 2, 3, 3);

-- Дані для таблиці subjects
insert into subjects (name) values
    ('Database Theory'),
    ('Software Development'),
    ('Computer Networks');

-- Дані для таблиці teachers
insert into teachers (name, surname) values
    ('John', 'Doe'),
    ('Jane', 'Smith'),
    ('Bob', 'Johnson'),
    ('Edward', 'Hopper'),
    ('Alice', 'Williams'),
    ('Alex', 'Carmack'),
    ('Laura', 'Brown'),
    ('Charlie', 'Miller'),
    ('David', 'White');


select * from assistants;
select * from curators;
select * from deans;
select * from departments;
select * from faculties;
select * from groups_curators;
select * from groups_lectures;
select * from heads;
select * from lecture_rooms;
select * from groups;
select * from lectures;
select * from schedules;
select * from subjects;
select * from teachers;




select lr.name
from lecture_rooms lr
join schedules s on lr.id = s.lecture_room_id
join lectures l on s.lecture_id = l.id
join teachers t on l.teacher_id = t.id
where t.surname = 'Hopper' and t.name = 'Edward';



select distinct t.surname--
from assistants a
join teachers t on a.teacher_id = t.id
join lectures l on t.id = l.teacher_id
join schedules s on l.id = s.lecture_id
join groups_lectures gl on s.id = gl.lecture_id
join groups g on gl.group_id = g.id
where g.name = 'F505';

select distinct sub.name--
from teachers t
join lectures l on t.id = l.teacher_id
join subjects sub on l.subject_id = sub.id
join schedules s on l.id = s.lecture_id
join groups_lectures gl on s.id = gl.lecture_id
join groups g on gl.group_id = g.id
where t.surname = 'Carmack' and t.name = 'Alex' and g.year = 5;

select distinct t.surname
from teachers t
left join lectures l on t.id = l.teacher_id
left join schedules s on l.id = s.lecture_id
where s.id is null or s.day_of_week != 1;

select lr.name, lr.building
from lecture_rooms lr
where lr.id not in (
    select lr.id
    from lecture_rooms lr
    join schedules s on lr.id = s.lecture_room_id
    where s.week = 2 and s.day_of_week = 3 and s.class = 3
);

select distinct concat(t.name, ' ', t.surname) as full_name--
from teachers t
join deans d on t.id = d.teacher_id
join faculties f on d.id = f.dean_id
left join departments dep on f.id = dep.faculty_id
left join groups g on dep.id = g.department_id
where f.name = 'Computer Science' and dep.name = 'Software Development' and g.id is null;

select distinct building
from (
    select building from faculties
    union
    select building from departments
    union
    select building from lecture_rooms
) as building_numbers;

select concat(t.name, ' ', t.surname) as full_name
from teachers t
left join deans d on t.id = d.teacher_id
left join heads h on t.id = h.teacher_id
left join curators c on t.id = c.teacher_id
left join assistants a on t.id = a.teacher_id
order by d.id desc, h.id desc, t.id, c.id, a.id;

select distinct s.day_of_week--
from schedules s
join lecture_rooms lr on s.lecture_room_id = lr.id
where lr.name in ('A311', 'A104');