
CREATE DATABASE M3_School;
USE M3_School;


# 1 - Level
CREATE TABLE Levels (
  id INT AUTO_INCREMENT PRIMARY KEY
);

# 2 - Schools
CREATE TABLE Schools (
  id            INT PRIMARY KEY AUTO_INCREMENT,
  name          VARCHAR(100),
  vision        TEXT,
  mission       TEXT,
  main_language VARCHAR(20),
  type          VARCHAR(20),
  fees          DOUBLE,
  address       VARCHAR(100),
  email         VARCHAR(50),
  general_info  TEXT
);


CREATE TABLE School_Phone_Numbers (
  telephone_number VARCHAR(20),
  school_id        INT,
  PRIMARY KEY (telephone_number, school_id),
  FOREIGN KEY (school_id) REFERENCES Schools (id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE Elementary_Schools (
  school_id INT PRIMARY KEY,
  supplies  TEXT,
  level_id  INT,
  FOREIGN KEY (level_id) REFERENCES Levels (id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY (school_id) REFERENCES Schools (id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE Middle_Schools (
  school_id INT PRIMARY KEY,
  supplies  TEXT,
  level_id  INT,
  FOREIGN KEY (level_id) REFERENCES Levels (id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY (school_id) REFERENCES Schools (id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE High_Schools (
  school_id INT PRIMARY KEY,
  supplies  TEXT,
  level_id  INT,
  FOREIGN KEY (level_id) REFERENCES Levels (id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY (school_id) REFERENCES Schools (id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);



# 3 - Clubs
CREATE TABLE Clubs (
  name           VARCHAR(15),
  high_school_id INT,
  purpose        TEXT,
  PRIMARY KEY (name, high_school_id),
  FOREIGN KEY (high_school_id) REFERENCES High_Schools (school_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

# 4- Employees
CREATE TABLE Employees (
  username    VARCHAR(50) PRIMARY KEY,
  password    VARCHAR(100),
  first_name  VARCHAR(50),
  middle_name VARCHAR(50),
  last_name   VARCHAR(50),
  birthdate   DATETIME,
  address     VARCHAR(100),
  email       VARCHAR(50),
  salary      DOUBLE,
  gender      VARCHAR(10),
  school_id   INT,
  FOREIGN KEY (school_id) REFERENCES Schools (id)
    ON DELETE SET NULL
    ON UPDATE CASCADE
);

# 5- Teacher
CREATE TABLE Teachers (
  teacher_username   VARCHAR(50) PRIMARY KEY,
  years_of_experience INT,
  FOREIGN KEY (teacher_username) REFERENCES Employees (username)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

# 6- Administrators
CREATE TABLE Administrators (
  employee_username VARCHAR(50) PRIMARY KEY,
  FOREIGN KEY (employee_username) REFERENCES Employees (username)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE Activities (
  id                     INT PRIMARY KEY AUTO_INCREMENT,
  date                   DATETIME,
  administrator_username VARCHAR(50),
  teacher_username       VARCHAR(50),
  location               VARCHAR(50),
  equipment              TEXT,
  type                   VARCHAR(20),
  description            TEXT,
  FOREIGN KEY (administrator_username) REFERENCES Administrators (employee_username)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY (teacher_username) REFERENCES Teachers (teacher_username)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

# 7- Parent
CREATE TABLE Parents (
  username    VARCHAR(50) PRIMARY KEY,
  password    VARCHAR(100),
  first_name  VARCHAR(50),
  last_name   VARCHAR(50),
  email       VARCHAR(50),
  address     VARCHAR(100),
  home_number VARCHAR(20)
);

# 8- Parent Phone Numbers
CREATE TABLE Parent_Phone_Numbers (
  parent_username  VARCHAR(50),
  telephone_number VARCHAR(20),
  PRIMARY KEY (parent_username, telephone_number),
  FOREIGN KEY (parent_username) REFERENCES Parents (username)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

# 9- Children
CREATE TABLE Children (
  ssn        INT PRIMARY KEY,
  first_name       VARCHAR(50),
  last_name       VARCHAR(50),
  birth_date DATETIME,
  age        INT AS (2016 - YEAR(birth_date)),
  gender     VARCHAR(10)

);

# 10 - Students
CREATE TABLE Students (
  child_ssn INT PRIMARY KEY,
  school_id INT,
  username  VARCHAR(50),
  password  VARCHAR(100),
  grade     INT,
  FOREIGN KEY (school_id) REFERENCES Schools (id)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  FOREIGN KEY (child_ssn) REFERENCES Children (ssn)
    ON DELETE CASCADE
    ON UPDATE CASCADE

);

#11 - Questions
CREATE TABLE Questions (
  id               INT PRIMARY KEY AUTO_INCREMENT,
  teacher_username VARCHAR(50),
  title            VARCHAR(50),
  content          VARCHAR(50),
  answer           TEXT,
  FOREIGN KEY (teacher_username) REFERENCES Teachers (teacher_username)
    ON DELETE SET NULL
    ON UPDATE CASCADE

);

CREATE TABLE Courses (
  code             INT PRIMARY KEY,
  name             VARCHAR(20),
  description      TEXT
);

CREATE TABLE Assignments (
  id               INT PRIMARY KEY AUTO_INCREMENT,
  content          TEXT,
  posting_date     DATETIME,
  due_date         DATETIME,
  course_code      INT,
  teacher_username VARCHAR(20),
  FOREIGN KEY (teacher_username) REFERENCES Teachers (teacher_username)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY (course_code) REFERENCES Courses (code)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE Solutions (
  student_ssn      INT,
  assignment_id    INT AUTO_INCREMENT,
  teacher_username VARCHAR(20),
  content          TEXT,
  grade            INT,
  CHECK (grade >= 0),
  PRIMARY KEY (student_ssn, assignment_id, teacher_username),
  FOREIGN KEY (teacher_username) REFERENCES Teachers(teacher_username) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (student_ssn) REFERENCES Students (child_ssn)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY (assignment_id) REFERENCES Assignments (id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE Announcements (
  id                     INT PRIMARY KEY AUTO_INCREMENT,
  date                   DATETIME,
  type                   VARCHAR(20),
  description            TEXT,
  title                  VARCHAR(30),
  administrator_username VARCHAR(50),
  FOREIGN KEY (administrator_username) REFERENCES Administrators (employee_username)
    ON DELETE SET NULL
    ON UPDATE CASCADE
);

CREATE TABLE Clubs_Joined_By_Students (
  student_ssn    INT,
  club_name      VARCHAR(15),
  high_school_id INT,

  PRIMARY KEY (student_ssn, club_name, high_school_id),
  FOREIGN KEY (student_ssn) REFERENCES Students (child_ssn)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY (club_name) REFERENCES Clubs (name)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY (high_school_id) REFERENCES Clubs (high_school_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE Activities_Participated_In_By_Students (
  activity_id INT,
  student_ssn INT,
  PRIMARY KEY (activity_id, student_ssn),
  FOREIGN KEY (activity_id) REFERENCES Activities (id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY (student_ssn) REFERENCES Students (child_ssn)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE Children_Have_Parents (
  child_ssn       INT,
  parent_username VARCHAR(50),
  PRIMARY KEY (child_ssn, parent_username),
  FOREIGN KEY (child_ssn) REFERENCES Children (ssn)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY (parent_username) REFERENCES Parents (username)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE Courses_Prerequisite_Courses (
  course1_id INT,
  course2_id INT,
  PRIMARY KEY (course1_id, course2_id),
  FOREIGN KEY (course1_id) REFERENCES Courses (code)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY (course2_id) REFERENCES Courses (code)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE Teachers_Supervise_Teachers (
  teacher1_username VARCHAR(50),
  teacher2_username VARCHAR(50),
  PRIMARY KEY (teacher1_username, teacher2_username),
  FOREIGN KEY (teacher1_username) REFERENCES Teachers (teacher_username)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY (teacher2_username) REFERENCES Teachers (teacher_username)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE Parents_Rate_Teachers (
  parent_username  VARCHAR(50),
  teacher_username VARCHAR(50),
  rating           INT,
  PRIMARY KEY (parent_username, teacher_username),
  FOREIGN KEY (parent_username) REFERENCES Parents (username)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY (teacher_username) REFERENCES Teachers (teacher_username)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE Parents_Review_Schools (
  parent_username VARCHAR(50),
  school_id       INT,
  review          TEXT,
  PRIMARY KEY (parent_username, school_id),
  FOREIGN KEY (parent_username) REFERENCES Parents (username)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY (school_id) REFERENCES Schools (id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE Courses_Offered_By_Levels (
  course_code INT PRIMARY KEY,
  level_id INT,
  grade     INT,

  FOREIGN KEY (course_code) REFERENCES Courses(code)
  ON DELETE CASCADE
  ON UPDATE CASCADE,

  FOREIGN KEY (level_id) REFERENCES Levels(id)
  ON DELETE CASCADE
  ON UPDATE CASCADE

);

CREATE TABLE Children_Applied_For_By_Parents_In_Schools (
  parent_username VARCHAR(50),
  school_id       INT,
  child_ssn       INT,
  status          BIT,
  PRIMARY KEY (parent_username, school_id, child_ssn),
  FOREIGN KEY (parent_username) REFERENCES Parents (username)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY (school_id) REFERENCES Schools (id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY (child_ssn) REFERENCES Children(ssn)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE Courses_Questions_From_Students (
  student_ssn INT,
  question_id INT PRIMARY KEY,
  course_code INT,
  FOREIGN KEY (student_ssn) REFERENCES Children(ssn)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY (course_code) REFERENCES Courses (code)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY (question_id) REFERENCES Questions (id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE Courses_Taught_In_School_By_Teacher (
  school_id INT,
  course_code INT,
  teacher_username VARCHAR(50),
  PRIMARY KEY (school_id,course_code),
    FOREIGN KEY (school_id) REFERENCES Schools (id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY (course_code) REFERENCES Courses (code)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY (teacher_username) REFERENCES Teachers (teacher_username)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE Courses_Taken_By_Students(
    course_code INT,
    student_ssn INT,
    PRIMARY KEY (course_code, student_ssn),
    FOREIGN KEY (student_ssn) REFERENCES Students(child_ssn) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (course_code) REFERENCES Courses(code)  ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Reports_About_Students(
    teacher_username VARCHAR(50),
    student_ssn INT,
    date DATETIME,
    teacher_comment TEXT,
    parent_reply TEXT,
    PRIMARY KEY (teacher_username, student_ssn, date),
    FOREIGN KEY (student_ssn) REFERENCES Students(child_ssn) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (teacher_username) REFERENCES Teachers(teacher_username)  ON DELETE CASCADE ON UPDATE CASCADE
);
