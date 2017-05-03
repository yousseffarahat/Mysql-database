USE M3_School;

# 1. levels
INSERT INTO Levels (id) VALUES (1);
INSERT INTO Levels (id) VALUES (2);
INSERT INTO Levels (id) VALUES (3);

# 2. Schools
INSERT INTO Schools (id, name, vision, mission, main_language, type, fees, address, email, general_info)
VALUES (1, 'GUC', 'near', 'impossible', 'English', 'International', 70000, '5th tagamo3', 'guc@guc.guc', 'none');

INSERT INTO Schools (id, name, vision, mission, main_language, type, fees, address, email, general_info)
VALUES (2, 'ExtremelySimpleSchoolName', 'far', 'impossible', 'English', 'National', 2000, 'Madinaty', 'essn@gmail.com',
        'none');

INSERT INTO Schools (id, name, vision, mission, main_language, type, fees, address, email, general_info)
VALUES
  (3, 'AUC', 'CashMoney', 'impossible', 'English', 'International', 240000, '5th tagamo3', 'auc@notguc.auc', 'none');

INSERT INTO Schools (id, name, vision, mission, main_language, type, fees, address, email, general_info)
VALUES
  (4, 'ZH', 'CashMoney', 'impossible', 'English', 'International', 140000, '5th tagamo3', 'auc@notguc.auc', 'none');


# 2.1 - Schools Types
INSERT INTO Elementary_Schools (school_id, supplies, level_id) VALUES (1, 'WLA AY 7AGA 5AAALS', 1);

INSERT INTO Elementary_Schools (school_id, supplies, level_id) VALUES (2, 'SHWYT 7AGAT', 2);
INSERT INTO Middle_Schools (school_id, level_id) VALUES (2, 2);

INSERT INTO High_Schools (school_id, level_id) VALUES (3, 3);

# 2.2 School Phone Numbers
INSERT INTO School_Phone_Numbers (telephone_number, school_id) VALUES ('01001212333', 1);
INSERT INTO School_Phone_Numbers (telephone_number, school_id) VALUES ('01001218333', 2);
INSERT INTO School_Phone_Numbers (telephone_number, school_id) VALUES ('01001212313', 3);
INSERT INTO School_Phone_Numbers (telephone_number, school_id) VALUES ('01101212333', 2);
INSERT INTO School_Phone_Numbers (telephone_number, school_id) VALUES ('01301212333', 3);

# 3. Employees
INSERT INTO Employees (username, password, first_name, middle_name, last_name, birthdate, address, email, salary, gender, school_id)
VALUES ('Melzarei', 'ExremelyDifficultPasswordThatNoOneWillKnow', 'Mohammad', 'Abdelaal', 'Elzarei', '1996-1-1',
                    '5th tagamo3', 'melzar3i@gmail.com', 10, 'male', 2);

INSERT INTO Employees (username, password, first_name, middle_name, last_name, birthdate, address, email, salary, gender, school_id)
VALUES ('MelzareiPlus', 'ExremelyDifficultPasswordThatNoOneWillKnow', 'Mohammad', 'Abdelaal', 'Elzarei', '1996-1-1',
                        '5th tagamo3', 'melzar3i@gmail.com', 10, 'male', 2);

INSERT INTO Employees (username, password, first_name, middle_name, last_name, birthdate, address, email, salary, gender, school_id)
VALUES ('ShabrawyMet', 'SimpleButUnguesssable', 'Abdelrahman', 'Abdelmonem', 'Elshabrawy', '1996-9-3', 'El Rehab',
                       'abdoshabrawy@gmail.com', 10000, 'male', 1);


INSERT INTO Employees (username, password, first_name, middle_name, last_name, birthdate, address, email, salary, gender, school_id)
VALUES
  ('YoussefF', 'HelpIForgotMyPassword', 'Youssef', 'Hossam', 'Farahat', '1996-1-1', 'Madinaty', 'joeforshow@gmail.com',
               10000, 'male', 3);

INSERT INTO Employees (username, password, first_name, middle_name, last_name, birthdate, address, email, salary, gender, school_id)
VALUES
  ('Nour', 'YouCanDoBetter', 'Nour', 'Eldin', 'salem', '1980-1-1', 'Madinaty', 'betterisgood@gmail.com', 101, 'other',
           1);

# Unverified users

INSERT INTO Employees (username, first_name, middle_name, last_name, birthdate, address, email, gender, school_id)
VALUES ('AhmedAli', 'Ahmed', 'Ali', 'Ali', '1982-1-1', 'Cairo', 'A2oj@gmail.com', 'male', 2);

INSERT INTO Employees (username, first_name, middle_name, last_name, birthdate, address, email, gender, school_id)
VALUES ('Unverified1', 'Omar', 'Ashraf', 'KojakxD', '1996-1-1', 'El Rehab', 'omarkojaks@gmail.com', 'male', 3);

# 4 - Teachers
INSERT INTO Teachers (teacher_username, years_of_experience) VALUES ('Melzarei', 3);
INSERT INTO Teachers (teacher_username, years_of_experience) VALUES ('YoussefF', 5);
INSERT INTO Teachers (teacher_username, years_of_experience) VALUES ('MelzareiPlus', 5);
INSERT INTO Teachers (teacher_username, years_of_experience) VALUES ('Nour', 1);

# 5- Administrators
INSERT INTO Administrators (employee_username) VALUES ('Nour');
INSERT INTO Administrators (employee_username) VALUES ('ShabrawyMet');

# 6- Courses
INSERT INTO Courses (code, name, description) VALUES (101, 'MATH', 'PROOOOFS!');
INSERT INTO Courses (code, name, description) VALUES (103, 'MATH7', 'PROOOOFS!');
INSERT INTO Courses (code, name, description) VALUES (102, 'PHYS', 'OLO S7');
INSERT INTO Courses (code, name, description) VALUES (201, 'CSEN', 'MODULUS');
INSERT INTO Courses (code, name, description) VALUES (203, 'EDPT', 'WORKPIECE');
INSERT INTO Courses (code, name, description) VALUES (305, 'CHEM', '3 Doctors Because Why Not?!');
INSERT INTO Courses (code, name, description) VALUES (303, 'DB1', 'DATA ENTRY!!');

# 7 - Courses In Levels
INSERT INTO Courses_Offered_By_Levels (course_code, level_id, grade) VALUES (101, 1, 1);
INSERT INTO Courses_Offered_By_Levels (course_code, level_id, grade) VALUES (103, 1, 1);
INSERT INTO Courses_Offered_By_Levels (course_code, level_id, grade) VALUES (102, 1, 2);
INSERT INTO Courses_Offered_By_Levels (course_code, level_id, grade) VALUES (201, 2, 1);
INSERT INTO Courses_Offered_By_Levels (course_code, level_id, grade) VALUES (203, 2, 3);
INSERT INTO Courses_Offered_By_Levels (course_code, level_id, grade) VALUES (305, 3, 5);
INSERT INTO Courses_Offered_By_Levels (course_code, level_id, grade) VALUES (303, 3, 3);

# 8 - Courses Taught In School
INSERT INTO Courses_Taught_In_School_By_Teacher (school_id, course_code, teacher_username) VALUES (3, 305, 'YoussefF');
INSERT INTO Courses_Taught_In_School_By_Teacher (school_id, course_code, teacher_username) VALUES (2, 102, 'Melzarei');
INSERT INTO Courses_Taught_In_School_By_Teacher (school_id, course_code, teacher_username) VALUES (2, 101, 'Melzarei');
INSERT INTO Courses_Taught_In_School_By_Teacher (school_id, course_code, teacher_username) VALUES (2, 201, 'Melzarei');
INSERT INTO Courses_Taught_In_School_By_Teacher (school_id, course_code, teacher_username) VALUES (3, 303, 'YoussefF');

# 9 - Parents
INSERT INTO Parents (username, password, first_name, last_name, email, address, home_number)
VALUES ('kojak', '1234', 'ahmed', 'ali', 'ahmad@guc.edu.eg', 'elmaadi', 111111);

# 10 - Children
INSERT INTO Children (ssn, first_name, last_name, birth_date, gender)
VALUES (1, 'Abdelmegeed', 'soso', '2009-4-1', 'male');
INSERT INTO Children (ssn, first_name, last_name, birth_date, gender)
VALUES (2, 'Salem', 'mego', '2007-3-11', 'female');
INSERT INTO Children (ssn, first_name, last_name, birth_date, gender)
VALUES (3, 'Mohamed', 'moody', '2005-2-21', 'other');
INSERT INTO Children (ssn, first_name, last_name, birth_date, gender) VALUES (5, 'amr', 'hatem', '2009-5-5', 'male');
INSERT INTO Children (ssn, first_name, last_name, birth_date, gender) VALUES (6, 'aly', 'hashim', '2009-6-5', 'male');
INSERT INTO Children (ssn, first_name, last_name, birth_date, gender) VALUES (7, 'mai', 'hashim', '2009-6-5', 'female');

INSERT INTO Children_Have_Parents (child_ssn, parent_username) VALUES (5, 'kojak');
INSERT INTO Children_Have_Parents (child_ssn, parent_username) VALUES (6, 'kojak');
INSERT INTO Children_Have_Parents (child_ssn, parent_username) VALUES (7, 'kojak');
INSERT INTO Children_Have_Parents (child_ssn, parent_username) VALUES (1, 'kojak');
INSERT INTO Children_Have_Parents (child_ssn, parent_username) VALUES (2, 'kojak');

INSERT INTO Children_Applied_For_By_Parents_In_Schools (parent_username, school_id, child_ssn, status)
VALUES ('kojak', 1, 5, 1);
INSERT INTO Children_Applied_For_By_Parents_In_Schools (parent_username, school_id, child_ssn, status)
VALUES ('kojak', 2, 6, 1);
INSERT INTO Children_Applied_For_By_Parents_In_Schools (parent_username, school_id, child_ssn, status)
VALUES ('kojak', 1, 7, 0);

# 11 - Students
INSERT INTO Students (child_ssn, school_id, username, password, grade) VALUES (1, 2, 'mego', '1234', 1);
INSERT INTO Students (child_ssn, school_id, username, password, grade) VALUES (2, 2, 'soso', '1234', 2);
INSERT INTO Students (child_ssn, school_id, username, password, grade) VALUES (3, 3, 'moody', '1234', 5);

# 12 - Courses Taken By Students
INSERT INTO Courses_Taken_By_Students (course_code, student_ssn) VALUES (101, 1);
INSERT INTO Courses_Taken_By_Students (course_code, student_ssn) VALUES (102, 2);
INSERT INTO Courses_Taken_By_Students (course_code, student_ssn) VALUES (305, 3);

# 13 - Assignments
INSERT INTO Assignments (content, posting_date, due_date, course_code, teacher_username)
VALUES ('7lw W Gameel', '2016-3-1', '2016-4-1', 102, 'Melzarei');
INSERT INTO Assignments (content, posting_date, due_date, course_code, teacher_username)
VALUES ('7lw AWI BS MSH GAMEEL WLA Gameel MSH 3ARF', '2016-5-1', '2016-6-1', 101, 'Melzarei');
INSERT INTO Assignments (content, posting_date, due_date, course_code, teacher_username)
VALUES ('7lw BAS MSH Gameel', '2016-4-1', '2016-6-1', 305, 'YoussefF');
INSERT INTO Assignments (content, posting_date, due_date, course_code, teacher_username)
VALUES ('7lw W Gameel-123', '2016-3-1', '2016-4-2', 102, 'Melzarei');

# 14 -  Assignments Solutions
INSERT INTO Solutions (student_ssn, assignment_id, teacher_username, content, grade)
VALUES (1, 2, 'Melzarei', 'MSH H7LO2', 0);
INSERT INTO Solutions (student_ssn, assignment_id, teacher_username, content, grade)
VALUES (2, 1, 'Melzarei', 'MSH H7LO1', NULL);
INSERT INTO Solutions (student_ssn, assignment_id, teacher_username, content, grade)
VALUES (3, 3, 'YoussefF', 'MSH H7LO4', 10);

# 15 - Questions
INSERT INTO Questions (teacher_username, title, content, answer) VALUES (NULL, 'Integration', 'By Parts Ezai?!', NULL);
INSERT INTO Questions (teacher_username, title, content, answer) VALUES (NULL, 'Integration 2', 'Twisted?!', NULL);
INSERT INTO Questions (teacher_username, title, content, answer)
VALUES (NULL, 'Integration 3', 'Gamed El Twisted?!', NULL);

# 16 - Courses_Questions_From_Students
INSERT INTO Courses_Questions_From_Students (student_ssn, question_id, course_code) VALUES (1, 1, 101);
INSERT INTO Courses_Questions_From_Students (student_ssn, question_id, course_code) VALUES (2, 2, 102);
INSERT INTO Courses_Questions_From_Students (student_ssn, question_id, course_code) VALUES (3, 3, 305);

# 17 - Announcements
INSERT INTO Announcements (date, type, description, title, administrator_username)
VALUES ('2000-10-10', 'sports', 'no description1', 'no title1', 'Nour');
INSERT INTO Announcements (date, type, description, title, administrator_username)
VALUES ('2016-11-20', 'sports', 'no description2', 'no title2', 'Nour');

# 18 - Activities
INSERT INTO Activities (date, administrator_username, teacher_username, location, equipment, type, description)
VALUES ('2016-11-20', 'Nour', 'Melzarei', 'ElRehab', 'rfuruf', 'sports', 'frnfrinfr');
INSERT INTO Activities (date, administrator_username, teacher_username, location, equipment, type, description)
VALUES ('2016-11-20', 'Nour', 'Melzarei', 'ElRehab', 'rfuruf', 'sports', 'frnfrinfr');

# 19 - Clubs
INSERT INTO Clubs (name, high_school_id, purpose) VALUES ('bdaya', 3, 'Charity');
INSERT INTO Clubs (name, high_school_id, purpose) VALUES ('AIESC', 3, 'FUN');

# 20 - Reports
INSERT INTO Reports_About_Students (teacher_username, student_ssn, date, teacher_comment)
VALUES ('Melzarei', 1, '2016-11-11', 'ebnk msh 3agbny');