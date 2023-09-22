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
        accident_id INT,
        FOREIGN KEY(accident_id) REFERENCES tbl_accident (accident_id)
    )