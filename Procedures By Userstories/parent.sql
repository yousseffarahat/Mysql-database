
USE M3_School;

# “As a Parent, I should be able to ...”

# 1.1 - Sign up by providing my name (first name and last name), contact email,
# address, home phone number, a unique username and password.

DELIMITER //
CREATE PROCEDURE Parent_Signup(fname   VARCHAR(50), lname VARCHAR(50), e_mail VARCHAR(50), addres VARCHAR(50),
                               hnumber INT, usrname VARCHAR(50), pass VARCHAR(100))
  BEGIN

    INSERT INTO Parents (username, password, first_name, last_name, email, address, home_number)
    VALUES (usrname, pass, fname, lname, e_mail, addres, hnumber);

  END//
DELIMITER ;

# 1.2 - provide  mobile number(s).
DELIMITER //
CREATE PROCEDURE ParentAddPhoneNumber(usrname VARCHAR(50), pnumber VARCHAR(50))
  BEGIN

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