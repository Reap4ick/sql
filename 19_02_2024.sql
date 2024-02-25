
use Academy_3

create table Curators (
    Id int identity primary key,
    Name nvarchar(max) not null,
    Surname nvarchar(max) not null
);

create table Departments (
    Id int identity primary key,
    Financing money not null check (Financing >= 0),
    Name nvarchar(100) not null unique,
    FacultyId int not null references Faculties(Id)
);

create table Faculties (
    Id int identity primary key,
    Financing money not null check (Financing >= 0),
    Name nvarchar(100) not null unique
);

create table Groups (
    Id int identity primary key,
    Name nvarchar(10) not null unique,
    Year int not null check (Year between 1 and 5),
    DepartmentId int not null references Departments(Id)
);

create table GroupsCurators (
    Id int identity primary key,
    CuratorId int not null references Curators(Id),
    GroupId int not null references Groups(Id)
);

create table GroupsLectures (
    Id int identity primary key,
    GroupId int not null references Groups(Id),
    LectureId int not null references Lectures(Id)
);


create table Lectures (
    Id int identity primary key,
    LectureRoom nvarchar(max) not null,
    DayOfWeek int not null,  -- Додано цю лінійку
    SubjectId int not null references Subjects(Id),
    TeacherId int not null references Teachers(Id),
    DepartmentId int not null references Departments(Id)
);



create table Subjects (
    Id int identity primary key,
    Name nvarchar(100) not null unique
);

create table Teachers (
    Id int identity primary key,
    Name nvarchar(max) not null,
    Salary money not null check (Salary >= 0),
    Surname nvarchar(max) not null
);


-- Додавання вхідних даних для Teachers
INSERT INTO Teachers (Name, Salary, Surname) VALUES
    ('John', 50000, 'Doe'),
    ('Jane', 60000, 'Smith'),
    ('Bob', 55000, 'Johnson'),---
    ('Alice', 70000, 'Williams'),
    ('Charlie', 65000, 'Davis'),
    ('Teacher1', 50000, 'Surname1'),  -- Додали для групи B103
    ('Teacher2', 60000, 'Surname2');  -- Додали для групи P107

-- Додавання вхідних даних для Subjects
INSERT INTO Subjects (Name) VALUES
    ('Mathematics'),
    ('Computer Science'),
    ('Electrical Engineering'),---
    ('Mechanical Engineering'),
    ('Physics');

-- Додавання вхідних даних для Groups
INSERT INTO Groups (Name, Year, DepartmentId) VALUES
    ('SE101', 1, 1),
    ('CS202', 2, 2),
    ('IT303', 1, 3),
    ('EE404', 3, 4),
    ('ME505', 4, 4),
    ('B103', 2, 1),
    ('P107', 2, 2);

-- Додавання вхідних даних для Lectures
INSERT INTO Lectures (DayOfWeek, LectureRoom, SubjectId, TeacherId, DepartmentId) VALUES
    (1, 'B103', 1, 1, 1),
    (2, 'C201', 2, 2, 2),
    (3, 'D201', 3, 3, 3),
    (4, 'A101', 4, 4, 4),
    (5, 'E301', 5, 5, 1),
    (1, 'F105', 1, 6, 1),
    (2, 'G202', 2, 7, 2);

-- Додавання вхідних даних для Curators
INSERT INTO Curators (Name, Surname) VALUES
    ('John', 'Doe'),
    ('Jane', 'Smith'),
    ('Bob', 'Johnson'),---
    ('Alice', 'Williams'),
    ('Charlie', 'Davis');

-- Додавання вхідних даних для GroupsCurators
INSERT INTO GroupsCurators (CuratorId, GroupId) VALUES
    (1, 5),
    (2, 6),
    (3, 7),
    (4, 8),
    (5, 9),
    (1, 10),  -- Змінено на існуючий ідентифікатор групи
    (2, 11);  -- Змінено на існуючий ідентифікатор групи


-- Додавання вхідних даних для GroupsLectures
INSERT INTO GroupsLectures (GroupId, LectureId) VALUES
    (5, 5),
    (6, 6),
    (7, 7),
    (8, 8),
    (9, 9),
    (10, 10),
    (11, 11);



    -- Додавання вхідних даних для Faculties
INSERT INTO Faculties (Financing, Name) VALUES
    (500000, 'Engineering'),
    (400000, 'Computer Science');

-- Додавання вхідних даних для Departments
INSERT INTO Departments (Financing, Name, FacultyId) VALUES
    (1000000, 'Software Development', 1),
    (120000, 'Computer Science', 2),
    (90000, 'Electrical Engineering', 1),
    (110000, 'Mechanical Engineering', 1);

-- Додавання вхідних даних для Groups




select* from Curators
select* from Departments
select* from Faculties
select* from Groups
select* from GroupsCurators
select* from GroupsLectures
select* from Lectures
select* from Subjects
select* from Teachers


select* from GroupsLectures
select* from Groups
select* from Lectures
select* from Teachers



select t.Id as TeacherId, t.Name as TeacherName, t.Surname as TeacherSurname, g.Id as GroupId, g.Name as GroupName
from Teachers as t, Groups as g;

select f.Name as FacultyName, d.Financing as DepartmentFinancing, f.Financing as FacultyFinancing
from Departments as d
join Faculties as f on d.FacultyId = f.Id
where d.Financing > f.Financing;


select c.Surname as CuratorSurname, g.Name as GroupName
from Curators as c
join GroupsCurators as gc on c.Id = gc.CuratorId
join Groups as g on gc.GroupId = g.Id;

select distinct t.Name, t.Surname
from Teachers as t
join Lectures as l on t.Id = l.TeacherId
join GroupsLectures as gl on l.Id = gl.LectureId
join Groups as g on gl.GroupId = g.Id
where g.Name = 'P107';

select t.Surname as TeacherSurname, f.Name as FacultyName
from Teachers as t
join Lectures as l on t.Id = l.TeacherId
join Departments as d on l.DepartmentId = d.Id
join Faculties as f on d.FacultyId = f.Id;

select d.Name as DepartmentName, g.Name as GroupName
from Departments as d
join Groups as g on d.Id = g.DepartmentId;

select s.Name as SubjectName
from Teachers as t
join Lectures as l on t.Id = l.TeacherId
join Subjects as s on l.SubjectId = s.Id
where t.Name = 'John' and t.Surname = 'Doe';

select d.Name as DepartmentName
from Departments as d
join Lectures as l on d.Id = l.DepartmentId
join Subjects as s on l.SubjectId = s.Id
where s.Name = 'Physics';

select g.Name as GroupName
from Groups as  g
join Departments as d on g.DepartmentId = d.Id
join Faculties as f on d.FacultyId = f.Id
where f.Name = 'Computer Science';

select g.Name as GroupName, g.Year, f.Name as FacultyName
from Groups as g
join Departments as d on g.DepartmentId = d.Id
join Faculties as f on d.FacultyId = f.Id
where g.Year = 3;


select t.Name + ' ' + t.Surname as TeacherFullName, l.SubjectId, g.Name as GroupName
from Teachers as t
join Lectures as l on t.Id = l.TeacherId
join GroupsLectures as gl on l.Id = gl.LectureId
join Groups as g on gl.GroupId = g.Id
where l.LectureRoom = 'B103';
