USE M3_School;

# “As a system administrator, I should be able to ...”

# 1.1 - Create a school with its information: school name, address, email,
# general information, vision, mission, main language, type(national, international) and fees.

# validation
# check whether he is the system admin

DELIMITER //
CREATE PROCEDURE Create_Schools(s_name VARCHAR(100), addres VARCHAR(100), mail VARCHAR(50),
                                g_info TEXT, visn TEXT, misn TEXT, main_l VARCHAR(20), typ VARCHAR(20), fes DOUBLE)
  BEGIN
    INSERT INTO Schools (name, vision, mission, main_language, type, fees, address, email, general_info)
    VALUES (s_name, visn, misn, main_l, typ, fes, addres, mail, g_info);

  END //
DELIMITER ;

# 1.2 make the school elementary
# the school id input in the procedure comes from php

DELIMITER //
CREATE PROCEDURE Make_Schools_Elementary(s_id INT, sups TEXT)
  BEGIN
    INSERT INTO Elementary_Schools (school_id, supplies, level_id)
    VALUES (s_id, sups, 1);

  END //
DELIMITER ;

# 1.3 make the school middle
# the school id input in the procedure comes from php
DELIMITER //
CREATE PROCEDURE Make_Schools_Middle(s_id INT, sups TEXT)
  BEGIN

    INSERT INTO Middle_Schools (school_id, supplies, level_id)
    VALUES (s_id, sups, 2);

  END //
DELIMITER ;

# 1.4 make the school high
# the school id input in the procedure comes from php
DELIMITER //
CREATE PROCEDURE Make_Schools_High(s_id INT, sups TEXT)
  BEGIN

    INSERT INTO High_Schools (school_id, supplies, level_id)
    VALUES (s_id, sups, 3);

  END //
DELIMITER ;


# 1.5 add phone number(s) to the schools
# validation
# check whether he is the system admin and no phone number is null
# school id will come from php

DELIMITER //
CREATE PROCEDURE Add_PhoneNumbers_To_Schools(s_id INT, p_number INT)
  BEGIN
    INSERT INTO School_Phone_Numbers (telephone_number, school_id) VALUES (p_number, s_id);
  END //
DELIMITER ;

# 2.1 - Add courses to the system with all of its information: course code, course name,
# course level (elementary, middle, high), grade, description.
# validation
# check whether he is the system admin, course code not null

DELIMITER //
CREATE PROCEDURE Add_Courses(c_code INT, c_name VARCHAR(20), c_level INT, c_grade INT, descp TEXT)
  BEGIN
    INSERT INTO Courses (code, name, description) VALUES (c_code, c_name, descp);

    INSERT INTO Courses_Offered_By_Levels (course_code, level_id, grade)
    VALUES (c_code, c_level, c_grade);
  END //
DELIMITER ;


# 2.2 - Add courses prerequisites
# validation
# check whether he is the system admin, course codes not null

DELIMITER //
CREATE PROCEDURE Add_Course_Prerequisites(c_code1 INT, c_code2 INT)
  BEGIN

    INSERT INTO Courses_Prerequisite_Courses (course1_id, course2_id) VALUES (c_code1, c_code2);

  END //
DELIMITER ;

# 3 - Add admins to the system with their information: first name, middle name, last name,
# birth_date, address, email, username, password, and gender.
# Given the school name, I should assign admins to work in this school
# we added the school id not the school as it is the primary key and we will
# handle this part in php
# validation
# check whether he is the system admin, and the username is not null

DELIMITER //
CREATE PROCEDURE Add_Admins(f_name VARCHAR(50), m_name VARCHAR(50), l_name VARCHAR(50),
                            bdate  DATETIME, addres VARCHAR(100), mail VARCHAR(50), usrname VARCHAR(50),
                            pass   VARCHAR(100),
                            gen    VARCHAR(10), s_id INT)
  BEGIN
    DECLARE sal DOUBLE DEFAULT 3000;
    IF (exists(SELECT *
               FROM Schools
               WHERE id = s_id AND type = 'International'))
    THEN SET sal = 5000;
    END IF;

    INSERT INTO Employees
    (username, password, first_name, middle_name, last_name, birthdate,
     address, email, salary, gender, school_id)
    VALUES (usrname, pass, f_name, m_name, l_name, bdate, addres, mail, sal, gen, s_id);

    INSERT INTO Administrators (employee_username) VALUES (usrname);

  END //
DELIMITER ;

# 4.1 - Delete a school from the database with all of its corresponding information
# and set students enrolled in it username to null
DELIMITER //
CREATE PROCEDURE Delete_Schools(s_id INT)
  BEGIN
    DELETE FROM Schools
    WHERE id = s_id;

    UPDATE Students
    SET username = NULL
    WHERE school_id = s_id;
  END //
DELIMITER ;

# 4.2 - Change the name of employees working on a school which was deleted
# that will be called along with the school deletion for every employee in php
# we agreed on that the new username will be as the following #oldusrname#
DELIMITER //
CREATE PROCEDURE ChangeEmployeeUsername(oldusrname VARCHAR(50))
  BEGIN
    UPDATE Employees
    SET username = concat('#', oldusrname, '#')
    WHERE username = oldusrname;

    UPDATE Teachers
    SET teacher_username =  concat('#', oldusrname, '#')
    WHERE teacher_username = oldusrname;

    UPDATE Administrators
    SET employee_username = concat('#', oldusrname, '#')
    WHERE employee_username = oldusrname;

  END //
DELIMITER ;













