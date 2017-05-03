USE M3_School;

# “As a system user (registered, or not registered),
#  I should be able to ...”

# Returns the school id and name of the school.

DELIMITER //
CREATE PROCEDURE Search_For_School_By_Name(IN schoolName VARCHAR(100))
  BEGIN
    SELECT id,name
    FROM Schools
    WHERE name = schoolName;
  END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Search_For_School_By_Address(IN schoolAddress VARCHAR(100))
  BEGIN
    SELECT id,name
    FROM Schools
    WHERE address = schoolAddress;
  END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Search_For_School_By_Type(IN schoolType VARCHAR(100))
  BEGIN
    SELECT id,name
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