DROP TABLE IF EXISTS GRADE;
DROP TABLE IF EXISTS NURSE_EXP;
DROP TABLE IF EXISTS PATIENT;
DROP TABLE IF EXISTS SPECIALTY;
DROP TABLE IF EXISTS STAFF;
DROP TABLE IF EXISTS SURGEON_SPECIALTY;


-- /* Staff */
    CREATE TABLE STAFF (
        EmpNo INT AUTO_INCREMENT,
        Fname VARCHAR(50) NOT NULL,
        Minit CHAR(1),
        Lname VARCHAR(50) NOT NULL,
        Ssn CHAR(9) UNIQUE,
        Gender CHAR(1) NOT NULL CHECK (Gender = 'M' OR Gender = 'F'),
        EmpType CHAR(4) NOT NULL CHECK (EmpType = 'PHYS' OR EmpType = 'NURS' OR EmpType = 'SURG' OR EmpType = 'SUPP'),
        Title VARCHAR(50),
        EmpStatus CHAR(1) NOT NULL CHECK (EmpStatus = 'A' OR EmpStatus = 'I'),
        Addr VARCHAR(100),
        City VARCHAR(20),
        StateProv CHAR(2),
        ZIP VARCHAR(10),
        Country CHAR(2),
        Phone VARCHAR(10),
        PRIMARY KEY (EmpNo)
    );

 -- Nurse Grade 
    -- DROP TABLE GRADE;
    CREATE TABLE GRADE (
        Grade INT AUTO_INCREMENT,
        Description VARCHAR(50),
        PRIMARY KEY (Grade)
    );
    
-- /* Nurse Experience (Years, Grade, Surgery Type) */
    CREATE TABLE NURSE_EXP (
        EmpNum INT,
        YrsExp INT CHECK (YrsExp > 0),
        Grade INT, -- /* FOREIGN KEY */
        SurgeryType INT, -- /* FOREIGN KEY */
        PRIMARY KEY (EmpNum)
    );

-- /* Patient */
    CREATE TABLE PATIENT (
        PatientNo INT AUTO_INCREMENT,
        Fname VARCHAR(50) NOT NULL,
        Minit CHAR(1),
        Lname VARCHAR(50) NOT NULL,
        Ssn CHAR(9) UNIQUE,
        Gender CHAR(1) NOT NULL CHECK (Gender = 'M' OR Gender = 'F'),
        Dob DATE NOT NULL, --/* TRIGGER?? */
        BloodType VARCHAR(2) CHECK (BloodType = 'A' OR BloodType = 'B' OR BloodType = 'AB' OR BloodType = 'O'),
        RhFactor CHAR(1) CHECK (RhFactor = '+' OR RhFactor = '-'),
        InsProvider VARCHAR(50),
        InsMemberId VARCHAR(20),
        Pcp INT NOT NULL, -- /* FOREIGN KEY FROM TWO SOURCES, MUST HAVE DEFAULT (CHIEF OF STAFF) */
        Addr VARCHAR(100),
        City VARCHAR(20),
        StateProv CHAR(2),
        ZIP VARCHAR(10),
        Country CHAR(2),
        Phone VARCHAR(10),
        PRIMARY KEY (PatientNo)
    );

   -- /* Surgeon Specialty */
    CREATE TABLE SPECIALTY (
        Code INT AUTO_INCREMENT,
        Description VARCHAR(50),
        PRIMARY KEY (Code)
    );



    --/* Surgeon Specialty */

    CREATE TABLE SURGEON_SPECIALTY (
        EmpNum INT,
        SpecialtyCode INT,
        PRIMARY KEY (EmpNum, SpecialtyCode)
    );