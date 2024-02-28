-- Create Tables
create table Departments (
    Id int primary key identity,
    Financing money not null default 0,
    Name nvarchar(100) not null unique,
    FacultyId int not null,
    foreign key (FacultyId) references Faculties(Id)---
);

create table Faculties (
    Id int primary key identity,
    Name nvarchar(100) not null unique ---
);

create table Groups (
    Id int primary key identity,
    Name nvarchar(10) not null unique,
    Year int not null check (Year between 1 and 5),
    DepartmentId int not null,
    foreign key (DepartmentId) references Departments(Id)---
);

create table GroupsLectures (
    Id int primary key identity,
    GroupId int not null,
    LectureId int not null,
    foreign key (GroupId) references Groups(Id),
    foreign key (LectureId) references Lectures(Id)---
);

create table Lectures (
    Id int primary key identity,
    DayOfWeek int not null check (DayOfWeek between 1 and 7),---
    LectureRoom nvarchar(max) not null,
    SubjectId int not null,
    TeacherId int not null,
    foreign key (SubjectId) references Subjects(Id),
    foreign key (TeacherId) references Teachers(Id)
);

create table Subjects (
    Id int primary key identity,
    Name nvarchar(100) not null unique---
);

create table Teachers (
    Id int primary key identity,
    Name nvarchar(max) not null,
    Salary money not null check (Salary > 0),---
    Surname nvarchar(max) not null
);



-- Insert Data
insert into Faculties (Name) values ---
    ('Computer Science'),
    ('Mathematics'),
    ('Physics');

insert into Departments (Financing, Name, FacultyId) values ---
    (100000, 'Software Development', 1),
    (80000, 'Algorithms', 2),
    (75000, 'Quantum Mechanics', 3);

insert into Groups (Name, Year, DepartmentId) values ---
    ('CS101', 1, 1),
    ('CS201', 2, 1),
    ('Math101', 1, 2),
    ('Phys201', 2, 3);

insert into Subjects (Name) values 
    ('Introduction to Programming'),---
    ('Linear Algebra'),
    ('Quantum Physics');

insert into Teachers (Name, Salary, Surname) values 
    ('John', 50000, 'Doe'),
    ('Alice', 60000, 'Smith'),
    ('Bob', 55000, 'Johnson');

insert into Lectures (DayOfWeek, LectureRoom, SubjectId, TeacherId) values 
    (1, 'D201', 1, 1),
    (2, 'B301', 2, 2),
    (3, 'C102', 3, 3);

insert into GroupsLectures (GroupId, LectureId) values 
    (1, 2),
    (2, 3),
    (3, 4);

select* from Teachers
select* from Subjects
select* from Lectures
select* from GroupsLectures
select* from Groups
select* from Faculties
select* from Departments



-- 1
select count(*) as teacherCount
from teachers t
join lectures l on t.id = l.teacherId
join subjects s on l.subjectId = s.id
join departments d on s.id = d.id
where d.name = 'Software Development';

-- 2
select count(*) as lectureCount
from lectures l
join teachers t on l.teacherId = t.id
where t.name = 'Dave' and t.surname = 'McQueen';
--3
select count(*) as lectureCount
from lectures
where lectureRoom = 'D201';

-- 4
select lectureRoom, count(*) as lectureCount
from lectures
group by lectureRoom;

-- 5
select count(*) as studentCount
from groupsLectures gl
join groups g on gl.groupId = g.id
join lectures l on gl.lectureId = l.id
join teachers t on l.teacherId = t.id
where t.name = 'Jack' and t.surname = 'Underhill';

-- 6
select avg(salary) as averageSalary
from teachers t
join lectures l on t.id = l.teacherId
join subjects s on l.subjectId = s.id
join departments d on s.id = d.id
join faculties f on d.facultyId = f.id
where f.name = 'Computer Science';

-- 7
select min(studentCount) as minStudents, max(studentCount) as maxStudents
from (
    select g.id, count(*) as studentCount
    from groups g
    join groupsLectures gl on g.id = gl.groupId
    group by g.id
) as groupStudentCount;

-- 8
select avg(financing) as averageFinancing
from departments;

-- 9
select concat(name, ' ', surname) as fullName, count(distinct subjectId) as subjectCount
from teachers t
join lectures l on t.id = l.teacherId
group by t.id, name, surname;

-- 10
select dayOfWeek, count(*) as lectureCount
from lectures
group by dayOfWeek;

-- 11
select lectureRoom, count(distinct d.id) as departmentCount
from lectures l
join subjects s on l.subjectId = s.id
join departments d on s.id = d.id
group by lectureRoom;

-- 12
select f.name as facultyName, count(distinct s.id) as subjectCount
from subjects s
join departments d on s.id = d.id
join faculties f on d.facultyId = f.id
group by f.id, f.name;

-- 13
select concat(t.name, ' ', t.surname) as teacherName, lectureRoom, count(*) as lectureCount
from lectures l
join teachers t on l.teacherId = t.id
group by t.id, t.name, t.surname, lectureRoom;
