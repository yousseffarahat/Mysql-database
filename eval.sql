USE M3_School;

CREATE TABLE Buses(
  bus_number int PRIMARY KEY ,
  route VARCHAR(50),
  model VARCHAR(50),
  capacity INT
);

CREATE TABLE Buses_Joined_By_Students(
  bus_no int,
  childssn int UNIQUE ,
  PRIMARY KEY (bus_no,childssn),
  FOREIGN KEY (bus_no) REFERENCES Buses(bus_number) ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY (childssn) REFERENCES Students(child_ssn) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Buses_Belonging_To_Schools(
  bus_no int UNIQUE ,
  s_id INT,
  PRIMARY KEY (bus_no,s_id),
  FOREIGN KEY (bus_no) REFERENCES Buses(bus_number)ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY (s_id) REFERENCES Schools(id) ON UPDATE CASCADE ON DELETE CASCADE
)


DELIMITER //
CREATE PROCEDURE Insert_Bus_Info(busno INT,busroute VARCHAR(50),busmodel VARCHAR(50),buscapacity INT,sid INT)
BEGIN

  IF exists(SELECT *
            FROM Buses_Belonging_To_Schools
            WHERE s_id = sid
  )THEN
    select'';
    ELSE

    INSERT INTO Buses(bus_number, route, model, capacity) VALUES (busno,busroute,busmodel,buscapacity);
  INSERT INTO Buses_Belonging_To_Schools(bus_no, s_id) VALUES (busno,sid);

    END IF ;
END//
DELIMITER;

DELIMITER //
create PROCEDURE Student_Bus_Register(busno INT,childid INT)
  BEGIN
    INSERT INTO Buses_Joined_By_Students(bus_no, childssn) VALUES (busno,childid);
  END //
Delimiter;

CALL Insert_Bus_Info(3,'maadi','A1',20,3);
CALL Insert_Bus_Info(4,'maadi','A1',30,3);
CALL Insert_Bus_Info(5,'maadi','A1',70,3);
CALL Insert_Bus_Info(6,'maadi','A1',80,4);

CALL Student_Bus_Register(1,1);
CALL Student_Bus_Register(2,1);


SELECT AVG(B.capacity),BS.s_id
FROM Buses B INNER JOIN Buses_Belonging_To_Schools BS ON B.bus_number = BS.bus_no
GROUP BY BS.s_id