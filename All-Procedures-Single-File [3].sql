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
    SET teacher_username = concat('#', oldusrname, '#')
    WHERE teacher_username = oldusrname;

    UPDATE Administrators
    SET employee_username = concat('#', oldusrname, '#')
    WHERE employee_username = oldusrname;

  END //
DELIMITER ;

USE M3_School;

# -----------------------------------------------------------------------------------------

USE M3_School;

# “As a system user (registered, or not registered),
#  I should be able to ...”

# Returns the school id and name of the school.

DELIMITER //
CREATE PROCEDURE Search_For_School_By_Name(IN schoolName VARCHAR(100))
  BEGIN
    SELECT
      id,
      name
    FROM Schools
    WHERE name = schoolName;
  END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Search_For_School_By_Address(IN schoolAddress VARCHAR(100))
  BEGIN
    SELECT
      id,
      name
    FROM Schools
    WHERE address = schoolAddress;
  END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Search_For_School_By_Type(IN schoolType VARCHAR(100))
  BEGIN
    SELECT
      id,
      name
    FROM Schools
    WHERE type = schoolType;
  END //
DELIMITER ;

# 2- View a list of all available schools on the system categorized by their level.
DELIMITER //
CREATE PROCEDURE View_AllAvailable_Schools()
  BEGIN

    SELECT
      school_id,
      level_id,
      name AS "School Name"
    FROM Elementary_Schools
      INNER JOIN Schools ON Elementary_Schools.school_id = Schools.id

    UNION ALL

    SELECT
      school_id,
      level_id,
      name AS "School Name"
    FROM Middle_Schools
      INNER JOIN Schools ON Middle_Schools.school_id = Schools.id

    UNION ALL

    SELECT
      school_id,
      level_id,
      name AS "School Name"
    FROM High_Schools
      INNER JOIN Schools ON High_Schools.school_id = Schools.id
    ORDER BY level_id ASC;

  END//
DELIMITER ;

# 3- View the information of a certain school along with
# the reviews written about it and teachers teaching in this school.

# Seperate procedures for each type of information, unioned in php to avoid duplicate rows.
DELIMITER //
CREATE PROCEDURE View_Specific_School(IN curr_school_id INT)
  BEGIN
    SELECT *
    FROM Schools
    WHERE id = curr_school_id;
  END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE View_Specific_School_Reviews(IN curr_school_id INT)
  BEGIN
    SELECT *
    FROM Parents_Review_Schools
    WHERE school_id = curr_school_id;
  END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE View_Specific_School_Teachers(IN curr_school_id INT)
  BEGIN
    SELECT *
    FROM Employees
      JOIN Teachers
        ON Teachers.teacher_username = Employees.username
    WHERE school_id = curr_school_id;
  END//
DELIMITER ;

# View School Phone Numbers
DELIMITER //
CREATE PROCEDURE View_Specific_School_PhoneNumbers(IN curr_school_id INT)
  BEGIN
    SELECT *
    FROM School_Phone_Numbers
    WHERE school_id = curr_school_id;
  END//
DELIMITER ;

# -----------------------------------------------------------------------------------------

# “As an administrator, I should be able to ...”
# GENERAL PURPOSE PROCEDURES TO CHECK FOR ERRORS AND PERMISSION

# CHECK THAT THE CURRENT USER IS AN ADMINISTRATOR
DELIMITER //
CREATE PROCEDURE IsAnAdministrator(IN adminstrator_username VARCHAR(50), OUT ISADMINSTRATOR TINYINT)
  BEGIN
    SET ISADMINSTRATOR = 0;
    IF adminstrator_username IN (SELECT *
                                 FROM Administrators)
    THEN
      SET ISADMINSTRATOR = 1;
    END IF;
  END;
DELIMITER ;

# GET THE CURRENT ADMINISTRATOR SCHOOL_ID

DELIMITER //
DROP PROCEDURE IF EXISTS GetAdministratorSchoolID;
CREATE PROCEDURE GetAdministratorSchoolID(IN adminstrator_username VARCHAR(50), OUT SCHOOL_ID INT)
  BEGIN
    DECLARE ISADMINSTRATOR TINYINT;
    CALL IsAnAdministrator(adminstrator_username, ISADMINSTRATOR);

    IF ISADMINSTRATOR = 1
    THEN
      SELECT Employees.school_id
      INTO SCHOOL_ID
      FROM Employees
      WHERE username = adminstrator_username;
    END IF;

  END//

DELIMITER ;

# CHECK THAT AN ADMINISTRATOR CAN MODIFY ACTIVITY
DELIMITER //
CREATE PROCEDURE CanAdministratorModifyActivity(IN  adminstrator_username VARCHAR(50),
                                                IN  activity_id           INT,
                                                OUT CANMODIFY             TINYINT)
  BEGIN
    DECLARE ISADMINSTRATOR TINYINT;
    SET CANMODIFY = 0;
    CALL IsAnAdministrator(adminstrator_username, ISADMINSTRATOR);

    IF ISADMINSTRATOR = 1
    THEN
      IF activity_id IN (SELECT id
                         FROM Activities
                         WHERE Activities.administrator_username = adminstrator_username)
      THEN
        SET CANMODIFY = 1;
      END IF;
    END IF;

  END//
DELIMITER ;

# CHECK THAT A TEACHER WORKS IN AN ADMINISTRATOR'S SCHOOL
DELIMITER //
CREATE PROCEDURE IsTeacherWorkingInAdministratorSchool(IN  adminstrator_username VARCHAR(50),
                                                       IN  teacher_usrname       VARCHAR(50),
                                                       OUT TWORKS                TINYINT)
  BEGIN
    SET TWORKS = 0;
  END//
DELIMITER ;

# 1 - View and verify teachers who signed up as employees of the school I am responsible of,
#  and assign to them a unique username and password.
# The salary of a teacher is calculated as follows: years of experience * 500 EGP.


DELIMITER //
CREATE PROCEDURE View_Teachers_As_Administrator(IN adminstrator_username VARCHAR(50))
  BEGIN
    DECLARE adminstrator_school_id INT;
    CALL GetAdministratorSchoolID(adminstrator_username, adminstrator_school_id);

    SELECT *
    FROM Teachers
      INNER JOIN Employees ON username = Teachers.teacher_username
    WHERE school_id = adminstrator_school_id;

  END;
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Verify_Teacher_As_Administrator(IN adminstrator_username       VARCHAR(50),
                                                 IN teacher_random_username     VARCHAR(50),
                                                 IN teacher_new_username        VARCHAR(50),
                                                 IN teacher_new_password        VARCHAR(100),
                                                 IN teacher_years_of_experience INT)
  BEGIN
    DECLARE teacher_has_password VARCHAR(100) DEFAULT '.';
    DECLARE teacher_exists INT DEFAULT NULL;

    DECLARE adminstrator_school_id INT;
    CALL GetAdministratorSchoolID(adminstrator_username, adminstrator_school_id);

    SELECT
      school_id,
      password
    INTO teacher_exists, teacher_has_password
    FROM Teachers, Employees
    WHERE school_id = adminstrator_school_id AND
          teacher_username = teacher_random_username
          AND Employees.username = teacher_random_username;

    IF teacher_has_password IS NULL AND teacher_exists IS NOT NULL
    THEN

      UPDATE Teachers
      SET years_of_experience = teacher_years_of_experience
      WHERE teacher_username = teacher_random_username;

      UPDATE Employees
      SET username = teacher_new_username, password = teacher_new_password,
        salary     = 500 * teacher_years_of_experience
      WHERE username = teacher_random_username AND school_id = adminstrator_school_id;


    END IF;

  END //
DELIMITER ;

# 2 - View and verify students who enrolled to the school
# I am responsible of, and assign to them a unique username and password.
# NEEDS : IsAnAdministrator

DELIMITER //
CREATE PROCEDURE View_Students_As_Administrator(IN adminstrator_username VARCHAR(50))
  BEGIN
    DECLARE adminstrator_school_id INT;
    CALL GetAdministratorSchoolID(adminstrator_username, adminstrator_school_id);

    IF adminstrator_school_id IS NOT NULL
    THEN
      SELECT *
      FROM Students
        INNER JOIN Children ON child_ssn = Children.ssn
      WHERE school_id = adminstrator_school_id;
    END IF;
  END//
DELIMITER ;


DELIMITER //
CREATE PROCEDURE Verify_Enrolled_Student_As_Administrator(IN adminstrator_username VARCHAR(50),
                                                          IN curr_child_ssn        INT,
                                                          IN student_username      VARCHAR(50),
                                                          IN student_password      VARCHAR(100))
  BEGIN
    DECLARE adminstrator_school_id INT;
    DECLARE student_has_password VARCHAR(50) DEFAULT '.';
    DECLARE student_exists INT DEFAULT NULL;

    CALL GetAdministratorSchoolID(adminstrator_username, adminstrator_school_id);


    SELECT
      school_id,
      password
    INTO student_exists, student_has_password
    FROM Children, Students
    WHERE school_id = adminstrator_school_id AND
          Students.child_ssn = curr_child_ssn
          AND Children.ssn = curr_child_ssn;


    IF student_has_password IS NULL AND student_exists IS NOT NULL
    THEN
      UPDATE Students
      SET username = student_username, password = student_password
      WHERE child_ssn = curr_child_ssn;
    END IF;

  END //
DELIMITER ;


# 3 - Add other admins to the school I am working in. An admin has first name, middle name, last name, birthdate,
#  address, email, username, password, and gender. Note that the salary
# of the admin depends on the type of the school.
# NEEDS : IsAnAdministrator

DELIMITER //
CREATE PROCEDURE Add_New_Administrator_ToSchool(adminstrator_username VARCHAR(50),
                                                fname                 VARCHAR(50), mname VARCHAR(50), lname VARCHAR(50),
                                                birthd                DATETIME, aadress VARCHAR(100),
                                                temail                VARCHAR(50),
                                                usrname               VARCHAR(50), pass VARCHAR(100),
                                                tgender               VARCHAR(10))
  BEGIN
    DECLARE adminstrator_school_id INT;
    DECLARE asalary INT DEFAULT 5000;
    DECLARE school_type VARCHAR(50) DEFAULT 5000;

    CALL GetAdministratorSchoolID(adminstrator_username, adminstrator_school_id);

    SELECT type
    INTO school_type
    FROM Schools
    WHERE id = adminstrator_school_id;

    IF (school_type = 'National')
    THEN
      SET asalary = 2000;
    END IF;

    INSERT INTO Employees (username, password, first_name, middle_name, last_name, birthdate, address, email, salary, gender, school_id)
    VALUES (usrname, pass, fname, mname, lname, birthd, aadress, temail, asalary, tgender, adminstrator_school_id);

    INSERT INTO Administrators (employee_username) VALUES (usrname);
  END //

DELIMITER ;

# 4 - Delete employees and students from the system.
# NEEDS : IsAnAdministrator, IsTeacherWorkingInAdministratorSchool

DELIMITER //
CREATE PROCEDURE Delete_Employee(adminstrator_username VARCHAR(50), employee_usrname VARCHAR(50))
  BEGIN
    DECLARE adminstrator_school_id INT;
    CALL GetAdministratorSchoolID(adminstrator_username, adminstrator_school_id);

    DELETE
    FROM Employees
    WHERE school_id = adminstrator_school_id AND username = employee_usrname;
  END //
DELIMITER ;

# 5 - Edit the information of the school I am working in.
# NEEDS : IsAnAdministrator

DELIMITER //
CREATE PROCEDURE Edit_School_Information(adminstrator_username VARCHAR(50),
                                         sname                 VARCHAR(100), svision TEXT, smission TEXT,
                                         smainlang             VARCHAR(20), stype VARCHAR(20), sfees DOUBLE,
                                         saddress              VARCHAR(100),
                                         semail                VARCHAR(50), sgninfo TEXT)
  BEGIN
    DECLARE adminstrator_school_id INT;
    CALL GetAdministratorSchoolID(adminstrator_username, adminstrator_school_id);

    UPDATE Schools
    SET name  = sname, vision = svision, mission = smission, main_language = smainlang,
      address = saddress, type = stype, fees = sfees, email = semail, general_info = sgninfo
    WHERE id = adminstrator_school_id;
  END //
DELIMITER ;

# 6 - Post announcements with the following information: date, title, description and
# type (events, news, trips ...etc).
# NEEDS : IsAnAdministrator

DELIMITER //
CREATE PROCEDURE Post_Announcement(adminstrator_username VARCHAR(50),
                                   adate                 DATETIME, atype VARCHAR(20), adesc TEXT,
                                   atitle                VARCHAR(30))
  BEGIN
    INSERT INTO Announcements (date, type, description, title, administrator_username)
    VALUES (adate, atype, adesc, atitle, adminstrator_username);
  END //
DELIMITER ;

# 7 - Create activities and assign every activity to a certain teacher.
# An activity has its own date, location in school, type, equipment(if any), and description.
# NEEDS : IsAnAdministrator

DELIMITER //
CREATE PROCEDURE Create_School_Activity(adminstrator_username VARCHAR(50),
                                        teacher_usrname       VARCHAR(50),
                                        adate                 DATETIME, aloc VARCHAR(50),
                                        aequip                TEXT, atype VARCHAR(20), adesc TEXT)
  BEGIN
    INSERT INTO Activities (date, administrator_username, teacher_username, location, equipment, type, description)
    VALUES (adate, adminstrator_username, teacher_usrname, aloc, aequip, atype, adesc);
  END //
DELIMITER ;

# 8 - Change the teacher assigned to an activity.
# NEEDS : IsTeacherWorkingInAdministratorSchool, IsAnAdministrator
DELIMITER //
CREATE PROCEDURE Change_Activity_Teacher(adminstrator_username VARCHAR(50),
                                         activity_id           INT,
                                         teacher_usrname       VARCHAR(50))
  BEGIN
    UPDATE Activities
    SET teacher_username = teacher_usrname
    WHERE id = activity_id;
  END//
DELIMITER ;

# 9 - Assign teachers to courses that are taught in my school based on the levels it offers.
# validation needed in the nest milestone that this course is offered by my school in some level
DELIMITER //
CREATE PROCEDURE Assign_Teacher_To_Courses(usrname VARCHAR(50), c_id INT, tchrusrname VARCHAR(50))
  BEGIN
    DECLARE s_id INT DEFAULT 0;

    SELECT school_id
    INTO s_id
    FROM Employees
    WHERE username = usrname;

    INSERT INTO Courses_Taught_In_School_By_Teacher (school_id, course_code, teacher_username)
    VALUES (s_id, c_id, tchrusrname);
  END //
DELIMITER ;

# 10 -  Assign teachers to be supervisors to other teachers.
# Needs IsTeacherWorkingInAdministratorSchool in PHP to validate that it's valid
# AND IsAnAdministrator
DELIMITER //
CREATE PROCEDURE Assign_Teacher_To_Be_Supervisors(adminstrator_username VARCHAR(50), t1 VARCHAR(50), t2 VARCHAR(50))
  BEGIN
    INSERT INTO Teachers_Supervise_Teachers (teacher1_username, teacher2_username)
    VALUES (t1, t2);
  END //
DELIMITER ;

# 11 - Accept or reject the application submitted by parents to their children.
# NEEDS : IsAnAdministrator
DELIMITER //
CREATE PROCEDURE Accept_Or_Reject_Child(adminstrator_username VARCHAR(50), chld_ssn INT, prent_username VARCHAR(50),
                                        isAccepted            BIT)
  BEGIN
    DECLARE adminstrator_school_id INT;
    CALL GetAdministratorSchoolID(adminstrator_username, adminstrator_school_id);

    UPDATE Children_Applied_For_By_Parents_In_Schools s
    SET status = isAccepted
    WHERE s.school_id = adminstrator_school_id AND s.child_ssn = chld_ssn AND s.parent_username = prent_username;

  END //
DELIMITER ;

USE M3_School;
# -----------------------------------------------------------------------------------------

# “As a teacher, I should be able to ...”

# 1 - Sign up by providing my first name, middle name,
# last name, birthdate, address, email, and gender.

# the username in this procedure refers to the randomized one that
# will be generated by php and checked here that it's unique

DELIMITER //
CREATE PROCEDURE TeacherSignUp(usrname VARCHAR(50), f_name VARCHAR(50), m_name VARCHAR(50),
                               l_name  VARCHAR(50), bdate DATETIME, addres VARCHAR(100), mail VARCHAR(50),
                               gen     VARCHAR(10), s_id INT)
  BEGIN
    INSERT INTO Employees (username, first_name, middle_name, last_name, birthdate, address, email, gender, school_id)
    VALUES (usrname, f_name, m_name, l_name, bdate, addres, mail, gen, s_id);

    INSERT INTO Teachers (teacher_username, years_of_experience) VALUES (usrname, 0);
  END //
DELIMITER ;

# 2 - View a list of courses’ names I teach categorized by level and grade.

DELIMITER //
CREATE PROCEDURE ViewCoursesTaughtByTeacher(usrname VARCHAR(50))
  BEGIN
    SELECT
      CL.level_id,
      CL.grade,
      CT.course_code
    FROM
      Courses_Taught_In_School_By_Teacher CT INNER JOIN Courses_Offered_By_Levels CL ON CT.course_code = CL.course_code
    WHERE CT.teacher_username = usrname
    ORDER BY level_id ASC, grade ASC;
  END//
DELIMITER ;


# 3 - Post assignments for the course(s) I teach.
# Every assignment has a posting date, due date and content.

DELIMITER //
CREATE PROCEDURE PostAssigmentByTeacher(usrname VARCHAR(50), c_id INT,
                                        s_date  DATETIME, d_date DATETIME, cont TEXT)
  BEGIN
    INSERT INTO Assignments (content, posting_date, due_date, course_code, teacher_username)
    VALUES (cont, s_date, d_date, c_id, usrname);
  END//
DELIMITER ;


# 4 - View the students’ solutions for the assignments I posted ordered by students’ ids.
DELIMITER //
CREATE PROCEDURE TeacherViewAssignmentSolution(usrname VARCHAR(50))
  BEGIN
    SELECT
      student_ssn,
      assignment_id,
      content,
      grade
    FROM Solutions
    WHERE teacher_username = usrname
    ORDER BY student_ssn;
  END//
DELIMITER ;

# 5 - Grade the students’ solutions for the assignments I posted.
DELIMITER //
CREATE PROCEDURE TeacherUpdatesAssignmentGrade(usrname VARCHAR(50), a_id INT, s_ssn INT, gr INT)
  BEGIN
    UPDATE Solutions
    SET grade = gr
    WHERE teacher_username = usrname AND assignment_id = a_id AND student_ssn = s_ssn;
  END//
DELIMITER ;


# 6 - Delete assignments.
DELIMITER //
CREATE PROCEDURE TeacherDeleteAssignment(usrname VARCHAR(50), a_id INT)
  BEGIN
    DELETE FROM Assignments
    WHERE id = a_id AND teacher_username = usrname;
  END//
DELIMITER ;


# 7- Write monthly reports about every student I teach.
# A report is issued on a specific date to a specific student and contains my comment.

DELIMITER //
CREATE PROCEDURE ReportAboutStudentByTeacher(usrname VARCHAR(50), content TEXT, p_date DATETIME, s_ssn INT)
  BEGIN
    IF (s_ssn IN
        (SELECT CTS.student_ssn
         FROM Courses_Taken_By_Students CTS INNER JOIN Courses_Taught_In_School_By_Teacher C
             ON CTS.course_code = C.course_code
         WHERE C.teacher_username = usrname
        ))
    THEN
      INSERT INTO Reports_About_Students (teacher_username, student_ssn, date, teacher_comment)
      VALUES (usrname, s_ssn, p_date, content);
    END IF;
  END//
DELIMITER ;


# 8 - View the questions asked by the students for each course I teach.
DELIMITER //
CREATE PROCEDURE Teacher_View_Questions(usrname VARCHAR(50))
  BEGIN
    SELECT
      Q.id,
      CQS.student_ssn,
      CQS.course_code,
      Q.title,
      Q.content
    FROM Courses_Questions_From_Students CQS INNER JOIN Questions Q ON Q.id = CQS.question_id
      INNER JOIN Courses_Taught_In_School_By_Teacher CTBT ON CQS.course_code = CTBT.course_code
    WHERE CTBT.teacher_username = usrname;
  END//
DELIMITER ;


# 9 - Answer the questions asked by the students for each course I teach.
DELIMITER //
CREATE PROCEDURE Teacher_Answer_Questions(usrname VARCHAR(50), q_id INT, ans TEXT)
  BEGIN
    IF
    EXISTS(
        SELECT Q.id
        FROM Courses_Questions_From_Students CQS INNER JOIN Questions Q ON Q.id = CQS.question_id
          INNER JOIN Courses_Taught_In_School_By_Teacher CTBT ON CQS.course_code = CTBT.course_code
        WHERE CTBT.teacher_username = usrname AND Q.id = q_id
    )
    THEN
      UPDATE Questions
      SET Questions.answer = ans, Questions.teacher_username = usrname
      WHERE Questions.id = q_id;
    END IF;
  END//
DELIMITER ;

# 10 - View a list of students that I teach categorized by the grade
#  and ordered by their name (first name and last name).

DELIMITER //
CREATE PROCEDURE Teacher_list_Students(usrname VARCHAR(50))
  BEGIN
    SELECT
      Children.first_name,
      Children.last_name,
      CL.level_id,
      CL.grade,
      CT.course_code
    FROM
      Courses_Taught_In_School_By_Teacher CT INNER JOIN Courses_Offered_By_Levels CL ON CT.course_code = CL.course_code
      INNER JOIN Courses_Taken_By_Students CTS ON CTS.course_code = CT.course_code
      INNER JOIN Children ON Children.ssn = CTS.student_ssn
    WHERE CT.teacher_username = usrname
    ORDER BY grade ASC, first_name ASC, last_name ASC;
  END//
DELIMITER ;


# 11 - View a list of students that did not join any activity.
DELIMITER //
CREATE PROCEDURE TeacherViewStudentsWithNoActivities()
  BEGIN
    SELECT
      child_ssn,
      first_name,
      last_name
    FROM Students
      INNER JOIN Children ON Students.child_ssn = Children.ssn
    WHERE child_ssn NOT IN (SELECT student_ssn
                            FROM Activities_Participated_In_By_Students);
  END//
DELIMITER ;

# 12 - Display the name of the high school student who
# is currently a member of the greatest number of clubs.
DROP PROCEDURE IF EXISTS ViewStudentWithHighestClubs;
DELIMITER //
CREATE PROCEDURE ViewStudentWithHighestClubs(usrname VARCHAR(50))
  BEGIN

    SELECT
      S.child_ssn,
      C.first_name,
      C.last_name,
      C.age,
      C.gender,
      COUNT(*)
    FROM Students S INNER JOIN Clubs_Joined_By_Students CJS
        ON S.child_ssn = CJS.student_ssn
      INNER JOIN Employees E
        ON S.school_id = E.school_id
      INNER JOIN Children C
        ON C.ssn = S.child_ssn
    WHERE E.username = usrname
    GROUP BY S.child_ssn
    HAVING COUNT(*) = (SELECT max(X)
                       FROM (SELECT count(*) AS X
                             FROM Students S2 INNER JOIN Clubs_Joined_By_Students CJS2
                                 ON S2.child_ssn = CJS2.student_ssn
                               INNER JOIN Employees E2
                                 ON S2.school_id = E2.school_id
                             WHERE E2.username = usrname
                             GROUP BY S2.child_ssn) AS Y);

  END //
DELIMITER ;


# -----------------------------------------------------------------------------------------

USE M3_School;

# “As a Parent, I should be able to ...”


  END//
DELIMITER ;

# 1.2 - provide  mobile number(s).
DELIMITER //
CREATE PROCEDURE ParentAddPhoneNumber(usrname VARCHAR(50), pnumber VARCHAR(50))
  BEGIN# 1.1 - Sign up by providing my name (first name and last name), contact email,
# address, home phone number, a unique username and password.

DELIMITER //
CREATE PROCEDURE Parent_Signup(fname   VARCHAR(50), lname VARCHAR(50), e_mail VARCHAR(50), addres VARCHAR(50),
                               hnumber INT, usrname VARCHAR(50), pass VARCHAR(100))
  BEGIN

    INSERT INTO Parents (username, password, first_name, last_name, email, address, home_number)
    VALUES (usrname, pass, fname, lname, e_mail, addres, hnumber);


    INSERT INTO Parent_Phone_Numbers (parent_username, telephone_number)
    VALUES (usrname, pnumber);

  END//
DELIMITER ;


# 2 - Apply for my children in any school. For each child I should provide his/her
# social security number (SSN), name, birthdate, and gender.

DELIMITER //
CREATE PROCEDURE ParentApplyForChildren(usrname VARCHAR(50), c_ssn INT,
                                        b_date  DATETIME, gen VARCHAR(10), s_id INT,
                                        f_name  VARCHAR(50), l_name VARCHAR(50))
  BEGIN

    INSERT INTO Children (ssn, first_name, last_name, birth_date, gender)
    VALUES (c_ssn, f_name, l_name, b_date, gen);
    INSERT INTO Children_Have_Parents (child_ssn, parent_username)
    VALUES (c_ssn, usrname);
    INSERT INTO Children_Applied_For_By_Parents_In_Schools (parent_username, school_id, child_ssn)
    VALUES (usrname, s_id, c_ssn);

  END//
DELIMITER ;


# 3 - View a list of schools that accepted my children categorized by child.

DROP PROCEDURE IF EXISTS View_Schools;
DELIMITER //
CREATE PROCEDURE ViewSchools(usrname VARCHAR(50))
  BEGIN

    SELECT
      CAPS.child_ssn,
      S.name
    FROM Parents P INNER JOIN Children_Applied_For_By_Parents_In_Schools CAPS
        ON P.username = CAPS.parent_username
      INNER JOIN Schools S ON CAPS.school_id = S.id
    WHERE CAPS.parent_username = usrname AND CAPS.status = 1
    ORDER BY CAPS.child_ssn;

  END//
DELIMITER ;

USE M3_School;
DELIMITER //
CREATE PROCEDURE ViewTeachers(usrname VARCHAR(50))
  BEGIN

    SELECT
      CTS.teacher_username,
      E.first_name,
      E.last_name

    FROM Parents P INNER JOIN Children_Have_Parents CHP  ON P.username = CHP.parent_username
      INNER JOIN Courses_Taken_By_Students CTBS ON CTBS.student_ssn = CHP.child_ssn
      INNER JOIN  Courses_Taught_In_School_By_Teacher CTS  ON CTS.course_code = CTBS.course_code
      INNER JOIN  Employees E ON CTS.teacher_username = E.username

    ORDER BY CHP.child_ssn;

  END//
DELIMITER ;



# 4 - Choose one of the schools that accepted my child to enroll him/her. The child remains unverified
# (no username and password, refer to user story 2 for the administrator) until the admin verifies him.
# Need to display the schools that accepted My child

DELIMITER //
CREATE PROCEDURE Accepted_In_School(c_ssn INT)
  BEGIN
    SELECT school_id
    FROM Children_Applied_For_By_Parents_In_Schools
    WHERE status = 1 AND child_ssn = c_ssn;
  END//
DELIMITER ;


DELIMITER //
CREATE PROCEDURE ChooseSchool(c_ssn INT, s_id INT)
  BEGIN
    INSERT INTO Students (child_ssn, school_id)
    VALUES (c_ssn, s_id);
  END//
DELIMITER ;


# 5 - View reports written about my children by their teachers.

DELIMITER //
CREATE PROCEDURE ViewReports(usrname VARCHAR(50))
  BEGIN

    SELECT
      C.first_name,
      RAS.date,
      E.first_name,
      E.middle_name,
      E.last_name,
      RAS.teacher_comment
    FROM Reports_About_Students RAS INNER JOIN Children_Have_Parents CHP
        ON RAS.student_ssn = CHP.child_ssn
      INNER JOIN Children C ON CHP.child_ssn = C.ssn
      INNER JOIN Employees E ON RAS.teacher_username = E.username
    WHERE CHP.parent_username = usrname;

  END//
DELIMITER ;

# 6 - Reply to reports written about my children by their teachers.

DELIMITER //
CREATE PROCEDURE ReplyToReports(c_ssn INT, t_usrname VARCHAR(50), datee DATETIME, rep TEXT)
  BEGIN

    UPDATE Reports_About_Students
    SET parent_reply = rep
    WHERE student_ssn = c_ssn AND teacher_username = t_usrname
          AND date = datee;

  END//
DELIMITER ;

# 7 - View a list of all schools of all my children ordered by its name.

DELIMITER //
CREATE PROCEDURE ViewSchoolsList(usrname VARCHAR(50))
  BEGIN

    SELECT
      SC.name,
      SC.address,
      SC.email,
      SC.fees,
      SC.general_info,
      SC.main_language,
      SC.mission,
      SC.type,
      SC.vision
    FROM Students S INNER JOIN Children_Have_Parents CHP
        ON S.child_ssn = CHP.child_ssn
      INNER JOIN Schools SC ON S.school_id = SC.id
    WHERE CHP.parent_username = usrname
    ORDER BY SC.name;

  END//
DELIMITER ;

use M3_School;
DELIMITER //
CREATE PROCEDURE ViewSchoolsList2(usrname VARCHAR(50))
  BEGIN

    SELECT
      CHP.child_ssn,
      SC.name,
      SC.address,
      SC.email,
      SC.fees,
      SC.general_info,
      SC.main_language,
      SC.mission,
      SC.type,
      SC.vision
    FROM Students S INNER JOIN Children_Have_Parents CHP
        ON S.child_ssn = CHP.child_ssn
      INNER JOIN Schools SC ON S.school_id = SC.id
    WHERE CHP.parent_username = usrname
    ORDER BY SC.name;

  END//
DELIMITER ;

# 8 - View the announcements posted within the past 10 days
# about a school if one of my children is enrolled in it.
DELIMITER //
CREATE PROCEDURE ParentViewAnnouncements(usrname VARCHAR(50), s_id INT)
  BEGIN
    IF (s_id NOT IN (
      SELECT S.school_id
      FROM Children_Have_Parents CHP INNER JOIN Students S
          ON CHP.child_ssn = S.child_ssn
      WHERE CHP.parent_username = usrname
    ))
    THEN SELECT 'You dont have children in this school';
    ELSE
      SELECT
        A.title,
        A.date,
        A.type,
        A.description
      FROM Announcements A INNER JOIN Employees E
          ON A.administrator_username = E.username
      WHERE E.school_id = s_id;

    END IF;
  END//
DELIMITER ;

# 9 - Rate any teacher that teaches my children.

DELIMITER //
CREATE PROCEDURE RateTeachers(usrname VARCHAR(50), tusrname VARCHAR(50), rate INT)
  BEGIN
    INSERT INTO Parents_Rate_Teachers (parent_username, teacher_username, rating)
    VALUES (usrname, tusrname, rate);
  END//
DELIMITER ;

# 10 - Write reviews about my children’s school(s).

DELIMITER //
CREATE PROCEDURE ReviewSchools(usrname VARCHAR(50), s_id INT, preview TEXT)
  BEGIN
    INSERT INTO Parents_Review_Schools (parent_username, school_id, review)
    VALUES (usrname, s_id, preview);
  END//
DELIMITER ;

# 11 - Delete a review that i have written.

DELIMITER //
CREATE PROCEDURE DeleteReview(usrname VARCHAR(50), s_id INT)
  BEGIN
    DELETE FROM Parents_Review_Schools
    WHERE parent_username = usrname AND school_id = s_id;
  END//
DELIMITER ;
use M3_School;
DELIMITER //
CREATE PROCEDURE FindReview(usrname VARCHAR(50))
  BEGIN
    SELECT  school_id,review
    From Parents_Review_Schools
    WHERE parent_username = usrname;
  END//
DELIMITER ;

# 12 - View the overall rating of a teacher, where the overall rating
# is calculated as the average of ratings provided by parents to that teacher.

DELIMITER //
CREATE PROCEDURE ViewRating(tusrname VARCHAR(50))
  BEGIN

    SELECT AVG(rating)
    FROM Parents_Rate_Teachers
    WHERE teacher_username = tusrname;

  END//
DELIMITER ;

# 13.1 - View the top 10 schools with the highest number of reviews
# This should exclude schools that my children are enrolled in.

DELIMITER //
CREATE PROCEDURE ViewHighestSchoolsByReviews(usrname VARCHAR(50))
  BEGIN

    SELECT
      S.name,
      S.address,
      S.email,
      S.fees,
      S.general_info,
      S.main_language,
      S.mission,
      S.type,
      S.vision
    FROM Schools S INNER JOIN Parents_Review_Schools PRS
        ON PRS.school_id = S.id
    WHERE S.id NOT IN (
      SELECT St.school_id
      FROM Children_Have_Parents CHP INNER JOIN Students St
          ON CHP.child_ssn = St.child_ssn
      WHERE CHP.parent_username = usrname
    )
    GROUP BY S.id
    ORDER BY COUNT(*) DESC
    LIMIT 10;

  END//
DELIMITER ;

# 13.2 - View the top 10 schools with the highest number of enrolled students
# This should exclude schools that my children are enrolled in.

DELIMITER //
CREATE PROCEDURE ViewHighestSchoolsByEnrolledStudents(usrname VARCHAR(50))
  BEGIN

    SELECT
      S.name,
      S.address,
      S.email,
      S.fees,
      S.general_info,
      S.main_language,
      S.mission,
      S.type,
      S.vision
    FROM Schools S INNER JOIN Students St
        ON St.school_id = S.id
    WHERE S.id NOT IN (
      SELECT St.school_id
      FROM Children_Have_Parents CHP INNER JOIN Students St
          ON CHP.child_ssn = St.child_ssn
      WHERE CHP.parent_username = usrname
    )
    GROUP BY S.id
    ORDER BY COUNT(*) DESC
    LIMIT 10;

  END//
DELIMITER ;

# 14 - Find the international school which has a reputation higher
# than all national schools, i.e. has the highest number of reviews.
DELIMITER //
DROP PROCEDURE IF EXISTS ViewInternationalSchools;
CREATE PROCEDURE ViewInternationalSchools()
  BEGIN

    DECLARE mx INT DEFAULT 0;
    SELECT max(X)
    INTO mx
    FROM ((SELECT count(*) AS X
           FROM Schools S INNER JOIN Parents_Review_Schools PRS
               ON S.id = PRS.school_id
           WHERE S.type = 'national'
           GROUP BY S.id
          ) AS Y);

    IF mx IS NULL
    THEN
      SET mx = 0;
    END IF;
    SELECT
      S.name,
      S.address,
      S.email,
      S.fees,
      S.general_info,
      S.main_language,
      S.mission,
      S.type,
      S.vision
    FROM Schools S INNER JOIN Parents_Review_Schools PRS
        ON S.id = PRS.school_id
    WHERE S.type = 'International'
    GROUP BY S.id
    HAVING COUNT(*) > mx;

  END //
DELIMITER ;

# -----------------------------------------------------------------------------------------

USE M3_School;

# “As a enrolled student, I should be able to ...”

# 1 - Update my account information except for the username.

DROP PROCEDURE IF EXISTS UpdateMyAccount;
DELIMITER //
CREATE PROCEDURE UpdateMyAccount(usrname VARCHAR(50), pass VARCHAR(100), f_name VARCHAR(50), l_name VARCHAR(50),
                                 bdate   DATETIME, gen VARCHAR(10))
  BEGIN
    DECLARE db_ssn INT DEFAULT 0;

    SELECT child_ssn
    INTO db_ssn
    FROM Students
    WHERE username = usrname;

    IF (gen IS NOT NULL)
    THEN
      UPDATE Children
      SET gender = gen
      WHERE ssn = db_ssn;
    END IF;

    IF (pass IS NOT NULL)
    THEN UPDATE Students
    SET password = pass
    WHERE child_ssn = db_ssn;
    END IF;

    IF (f_name IS NOT NULL)
    THEN UPDATE Children
    SET first_name = f_name
    WHERE ssn = db_ssn;
    END IF;


    IF (l_name IS NOT NULL)
    THEN UPDATE Children
    SET last_name = l_name
    WHERE ssn = db_ssn;
    END IF;

    IF (bdate IS NOT NULL)
    THEN UPDATE Children
    SET birth_date = bdate
    WHERE ssn = db_ssn;
    END IF;

  END//
DELIMITER ;

# 2 -  View a list of courses’ names assigned to me based on my grade ordered by name.
DELIMITER //
CREATE PROCEDURE ViewCoursesNames(usrname VARCHAR(50))
  BEGIN
    DECLARE q_grade INT DEFAULT 0;

    SELECT grade
    INTO q_grade
    FROM Students
    WHERE username = usrname;

    SELECT
      C.name,
      C.code,
      C.description,
      COL.grade,
      COL.grade
    FROM Courses_Offered_By_Levels COL INNER JOIN Courses C ON C.code = COL.course_code
    WHERE COL.grade = q_grade
    ORDER BY C.name;

  END//
DELIMITER ;


# 3 - Post questions I have about a certain course.
DELIMITER //
CREATE PROCEDURE PostQuestionsOnCourses(usrname VARCHAR(50), tit VARCHAR(50), cont VARCHAR(50))
  BEGIN
    DECLARE db_ssn INT DEFAULT 0;

    SELECT child_ssn
    INTO db_ssn
    FROM Students
    WHERE username = usrname;

    INSERT INTO Questions (title, content)
    VALUES (tit, cont);
  END//
DELIMITER ;

# 3.1 will add the question in the another table the
# question id will come from php
DELIMITER //
CREATE PROCEDURE PostQuestionsOnCourses2(usrname VARCHAR(50), q_id INT, c_code INT)
  BEGIN
    DECLARE db_ssn INT DEFAULT 0;

    SELECT child_ssn
    INTO db_ssn
    FROM Students
    WHERE username = usrname;

    INSERT INTO Courses_Questions_From_Students (student_ssn, question_id, course_code)
    VALUES (db_ssn, q_id, c_code);
  END//
DELIMITER ;

# 4 - View all questions asked by other students on a certain course along with their answers.
DROP PROCEDURE IF EXISTS ViewQuestions;
DELIMITER //
CREATE PROCEDURE ViewQuestions(usrname VARCHAR(50), c_code INT)
  BEGIN
    SELECT
      Q.title,
      Q.content,
      Q.answer,
      CQFS.course_code
    FROM Questions Q INNER JOIN Courses_Questions_From_Students CQFS
        ON Q.id = CQFS.question_id
    WHERE CQFS.course_code = c_code;

  END//
DELIMITER ;

# 5 - View the assignments posted for the courses I take.
DELIMITER //
CREATE PROCEDURE ViewAssignments(usrname VARCHAR(50))
  BEGIN
    DECLARE db_ssn INT DEFAULT 0;

    SELECT child_ssn
    INTO db_ssn
    FROM Students
    WHERE username = usrname;

    SELECT
      A.course_code,
      A.content,
      A.posting_date,
      A.due_date
    FROM Courses_Taken_By_Students CTS INNER JOIN Assignments A
        ON CTS.course_code = A.course_code
    WHERE CTS.student_ssn = db_ssn;

  END //
DELIMITER ;

# 6 - Solve assignments posted for courses I take.
DELIMITER //
CREATE PROCEDURE SolveAssignments(usrname VARCHAR(50), a_id INT, ans TEXT)
  BEGIN
    DECLARE db_ssn INT DEFAULT 0;
    DECLARE tchr_usrname VARCHAR(20);

    SELECT child_ssn
    INTO db_ssn
    FROM Students
    WHERE username = usrname;

    SELECT teacher_username
    INTO tchr_usrname
    FROM Assignments
    WHERE id = a_id;

    INSERT INTO Solutions (student_ssn, assignment_id, teacher_username, content, grade)
    VALUES (db_ssn, a_id, tchr_usrname, ans, NULL);
  END //
DELIMITER ;

# 7 - View the grade of the assignments I solved per course.
DELIMITER //
CREATE PROCEDURE ViewAssignmentsGrades(usrname VARCHAR(50))
  BEGIN
    DECLARE db_ssn INT DEFAULT 0;

    SELECT child_ssn
    INTO db_ssn
    FROM Students
    WHERE username = usrname;

    SELECT
      A.course_code,
      A.content,
      A.posting_date,
      A.due_date,
      S.content,
      S.grade
    FROM Assignments A INNER JOIN Solutions S
        ON A.id = S.assignment_id
    WHERE S.student_ssn = db_ssn
    ORDER BY A.course_code;

  END //
DELIMITER ;

# 8 - View the announcements posted within the past 10 days
# About the school I am enrolled in.
DELIMITER //
CREATE PROCEDURE ViewAnnouncements(usrname VARCHAR(50))
  BEGIN
    DECLARE sch_id INT DEFAULT 0;

    SELECT school_id
    INTO sch_id
    FROM Students S
    WHERE username = usrname;

    SELECT
      A.title,
      A.description,
      A.type,
      A.date
    FROM Announcements A INNER JOIN Employees E
        ON A.administrator_username = E.username
    WHERE E.school_id = sch_id AND A.date >= (CURDATE() - INTERVAL 10 DAY);

  END //
DELIMITER ;

# 9 - View all the information about activities offered by my school,
# As well as the teacher responsible for it.
DELIMITER //
CREATE PROCEDURE ViewActivities(usrname VARCHAR(50))
  BEGIN
    DECLARE sch_id INT DEFAULT 0;

    SELECT school_id
    INTO sch_id
    FROM Students S
    WHERE username = usrname;

    SELECT
      A.type,
      A.description,
      A.equipment,
      A.date,
      A.location,
      E.first_name,
      E.middle_name,
      E.last_name
    FROM Activities A INNER JOIN Employees E
        ON A.teacher_username = E.username
    WHERE E.school_id = sch_id;
  END //
DELIMITER ;

# 10 - Apply for activities in my school on the condition that
# I can not join two activities of the same type on the same date.
DELIMITER //
CREATE PROCEDURE ApplyForActivity(usrname VARCHAR(50), a_id INT)
  BEGIN
    DECLARE db_ssn INT DEFAULT 0;

    SELECT child_ssn
    INTO db_ssn
    FROM Students
    WHERE username = usrname;

    IF (EXISTS(
        SELECT *
        FROM Activities A1 INNER JOIN Activities A2 ON A1.id <> A2.id
          INNER JOIN Activities_Participated_In_By_Students APS ON A2.id = APS.activity_id
        WHERE APS.student_ssn = db_ssn AND A1.id = a_id AND A1.date = A2.date AND A1.type = A2.type
    ))
    THEN
      SELECT 'Cannot JOIN';
    ELSE
      INSERT INTO Activities_Participated_In_By_Students
      (activity_id, student_ssn) VALUES (a_id, db_ssn);
    END IF;

  END //
DELIMITER ;

# 11 - Join clubs offered by my school, if I am a high school student.
DELIMITER //
CREATE PROCEDURE JoinClubs(usrname VARCHAR(50), c_name VARCHAR(15))
  BEGIN
    DECLARE db_ssn INT DEFAULT 0;
    DECLARE sch_id INT DEFAULT 0;

    SELECT child_ssn
    INTO db_ssn
    FROM Students
    WHERE username = usrname;

    SELECT school_id
    INTO sch_id
    FROM Students
    WHERE username = usrname;

    IF (sch_id NOT IN (SELECT school_id
                       FROM High_Schools))
    THEN
      SELECT 'You are not old enough';
    ELSE
      INSERT INTO Clubs_Joined_By_Students (student_ssn, club_name, high_school_id)
      VALUES (db_ssn, c_name, sch_id);
    END IF;
  END //
DELIMITER ;

# 12 - Search in a list of courses that i take by .....

# a. its name
DELIMITER //
CREATE PROCEDURE SearchCourseByName(usrname VARCHAR(50), c_name VARCHAR(15))
  BEGIN
    DECLARE db_ssn INT DEFAULT 0;
    DECLARE sch_id INT DEFAULT 0;

    SELECT child_ssn
    INTO db_ssn
    FROM Students
    WHERE username = usrname;

    SELECT
      C.code,
      C.name,
      C.description
    FROM Courses_Taken_By_Students CTS INNER JOIN Courses C
        ON CTS.course_code = C.code
    WHERE CTS.student_ssn = db_ssn AND C.name = c_name;
  END //
DELIMITER ;


# b. its code
DELIMITER //
CREATE PROCEDURE SearchCourseByCode(usrname VARCHAR(50), c_code INT)
  BEGIN
    DECLARE db_ssn INT DEFAULT 0;
    DECLARE sch_id INT DEFAULT 0;

    SELECT child_ssn
    INTO db_ssn
    FROM Students
    WHERE username = usrname;

    SELECT
      C.code,
      C.name,
      C.description
    FROM Courses_Taken_By_Students CTS INNER JOIN Courses C
        ON CTS.course_code = C.code
    WHERE CTS.student_ssn = db_ssn AND C.code = c_code;
  END //
DELIMITER ;
