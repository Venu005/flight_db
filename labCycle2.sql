-- STRONG ENTITIES
create table AIRPORT (
    Airport_code int PRIMARY KEY,
    City varchar(20),
    State VARCHAR(20),
    Name VARCHAR(20)
);
create table AIRPLANE_TYPE (
    Type_name VARCHAR(20) PRIMARY KEY,
    Max_seats int,
    Company VARCHAR(20)
);
create table AIRPLANE (
  Airplane_id int PRIMARY KEY,
  Total_no_of_seats int 
);
create table FLIGHT (
    Flight_Number int PRIMARY KEY,
    Airline VARCHAR(20),
    Weekdays VARCHAR(20)
);
-- WEAK ENTITIES

-- easiest is fare 
create table FARE (
    Code int,
    Amount int,
    Flight_Number int,
    FOREIGN KEY(Flight_Number) REFERENCES FLIGHT(Flight_Number),
    PRIMARY KEY (Code, Flight_Number)
);
-- flight leg,

create  table FLIGHT_LEG(
    Leg_no int,
    Flight_Number int,
    FOREIGN KEY (Flight_Number) REFERENCES FLIGHT(Flight_Number),
    PRIMARY KEY (Leg_no, Flight_Number)
);
--leg instance
create table LEG_INSTANCE(
    Date_created DATE,
    No_of_avail_seats int,
    Leg_no int,
    Flight_Number int,

    FOREIGN KEY (Flight_Number) REFERENCES FLIGHT(Flight_Number),
    FOREIGN KEY (leg_no, Flight_Number) REFERENCES FLIGHT_LEG(leg_no, Flight_Number),
    PRIMARY KEY (Date_created, leg_no, Flight_Number)

);

-- seat
create table SEAT (
    Seat_no int,
    Date_created DATE,
    Leg_no int,
    Flight_Number int,
    FOREIGN KEY(Date_created, Leg_no, Flight_Number) REFERENCES LEG_INSTANCE(Date_created, Leg_no, Flight_Number),
    FOREIGN KEY (Leg_no, Flight_Number) REFERENCES FLIGHT_LEG(leg_no, Flight_Number),
    FOREIGN KEY (Flight_Number) REFERENCES FLIGHT(Flight_Number),
    PRIMARY KEY(Seat_no, Date_created, Leg_no, Flight_Number)
);

-- 1:n relationship between airport and flight_leg
ALTER TABLE FLIGHT_LEG 
ADD(
    Departure_Airport_Code int,
    Arrival_Airport_Code  int,
    Scheduled_dep_time TIMESTAMP,
    Scheduled_arr_time TIMESTAMP
);
-- foreign key constraints
ALTER TABLE FLIGHT_LEG
ADD CONSTRAINT fk_departure_airport_code
FOREIGN KEY(Departure_Airport_Code) REFERENCES AIRPORT(Airport_code);

ALTER TABLE FLIGHT_LEG
ADD CONSTRAINT fk_arrival_airport_code
FOREIGN KEY(Arrival_Airport_Code) REFERENCES AIRPORT(Airport_Code);

--m : n relation ship
create table CAN_LAND(
    Airport_Code int,
    Type_name VARCHAR(20),
    FOREIGN KEY(Airport_Code) REFERENCES AIRPORT(Airport_Code),
    FOREIGN KEY(Type_name) REFERENCES AIRPLANE_TYPE(Type_name),
    PRIMARY KEY (Airport_Code, Type_name)
);

-- TYPE RELATION (1:n) between AIRPLANE_TYPE and AIRPLANE
ALTER TABLE AIRPLANE
ADD (
    Type_name VARCHAR(20)

);
ALTER TABLE AIRPLANE
ADD CONSTRAINT fk_type_name
FOREIGN KEY(Type_name) REFERENCES AIRPLANE_TYPE(Type_name);

-- ASSIGNED RELATION (1:n) between AIRPLANE AND LEG_INSTANCE
ALTER TABLE LEG_INSTANCE
ADD (
    Airplane_id int 
);
ALTER TABLE LEG_INSTANCE
ADD CONSTRAINT fk_Airplane_id
FOREIGN KEY(Airplane_id) REFERENCES AIRPLANE(Airplane_id);

-- relation reservation between LEG_INSTANCE and SEAT
ALTER table SEAT
Add(
    Customer_name VARCHAR(20),
    Customer_phone VARCHAR(20)
);

Alter table SEAT
Add CONSTRAINT fk_leg_instance
FOREIGN KEY (Date_created, Leg_no, Flight_Number) REFERENCES LEG_INSTANCE(Date_created, Leg_no, Flight_Number);




-- --arrival relation (1:n) between airport and each leg_instance

-- ALTER TABLE LEG_INSTANCE
-- ADD CONSTRAINT fk_arrival_airport_code
-- FOREIGN KEY(Arrival_Airport_Code) REFERENCES AIRPORT(Airport_Code);

-- --departure relation (1:n) between airport and each leg_instance

-- ALTER TABLE LEG_INSTANCE
-- ADD CONSTRAINT fk_departure_airport_code
-- FOREIGN KEY(Departure_Airport_Code) REFERENCES AIRPORT(Airport_Code);


-- Insert into AIRPORT
INSERT INTO AIRPORT(Airport_code, City, State, Name) 
VALUES (1, 'New York', 'NY', 'JFK');


-- Insert into AIRPLANE_TYPE
INSERT INTO AIRPLANE_TYPE(Type_name, Max_seats, Company) 
VALUES ('Boeing 747', 416, 'Boeing');

SELECT * FROM AIRPLANE_TYPE;
-- Insert into AIRPLANE
INSERT INTO AIRPLANE(Airplane_id, Total_no_of_seats, Type_name) 
VALUES (1, 416, 'Boeing 747');

SELECT * FROM AIRPLANE;
-- Insert into FLIGHT
INSERT INTO FLIGHT(Flight_Number, Airline, Weekdays) 
VALUES (1, 'Delta', 'Mon, Wed, Fri');

SELECT * FROM FLIGHT;
-- Insert into FARE
INSERT INTO FARE(Code, Amount, Flight_Number) 
VALUES (1, 200, 1);

-- Insert into FLIGHT_LEG
INSERT INTO FLIGHT_LEG(Leg_no, Flight_Number, Departure_Airport_Code, Arrival_Airport_Code, Scheduled_dep_time, Scheduled_arr_time) 
VALUES (1, 1, 1, 1, TO_TIMESTAMP('2022-01-01 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2022-01-01 14:00:00', 'YYYY-MM-DD HH24:MI:SS'));

-- Insert into LEG_INSTANCE
INSERT INTO LEG_INSTANCE(Date_created, No_of_avail_seats, Leg_no, Flight_Number, Airplane_id) 
VALUES (TO_DATE('2022-01-01', 'YYYY-MM-DD'), 416, 1, 1, 1);

-- Insert into SEAT
INSERT INTO SEAT(Seat_no, Date_created, Leg_no, Flight_Number, Customer_name, Customer_phone) 
VALUES (1, TO_DATE('2022-01-01', 'YYYY-MM-DD'), 1, 1, 'Venusai', '8897628405');

-- Insert into CAN_LAND
INSERT INTO CAN_LAND(Airport_Code, Type_name) 
VALUES (1, 'Boeing 747');

SELECT * FROM CAN_LAND;

-- Repeat for the second set of data
INSERT INTO AIRPORT(Airport_code, City, State, Name) 
VALUES (2, 'Los Angeles', 'CA', 'LAX');

INSERT INTO AIRPLANE_TYPE(Type_name, Max_seats, Company) 
VALUES ('Airbus A380', 853, 'Airbus');

INSERT INTO AIRPLANE(Airplane_id, Total_no_of_seats, Type_name) 
VALUES (2, 853, 'Airbus A380');

INSERT INTO FLIGHT(Flight_Number, Airline, Weekdays) 
VALUES (2, 'American Airlines', 'Tue, Thu, Sat');

INSERT INTO FARE(Code, Amount, Flight_Number) 
VALUES (2, 300, 2);

INSERT INTO FLIGHT_LEG(Leg_no, Flight_Number, Departure_Airport_Code, Arrival_Airport_Code, Scheduled_dep_time, Scheduled_arr_time) 
VALUES (2, 2, 2, 2, TO_TIMESTAMP('2022-01-02 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2022-01-02 14:00:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO LEG_INSTANCE(Date_created, No_of_avail_seats, Leg_no, Flight_Number, Airplane_id) 
VALUES (TO_DATE('2022-01-02', 'YYYY-MM-DD'), 853, 2, 2, 2);

INSERT INTO SEAT(Seat_no, Date_created, Leg_no, Flight_Number, Customer_name, Customer_phone) 
VALUES (2, TO_DATE('2022-01-02', 'YYYY-MM-DD'), 2, 2, 'Meghana', '0987654321');

INSERT INTO CAN_LAND(Airport_Code, Type_name) 
VALUES (2, 'Airbus A380');

-----

INSERT INTO AIRPORT(Airport_code, City, State, Name) 
VALUES (3, 'Hyderabad', 'TG', 'IND');

INSERT INTO AIRPLANE_TYPE(Type_name, Max_seats, Company) 
VALUES ('Airbus123', 853, 'Airbus');

INSERT INTO AIRPLANE(Airplane_id, Total_no_of_seats, Type_name) 
VALUES (3, 853, 'Airbus123');

INSERT INTO FLIGHT(Flight_Number, Airline, Weekdays) 
VALUES (3, 'Hyderabad Airlines', 'Tue, Thu, Sat, Sun');

INSERT INTO FARE(Code, Amount, Flight_Number) 
VALUES (3, 3000, 3);

INSERT INTO FLIGHT_LEG(Leg_no, Flight_Number, Departure_Airport_Code, Arrival_Airport_Code, Scheduled_dep_time, Scheduled_arr_time) 
VALUES (3, 3, 3, 3, TO_TIMESTAMP('2024-01-02 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-01-02 14:00:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO LEG_INSTANCE(Date_created, No_of_avail_seats, Leg_no, Flight_Number, Airplane_id) 
VALUES (TO_DATE('2024-01-02', 'YYYY-MM-DD'), 800, 3, 3, 3);

INSERT INTO SEAT(Seat_no, Date_created, Leg_no, Flight_Number, Customer_name, Customer_phone) 
VALUES (3, TO_DATE('2024-01-02', 'YYYY-MM-DD'), 3, 3, 'Venusai', '8897628405');

INSERT INTO CAN_LAND(Airport_Code, Type_name) 
VALUES (3, 'Airbus123');
SELECT * from SEAT;



-- --i
-- SELECT Customer_name, COUNT(*) as Seat_Count
-- FROM SEAT
-- GROUP BY Customer_name
-- ORDER BY Seat_Count DESC
-- FETCH FIRST 1 ROWS ONLY;    
-- -- vi
-- select * from AIRPLANE where TOTAL_NO_OF_SEATS > 200;

-- --ix
-- SELECT Company
-- FROM AIRPLANE_TYPE
-- WHERE Type_name = 'Airbus123';

-- --x   
-- SELECT SUM(
--   EXTRACT(HOUR FROM (Scheduled_arr_time - Scheduled_dep_time)) 
-- ) as Total_Hours
-- FROM FLIGHT_LEG
-- WHERE Flight_Number  = 3; -- not perefect i shouldn't be entering the flight number manually 

-- SELECT Company 
-- FROM AIRPLANE_TYPE 
-- WHERE Type_name = (SELECT Type_name FROM AIRPLANE WHERE Airplane_id = (SELECT Airplane_id FROM FLIGHT WHERE Flight_Number = 2));

-- SELECT COUNT(*) 
-- FROM SEAT 
-- WHERE Date_created = '2014-01-01' 
-- AND Flight_Number IN (SELECT Flight_Number FROM FLIGHT_LEG WHERE Departure_Airport_Code = (SELECT Airport_code FROM AIRPORT WHERE City = 'X'));

-- SELECT Flight_Number 
-- FROM FLIGHT_LEG 
-- WHERE Departure_Airport_Code = (SELECT Airport_code FROM AIRPORT WHERE City = 'X');


-- SELECT Flight_Number 
-- FROM FLIGHT 
-- WHERE Weekdays = 'Mon, Tue, Wed, Thu, Fri, Sat, Sun' 
-- AND Flight_Number IN (SELECT Flight_Number FROM FLIGHT_LEG WHERE Departure_Airport_Code = (SELECT Airport_code FROM AIRPORT WHERE City = 'A') 
-- AND Arrival_Airport_Code = (SELECT Airport_code FROM AIRPORT WHERE City = 'B'));

-- SELECT Flight_Number 
-- FROM FLIGHT_LEG 
-- WHERE Departure_Airport_Code = (SELECT Airport_code FROM AIRPORT WHERE City = 'B') 
-- AND Arrival_Airport_Code = (SELECT Airport_code FROM AIRPORT WHERE City = 'M');

-- SELECT SUM(EXTRACT(HOUR FROM (Scheduled_arr_time - Scheduled_dep_time))) as Total_Hours 
-- FROM FLIGHT_LEG 
-- WHERE Flight_Number = (SELECT Flight_Number FROM FLIGHT WHERE Airline = 'Airbus123');