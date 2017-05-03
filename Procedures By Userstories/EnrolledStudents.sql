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

    IF (gen IS NOT NULL ) THEN
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
    WHERE CQFS.course_code = c_code ;

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
