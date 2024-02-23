create table Departments (
  Id int identity primary key,
  Financing money check (Financing >= 0) default 0,
  Name nvarchar(100) not null unique,
  FacultyId int not null references Faculties(Id)
);

create table Faculties (
  Id int identity primary key,
  Name nvarchar(100) not null unique
);

create table Groups (
  Id int identity primary key,
  Name nvarchar(10) not null unique,
  Year int not null check (Year between 1 and 5),
  DepartmentId int not null references Departments(Id)
);

create table GroupsLectures (
  Id int identity primary key,
  GroupId int not null references Groups(Id),
  LectureId int not null references Lectures(Id)
);

create table Lectures (
  Id int identity primary key,
  DayOfWeek int not null check (DayOfWeek between 1 and 7),
  LectureRoom nvarchar(max) not null,
  SubjectId int not null references Subjects(Id),
  TeacherId int not null references Teachers(Id)
);

create table Subjects (
  Id int identity primary key,
  Name nvarchar(max) not null
);

create table Teachers (
  Id int identity primary key,
  Name nvarchar(max) not null,
  Salary money not null check (Salary > 0),
  Surname nvarchar(max) not null
);

insert into Faculties (Name) values 
  ('Computer Science'),
  ('Mathematics'),
  ('Physics'),
  ('Engineering'),
  ('Biology');

insert into Departments (Financing, Name, FacultyId) values 
  (150000, 'Software Development', 1),
  (120000, 'Algebra and Geometry', 2),
  (100000, 'Quantum Mechanics', 3),
  (130000, 'Electrical Engineering', 4),
  (110000, 'Genetics', 5);

insert into Groups (Name, Year, DepartmentId) values 
  ('CS101', 1, 1),
  ('Math201', 2, 2),
  ('Physics301', 3, 3),
  ('EE401', 4, 4),
  ('Bio501', 5, 5);

insert into Subjects (Name) values 
  ('Introduction to Programming'),
  ('Abstract Algebra'),
  ('Quantum Physics'),
  ('Circuit Analysis'),
  ('Genetics and Evolution');

insert into Teachers (Name, Salary, Surname) values 
  ('John Doe', 60000, 'Doe'),
  ('Alice Johnson', 70000, 'Johnson'),
  ('Bob Smith', 80000, 'Smith'),
  ('Eva White', 75000, 'White'),
  ('Michael Brown', 90000, 'Brown');

insert into Lectures (DayOfWeek, LectureRoom, SubjectId, TeacherId) values 
  (1, 'D201', 1, 1),
  (2, 'C302', 2, 2),
  (3, 'A101', 3, 3),
  (4, 'B202', 4, 4),
  (5, 'E501', 5, 5);



select count(*) as TeachersCount
from Teachers t
join Departments d on t.DepartmentId = d.Id
where d.Name = 'Software Development';

select count(*) as LecturesCount
from Lectures l
join Teachers t on l.TeacherId = t.Id
where t.Name = 'Dave' and t.Surname = 'McQueen';

select count(*) as ClassesCount
from Lectures
where LectureRoom = 'D201';

select LectureRoom, count(*) as LecturesCount
from Lectures
group by LectureRoom;

select count(distinct g.Id) as StudentsCount
from Groups g
join GroupsLectures gl on g.Id = gl.GroupId
join Lectures l on gl.LectureId = l.Id
join Teachers t on l.TeacherId = t.Id
where t.Name = 'Jack' and t.Surname = 'Underhill';

select avg(Salary) as AverageSalary
from Teachers t
join Departments d on t.DepartmentId = d.Id
join Faculties f on d.FacultyId = f.Id
where f.Name = 'Computer Science';

select min(StudentsCount) as MinStudents, max(StudentsCount) as MaxStudents
from (
  select g.Id, count(*) as StudentsCount
  from Groups g
  join GroupsLectures gl on g.Id = gl.GroupId
  group by g.Id
) as StudentCounts;

select avg(Financing) as AverageFinancing
from Departments;

select t.Name + ' ' + t.Surname as FullName, count(distinct l.SubjectId) as SubjectsCount
from Teachers t
join Lectures l on t.Id = l.TeacherId
group by t.Name, t.Surname;

select DayOfWeek, count(*) as LecturesCount
from Lectures
group by DayOfWeek;

select LectureRoom, count(distinct d.Id) as DepartmentsCount
from Lectures l
join Departments d on l.TeacherId = d.Id
group by LectureRoom;

select f.Name as FacultyName, count(distinct l.SubjectId) as SubjectsCount
from Lectures l
join Departments d on l.TeacherId = d.Id
join Faculties f on d.FacultyId = f.Id
group by f.Name;

select t.Name + ' ' + t.Surname as TeacherFullName, l.LectureRoom, count(*) as LecturesCount
from Lectures l
join Teachers t on l.TeacherId = t.Id
group by t.Name, t.Surname, l.LectureRoom;
