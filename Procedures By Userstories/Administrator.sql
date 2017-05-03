USE M3_School;

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

    SELECT school_id INTO s_id
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

