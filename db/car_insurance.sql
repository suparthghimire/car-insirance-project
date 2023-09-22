-- Active: 1695289794711@@127.0.0.1@3306@db_car_insurance

CREATE TABLE
    tbl_owner(
        owner_id INT AUTO_INCREMENT,
        fname VARCHAR (255),
        lname VARCHAR (255),
        PRIMARY KEY(owner_id)
    )

CREATE TABLE
    tbl_owner_phone(
        phone BIGINT,
        owner_id INT,
        FOREIGN KEY(owner_id) REFERENCES tbl_owner (owner_id)
    )

CREATE TABLE
    tbl_insurance(
        insurance_id INT AUTO_INCREMENT,
        status ENUM(
            'CLAIMED',
            'IN_PROGRESS',
            'REJECTED'
        ),
        valid_till DATETIME,
        amount DECIMAL(10.34, 2),
        agent_name VARCHAR(255),
        paid_by INT,
        FOREIGN KEY(paid_by) REFERENCES tbl_owner (owner_id),
        car_id INT,
        FOREIGN KEY(car_id) REFERENCES tbl_car (car_id),
        PRIMARY KEY (insurance_id)
    )

CREATE TABLE
    tbl_car(
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
    )

CREATE TABLE
    tbl_accident(
        accident_id INT AUTO_INCREMENT,
        cause TEXT,
        date DATETIME,
        location VARCHAR(255),
        car_id INT,
        FOREIGN KEY(car_id) REFERENCES tbl_car (car_id),
        PRIMARY KEY (accident_id)
    )

CREATE TABLE
    tbl_claim(
        claim_id INT AUTO_INCREMENT,
        status ENUM('PENDING', 'APPROVED'),
        filed_by INT,
        FOREIGN KEY(filed_by) REFERENCES tbl_owner (owner_id),
        insurance_id INT,
        FOREIGN KEY(insurance_id) REFERENCES tbl_insurance (insurance_id),
    )

-- populate the valid_till field when the insurance record is inserted.
-- CREATE TRIGGER
--     insurance_valid_till
-- AFTER INSERT ON
--     tbl_insurance
-- FOR EACH ROW
-- BEGIN
--     SET NEW.valid_till = DATE_ADD(NOW(), INTERVAL 1 YEAR);
-- END

-- prevent the deletion of the insured cars
-- DELIMITER //
-- CREATE TRIGGER prevent_car_deletion
-- BEFORE DELETE ON tbl_car
-- FOR EACH ROW
-- BEGIN
--     DECLARE insurance_id INT;
--     DECLARE insurance_status VARCHAR(255);
    
--     SELECT insurance_id, status INTO insurance_id, insurance_status
--     FROM tbl_insurance 
--     WHERE car_id = OLD.car_id 
--     ORDER BY insurance_id DESC 
--     LIMIT 1;
    
--     IF insurance_status = 'CLAIMED' THEN
--         SIGNAL SQLSTATE '45000'
--         SET MESSAGE_TEXT = 'Car with insurance ID ' + CAST(insurance_id AS CHAR) + ' has a claimed insurance policy. Deletion allowed.';
--     END IF;
-- END;
-- //
-- DELIMITER ;
