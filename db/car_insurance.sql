-- Active: 1695560839345@@localhost@32768

-- ==============================================
-- Drop a database
-- ==============================================

DROP DATABASE insurance;


-- ==============================================
-- Create a database
-- ==============================================
CREATE DATABASE insurance;

-- ==============================================
-- Use the database
-- ==============================================
USE insurance;


-- ==============================================
-- Create Owner table
-- ==============================================

CREATE TABLE tbl_owner(
    owner_id INT AUTO_INCREMENT,
    fname VARCHAR (255),
    lname VARCHAR (255),
    PRIMARY KEY(owner_id)
);

-- ==============================================
-- Create Owner Phone table
-- ==============================================

CREATE TABLE tbl_owner_phone(
    phone BIGINT,
    owner_id INT,
    FOREIGN KEY(owner_id) REFERENCES tbl_owner (owner_id)
);

-- ==============================================
-- Create Insurance table
-- ==============================================

CREATE TABLE tbl_insurance(
    insurance_id INT AUTO_INCREMENT,
    status ENUM(
        'OPEN',
        'CLAIMED',
        'PENDING',
        'REJECTED'
    ) DEFAULT 'OPEN',
    valid_till DATETIME,
    amount INT,
    agent_name VARCHAR(255),
    paid_by INT,
    FOREIGN KEY(paid_by) REFERENCES tbl_owner (owner_id),
    PRIMARY KEY (insurance_id)
);

-- SELECT (SELECT valid_till from tbl_insurance WHERE insurance_id = 2) > NOW();

-- SELECT * FROM tbl_insurance WHERE (SELECT valid_till FROM tbl_insurance WHERE insurance_id = 2) > NOW();
-- ==============================================
-- Create Car table
-- ==============================================

CREATE TABLE tbl_car(
    car_id INT AUTO_INCREMENT,
    model VARCHAR(255),
    color VARCHAR(255),
    brand VARCHAR(255),
    year YEAR,
    owner_id INT,
    FOREIGN KEY(owner_id) REFERENCES tbl_owner (owner_id),
    insurance_id INT,
    FOREIGN KEY(insurance_id) REFERENCES tbl_insurance (insurance_id),
    PRIMARY KEY(car_id)
);

-- ==============================================
-- Create Accident table
-- ==============================================

CREATE TABLE tbl_accident(
    accident_id INT AUTO_INCREMENT,
    cause TEXT,
    date DATETIME,
    location VARCHAR(255),
    car_id INT,
    FOREIGN KEY(car_id) REFERENCES tbl_car (car_id),
    PRIMARY KEY (accident_id)
);

-- ==============================================
-- Create Claim table
-- ==============================================

CREATE TABLE tbl_claim(
    claim_id INT AUTO_INCREMENT,
    status ENUM('PENDING', 'APPROVED','REJECTED') DEFAULT 'PENDING',
    filed_by INT NOT NULL,
    FOREIGN KEY(filed_by) REFERENCES tbl_owner (owner_id),
    insurance_id INT NOT NULL,
    FOREIGN KEY(insurance_id) REFERENCES tbl_insurance (insurance_id),
    accident_id INT NOT NULL,
    FOREIGN KEY(accident_id) REFERENCES tbl_accident (accident_id),
    PRIMARY KEY (claim_id),
    UNIQUE KEY (insurance_id, accident_id, filed_by)
);

-- ==============================================
-- Stored Procedures
-- ==============================================
-- Create a stored procedure to insert a new owner
-- ==============================================
DELIMITER // 

DROP PROCEDURE IF EXISTS insert_owner;
CREATE PROCEDURE insert_owner(IN fname VARCHAR(255), IN lname VARCHAR(255)) 
BEGIN
INSERT INTO tbl_owner(fname, lname)
VALUES(fname, lname);
END // DELIMITER;

CALL insert_owner('John', 'Doe');

-- ==============================================
-- Create a stored procedure to insert a new car
-- ==============================================
DELIMITER //
DROP PROCEDURE IF EXISTS insert_car;

CREATE PROCEDURE insert_car(IN model VARCHAR(255), IN color VARCHAR(255), IN brand VARCHAR(255), IN year YEAR, IN owner_id INT)
BEGIN
INSERT INTO tbl_car(model, color, brand, year, owner_id)
VALUES(model, color, brand, year, owner_id);
END // DELIMITER;

CALL insert_car('Model 3', 'Black', 'Tesla', 2021, 1);


-- ==============================================
-- Create a stored procedure to insert a new insurance
-- ==============================================

DELIMITER //
DROP PROCEDURE IF EXISTS create_insurance;
CREATE PROCEDURE create_insurance(IN valid_till DATETIME, IN amount INT, IN agent_name VARCHAR(255), IN paid_by INT)
BEGIN
INSERT INTO tbl_insurance( valid_till, amount, agent_name, paid_by)
VALUES(valid_till, amount, agent_name, paid_by);
END // DELIMITER;

CALL create_insurance('2024-09-01 00:00:00', 10000, 'John Doe', 1);

-- ==============================================
-- Create a stored procedure to insert a new accident
-- ==============================================

DELIMITER //
DROP PROCEDURE IF EXISTS report_accident;

CREATE PROCEDURE report_accident(IN cause TEXT, IN date DATETIME, IN location VARCHAR(255), IN car_id INT)

BEGIN
INSERT INTO tbl_accident(cause, date, location, car_id)
VALUES(cause, date, location, car_id);
END // DELIMITER;

CALL report_accident('Rear Ended', '2021-09-01 00:00:00', 'New York', 1);


-- ==============================================
-- Create a stored procedure to insert a new claim when the insurance is valid
-- ==============================================

DELIMITER //
DROP PROCEDURE IF EXISTS file_claim;

CREATE PROCEDURE file_claim(IN filed_by INT, IN p_insurance_id INT, IN accident_id INT)
BEGIN
IF (SELECT (SELECT valid_till from tbl_insurance WHERE insurance_id =p_insurance_id ) > NOW()) THEN
INSERT INTO tbl_claim(filed_by, insurance_id, accident_id)
VALUES( filed_by, p_insurance_id, accident_id);
ELSE
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Insurance is not valid';
END IF;
END // DELIMITER;

-- CALL file_claim(1, 1, 1);

-- ==============================================
-- Create a stored procedure to approve a claim
-- ==============================================

DELIMITER //
DROP PROCEDURE IF EXISTS approve_claim;

CREATE PROCEDURE approve_claim(IN p_claim_id INT)
BEGIN
UPDATE tbl_claim
SET status = 'APPROVED'
WHERE claim_id = p_claim_id;
END // DELIMITER;

CALL approve_claim(1);


-- ==============================================
-- Create a stored procedure to reject a claim
-- ==============================================

DELIMITER //
DROP PROCEDURE IF EXISTS reject_claim;

CREATE PROCEDURE reject_claim(IN p_claim_id INT)
BEGIN
UPDATE tbl_claim
SET status = 'REJECTED'
WHERE claim_id = p_claim_id;
END // DELIMITER;

CALL reject_claim(1);


-- ==============================================
-- Create a stored procedure to insert a new phone number
-- ==============================================

DELIMITER //
DROP PROCEDURE IF EXISTS insert_phone;

CREATE PROCEDURE insert_phone(IN phone BIGINT, IN owner_id INT)

BEGIN
INSERT INTO tbl_owner_phone(phone, owner_id)
VALUES(phone, owner_id);
END // DELIMITER;

CALL insert_phone(1234567890, 1);

-- ==============================================
-- Create a stored procedure to delete a new phone number
-- ==============================================

DELIMITER //
DROP PROCEDURE IF EXISTS delete_phone;

CREATE PROCEDURE delete_phone(IN phone BIGINT, IN owner_id INT)
BEGIN
DELETE FROM tbl_owner_phone
WHERE phone = phone AND owner_id = owner_id;
END // DELIMITER;

CALL delete_phone(1234567890, 1);



-- ==============================================
-- List of all stored procedures
-- ==============================================

SHOW PROCEDURE STATUS WHERE Db = 'insurance';


-- ==============================================
-- Triggers
-- ==============================================

-- ==============================================
-- Create a trigger to update the insurance status to PENDING when a new claim is filed/inserted
-- ==============================================

DELIMITER //

DROP TRIGGER IF EXISTS update_insurance_status;

CREATE TRIGGER update_insurance_status

AFTER INSERT ON tbl_claim
FOR EACH ROW
BEGIN
UPDATE tbl_insurance
SET status = 'PENDING'
WHERE insurance_id = NEW.insurance_id;
END // DELIMITER;

CALL file_claim(1, 1, 1);

-- ==============================================
-- Create a trigger to update the insurance status to CLAIMED when a claim is approved
-- ==============================================

DELIMITER //

DROP TRIGGER IF EXISTS update_insurance_status_claimed;

CREATE TRIGGER update_insurance_status_claimed

AFTER UPDATE ON tbl_claim
FOR EACH ROW
BEGIN
IF NEW.status = 'APPROVED' THEN
UPDATE tbl_insurance
SET status = 'CLAIMED'
WHERE insurance_id = NEW.insurance_id;
END IF;
END // DELIMITER;

CALL approve_claim(3);

-- ==============================================
-- Create a trigger to update the insurance status to REJECTED when a claim is rejected
-- ==============================================

DELIMITER //

DROP TRIGGER IF EXISTS update_insurance_status_rejected;

CREATE TRIGGER update_insurance_status_rejected
AFTER UPDATE ON tbl_claim
FOR EACH ROW
BEGIN
IF NEW.status = 'REJECTED' THEN
UPDATE tbl_insurance
SET status = 'REJECTED'
WHERE insurance_id = NEW.insurance_id;
END IF;
END // DELIMITER;

CALL reject_claim(3);


-- ==============================================
-- Create a list of triggers
-- ==============================================

SHOW TRIGGERS;


-- ==============================================
-- Views
-- ==============================================

-- ==============================================
-- Create a view to list all the cars with their owners
-- ==============================================

CREATE VIEW vw_cars_owners AS
SELECT c.car_id, c.model, c.color, c.brand, c.year, o.fname, o.lname
FROM tbl_car c
INNER JOIN tbl_owner o
ON c.owner_id = o.owner_id;

SELECT * FROM vw_cars_owners;

-- ==============================================

-- ==============================================
-- Create a view to list all the accidents with their cars
-- ==============================================

CREATE VIEW vw_accidents_cars AS
SELECT a.accident_id, a.cause, a.date, a.location, c.model, c.color, c.brand, c.year
FROM tbl_accident a
INNER JOIN tbl_car c
ON a.car_id = c.car_id;

SELECT * FROM vw_accidents_cars;

-- ==============================================
-- Create a view to list all the claims with their accidents
-- ==============================================

CREATE VIEW vw_claims_accidents AS
SELECT cl.claim_id, cl.status, cl.filed_by, cl.insurance_id, cl.accident_id, a.cause, a.date, a.location
FROM tbl_claim cl
INNER JOIN tbl_accident a
ON cl.accident_id = a.accident_id;

SELECT * FROM vw_claims_accidents;

-- ==============================================
-- Create a view to list total claims of corresponding insurances
-- ==============================================

DROP VIEW IF EXISTS vw_total_claims;

CREATE VIEW vw_total_claims AS
SELECT i.insurance_id, i.agent_name, COUNT(c.claim_id) AS total_claims
FROM tbl_insurance i
INNER JOIN tbl_claim c
ON i.insurance_id = c.insurance_id
GROUP BY i.insurance_id;

SELECT * FROM vw_total_claims;

-- ==============================================
-- Create a view to list the total count of successful claims 
-- by an agent in insurance and return 0 if there is no 
-- successful claims by the agents
-- ==============================================

DROP VIEW IF EXISTS vw_successful_claims;

CREATE VIEW vw_successful_claims AS
SELECT i.agent_name, COUNT(
    CASE WHEN i.status = 'CLAIMED' THEN 1 ELSE NULL END
) AS total_claims
FROM tbl_insurance i
GROUP BY i.agent_name;

SELECT * FROM vw_successful_claims;

-- ==============================================
-- Create a list of all views
-- ==============================================

SHOW FULL TABLES;
SHOW FULL TABLES WHERE TABLE_TYPE LIKE 'VIEW';


