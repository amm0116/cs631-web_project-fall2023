DROP TABLE IF EXISTS CLINIC;
DROP TABLE IF EXISTS CORPORATION;
DROP TABLE IF EXISTS ANATOMICAL_LOC;
DROP TABLE IF EXISTS SURG_SKILL; 
DROP TABLE IF EXISTS MEDICATION;
DROP TABLE IF EXISTS ALLERGY;
DROP TABLE IF EXISTS ILLNESS; 
DROP TABLE IF EXISTS WING;
DROP TABLE IF EXISTS NURSING_UNIT; 
DROP TABLE IF EXISTS STAFF;
DROP TABLE IF EXISTS PATIENT; 
DROP TABLE IF EXISTS SURG_CONTRACT; 
DROP TABLE IF EXISTS PATIENT_SUGAR; 
DROP TABLE IF EXISTS BED;
DROP TABLE IF EXISTS OP_THEATRE;
DROP TABLE IF EXISTS APPOINTMENT;
DROP TABLE IF EXISTS PATIENT_ILLNESS; 
DROP TABLE IF EXISTS NURSE_SURG_SKILL;
DROP TABLE IF EXISTS SURG_TYPE_SKILL;
DROP TABLE IF EXISTS NURSE_SURG_TYPE;
DROP TABLE IF EXISTS MED_INTERACT; 
DROP TABLE IF EXISTS OWNER;
DROP TABLE IF EXISTS PATIENT_ALLERGY;
DROP TABLE IF EXISTS PATIENT_CHOLESTEROL;
DROP TABLE IF EXISTS PATIENT_PRESCRIPTION;
DROP TABLE IF EXISTS SURG_TYPE; 
DROP TABLE IF EXISTS SURGERY; 
DROP TABLE IF EXISTS SURGERY_STAFF;
DROP TABLE IF EXISTS SHIFT; 
DROP TABLE IF EXISTS STAY; 

BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS CLINIC (
    Name    VARCHAR(50),
    Addr    VARCHAR(100),
    City    VARCHAR(40),
    StateProv   CHAR(40),
    ZIP VARCHAR(20),
    Country CHAR(40),
    Phone   VARCHAR(10),
    PRIMARY KEY(Name)
);
CREATE TABLE IF NOT EXISTS CORPORATION (
    CorpName    VARCHAR(50),
    HqAddr  VARCHAR(100),
    HqCity  VARCHAR(40),
    HqStateProv CHAR(40),
    HqZIP   VARCHAR(20),
    HqCountry   CHAR(40),
    PRIMARY KEY(CorpName)
);
CREATE TABLE IF NOT EXISTS ANATOMICAL_LOC (
    Code    INTEGER,
    Description VARCHAR(50),
    PRIMARY KEY(Code AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS SURG_SKILL (
    Code    INTEGER,
    Description VARCHAR(50),
    PRIMARY KEY(Code AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS MEDICATION (
    Code    VARCHAR(15),
    Name    VARCHAR(50) NOT NULL,
    UnitCost    DECIMAL(8, 2) NOT NULL DEFAULT 0,
    QtyOnHand   DECIMAL(8, 2) NOT NULL DEFAULT 0,
    QtyOnOrder  DECIMAL(8, 2) NOT NULL DEFAULT 0,
    YTDUsage    DECIMAL(8, 2) NOT NULL DEFAULT 0,
    PRIMARY KEY(Code)
);
CREATE TABLE IF NOT EXISTS ALLERGY (
    Code    VARCHAR(10),
    Description VARCHAR(255),
    PRIMARY KEY(Code)
);
CREATE TABLE IF NOT EXISTS ILLNESS (
    Code    VARCHAR(10),
    Description VARCHAR(255),
    PRIMARY KEY(Code)
);
CREATE TABLE IF NOT EXISTS WING (
    Code    VARCHAR(5),
    PRIMARY KEY(Code)
);
CREATE TABLE IF NOT EXISTS NURSING_UNIT (
    Code    INTEGER,
    PRIMARY KEY(Code AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS STAFF (
    EmpNo   INTEGER,
    Fname   VARCHAR(50) NOT NULL,
    Minit   CHAR(1),
    Lname   VARCHAR(50) NOT NULL,
    Ssn CHAR(9) UNIQUE,
    Gender  CHAR(1) CHECK(Gender = 'M' OR Gender = 'F'),
    EmpType CHAR(4) NOT NULL CHECK(EmpType = 'PHYS' OR EmpType = 'NURS' OR EmpType = 'SURG' OR EmpType = 'SUPP'),
    Title   VARCHAR(50) NOT NULL,
    Salary  INTEGER,
    Specialty   VARCHAR(50) CHECK(Specialty IN ('Cardiology', 'Dermatology', 'Gastroenterology', 'Orthopedics', 'Neurology', 'Ophthalmology', 'Otolaryngology', 'Pediatrics', 'Obstetrics and Gynecology', 'Urology', 'Endocrinology', 'Rheumatology', 'Pulmonology', 'Hematology', 'Infectious Disease', 'Emergency Medicine', 'Plastic Surgery', 'Radiology', 'Anesthesiology', 'Pathology')),
    NurseGrade  INTEGER,
    YrsNursingExp   INT,
    Addr    VARCHAR(100),
    City    VARCHAR(40),
    StateProv   CHAR(40),
    ZIP VARCHAR(20),
    Country CHAR(40),
    Phone   VARCHAR(10),
    PRIMARY KEY(EmpNo AUTOINCREMENT),
    CHECK((EmpType = 'NURS' AND YrsNursingExp IS NOT NULL AND YrsNursingExp >= 0) OR (EmpType != 'NURS' AND YrsNursingExp IS NULL)),
    CHECK((EmpType != 'SURG' AND Salary IS NOT NULL AND Salary >= 25000 AND Salary <= 300000) OR (EmpType = 'SURG' AND Salary IS NULL)),
    CHECK(((EmpType = 'PHYS' OR EmpType = 'SURG') AND Specialty IS NOT NULL) OR ((EmpType = 'NURS' OR EmpType = 'SUPP') AND Specialty IS NULL)),
    CHECK((EmpType = 'NURS' AND NurseGrade IS NOT NULL AND NurseGrade >= 1) OR (EmpType != 'NURS' AND NurseGrade IS NULL))
);
CREATE TABLE IF NOT EXISTS PATIENT (
    PatientNo   INTEGER,
    Fname   VARCHAR(50) NOT NULL,
    Minit   CHAR(1),
    Lname   VARCHAR(50) NOT NULL,
    Ssn CHAR(9) UNIQUE,
    Gender  CHAR(1) NOT NULL CHECK(Gender IN ('M', 'F')),
    Dob DATETIME NOT NULL,
    BloodType   VARCHAR(2) CHECK(BloodType IN ('A', 'B', 'AB', 'O')),
    RhFactor    CHAR(1) CHECK(RhFactor IN ('+', '-')),
    Pcp INTEGER NOT NULL DEFAULT 1,
    Addr    VARCHAR(100),
    City    VARCHAR(20),
    StateProv   CHAR(2),
    ZIP VARCHAR(10),
    Country CHAR(2),
    Phone   VARCHAR(15),
    PRIMARY KEY(PatientNo AUTOINCREMENT),
    FOREIGN KEY(Pcp) REFERENCES STAFF(EmpNo) ON UPDATE CASCADE ON DELETE SET DEFAULT
);
CREATE TABLE IF NOT EXISTS SURG_CONTRACT (
    EmpNo   INTEGER,
    ContractType    VARCHAR(20) NOT NULL CHECK(ContractType IN ('Independent', 'Partnership', 'Call Coverage', 'Research', 'Consulting')),
    LengthYrs   INTEGER NOT NULL,
    PRIMARY KEY(EmpNo),
    FOREIGN KEY(EmpNo) REFERENCES STAFF(EmpNo) ON UPDATE CASCADE ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS PATIENT_SUGAR (
    ReadingNo   INTEGER,
    PatientNo   INTEGER NOT NULL,
    ReadTime    DATETIME NOT NULL,
    mgdL    INTEGER NOT NULL,
    PRIMARY KEY(ReadingNo AUTOINCREMENT),
    FOREIGN KEY(PatientNo) REFERENCES PATIENT(PatientNo) ON UPDATE CASCADE ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS BED (
    Code    INTEGER,
    Clinic  VARCHAR(50) NOT NULL,
    Wing    VARCHAR(5) NOT NULL,
    NurseUnit   INT NOT NULL,
    RoomNo  INT NOT NULL,
    Bed CHAR NOT NULL CHECK(Bed IN ('A', 'B')),
    PRIMARY KEY(Code AUTOINCREMENT),
    FOREIGN KEY(Clinic) REFERENCES CLINIC(Name) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY(Wing) REFERENCES WING(Code) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY(NurseUnit) REFERENCES NURSING_UNIT(Code) ON UPDATE CASCADE ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS OP_THEATRE (
    Code    INTEGER,
    Clinic  VARCHAR(50) NOT NULL,
    Theatre CHAR NOT NULL,
    PRIMARY KEY(Code AUTOINCREMENT),
    FOREIGN KEY(Clinic) REFERENCES CLINIC(Name) ON UPDATE CASCADE ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS APPOINTMENT (
    AppointmentNo   INTEGER,
    PatientNo   INTEGER NOT NULL,
    Physician   INTEGER NOT NULL,
    Clinic  VARCHAR(50) NOT NULL,
    Time    DATETIME NOT NULL,
    Type    VARCHAR(15) NOT NULL CHECK(Type IN ('Routine', 'Consultation', 'Follow-up', 'Diagnostic', 'Preventive', 'Emergency')),
    FOREIGN KEY(PatientNo) REFERENCES PATIENT(PatientNo) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY(Physician) REFERENCES STAFF(EmpNo) ON UPDATE CASCADE ON DELETE CASCADE,
    PRIMARY KEY(AppointmentNo AUTOINCREMENT),
    FOREIGN KEY(Clinic) REFERENCES CLINIC(Name) ON UPDATE CASCADE ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS PATIENT_ILLNESS (
    DiagnosisNo INTEGER,
    PatientNo   INTEGER NOT NULL,
    Illness VARCHAR(10) NOT NULL,
    AppointmentNo   INT NOT NULL,
    PRIMARY KEY(DiagnosisNo AUTOINCREMENT),
    FOREIGN KEY(Illness) REFERENCES ILLNESS(Code) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY(AppointmentNo) REFERENCES APPOINTMENT(AppointmentNo) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY(PatientNo) REFERENCES Patient(PatientNo) ON UPDATE CASCADE ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS NURSE_SURG_SKILL (
    EmpNo   INTEGER NOT NULL,
    Skill   INTEGER NOT NULL,
    FOREIGN KEY(EmpNo) REFERENCES STAFF(EmpNo) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY(Skill) REFERENCES SURG_SKILL(Code) ON UPDATE CASCADE ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS SURG_TYPE_SKILL (
    Type    INTEGER NOT NULL,
    Skill   INTEGER NOT NULL,
    FOREIGN KEY(Type) REFERENCES SURG_TYPE(Code) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY(Skill) REFERENCES SURG_SKILL(Code) ON UPDATE CASCADE ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS NURSE_SURG_TYPE (
    EmpNo   INTEGER,
    Type    INTEGER NOT NULL,
    PRIMARY KEY(EmpNo),
    FOREIGN KEY(EmpNo) REFERENCES STAFF(EmpNo) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY(Type) REFERENCES SURG_TYPE(Code) ON UPDATE CASCADE ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS MED_INTERACT (
    InteractionNo   INTEGER,
    MedA    VARCHAR(15) NOT NULL,
    MedB    VARCHAR(15) NOT NULL,
    Severity    CHAR NOT NULL CHECK(Severity IN ('N', 'L', 'M', 'S')),
    PRIMARY KEY(InteractionNo AUTOINCREMENT),
    FOREIGN KEY(MedB) REFERENCES MEDICATION(Code) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY(MedA) REFERENCES MEDICATION(Code) ON UPDATE CASCADE ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS OWNER (
    OwnerID INTEGER,
    Clinic  VARCHAR(50) NOT NULL,
    CorpName    VARCHAR(50),
    EmpNo   INTEGER,
    PctOwnership    INT NOT NULL,
    PRIMARY KEY(OwnerID AUTOINCREMENT),
    FOREIGN KEY(EmpNo) REFERENCES STAFF(EmpNo) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY(CorpName) REFERENCES CORPORATION(CorpName) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY(Clinic) REFERENCES CLINIC(Name) ON UPDATE CASCADE ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS PATIENT_ALLERGY (
    DiagnosisNo INTEGER,
    PatientNo   INTEGER NOT NULL,
    Allergy VARCHAR(10) NOT NULL,
    AppointmentNo   INT NOT NULL,
    PRIMARY KEY(DiagnosisNo AUTOINCREMENT),
    FOREIGN KEY(AppointmentNo) REFERENCES APPOINTMENT(AppointmentNo) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY(Allergy) REFERENCES ALLERGY(Code) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY(PatientNo) REFERENCES Patient(PatientNo) ON UPDATE CASCADE ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS PATIENT_CHOLESTEROL (
    ReadingNo   INTEGER,
    PatientNo   INTEGER NOT NULL,
    ReadTime    DATETIME NOT NULL,
    Hdl INTEGER NOT NULL,
    Ldl INTEGER NOT NULL,
    Triglycerides   INTEGER NOT NULL,
    CalculatedRatio DECIMAL(5, 4),
    CalculatedRiskCode  CHAR,
    HighRiskFlag    INT DEFAULT 0 CHECK(HighRiskFlag IN (0, 1)),
    PRIMARY KEY(ReadingNo AUTOINCREMENT),
    FOREIGN KEY(PatientNo) REFERENCES PATIENT(PatientNo) ON UPDATE CASCADE ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS PATIENT_PRESCRIPTION (
    PrescriptionNo  INTEGER,
    PatientNo   INTEGER NOT NULL,
    Medication  VARCHAR(15) NOT NULL,
    Dosage  VARCHAR(20) NOT NULL,
    Freq    VARCHAR(20) NOT NULL,
    PrescribedBy    INT NOT NULL,
    PRIMARY KEY(PrescriptionNo AUTOINCREMENT),
    FOREIGN KEY(PrescribedBy) REFERENCES STAFF(EmpNo) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY(Medication) REFERENCES MEDICATION(Code) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY(PatientNo) REFERENCES PATIENT(PatientNo) ON UPDATE CASCADE ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS SURG_TYPE (
    Code    INTEGER,
    Name    VARCHAR(50),
    Category    CHAR CHECK(Category IN ('O', 'H')),
    AnatomicalLoc   INTEGER NOT NULL,
    SpecialNeeds    VARCHAR(100),
    PRIMARY KEY(Code AUTOINCREMENT),
    FOREIGN KEY(AnatomicalLoc) REFERENCES ANATOMICAL_LOC(Code) ON UPDATE CASCADE ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS SURGERY (
    SurgeryNo   INTEGER,
    PatientNo   INTEGER NOT NULL,
    Surgeon INTEGER NOT NULL,
    SurgeryTime DATETIME NOT NULL,
    OpTheatre   INTEGER NOT NULL,
    SurgeryType INTEGER NOT NULL,
    PRIMARY KEY(SurgeryNo AUTOINCREMENT),
    FOREIGN KEY(PatientNo) REFERENCES PATIENT(PatientNo) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY(Surgeon) REFERENCES STAFF(EmpNo) ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY(OpTheatre) REFERENCES OP_THEATRE(Code) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY(SurgeryType) REFERENCES SURG_TYPE(Code) ON UPDATE CASCADE ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS SURGERY_STAFF (
    SurgeryNo   INTEGER NOT NULL,
    EmpNo   INTEGER NOT NULL,
    FOREIGN KEY(EmpNo) REFERENCES STAFF(EmpNo) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY(SurgeryNo) REFERENCES SURGERY(SurgeryNo) ON UPDATE CASCADE ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS SHIFT (
    ShiftNo INTEGER,
    EmpNo   INTEGER NOT NULL,
    StartDate   DATETIME  NOT NULL,
    Shift   INTEGER NOT NULL CHECK(Shift IN (1, 2, 3)),
    PRIMARY KEY(ShiftNo AUTOINCREMENT)
);

CREATE TABLE IF NOT EXISTS STAY (
    StayNo    INTEGER,
    PatientNo INTEGER NOT NULL,
    Bed   INTEGER NOT NULL,
    AdmissionDate DATETIME  NOT NULL,
    DiagnosisNo   INTEGER NOT NULL,
    Physician INTEGER,
    Nurse INTEGER,
    PRIMARY KEY(StayNo AUTOINCREMENT),
    FOREIGN KEY(Nurse) REFERENCES STAFF(EmpNo) ON UPDATE CASCADE ON DELETE SET NULL,
    FOREIGN KEY(Bed) REFERENCES BED(Code) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY(PatientNo) REFERENCES PATIENT(PatientNo) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY(DiagnosisNo) REFERENCES PATIENT_ILLNESS(DiagnosisNo) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY(Physician) REFERENCES STAFF(EmpNo) ON UPDATE CASCADE ON DELETE SET NULL
);

INSERT INTO "CLINIC" ("Name","Addr","City","StateProv","ZIP","Country","Phone") VALUES ('Newark Medical Clinic','1500 Commerce Avenue','Newark','New Jersey','07101','United States','555-123-4567');
INSERT INTO "CLINIC" ("Name","Addr","City","StateProv","ZIP","Country","Phone") VALUES ('Jersey City Health','12-04 Market Street','Jersey City','New Jersey','07302','United States','555-234-5678');
INSERT INTO "CLINIC" ("Name","Addr","City","StateProv","ZIP","Country","Phone") VALUES ('High Point Hospital','86 Trade Boulevard','Harrison','New Jersey','07029','United States','555-456-7890');
INSERT INTO "CORPORATION" ("CorpName","HqAddr","HqCity","HqStateProv","HqZIP","HqCountry") VALUES ('Newark Medical Associates, Inc.','500 Main St','Newark','New Jersey','17101','United States');
INSERT INTO "CORPORATION" ("CorpName","HqAddr","HqCity","HqStateProv","HqZIP","HqCountry") VALUES ('MediLife Healthcare Corporation','100 Commerce St','New York','New York','10001','United States');
INSERT INTO "CORPORATION" ("CorpName","HqAddr","HqCity","HqStateProv","HqZIP","HqCountry") VALUES ('HealthLink Medical Group','123 Health Way','Dublin',NULL,'D14','Ireland');
INSERT INTO "CORPORATION" ("CorpName","HqAddr","HqCity","HqStateProv","HqZIP","HqCountry") VALUES ('MediCore Hospitals, Inc.','1200 Jersey St','Jersey City','New Jersey','07030','United States');
INSERT INTO "CORPORATION" ("CorpName","HqAddr","HqCity","HqStateProv","HqZIP","HqCountry") VALUES ('MediServe Health Systems','5000 Insurance Dr','Toronto','Ontario','M4C 1T6','Canada');
INSERT INTO "ANATOMICAL_LOC" ("Code","Description") VALUES (1,'Abdominal-Epigastric');
INSERT INTO "ANATOMICAL_LOC" ("Code","Description") VALUES (2,'Abdominal-Umbilical');
INSERT INTO "ANATOMICAL_LOC" ("Code","Description") VALUES (3,'Abdominal-Hypogastric (Suprapubic)');
INSERT INTO "ANATOMICAL_LOC" ("Code","Description") VALUES (4,'Abdominal-Right Hypochondriac');
INSERT INTO "ANATOMICAL_LOC" ("Code","Description") VALUES (5,'Abdominal-Left Hypochondriac');
INSERT INTO "ANATOMICAL_LOC" ("Code","Description") VALUES (6,'Abdominal-Right Lumbar (Flank)');
INSERT INTO "ANATOMICAL_LOC" ("Code","Description") VALUES (7,'Abdominal-Left Lumbar (Flank)');
INSERT INTO "ANATOMICAL_LOC" ("Code","Description") VALUES (8,'Abdominal-Right Inguinal (Iliac)');
INSERT INTO "ANATOMICAL_LOC" ("Code","Description") VALUES (9,'Abdominal-Left Inguinal (Iliac)');
INSERT INTO "ANATOMICAL_LOC" ("Code","Description") VALUES (10,'Abdominal-Upper Right Quadrant (URQ)');
INSERT INTO "ANATOMICAL_LOC" ("Code","Description") VALUES (11,'Abdominal-Upper Left Quadrant (ULQ)');
INSERT INTO "ANATOMICAL_LOC" ("Code","Description") VALUES (12,'Abdominal-Lower Right Quadrant (LRQ)');
INSERT INTO "ANATOMICAL_LOC" ("Code","Description") VALUES (13,'Abdominal-Lower Left Quadrant (LLQ)');
INSERT INTO "ANATOMICAL_LOC" ("Code","Description") VALUES (14,'Abdominal-Liver');
INSERT INTO "ANATOMICAL_LOC" ("Code","Description") VALUES (15,'Abdominal-Kidney');
INSERT INTO "ANATOMICAL_LOC" ("Code","Description") VALUES (16,'Abdominal-Spleen');
INSERT INTO "ANATOMICAL_LOC" ("Code","Description") VALUES (17,'Abdominal-Appendix');
INSERT INTO "ANATOMICAL_LOC" ("Code","Description") VALUES (18,'Chest-Right Upper Quadrant (RUQ)');
INSERT INTO "ANATOMICAL_LOC" ("Code","Description") VALUES (19,'Chest-Left Upper Quadrant (LUQ)');
INSERT INTO "ANATOMICAL_LOC" ("Code","Description") VALUES (20,'Chest-Right Lower Quadrant (RLQ)');
INSERT INTO "ANATOMICAL_LOC" ("Code","Description") VALUES (21,'Chest-Left Lower Quadrant (LLQ)');
INSERT INTO "ANATOMICAL_LOC" ("Code","Description") VALUES (22,'Chest-Pectoral Region (Breast)');
INSERT INTO "ANATOMICAL_LOC" ("Code","Description") VALUES (23,'Chest-Sternal Region (Sternum)');
INSERT INTO "ANATOMICAL_LOC" ("Code","Description") VALUES (24,'Head and Neck-Frontal Region');
INSERT INTO "ANATOMICAL_LOC" ("Code","Description") VALUES (25,'Head and Neck-Occipital Region');
INSERT INTO "ANATOMICAL_LOC" ("Code","Description") VALUES (26,'Head and Neck-Temporal Region');
INSERT INTO "ANATOMICAL_LOC" ("Code","Description") VALUES (27,'Head and Neck-Parietal Region');
INSERT INTO "ANATOMICAL_LOC" ("Code","Description") VALUES (28,'Head and Neck-Cervical Region (Neck)');
INSERT INTO "ANATOMICAL_LOC" ("Code","Description") VALUES (29,'Head and Neck-Facial Region');
INSERT INTO "ANATOMICAL_LOC" ("Code","Description") VALUES (30,'Head and Neck-Oral Region');
INSERT INTO "ANATOMICAL_LOC" ("Code","Description") VALUES (31,'Cranial Compartments-Anterior Cranial Fossa');
INSERT INTO "ANATOMICAL_LOC" ("Code","Description") VALUES (32,'Cranial Compartments-Middle Cranial Fossa');
INSERT INTO "ANATOMICAL_LOC" ("Code","Description") VALUES (33,'Cranial Compartments-Posterior Cranial Fossa');
INSERT INTO "ANATOMICAL_LOC" ("Code","Description") VALUES (34,'Extremities-Upper Arm');
INSERT INTO "ANATOMICAL_LOC" ("Code","Description") VALUES (35,'Extremities-Forearm');
INSERT INTO "ANATOMICAL_LOC" ("Code","Description") VALUES (36,'Extremities-Hand');
INSERT INTO "ANATOMICAL_LOC" ("Code","Description") VALUES (37,'Extremities-Thigh');
INSERT INTO "ANATOMICAL_LOC" ("Code","Description") VALUES (38,'Extremities-Leg');
INSERT INTO "ANATOMICAL_LOC" ("Code","Description") VALUES (39,'Extremities-Foot');
INSERT INTO "ANATOMICAL_LOC" ("Code","Description") VALUES (40,'Spinal Regions-Cervical Spine');
INSERT INTO "ANATOMICAL_LOC" ("Code","Description") VALUES (41,'Spinal Regions-Thoracic Spine');
INSERT INTO "ANATOMICAL_LOC" ("Code","Description") VALUES (42,'Spinal Regions-Lumbar Spine');
INSERT INTO "ANATOMICAL_LOC" ("Code","Description") VALUES (43,'Spinal Regions-Sacral Spine');
INSERT INTO "ANATOMICAL_LOC" ("Code","Description") VALUES (44,'Breast-Upper Outer Quadrant');
INSERT INTO "ANATOMICAL_LOC" ("Code","Description") VALUES (45,'Breast-Upper Inner Quadrant');
INSERT INTO "ANATOMICAL_LOC" ("Code","Description") VALUES (46,'Breast-Lower Outer Quadrant');
INSERT INTO "ANATOMICAL_LOC" ("Code","Description") VALUES (47,'Breast-Lower Inner Quadrant');
INSERT INTO "ANATOMICAL_LOC" ("Code","Description") VALUES (48,'Breast-Lower Inner Quadrant');
INSERT INTO "ANATOMICAL_LOC" ("Code","Description") VALUES (49,'Cranial-Sagittal');
INSERT INTO "ANATOMICAL_LOC" ("Code","Description") VALUES (50,'Cranial-Coronal');
INSERT INTO "ANATOMICAL_LOC" ("Code","Description") VALUES (51,'Cranial-Lambdoid');
INSERT INTO "ANATOMICAL_LOC" ("Code","Description") VALUES (52,'Cranial-Squamous');
INSERT INTO "SURG_SKILL" ("Code","Description") VALUES (1,'Anatomy Knowledge');
INSERT INTO "SURG_SKILL" ("Code","Description") VALUES (2,'Manual Dexterity');
INSERT INTO "SURG_SKILL" ("Code","Description") VALUES (3,'Surgical Instrument Proficiency');
INSERT INTO "SURG_SKILL" ("Code","Description") VALUES (4,'Suture Techniques');
INSERT INTO "SURG_SKILL" ("Code","Description") VALUES (5,'Tissue Handling');
INSERT INTO "SURG_SKILL" ("Code","Description") VALUES (6,'Hemostasis');
INSERT INTO "SURG_SKILL" ("Code","Description") VALUES (7,'Tissue Dissection');
INSERT INTO "SURG_SKILL" ("Code","Description") VALUES (8,'Minimally Invasive Surgery (MIS) Skills');
INSERT INTO "SURG_SKILL" ("Code","Description") VALUES (9,'Patient Positioning and Access');
INSERT INTO "SURG_SKILL" ("Code","Description") VALUES (10,'Infection Control');
INSERT INTO "SURG_SKILL" ("Code","Description") VALUES (11,'Decision-Making');
INSERT INTO "SURG_SKILL" ("Code","Description") VALUES (12,'Communication');
INSERT INTO "SURG_SKILL" ("Code","Description") VALUES (13,'Teamwork');
INSERT INTO "SURG_SKILL" ("Code","Description") VALUES (14,'Patient Assessment');
INSERT INTO "SURG_SKILL" ("Code","Description") VALUES (15,'Ethical and Legal Understanding');
INSERT INTO "SURG_SKILL" ("Code","Description") VALUES (16,'Postoperative Care');
INSERT INTO "MEDICATION" ("Code","Name","UnitCost","QtyOnHand","QtyOnOrder","YTDUsage") VALUES ('00168047515','Ibuprofen 200mg Tablets',0.15,500,100,300);
INSERT INTO "MEDICATION" ("Code","Name","UnitCost","QtyOnHand","QtyOnOrder","YTDUsage") VALUES ('00378046501','Amoxicillin 500mg Capsules',0.25,300,50,200);
INSERT INTO "MEDICATION" ("Code","Name","UnitCost","QtyOnHand","QtyOnOrder","YTDUsage") VALUES ('00093529201','Lisinopril 10mg Tablets',0.3,200,20,150);
INSERT INTO "MEDICATION" ("Code","Name","UnitCost","QtyOnHand","QtyOnOrder","YTDUsage") VALUES ('00054446001','Metformin 500mg Tablets',0.2,400,30,250);
INSERT INTO "MEDICATION" ("Code","Name","UnitCost","QtyOnHand","QtyOnOrder","YTDUsage") VALUES ('00378233001','Simvastatin 20mg Tablets',0.35,150,10,100);
INSERT INTO "MEDICATION" ("Code","Name","UnitCost","QtyOnHand","QtyOnOrder","YTDUsage") VALUES ('00173048710','Omeprazole 20mg Capsules',0.4,100,5,80);
INSERT INTO "MEDICATION" ("Code","Name","UnitCost","QtyOnHand","QtyOnOrder","YTDUsage") VALUES ('00781101001','Levothyroxine 50mcg Tablets',0.18,250,15,180);
INSERT INTO "MEDICATION" ("Code","Name","UnitCost","QtyOnHand","QtyOnOrder","YTDUsage") VALUES ('00378636501','Losartan 50mg Tablets',0.33,180,25,120);
INSERT INTO "MEDICATION" ("Code","Name","UnitCost","QtyOnHand","QtyOnOrder","YTDUsage") VALUES ('00527313101','Atorvastatin 40mg Tablets',0.45,120,8,90);
INSERT INTO "MEDICATION" ("Code","Name","UnitCost","QtyOnHand","QtyOnOrder","YTDUsage") VALUES ('00093714901','Hydrochlorothiazide 25mg Tablets',0.28,220,18,160);
INSERT INTO "ALLERGY" ("Code","Description") VALUES ('T78.1XXA','Adverse Food Reactions');
INSERT INTO "ALLERGY" ("Code","Description") VALUES ('T78.07XA','Anaphylaxis to dairy, initial encounter');
INSERT INTO "ALLERGY" ("Code","Description") VALUES ('T78.08XA','Anaphylaxis to egg, initial encounter');
INSERT INTO "ALLERGY" ("Code","Description") VALUES ('T78.01XA','Anaphylaxis to peanut, initial encounter');
INSERT INTO "ALLERGY" ("Code","Description") VALUES ('T78.05XA','Anaphylaxis to tree nuts or seeds, initial encounter');
INSERT INTO "ALLERGY" ("Code","Description") VALUES ('T78.02XA','Anaphylaxis to shellfish, initial encounter');
INSERT INTO "ALLERGY" ("Code","Description") VALUES ('T78.03XA','Anaphylaxis to fish, initial encounter');
INSERT INTO "ALLERGY" ("Code","Description") VALUES ('T78.00XA','Anaphylactic reaction due to unspecified food, initial encounter');
INSERT INTO "ALLERGY" ("Code","Description") VALUES ('T78.06XA','Anaphylactic reaction due to food additives, initial encounter');
INSERT INTO "ALLERGY" ("Code","Description") VALUES ('T88.6XXA','Anaphylactic reaction due to adverse effect of correct drug or medicament properly administered, initial encounter');
INSERT INTO "ALLERGY" ("Code","Description") VALUES ('L50.0','Allergic Urticaria');
INSERT INTO "ALLERGY" ("Code","Description") VALUES ('T78.3XXA','Angioneurotic Edema, initial encounter');
INSERT INTO "ALLERGY" ("Code","Description") VALUES ('L20.9','Atopic Dermatitis');
INSERT INTO "ALLERGY" ("Code","Description") VALUES ('L23.9','Allergic Contact Dermatitis');
INSERT INTO "ALLERGY" ("Code","Description") VALUES ('L23.6','Allergic Contact Dermatitis due to food in contact with the skin');
INSERT INTO "ALLERGY" ("Code","Description") VALUES ('J30.81','Allergic Rhinitis due to animal');
INSERT INTO "ALLERGY" ("Code","Description") VALUES ('J30.1','Allergic Rhinitis due to seasonal allergen');
INSERT INTO "ALLERGY" ("Code","Description") VALUES ('J30.89','Other Allergic Rhinitis (mold, dust mite, perennial)');
INSERT INTO "ALLERGY" ("Code","Description") VALUES ('J30.2','Other Seasonal Allergic Rhinitis');
INSERT INTO "ALLERGY" ("Code","Description") VALUES ('J30.5','Allergic Rhinitis Due to Food');
INSERT INTO "ALLERGY" ("Code","Description") VALUES ('H10.45','Other Chronic Allergic Conjunctivitis');
INSERT INTO "ILLNESS" ("Code","Description") VALUES ('I10','Essential (Primary) Hypertension');
INSERT INTO "ILLNESS" ("Code","Description") VALUES ('E11.9','Type 2 Diabetes Mellitus without Complications');
INSERT INTO "ILLNESS" ("Code","Description") VALUES ('K21.9','Gastroesophageal Reflux Disease without Esophagitis');
INSERT INTO "ILLNESS" ("Code","Description") VALUES ('N18.9','Chronic Kidney Disease, Unspecified');
INSERT INTO "ILLNESS" ("Code","Description") VALUES ('J44.9','Chronic Obstructive Pulmonary Disease, Unspecified');
INSERT INTO "ILLNESS" ("Code","Description") VALUES ('M54.5','Low Back Pain');
INSERT INTO "ILLNESS" ("Code","Description") VALUES ('M79.1','Myalgia');
INSERT INTO "ILLNESS" ("Code","Description") VALUES ('F32.9','Major Depressive Disorder, Single Episode, Unspecified');
INSERT INTO "ILLNESS" ("Code","Description") VALUES ('F41.9','Anxiety Disorder, Unspecified');
INSERT INTO "ILLNESS" ("Code","Description") VALUES ('G47.00','Insomnia, Unspecified');
INSERT INTO "ILLNESS" ("Code","Description") VALUES ('C61','Malignant Neoplasm of Prostate');
INSERT INTO "ILLNESS" ("Code","Description") VALUES ('C50.919','Malignant Neoplasm of Breast, Unspecified');
INSERT INTO "ILLNESS" ("Code","Description") VALUES ('C18.9','Malignant Neoplasm of Colon, Unspecified');
INSERT INTO "ILLNESS" ("Code","Description") VALUES ('C34.90','Malignant Neoplasm of Bronchus or Lung, Unspecified');
INSERT INTO "ILLNESS" ("Code","Description") VALUES ('C73','Malignant Neoplasm of Thyroid Gland');
INSERT INTO "ILLNESS" ("Code","Description") VALUES ('I20.9','Angina Pectoris, Unspecified');
INSERT INTO "ILLNESS" ("Code","Description") VALUES ('I25.10','Atherosclerotic Heart Disease of Native Coronary Artery without Angina Pectoris');
INSERT INTO "ILLNESS" ("Code","Description") VALUES ('N40.1','Enlarged Prostate without Lower Urinary Tract Symptoms');
INSERT INTO "ILLNESS" ("Code","Description") VALUES ('E78.5','Hyperlipidemia, Unspecified');
INSERT INTO "ILLNESS" ("Code","Description") VALUES ('J02.9','Acute Pharyngitis, Unspecified');
INSERT INTO "ILLNESS" ("Code","Description") VALUES ('K29.00','Acute Gastritis without Bleeding');
INSERT INTO "ILLNESS" ("Code","Description") VALUES ('R10.9','Abdominal Pain, Unspecified');
INSERT INTO "ILLNESS" ("Code","Description") VALUES ('M25.50','Pain in Unspecified Joint');
INSERT INTO "ILLNESS" ("Code","Description") VALUES ('G44.209','Tension-Type Headache, Unspecified, Not Intractable');
INSERT INTO "ILLNESS" ("Code","Description") VALUES ('H52.13','Myopia, Left Eye, Low Vision');
INSERT INTO "ILLNESS" ("Code","Description") VALUES ('H93.19','Tinnitus, Unspecified Ear');
INSERT INTO "ILLNESS" ("Code","Description") VALUES ('H61.90','Otitis Media, Unspecified Ear');
INSERT INTO "ILLNESS" ("Code","Description") VALUES ('H10.9','Conjunctivitis, Unspecified');
INSERT INTO "ILLNESS" ("Code","Description") VALUES ('B34.9','Viral Infection, Unspecified');
INSERT INTO "WING" ("Code") VALUES ('Blue');
INSERT INTO "WING" ("Code") VALUES ('Green');
INSERT INTO "NURSING_UNIT" ("Code") VALUES (1);
INSERT INTO "NURSING_UNIT" ("Code") VALUES (2);
INSERT INTO "NURSING_UNIT" ("Code") VALUES (3);
INSERT INTO "NURSING_UNIT" ("Code") VALUES (4);
INSERT INTO "NURSING_UNIT" ("Code") VALUES (5);
INSERT INTO "NURSING_UNIT" ("Code") VALUES (6);
INSERT INTO "NURSING_UNIT" ("Code") VALUES (7);
INSERT INTO "STAFF" ("EmpNo","Fname","Minit","Lname","Ssn","Gender","EmpType","Title","Salary","Specialty","NurseGrade","YrsNursingExp","Addr","City","StateProv","ZIP","Country","Phone") VALUES (1,'Lydia','A','Brown','123456789','F','SUPP','Chief of Staff',120000,NULL,NULL,NULL,'1200 Main St','Newark','NJ','07123','United States','555-1111');
INSERT INTO "STAFF" ("EmpNo","Fname","Minit","Lname","Ssn","Gender","EmpType","Title","Salary","Specialty","NurseGrade","YrsNursingExp","Addr","City","StateProv","ZIP","Country","Phone") VALUES (2,'Jane','B','Doe','111222333','F','PHYS','Generalist',125000,'Pathology',NULL,NULL,'100 Oak St','Jersey City','NJ','07321','United States','555-2222');
INSERT INTO "STAFF" ("EmpNo","Fname","Minit","Lname","Ssn","Gender","EmpType","Title","Salary","Specialty","NurseGrade","YrsNursingExp","Addr","City","StateProv","ZIP","Country","Phone") VALUES (3,'Mark','C','Green','333222111','M','SURG','Lead Surgeon',NULL,'Cardiology',NULL,NULL,'20 Spruce St','Jersey City','NJ','07321','United States','555-3333');
INSERT INTO "STAFF" ("EmpNo","Fname","Minit","Lname","Ssn","Gender","EmpType","Title","Salary","Specialty","NurseGrade","YrsNursingExp","Addr","City","StateProv","ZIP","Country","Phone") VALUES (4,'Tony','D','Scarlet','987654321','M','NURS','Head Nurse',100000,NULL,5,10,'345 Willow Ave','Newark','NJ','07123','United States','555-4444');
INSERT INTO "STAFF" ("EmpNo","Fname","Minit","Lname","Ssn","Gender","EmpType","Title","Salary","Specialty","NurseGrade","YrsNursingExp","Addr","City","StateProv","ZIP","Country","Phone") VALUES (5,'Michael','E','Baker','354364136','M','SURG','Surgeon',NULL,'Cardiology',NULL,NULL,'45 Circle Ct','Newark','NJ','07123','United States','555-5555');
INSERT INTO "STAFF" ("EmpNo","Fname","Minit","Lname","Ssn","Gender","EmpType","Title","Salary","Specialty","NurseGrade","YrsNursingExp","Addr","City","StateProv","ZIP","Country","Phone") VALUES (6,'Angelina','F','Hernandez','115879266','F','SURG','Surgeon',NULL,'Cardiology',NULL,NULL,'56 45th St','Philadelphia','PA','09654','United States','555-6666');
INSERT INTO "STAFF" ("EmpNo","Fname","Minit","Lname","Ssn","Gender","EmpType","Title","Salary","Specialty","NurseGrade","YrsNursingExp","Addr","City","StateProv","ZIP","Country","Phone") VALUES (7,'Peter','M','Parker','559311458','M','PHYS','Specialist',275000,'Gastroenterology',NULL,NULL,'587 Ocean Ln','Hoboken','NJ','07852','United States','555-7777');
INSERT INTO "STAFF" ("EmpNo","Fname","Minit","Lname","Ssn","Gender","EmpType","Title","Salary","Specialty","NurseGrade","YrsNursingExp","Addr","City","StateProv","ZIP","Country","Phone") VALUES (8,'David','L','Baldwin','000111222','M','PHYS','Specialist',225000,'Orthopedics',NULL,NULL,'87 Beach St','Red Bank','NJ','07999','United States','555-8888');
INSERT INTO "STAFF" ("EmpNo","Fname","Minit","Lname","Ssn","Gender","EmpType","Title","Salary","Specialty","NurseGrade","YrsNursingExp","Addr","City","StateProv","ZIP","Country","Phone") VALUES (9,'Noor','H','Ahmad','222333444','F','PHYS','Generalist',215000,'Pathology',NULL,NULL,'89 Silver Mine Rd','Suffern','NY','08563','United States','555-9999');
INSERT INTO "STAFF" ("EmpNo","Fname","Minit","Lname","Ssn","Gender","EmpType","Title","Salary","Specialty","NurseGrade","YrsNursingExp","Addr","City","StateProv","ZIP","Country","Phone") VALUES (10,'Ernest',NULL,'Li','333444555','M','NURS','Nurse',65000,NULL,1,2,'5890 Main St','Newark','NJ','07123','United States','555-0000');
INSERT INTO "STAFF" ("EmpNo","Fname","Minit","Lname","Ssn","Gender","EmpType","Title","Salary","Specialty","NurseGrade","YrsNursingExp","Addr","City","StateProv","ZIP","Country","Phone") VALUES (11,'Tracy','O','Allison','555666777','F','NURS','Nurse',65000,NULL,1,2,'54 Eureka Ave','Edison','NJ','07456','United States','555-1000');
INSERT INTO "STAFF" ("EmpNo","Fname","Minit","Lname","Ssn","Gender","EmpType","Title","Salary","Specialty","NurseGrade","YrsNursingExp","Addr","City","StateProv","ZIP","Country","Phone") VALUES (12,'John','P','Smith','666777888','M','SUPP','Shift Manager',90000,NULL,NULL,NULL,'43 Church Rd','Jersey City','NJ','07321','United States','555-2000');
INSERT INTO "STAFF" ("EmpNo","Fname","Minit","Lname","Ssn","Gender","EmpType","Title","Salary","Specialty","NurseGrade","YrsNursingExp","Addr","City","StateProv","ZIP","Country","Phone") VALUES (13,'Taylor',NULL,'White','777888999','F','SUPP','Jr. Payroll Accountant',45000,NULL,NULL,NULL,'6547 City St','Newark','NJ','07123','United States','555-3000');
INSERT INTO "STAFF" ("EmpNo","Fname","Minit","Lname","Ssn","Gender","EmpType","Title","Salary","Specialty","NurseGrade","YrsNursingExp","Addr","City","StateProv","ZIP","Country","Phone") VALUES (14,'Stanley','P','Arabel','111111111','M','SUPP','IT Director',170000,NULL,NULL,NULL,'22 W 2nd Ave','Jersey City','NJ','07321','United States','555-4000');
INSERT INTO "STAFF" ("EmpNo","Fname","Minit","Lname","Ssn","Gender","EmpType","Title","Salary","Specialty","NurseGrade","YrsNursingExp","Addr","City","StateProv","ZIP","Country","Phone") VALUES (15,'Lana','R','Skye','999666333','F','SUPP','Receptionist',40000,NULL,NULL,NULL,'4545 Distant Ln','Yonkers','NY','08521','United States','555-5000');
INSERT INTO "PATIENT" ("PatientNo","Fname","Minit","Lname","Ssn","Gender","Dob","BloodType","RhFactor","Pcp","Addr","City","StateProv","ZIP","Country","Phone") VALUES (1,'Mohammad','M','Abdullah','986486000','M','1/16/1974','A','-',2,'789 Cooper St','Newark','New Jersey','07111','United States','555-2536');
INSERT INTO "PATIENT" ("PatientNo","Fname","Minit","Lname","Ssn","Gender","Dob","BloodType","RhFactor","Pcp","Addr","City","StateProv","ZIP","Country","Phone") VALUES (2,'Bob','A','Smith','455523369','M','1/1/1990','AB','+',2,'87 Maple St','Toronto','Ontario','A1A 2B2','Canada','555-6589');
INSERT INTO "PATIENT" ("PatientNo","Fname","Minit","Lname","Ssn","Gender","Dob","BloodType","RhFactor","Pcp","Addr","City","StateProv","ZIP","Country","Phone") VALUES (3,'Grace',NULL,'Nguyen',NULL,'F','1/1/2001','O','-',2,'345 Washington Ave','Newark','New Jersey','07111','United States','555-4455');
INSERT INTO "PATIENT" ("PatientNo","Fname","Minit","Lname","Ssn","Gender","Dob","BloodType","RhFactor","Pcp","Addr","City","StateProv","ZIP","Country","Phone") VALUES (5,'Jon','L','Polowski','566999555','M','2/18/1974',NULL,NULL,7,'1111 Main St','Newark','New Jersey','07111','United States','555-8523');
INSERT INTO "PATIENT" ("PatientNo","Fname","Minit","Lname","Ssn","Gender","Dob","BloodType","RhFactor","Pcp","Addr","City","StateProv","ZIP","Country","Phone") VALUES (6,'Courtney','L','Rachels','898787447','F','5/18/1995','A','+',2,'78 Lincoln Ave','Philadelphia','Pennsylvania','08561','United States','555-8564');
INSERT INTO "PATIENT" ("PatientNo","Fname","Minit","Lname","Ssn","Gender","Dob","BloodType","RhFactor","Pcp","Addr","City","StateProv","ZIP","Country","Phone") VALUES (7,'Zack','W','Steiner','752263354','M','9/14/1965','A','+',7,'4 Brookside Dr','Dublin',NULL,'D22','Ireland',NULL);
INSERT INTO "PATIENT" ("PatientNo","Fname","Minit","Lname","Ssn","Gender","Dob","BloodType","RhFactor","Pcp","Addr","City","StateProv","ZIP","Country","Phone") VALUES (8,'Gary','M','Jackson','445522779','M','8/30/1954','B','+',2,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "PATIENT" ("PatientNo","Fname","Minit","Lname","Ssn","Gender","Dob","BloodType","RhFactor","Pcp","Addr","City","StateProv","ZIP","Country","Phone") VALUES (9,'Jessica','J','Quincy','556894331','F','8/1/1984','O','+',7,'65 Hickory St','Morristown','New Jersey','07554','United States','555-8897');
INSERT INTO "PATIENT" ("PatientNo","Fname","Minit","Lname","Ssn","Gender","Dob","BloodType","RhFactor","Pcp","Addr","City","StateProv","ZIP","Country","Phone") VALUES (10,'Ivan','R','Vitaly','555888666','M','4/5/1967','B','-',1,'1 Eagle St','Atlanta','Georgia','56211','United States','555-9876');
INSERT INTO "SURG_CONTRACT" ("EmpNo","ContractType","LengthYrs") VALUES (3,'Independent',2);
INSERT INTO "SURG_CONTRACT" ("EmpNo","ContractType","LengthYrs") VALUES (5,'Independent',3);
INSERT INTO "SURG_CONTRACT" ("EmpNo","ContractType","LengthYrs") VALUES (6,'Call Coverage',1);
INSERT INTO "PATIENT_SUGAR" ("ReadingNo","PatientNo","ReadTime","mgdL") VALUES (1,1,'1/16/2023',75);
INSERT INTO "PATIENT_SUGAR" ("ReadingNo","PatientNo","ReadTime","mgdL") VALUES (2,1,'7/5/2023',45);
INSERT INTO "BED" ("Code","Clinic","Wing","NurseUnit","RoomNo","Bed") VALUES (14,'High Point Hospital','Blue',1,101,'A');
INSERT INTO "BED" ("Code","Clinic","Wing","NurseUnit","RoomNo","Bed") VALUES (15,'High Point Hospital','Blue',1,101,'B');
INSERT INTO "BED" ("Code","Clinic","Wing","NurseUnit","RoomNo","Bed") VALUES (16,'High Point Hospital','Blue',1,102,'A');
INSERT INTO "BED" ("Code","Clinic","Wing","NurseUnit","RoomNo","Bed") VALUES (17,'High Point Hospital','Blue',1,102,'B');
INSERT INTO "BED" ("Code","Clinic","Wing","NurseUnit","RoomNo","Bed") VALUES (18,'High Point Hospital','Blue',2,103,'A');
INSERT INTO "BED" ("Code","Clinic","Wing","NurseUnit","RoomNo","Bed") VALUES (19,'High Point Hospital','Blue',2,103,'B');
INSERT INTO "BED" ("Code","Clinic","Wing","NurseUnit","RoomNo","Bed") VALUES (20,'High Point Hospital','Green',3,201,'A');
INSERT INTO "BED" ("Code","Clinic","Wing","NurseUnit","RoomNo","Bed") VALUES (21,'High Point Hospital','Green',3,201,'B');
INSERT INTO "BED" ("Code","Clinic","Wing","NurseUnit","RoomNo","Bed") VALUES (22,'High Point Hospital','Green',3,202,'A');
INSERT INTO "BED" ("Code","Clinic","Wing","NurseUnit","RoomNo","Bed") VALUES (23,'High Point Hospital','Green',3,202,'B');
INSERT INTO "BED" ("Code","Clinic","Wing","NurseUnit","RoomNo","Bed") VALUES (24,'High Point Hospital','Green',4,203,'A');
INSERT INTO "BED" ("Code","Clinic","Wing","NurseUnit","RoomNo","Bed") VALUES (25,'High Point Hospital','Green',4,203,'B');
INSERT INTO "BED" ("Code","Clinic","Wing","NurseUnit","RoomNo","Bed") VALUES (26,'Jersey City Health','Blue',1,101,'A');
INSERT INTO "BED" ("Code","Clinic","Wing","NurseUnit","RoomNo","Bed") VALUES (27,'Jersey City Health','Blue',1,101,'B');
INSERT INTO "BED" ("Code","Clinic","Wing","NurseUnit","RoomNo","Bed") VALUES (28,'Jersey City Health','Blue',1,102,'A');
INSERT INTO "BED" ("Code","Clinic","Wing","NurseUnit","RoomNo","Bed") VALUES (29,'Jersey City Health','Blue',1,102,'B');
INSERT INTO "BED" ("Code","Clinic","Wing","NurseUnit","RoomNo","Bed") VALUES (30,'Jersey City Health','Blue',2,103,'A');
INSERT INTO "BED" ("Code","Clinic","Wing","NurseUnit","RoomNo","Bed") VALUES (31,'Jersey City Health','Blue',2,103,'B');
INSERT INTO "BED" ("Code","Clinic","Wing","NurseUnit","RoomNo","Bed") VALUES (32,'Jersey City Health','Green',3,201,'A');
INSERT INTO "BED" ("Code","Clinic","Wing","NurseUnit","RoomNo","Bed") VALUES (33,'Jersey City Health','Green',3,201,'B');
INSERT INTO "BED" ("Code","Clinic","Wing","NurseUnit","RoomNo","Bed") VALUES (34,'Jersey City Health','Green',3,202,'A');
INSERT INTO "BED" ("Code","Clinic","Wing","NurseUnit","RoomNo","Bed") VALUES (35,'Jersey City Health','Green',3,202,'B');
INSERT INTO "BED" ("Code","Clinic","Wing","NurseUnit","RoomNo","Bed") VALUES (36,'Jersey City Health','Green',4,203,'A');
INSERT INTO "BED" ("Code","Clinic","Wing","NurseUnit","RoomNo","Bed") VALUES (37,'Jersey City Health','Green',4,203,'B');
INSERT INTO "BED" ("Code","Clinic","Wing","NurseUnit","RoomNo","Bed") VALUES (38,'Newark Medical Clinic','Blue',1,101,'A');
INSERT INTO "BED" ("Code","Clinic","Wing","NurseUnit","RoomNo","Bed") VALUES (39,'Newark Medical Clinic','Blue',1,101,'B');
INSERT INTO "BED" ("Code","Clinic","Wing","NurseUnit","RoomNo","Bed") VALUES (40,'Newark Medical Clinic','Blue',1,102,'A');
INSERT INTO "BED" ("Code","Clinic","Wing","NurseUnit","RoomNo","Bed") VALUES (41,'Newark Medical Clinic','Blue',1,102,'B');
INSERT INTO "BED" ("Code","Clinic","Wing","NurseUnit","RoomNo","Bed") VALUES (42,'Newark Medical Clinic','Blue',2,103,'A');
INSERT INTO "BED" ("Code","Clinic","Wing","NurseUnit","RoomNo","Bed") VALUES (43,'Newark Medical Clinic','Blue',2,103,'B');
INSERT INTO "BED" ("Code","Clinic","Wing","NurseUnit","RoomNo","Bed") VALUES (44,'Newark Medical Clinic','Green',3,201,'A');
INSERT INTO "BED" ("Code","Clinic","Wing","NurseUnit","RoomNo","Bed") VALUES (45,'Newark Medical Clinic','Green',3,201,'B');
INSERT INTO "BED" ("Code","Clinic","Wing","NurseUnit","RoomNo","Bed") VALUES (46,'Newark Medical Clinic','Green',3,202,'A');
INSERT INTO "BED" ("Code","Clinic","Wing","NurseUnit","RoomNo","Bed") VALUES (47,'Newark Medical Clinic','Green',3,202,'B');
INSERT INTO "BED" ("Code","Clinic","Wing","NurseUnit","RoomNo","Bed") VALUES (48,'Newark Medical Clinic','Green',4,203,'A');
INSERT INTO "BED" ("Code","Clinic","Wing","NurseUnit","RoomNo","Bed") VALUES (49,'Newark Medical Clinic','Green',4,203,'B');
INSERT INTO "OP_THEATRE" ("Code","Clinic","Theatre") VALUES (1,'High Point Hospital','A');
INSERT INTO "OP_THEATRE" ("Code","Clinic","Theatre") VALUES (2,'High Point Hospital','B');
INSERT INTO "OP_THEATRE" ("Code","Clinic","Theatre") VALUES (3,'High Point Hospital','C');
INSERT INTO "OP_THEATRE" ("Code","Clinic","Theatre") VALUES (4,'Newark Medical Clinic','A');
INSERT INTO "OP_THEATRE" ("Code","Clinic","Theatre") VALUES (5,'Newark Medical Clinic','B');
INSERT INTO "OP_THEATRE" ("Code","Clinic","Theatre") VALUES (6,'Newark Medical Clinic','C');
INSERT INTO "OP_THEATRE" ("Code","Clinic","Theatre") VALUES (7,'Newark Medical Clinic','D');
INSERT INTO "OP_THEATRE" ("Code","Clinic","Theatre") VALUES (8,'Newark Medical Clinic','E');
INSERT INTO "OP_THEATRE" ("Code","Clinic","Theatre") VALUES (10,'Newark Medical Clinic','F');
INSERT INTO "APPOINTMENT" ("AppointmentNo","PatientNo","Physician","Clinic","Time","Type") VALUES (1,1,2,'Newark Medical Clinic','11/19/2023 12:00PM','Consultation');
INSERT INTO "APPOINTMENT" ("AppointmentNo","PatientNo","Physician","Clinic","Time","Type") VALUES (2,1,2,'Newark Medical Clinic','11/19/2023 1:00 PM','Routine');
INSERT INTO "APPOINTMENT" ("AppointmentNo","PatientNo","Physician","Clinic","Time","Type") VALUES (3,2,2,'Newark Medical Clinic','11/19/2023 2:00 PM','Consultation');
INSERT INTO "APPOINTMENT" ("AppointmentNo","PatientNo","Physician","Clinic","Time","Type") VALUES (4,1,2,'Newark Medical Clinic','11/30/2023 9:00 AM','Consultation');
INSERT INTO "APPOINTMENT" ("AppointmentNo","PatientNo","Physician","Clinic","Time","Type") VALUES (5,3,2,'Newark Medical Clinic','11/20/2023 9:00 AM','Consultation');
INSERT INTO "APPOINTMENT" ("AppointmentNo","PatientNo","Physician","Clinic","Time","Type") VALUES (6,6,7,'High Point Hospital','11/20/2023 9:00 AM','Consultation');
INSERT INTO "APPOINTMENT" ("AppointmentNo","PatientNo","Physician","Clinic","Time","Type") VALUES (7,7,7,'High Point Hospital','11/20/2023 10:00 AM','Consultation');
INSERT INTO "APPOINTMENT" ("AppointmentNo","PatientNo","Physician","Clinic","Time","Type") VALUES (8,8,7,'High Point Hospital','11/20/2023 11:00 AM','Consultation');
INSERT INTO "APPOINTMENT" ("AppointmentNo","PatientNo","Physician","Clinic","Time","Type") VALUES (9,9,2,'Newark Medical Clinic','11/20/2023 10:00 AM','Consultation');
INSERT INTO "APPOINTMENT" ("AppointmentNo","PatientNo","Physician","Clinic","Time","Type") VALUES (10,10,8,'Newark Medical Clinic','11/20/2023 2:00 PM','Consultation');
INSERT INTO "APPOINTMENT" ("AppointmentNo","PatientNo","Physician","Clinic","Time","Type") VALUES (11,5,2,'Newark Medical Clinic','11/21/2023 9:00 AM','Consultation');
INSERT INTO "PATIENT_ILLNESS" ("DiagnosisNo","PatientNo","Illness","AppointmentNo") VALUES (1,1,'I10',1);
INSERT INTO "PATIENT_ILLNESS" ("DiagnosisNo","PatientNo","Illness","AppointmentNo") VALUES (6,2,'I10',3);
INSERT INTO "PATIENT_ILLNESS" ("DiagnosisNo","PatientNo","Illness","AppointmentNo") VALUES (7,3,'E11.9',5);
INSERT INTO "PATIENT_ILLNESS" ("DiagnosisNo","PatientNo","Illness","AppointmentNo") VALUES (8,6,'F32.9',6);
INSERT INTO "PATIENT_ILLNESS" ("DiagnosisNo","PatientNo","Illness","AppointmentNo") VALUES (9,7,'G44.209',7);
INSERT INTO "PATIENT_ILLNESS" ("DiagnosisNo","PatientNo","Illness","AppointmentNo") VALUES (10,8,'H61.90',8);
INSERT INTO "PATIENT_ILLNESS" ("DiagnosisNo","PatientNo","Illness","AppointmentNo") VALUES (11,9,'B34.9',9);
INSERT INTO "PATIENT_ILLNESS" ("DiagnosisNo","PatientNo","Illness","AppointmentNo") VALUES (12,10,'B34.9',10);
INSERT INTO "PATIENT_ILLNESS" ("DiagnosisNo","PatientNo","Illness","AppointmentNo") VALUES (13,5,'H93.19',11);
INSERT INTO "PATIENT_ILLNESS" ("DiagnosisNo","PatientNo","Illness","AppointmentNo") VALUES (14,1,'E11.9',1);
INSERT INTO "NURSE_SURG_SKILL" ("EmpNo","Skill") VALUES (4,4);
INSERT INTO "NURSE_SURG_SKILL" ("EmpNo","Skill") VALUES (4,5);
INSERT INTO "NURSE_SURG_SKILL" ("EmpNo","Skill") VALUES (4,6);
INSERT INTO "NURSE_SURG_SKILL" ("EmpNo","Skill") VALUES (10,1);
INSERT INTO "NURSE_SURG_SKILL" ("EmpNo","Skill") VALUES (10,2);
INSERT INTO "NURSE_SURG_SKILL" ("EmpNo","Skill") VALUES (11,6);
INSERT INTO "NURSE_SURG_SKILL" ("EmpNo","Skill") VALUES (11,1);
INSERT INTO "SURG_TYPE_SKILL" ("Type","Skill") VALUES (1,1);
INSERT INTO "SURG_TYPE_SKILL" ("Type","Skill") VALUES (1,2);
INSERT INTO "SURG_TYPE_SKILL" ("Type","Skill") VALUES (2,2);
INSERT INTO "SURG_TYPE_SKILL" ("Type","Skill") VALUES (2,3);
INSERT INTO "SURG_TYPE_SKILL" ("Type","Skill") VALUES (2,4);
INSERT INTO "NURSE_SURG_TYPE" ("EmpNo","Type") VALUES (4,2);
INSERT INTO "NURSE_SURG_TYPE" ("EmpNo","Type") VALUES (10,2);
INSERT INTO "NURSE_SURG_TYPE" ("EmpNo","Type") VALUES (11,1);
INSERT INTO "MED_INTERACT" ("InteractionNo","MedA","MedB","Severity") VALUES (1,'00168047515','00378046501','N');
INSERT INTO "MED_INTERACT" ("InteractionNo","MedA","MedB","Severity") VALUES (2,'00168047515','00093529201','L');
INSERT INTO "MED_INTERACT" ("InteractionNo","MedA","MedB","Severity") VALUES (3,'00168047515','00054446001','M');
INSERT INTO "MED_INTERACT" ("InteractionNo","MedA","MedB","Severity") VALUES (4,'00168047515','00378233001','S');
INSERT INTO "OWNER" ("OwnerID","Clinic","CorpName","EmpNo","PctOwnership") VALUES (1,'Newark Medical Clinic','Newark Medical Associates, Inc.',NULL,75);
INSERT INTO "OWNER" ("OwnerID","Clinic","CorpName","EmpNo","PctOwnership") VALUES (2,'Newark Medical Clinic','MediLife Healthcare Corporation',NULL,20);
INSERT INTO "OWNER" ("OwnerID","Clinic","CorpName","EmpNo","PctOwnership") VALUES (3,'Newark Medical Clinic',NULL,2,5);
INSERT INTO "OWNER" ("OwnerID","Clinic","CorpName","EmpNo","PctOwnership") VALUES (4,'Jersey City Health',NULL,2,2);
INSERT INTO "OWNER" ("OwnerID","Clinic","CorpName","EmpNo","PctOwnership") VALUES (5,'Jersey City Health','MediLife Healthcare Corporation',NULL,90);
INSERT INTO "OWNER" ("OwnerID","Clinic","CorpName","EmpNo","PctOwnership") VALUES (6,'Jersey City Health',NULL,7,3);
INSERT INTO "OWNER" ("OwnerID","Clinic","CorpName","EmpNo","PctOwnership") VALUES (7,'High Point Hospital','MediServe Health Systems',NULL,45);
INSERT INTO "OWNER" ("OwnerID","Clinic","CorpName","EmpNo","PctOwnership") VALUES (8,'High Point Hospital','Newark Medical Associates, Inc.',NULL,55);
INSERT INTO "PATIENT_ALLERGY" ("DiagnosisNo","PatientNo","Allergy","AppointmentNo") VALUES (1,1,'T78.1XXA',1);
INSERT INTO "PATIENT_ALLERGY" ("DiagnosisNo","PatientNo","Allergy","AppointmentNo") VALUES (2,1,'T78.05XA',1);
INSERT INTO "PATIENT_CHOLESTEROL" ("ReadingNo","PatientNo","ReadTime","Hdl","Ldl","Triglycerides","CalculatedRatio","CalculatedRiskCode","HighRiskFlag") VALUES (6,1,'1/15/2023',45,185,180,5.91111111111111,'M',1);
INSERT INTO "PATIENT_CHOLESTEROL" ("ReadingNo","PatientNo","ReadTime","Hdl","Ldl","Triglycerides","CalculatedRatio","CalculatedRiskCode","HighRiskFlag") VALUES (7,1,'4/14/2023',52,154,175,4.63461538461539,'L',0);
INSERT INTO "PATIENT_CHOLESTEROL" ("ReadingNo","PatientNo","ReadTime","Hdl","Ldl","Triglycerides","CalculatedRatio","CalculatedRiskCode","HighRiskFlag") VALUES (8,1,'7/5/2023',59,160,154,4.23389830508475,'L',0);
INSERT INTO "PATIENT_CHOLESTEROL" ("ReadingNo","PatientNo","ReadTime","Hdl","Ldl","Triglycerides","CalculatedRatio","CalculatedRiskCode","HighRiskFlag") VALUES (9,1,'10/25/2023',60,142,132,3.80666666666667,'N',0);
INSERT INTO "PATIENT_PRESCRIPTION" ("PrescriptionNo","PatientNo","Medication","Dosage","Freq","PrescribedBy") VALUES (1,1,'00168047515','20mcg','2x per day',7);
INSERT INTO "PATIENT_PRESCRIPTION" ("PrescriptionNo","PatientNo","Medication","Dosage","Freq","PrescribedBy") VALUES (2,1,'00378636501','10mL','1x per day',9);
INSERT INTO "SURG_TYPE" ("Code","Name","Category","AnatomicalLoc","SpecialNeeds") VALUES (1,'Orthopedic Surgery','H',43,'None');
INSERT INTO "SURG_TYPE" ("Code","Name","Category","AnatomicalLoc","SpecialNeeds") VALUES (2,'Cardiovascular Surgery','H',18,'Cardiac monitoring required');
INSERT INTO "SURG_TYPE" ("Code","Name","Category","AnatomicalLoc","SpecialNeeds") VALUES (3,'Neurological Surgery','H',41,'Neurosurgeon needed');
INSERT INTO "SURG_TYPE" ("Code","Name","Category","AnatomicalLoc","SpecialNeeds") VALUES (4,'General Surgery','H',1,'None');
INSERT INTO "SURG_TYPE" ("Code","Name","Category","AnatomicalLoc","SpecialNeeds") VALUES (5,'Plastic Surgery','O',24,'Dermatologist consultation required');
INSERT INTO "SURGERY" ("SurgeryNo","PatientNo","Surgeon","SurgeryTime","OpTheatre","SurgeryType") VALUES (1,1,6,'11/19/2023',1,2);
INSERT INTO "SURGERY" ("SurgeryNo","PatientNo","Surgeon","SurgeryTime","OpTheatre","SurgeryType") VALUES (2,1,3,'11/20/2023',1,1);
INSERT INTO "SURGERY" ("SurgeryNo","PatientNo","Surgeon","SurgeryTime","OpTheatre","SurgeryType") VALUES (3,2,6,'11/21/2023',2,1);
INSERT INTO "SURGERY_STAFF" ("SurgeryNo","EmpNo") VALUES (1,4);
INSERT INTO "SURGERY_STAFF" ("SurgeryNo","EmpNo") VALUES (1,10);
INSERT INTO "SURGERY_STAFF" ("SurgeryNo","EmpNo") VALUES (2,4);
INSERT INTO "SURGERY_STAFF" ("SurgeryNo","EmpNo") VALUES (2,11);
INSERT INTO "SHIFT" ("ShiftNo","EmpNo","StartDate","Shift") VALUES (1,1,'11/20/2023',1);
INSERT INTO "SHIFT" ("ShiftNo","EmpNo","StartDate","Shift") VALUES (3,1,'11/21/2023',1);
INSERT INTO "SHIFT" ("ShiftNo","EmpNo","StartDate","Shift") VALUES (4,1,'11/22/2023',1);
INSERT INTO "STAY" ("StayNo","PatientNo","Bed","AdmissionDate","DiagnosisNo","Physician","Nurse") VALUES (1,1,14,'11/25/2023',1,2,4);
INSERT INTO "STAY" ("StayNo","PatientNo","Bed","AdmissionDate","DiagnosisNo","Physician","Nurse") VALUES (3,2,16,'11/25/2023',6,NULL,4);
INSERT INTO "STAY" ("StayNo","PatientNo","Bed","AdmissionDate","DiagnosisNo","Physician","Nurse") VALUES (4,7,35,'11/26/2023',9,9,4);
INSERT INTO "STAY" ("StayNo","PatientNo","Bed","AdmissionDate","DiagnosisNo","Physician","Nurse") VALUES (5,6,15,'11/27/2023',8,2,4);
INSERT INTO "STAY" ("StayNo","PatientNo","Bed","AdmissionDate","DiagnosisNo","Physician","Nurse") VALUES (6,10,19,'11/30/2023',12,9,4);

CREATE TRIGGER AUTOREASSIGN_PCP
AFTER DELETE ON STAFF
FOR EACH ROW
BEGIN
    UPDATE PATIENT
    SET Pcp = (SELECT EmpNo FROM STAFF WHERE Title = 'Chief of Staff' LIMIT 1)
    WHERE Pcp = OLD.EmpType;
END;
CREATE TRIGGER CHECK_CONTRACT_EMP_INSERT
BEFORE INSERT ON SURG_CONTRACT
FOR EACH ROW
WHEN NOT EXISTS (
    SELECT 1 FROM STAFF WHERE EmpNo = NEW.EmpNo AND EmpType = 'SURG'
)
BEGIN
    SELECT RAISE (ABORT, 'The selected Employee must be a Surgeon.');
END;
CREATE TRIGGER CHECK_CONTRACT_EMP_UPDATE
BEFORE UPDATE ON SURG_CONTRACT
FOR EACH ROW
WHEN NOT EXISTS (
    SELECT 1 FROM STAFF WHERE EmpNo = NEW.EmpNo AND EmpType = 'SURG'
)
BEGIN
    SELECT RAISE (ABORT, 'The selected Employee must be a Surgeon.');
END;
CREATE TRIGGER CHECK_PCP_INSERT
BEFORE INSERT ON PATIENT
FOR EACH ROW
WHEN NOT EXISTS (
    SELECT 1 FROM STAFF WHERE EmpNo = NEW.Pcp AND (EmpType = 'PHYS' OR Title = 'Chief of Staff')
)
BEGIN
    SELECT RAISE (ABORT, 'The selected Primary Care Provider must be a Physician or the Chief of Staff.');
END;
CREATE TRIGGER CHECK_PCP_UPDATE
BEFORE UPDATE ON PATIENT
FOR EACH ROW
WHEN NOT EXISTS (
    SELECT 1 FROM STAFF WHERE EmpNo = NEW.Pcp AND (EmpType = 'PHYS' OR Title = 'Chief of Staff')
)
BEGIN
    SELECT RAISE (ABORT, 'The selected Primary Care Provider must be a Physician or the Chief of Staff.');
END;
CREATE TRIGGER CHECK_BED_DUP_INSERT
BEFORE INSERT ON BED
FOR EACH ROW
WHEN EXISTS (
    SELECT 1 FROM BED WHERE Clinic = NEW.Clinic AND Wing = NEW.Wing AND NurseUnit = NEW.NurseUnit AND RoomNo = NEW.RoomNo AND Bed = NEW.Bed
)
BEGIN
    SELECT RAISE (ABORT, 'The selected combination of clinic, wing, nursing unit, room, and bed already exists.');
END;
CREATE TRIGGER CHECK_BED_DUP_UPDATE
BEFORE UPDATE ON BED
FOR EACH ROW
WHEN EXISTS (
    SELECT 1 FROM BED WHERE Clinic = NEW.Clinic AND Wing = NEW.Wing AND NurseUnit = NEW.NurseUnit AND RoomNo = NEW.RoomNo AND Bed = NEW.Bed
)
BEGIN
    SELECT RAISE (ABORT, 'The selected combination of clinic, wing, nursing unit, room, and bed already exists.');
END;
CREATE TRIGGER CHECK_APPT_PHYS_INSERT
BEFORE INSERT ON APPOINTMENT
FOR EACH ROW
WHEN NOT EXISTS (
    SELECT 1 FROM STAFF WHERE EmpNo = NEW.Physician AND (EmpType = 'PHYS' OR Title = 'Chief of Staff')
)
BEGIN
    SELECT RAISE (ABORT, 'The selected Employee must be a Physician or the Chief of Staff.');
END;
CREATE TRIGGER CHECK_APPT_PHYS_UPDATE
BEFORE UPDATE ON APPOINTMENT
FOR EACH ROW
WHEN NOT EXISTS (
    SELECT 1 FROM STAFF WHERE EmpNo = NEW.Physician AND (EmpType = 'PHYS' OR Title = 'Chief of Staff')
)
BEGIN
    SELECT RAISE (ABORT, 'The selected Employee must be a Physician or the Chief of Staff.');
END;
CREATE TRIGGER CHECK_PATIENT_ILLNESS_DUP_INSERT
BEFORE INSERT ON PATIENT_ILLNESS
FOR EACH ROW
WHEN EXISTS (
    SELECT 1 FROM PATIENT_ILLNESS WHERE PatientNo = NEW.PatientNo AND Illness = NEW.Illness
)
BEGIN
    SELECT RAISE (ABORT, 'The selected Illness has already been diagnosed for this Patient.');
END;
CREATE TRIGGER CHECK_PATIENT_ILLNESS_DUP_UPDATE
BEFORE UPDATE ON PATIENT_ILLNESS
FOR EACH ROW
WHEN EXISTS (
    SELECT 1 FROM PATIENT_ILLNESS WHERE PatientNo = NEW.PatientNo AND Illness = NEW.Illness
)
BEGIN
    SELECT RAISE (ABORT, 'The selected Illness has already been diagnosed for this Patient.');
END;
CREATE TRIGGER CHECK_PATIENT_ILLNESS_APPT_INSERT
BEFORE INSERT ON PATIENT_ILLNESS
FOR EACH ROW
WHEN NOT EXISTS (
    SELECT 1 FROM APPOINTMENT WHERE PatientNo = NEW.PatientNo AND AppointmentNo = NEW.AppointmentNo AND Type = 'Consultation'
)
BEGIN
    SELECT RAISE (ABORT, 'The selected Appointment must be a Consultation that belongs to the selected Patient.');
END;
CREATE TRIGGER CHECK_PATIENT_ILLNESS_APPT_UPDATE
BEFORE UPDATE ON PATIENT_ILLNESS
FOR EACH ROW
WHEN NOT EXISTS (
    SELECT 1 FROM APPOINTMENT WHERE PatientNo = NEW.PatientNo AND AppointmentNo = NEW.AppointmentNo AND Type = 'Consultation'
)
BEGIN
    SELECT RAISE (ABORT, 'The selected Appointment must be a Consultation that belongs to the selected Patient.');
END;
CREATE TRIGGER CHECK_NURSE_SURG_SKILL_INSERT
BEFORE INSERT ON NURSE_SURG_SKILL
FOR EACH ROW
WHEN NOT EXISTS (
    SELECT 1 FROM STAFF WHERE EmpNo = NEW.EmpNo AND EmpType = 'NURS'
)
BEGIN
    SELECT RAISE (ABORT, 'The selected employee must be a Nurse.');
END;
CREATE TRIGGER CHECK_NURSE_SURG_SKILL_UPDATE
BEFORE UPDATE ON NURSE_SURG_SKILL
FOR EACH ROW
WHEN NOT EXISTS (
    SELECT 1 FROM STAFF WHERE EmpNo = NEW.EmpNo AND EmpType = 'NURS'
)
BEGIN
    SELECT RAISE (ABORT, 'The selected employee must be a Nurse.');
END;
CREATE TRIGGER CHECK_NURSE_SURG_SKILL_DUP_INSERT
BEFORE INSERT ON NURSE_SURG_SKILL
FOR EACH ROW
WHEN EXISTS (
    SELECT 1 FROM NURSE_SURG_SKILL WHERE EmpNo = NEW.EmpNo AND Skill = NEW.Skill
)
    BEGIN
        SELECT RAISE(ABORT, 'The selected Nurse and Skill combination already exists.');
    END;
CREATE TRIGGER CHECK_NURSE_SURG_SKILL_DUP_UPDATE
BEFORE UPDATE ON NURSE_SURG_SKILL
FOR EACH ROW
WHEN EXISTS (
    SELECT 1 FROM NURSE_SURG_SKILL WHERE EmpNo = NEW.EmpNo AND Skill = NEW.Skill
)
    BEGIN
        SELECT RAISE(ABORT, 'The selected Nurse and Skill combination already exists.');
    END;
CREATE TRIGGER CHECK_SURG_TYPE_SKILL_DUP_INSERT
BEFORE INSERT ON SURG_TYPE_SKILL
FOR EACH ROW
WHEN EXISTS (
    SELECT 1 FROM SURG_TYPE_SKILL WHERE Type = NEW.Type AND Skill = NEW.Skill
)
    BEGIN
        SELECT RAISE(ABORT, 'The selected Type and Skill combination already exists.');
    END;
CREATE TRIGGER CHECK_SURG_TYPE_SKILL_DUP_UPDATE
BEFORE UPDATE ON SURG_TYPE_SKILL
FOR EACH ROW
WHEN EXISTS (
    SELECT 1 FROM SURG_TYPE_SKILL WHERE Type = NEW.Type AND Skill = NEW.Skill
)
    BEGIN
        SELECT RAISE(ABORT, 'The selected Type and Skill combination already exists.');
    END;
CREATE TRIGGER CHECK_MED_DUP_INSERT
BEFORE INSERT ON MED_INTERACT
FOR EACH ROW
WHEN (NEW.MedA = NEW.MedB) OR EXISTS (
    SELECT 1 FROM MED_INTERACT WHERE (MedA = NEW.MedA AND MedB = NEW.MedB) OR (MedA = NEW.MedB AND MedB = NEW.MedA)
)
    BEGIN
        SELECT RAISE(ABORT, 'Medicine A and Medicine B is either set to the same value, or the combination of values entered already exists');
    END;
CREATE TRIGGER CHECK_MED_DUP_UPDATE
BEFORE UPDATE ON MED_INTERACT
FOR EACH ROW
WHEN (NEW.MedA = NEW.MedB) OR EXISTS (
    SELECT 1 FROM MED_INTERACT WHERE (MedA = NEW.MedA AND MedB = NEW.MedB) OR (MedA = NEW.MedB AND MedB = NEW.MedA)
)
    BEGIN
        SELECT RAISE(ABORT, 'Medicine A and Medicine B is either set to the same value, or the combination of values entered already exists');
    END;
CREATE TRIGGER CHECK_OWNER_INSERT
BEFORE INSERT ON OWNER
FOR EACH ROW
WHEN NOT (
    (NEW.EmpNo IS NOT NULL AND NEW.CorpName IS NULL AND EXISTS (
        SELECT 1 FROM STAFF WHERE EmpNo = NEW.EmpNo AND EmpType = 'PHYS'
    ))
    OR
    (NEW.EmpNo IS NULL AND NEW.CorpName IS NOT NULL)
)
BEGIN
    SELECT RAISE (ABORT, 'Each owner must be either Physician or a Corporation.');
END;
CREATE TRIGGER CHECK_OWNER_UPDATE
BEFORE UPDATE ON OWNER
FOR EACH ROW
WHEN NOT (
    (NEW.EmpNo IS NOT NULL AND NEW.CorpName IS NULL AND EXISTS (
        SELECT 1 FROM STAFF WHERE EmpNo = NEW.EmpNo AND EmpType = 'PHYS'
    ))
    OR
    (NEW.EmpNo IS NULL AND NEW.CorpName IS NOT NULL)
)
BEGIN
    SELECT RAISE (ABORT, 'Each owner must be either Physician or a Corporation.');
END;
CREATE TRIGGER CHECK_PCP_COUNT_INSERT
    BEFORE INSERT ON PATIENT
    FOR EACH ROW
    WHEN (
        (SELECT COUNT(*) FROM PATIENT WHERE Pcp = NEW.Pcp) >= 20
    )
    BEGIN
       SELECT RAISE (ABORT, 'This Physician already acts as a Primary Care Provider for 20 patients and no more can be added.'); 
    END;
CREATE TRIGGER CHECK_PATIENT_ALLERGY_APPT_INSERT
    BEFORE INSERT ON PATIENT_ALLERGY
    FOR EACH ROW
    WHEN NOT EXISTS (
        SELECT 1 FROM APPOINTMENT WHERE PatientNo = NEW.PatientNo AND AppointmentNo = NEW.AppointmentNo AND Type = 'Consultation'
    )
    BEGIN
        SELECT RAISE (ABORT, 'The selected Appointment must be a Consultation that belongs to the selected Patient.');
    END;
CREATE TRIGGER CHECK_PATIENT_ALLERGY_APPT_UPDATE
    BEFORE UPDATE ON PATIENT_ALLERGY
    FOR EACH ROW
    WHEN NOT EXISTS (
        SELECT 1 FROM APPOINTMENT WHERE PatientNo = NEW.PatientNo AND AppointmentNo = NEW.AppointmentNo AND Type = 'Consultation'
    )
    BEGIN
        SELECT RAISE (ABORT, 'The selected Appointment must be a Consultation that belongs to the selected Patient.');
    END;
CREATE TRIGGER CALC_HEART_RISK_RATIO_INSERT
    AFTER INSERT ON PATIENT_CHOLESTEROL
    FOR EACH ROW
    BEGIN
        UPDATE PATIENT_CHOLESTEROL
        SET
            CalculatedRatio = (NEW.Hdl + NEW.Ldl + (0.2 * NEW.Triglycerides)) / NEW.Hdl
        WHERE ReadingNo = NEW.ReadingNo;
    END;
CREATE TRIGGER CALC_HEART_RISK_RATIO_UPDATE
    AFTER UPDATE ON PATIENT_CHOLESTEROL
    FOR EACH ROW
    BEGIN
        UPDATE PATIENT_CHOLESTEROL
        SET
            CalculatedRatio = (NEW.Hdl + NEW.Ldl + (0.2 * NEW.Triglycerides)) / NEW.Hdl
        WHERE ReadingNo = NEW.ReadingNo;
    END;
CREATE TRIGGER CALC_HEART_RISK_CODE
    AFTER UPDATE ON PATIENT_CHOLESTEROL
    FOR EACH ROW
    BEGIN
        UPDATE PATIENT_CHOLESTEROL
        SET CalculatedRiskCode =
            CASE
                WHEN (NEW.CalculatedRatio < 4) THEN 'N'
                WHEN (NEW.CalculatedRatio >= 4 AND NEW.CalculatedRatio <= 5) THEN 'L'
                ELSE 'M'
                END
        WHERE ReadingNo = NEW.ReadingNo;
    END;
CREATE TRIGGER CHECK_PATIENT_ILLNESS_COUNT_DELETE
    BEFORE DELETE ON PATIENT_ILLNESS
    FOR EACH ROW
    WHEN (
        (SELECT COUNT(*) FROM PATIENT_ILLNESS WHERE PatientNo = OLD.PatientNo) <= 1
    )
    BEGIN
        SELECT RAISE(ABORT, 'Patients must have at least one illness.');
    END;
CREATE TRIGGER CHECK_RX_DUP_INSERT
    BEFORE INSERT ON PATIENT_PRESCRIPTION
    FOR EACH ROW
    WHEN EXISTS (
        SELECT 1 FROM PATIENT_PRESCRIPTION WHERE PatientNo = NEW.PatientNo AND Medication = NEW.Medication
    )
    BEGIN
        SELECT RAISE (ABORT, 'The selected Medication has already been prescribed to this Patient.');
    END;
CREATE TRIGGER CHECK_PRESCRIBER_INSERT
    BEFORE INSERT ON PATIENT_PRESCRIPTION
    FOR EACH ROW
    WHEN NOT EXISTS (
        SELECT 1 FROM STAFF WHERE EmpNo = NEW.PrescribedBy AND (EmpType = 'PHYS' OR Title = 'Chief of Staff')
    )
    BEGIN
        SELECT RAISE (ABORT, 'The selected Prescriber must be a Physician or the Chief of Staff.');
    END;
CREATE TRIGGER CHECK_PRESCRIBER_UPDATE
    BEFORE UPDATE ON PATIENT_PRESCRIPTION
    FOR EACH ROW
    WHEN NOT EXISTS (
        SELECT 1 FROM STAFF WHERE EmpNo = NEW.PrescribedBy AND (EmpType = 'PHYS' OR Title = 'Chief of Staff')
    )
    BEGIN
        SELECT RAISE (ABORT, 'The selected Prescriber must be a Physician or the Chief of Staff.');
    END;
CREATE TRIGGER CHECK_RX_DUP_UPDATE
    BEFORE UPDATE ON PATIENT_PRESCRIPTION
    FOR EACH ROW
    WHEN EXISTS (
        SELECT 1 FROM PATIENT_PRESCRIPTION WHERE PatientNo = NEW.PatientNo AND Medication = NEW.Medication AND PrescriptionNo <> NEW.PrescriptionNo
    )
    BEGIN
        SELECT RAISE (ABORT, 'The selected Medication has already been prescribed to this Patient.');
    END;
CREATE TRIGGER CHECK_EMPNO1_UPDATE
BEFORE UPDATE ON STAFF
FOR EACH ROW
WHEN (OLD.EmpNo = 1 AND NEW.EmpNo != 1) OR (OLD.EmpNo = 1 AND New.Title != 'Chief of Staff')
    BEGIN
        SELECT RAISE (ABORT, 'Employee 1 must be the Chief of Staff and cannot be deleted.');
    END;
CREATE TRIGGER CHECK_EMPNO1_DELETE
BEFORE DELETE ON STAFF
FOR EACH ROW
WHEN (OLD.EmpNo = 1)
    BEGIN
        SELECT RAISE (ABORT, 'Employee 1 cannot be deleted.');
    END;
CREATE TRIGGER CHECK_SURGEON_INSERT
    BEFORE INSERT ON SURGERY
    FOR EACH ROW
    WHEN NOT EXISTS (
        SELECT 1 FROM STAFF WHERE EmpNo = NEW.Surgeon AND EmpType = 'SURG'
    )
    BEGIN
        SELECT RAISE (ABORT, 'The selected Surgeon must be a Surgeon.');
    END;
CREATE TRIGGER CHECK_SURGERY_SKILL_EXISTS_INSERT
    BEFORE INSERT ON SURGERY
    FOR EACH ROW
    WHEN NOT EXISTS (
        SELECT 1 FROM SURG_TYPE_SKILL WHERE NEW.SurgeryType = Type
    )
    BEGIN
        SELECT RAISE (ABORT, 'The selected Surgery Type must have at least one skill to be assigned to a Surgery.');
    END;
CREATE TRIGGER CHECK_SURGERY_SKILL_EXISTS_UPDATE
    BEFORE UPDATE ON SURGERY
    FOR EACH ROW
    WHEN NOT EXISTS (
        SELECT 1 FROM SURG_TYPE_SKILL WHERE NEW.SurgeryType = Type
    )
    BEGIN
        SELECT RAISE (ABORT, 'The selected Surgery Type must have at least one skill to be assigned to a Surgery.');
    END;
CREATE TRIGGER CHECK_SURGERY_STAFF_INSERT
    BEFORE INSERT ON SURGERY_STAFF
    FOR EACH ROW
    WHEN NOT EXISTS (
        SELECT 1 FROM STAFF WHERE EmpNo = NEW.EmpNo AND EmpType = 'NURS')
    BEGIN
        SELECT RAISE (ABORT, 'The selected employee must be a Nurse.');
    END;
CREATE TRIGGER CHECK_SURGERY_STAFF_UPDATE
    BEFORE UPDATE ON SURGERY_STAFF
    FOR EACH ROW
    WHEN NOT EXISTS (
        SELECT 1 FROM STAFF WHERE EmpNo = NEW.EmpNo AND EmpType = 'NURS'
    )
    BEGIN
        SELECT RAISE (ABORT, 'The selected employee must be a Nurse.');
    END;
CREATE TRIGGER CHECK_SURGERY_STAFF_DUP_INSERT
    BEFORE INSERT ON SURGERY_STAFF
    FOR EACH ROW
    WHEN EXISTS (
        SELECT 1 FROM SURGERY_STAFF WHERE SurgeryNo = NEW.SurgeryNo AND EmpNo = NEW.EmpNo
    )
    BEGIN
        SELECT RAISE (ABORT, 'The selected Surgery and Employee combination already exists.');
    END;
CREATE TRIGGER CHECK_SURGERY_STAFF_DUP_UPDATE
    BEFORE UPDATE ON SURGERY_STAFF
    FOR EACH ROW
    WHEN EXISTS (
        SELECT 1 FROM SURGERY_STAFF WHERE SurgeryNo = NEW.SurgeryNo AND EmpNo = NEW.EmpNo
    )
    BEGIN
        SELECT RAISE (ABORT, 'The selected Surgery and Employee combination already exists.');
    END;
CREATE TRIGGER CHECK_SURGERY_STAFF_DELETE
    BEFORE DELETE ON SURGERY_STAFF
    FOR EACH ROW
    WHEN
        (SELECT COUNT(*) FROM SURGERY_STAFF WHERE SurgeryNo = OLD.SurgeryNo) <= 2
    BEGIN
        SELECT RAISE (ABORT, 'Every Surgery must have at least 2 nurses.');
    END;
CREATE TRIGGER CHECK_SURGERY_NURSE_INSERT
    BEFORE INSERT ON SURGERY_STAFF
    FOR EACH ROW
    WHEN NOT EXISTS (
        SELECT 1 FROM SURGERY A, NURSE_SURG_TYPE B WHERE A.SurgeryNo = NEW.SurgeryNo AND NEW.EmpNo = B.EmpNo AND A.SurgeryType = B.Type
    )
    BEGIN
        SELECT RAISE (ABORT, 'The selected Nurse does not possess the appropriate Surgery Type specialization for the selected Surgery.');
    END;
CREATE TRIGGER CHECK_NURSE_SURG_TYPE_INSERT
    BEFORE INSERT ON NURSE_SURG_TYPE
    FOR EACH ROW
    WHEN NOT EXISTS (
        SELECT 1 FROM STAFF WHERE EmpNo = NEW.EmpNo AND EmpType = 'NURS'
    ) OR NOT EXISTS (
        SELECT 1 FROM SURG_TYPE_SKILL A
        WHERE A.Type = NEW.Type AND EXISTS (
            SELECT 1 FROM NURSE_SURG_SKILL B
            WHERE B.EmpNo = NEW.EmpNo AND B.Skill = A.Skill
            LIMIT 1
        )
    )
    BEGIN
        SELECT RAISE (ABORT, 'The selected employee must be a Nurse with at least one Skill for the selected Surgery Type.');
    END;
CREATE TRIGGER CHECK_NURSE_SURG_TYPE_UPDATE
    BEFORE UPDATE ON NURSE_SURG_TYPE
    FOR EACH ROW
    WHEN NOT EXISTS (
        SELECT 1 FROM STAFF WHERE EmpNo = NEW.EmpNo AND EmpType = 'NURS'
    ) OR NOT EXISTS (
        SELECT 1 FROM SURG_TYPE_SKILL A
        WHERE A.Type = NEW.Type AND EXISTS (
            SELECT 1 FROM NURSE_SURG_SKILL B
            WHERE B.EmpNo = NEW.EmpNo AND B.Skill = A.Skill
            LIMIT 1
        )
    )
    BEGIN
        SELECT RAISE (ABORT, 'The selected employee must be a Nurse with at least one Skill for the selected Surgery Type.');
    END;
CREATE TRIGGER CHECK_OP_THEATRE_DUP_INSERT
    BEFORE INSERT ON OP_THEATRE
    FOR EACH ROW
    WHEN EXISTS (
        SELECT 1 FROM OP_THEATRE WHERE Clinic = NEW.Clinic AND Theatre = NEW.Theatre
    )
    BEGIN
        SELECT RAISE (ABORT, 'The selected Operating Theatre already exists.');
    END;
CREATE TRIGGER CHECK_OP_THEATRE_DUP_UPDATE
    BEFORE UPDATE ON OP_THEATRE
    FOR EACH ROW
    WHEN EXISTS (
        SELECT 1 FROM OP_THEATRE WHERE Clinic = NEW.Clinic AND Theatre = NEW.Theatre
    )
    BEGIN
        SELECT RAISE (ABORT, 'The selected Operating Theatre already exists.');
    END;
CREATE TRIGGER CHECK_PATIENT_ALLERGY_DUP_INSERT
    BEFORE INSERT ON PATIENT_ALLERGY
    FOR EACH ROW
    WHEN EXISTS (
        SELECT 1 FROM PATIENT_ALLERGY WHERE PatientNo = NEW.PatientNo AND Allergy = NEW.Allergy
    )
    BEGIN
        SELECT RAISE (ABORT, 'The selected Allergy has already been diagnosed for this Patient.');
    END;
CREATE TRIGGER CHECK_PATIENT_ALLERGY_DUP_UPDATE
    BEFORE UPDATE ON PATIENT_ALLERGY
    FOR EACH ROW
    WHEN EXISTS (
        SELECT 1 FROM PATIENT_ALLERGY WHERE PatientNo = NEW.PatientNo AND Allergy = NEW.Allergy
    )
    BEGIN
        SELECT RAISE (ABORT, 'The selected Allergy has already been diagnosed for this Patient.');
    END;
CREATE TRIGGER CHECK_SURGEON_UPDATE
    BEFORE UPDATE ON SURGERY
    FOR EACH ROW
    WHEN NOT EXISTS (
        SELECT 1 FROM STAFF WHERE EmpNo = NEW.Surgeon AND EmpType = 'SURG'
    )
    BEGIN
        SELECT RAISE (ABORT, 'The selected Surgeon must be a Surgeon.');
    END;
CREATE TRIGGER CHECK_SURGERY_NURSE_UPDATE
    BEFORE UPDATE ON SURGERY_STAFF
    FOR EACH ROW
    WHEN EXISTS (
        SELECT 1 FROM STAFF WHERE EmpNo = NEW.EmpNo AND EmpType = 'NURS'
    )
    AND NOT EXISTS (
        SELECT 1 FROM SURGERY A, NURSE_SURG_TYPE B WHERE A.SurgeryNo = NEW.SurgeryNo AND NEW.EmpNo = B.EmpNo AND A.SurgeryType = B.Type
    )
    BEGIN
        SELECT RAISE (ABORT, 'The selected Nurse does not possess the appropriate Surgery Type specialization for the selected Surgery.');
    END;
CREATE TRIGGER CHECK_SHIFT_DUP_INSERT
    BEFORE INSERT ON SHIFT
    FOR EACH ROW
    WHEN EXISTS (
        SELECT 1 FROM SHIFT WHERE EmpNo = NEW.EmpNo AND StartDate = NEW.StartDate 
    )
    BEGIN
        SELECT RAISE (ABORT, 'The selected Employee already has a shift scheduled for this date.');
    END;
CREATE TRIGGER CHECK_SHIFT_DUP_UPDATE
    BEFORE UPDATE ON SHIFT
    FOR EACH ROW
    WHEN EXISTS (
        SELECT 1 FROM SHIFT WHERE EmpNo = NEW.EmpNo AND StartDate = NEW.StartDate AND ShiftNo != NEW.ShiftNo
    )
    BEGIN
        SELECT RAISE (ABORT, 'The selected Employee already has a shift scheduled for this date.');
    END;
CREATE TRIGGER CHECK_PCP_COUNT_DELETE
    BEFORE DELETE ON PATIENT
    FOR EACH ROW
    WHEN OLD.Pcp IS NOT NULL AND (
        (SELECT COUNT(*) FROM PATIENT WHERE Pcp = OLD.Pcp) <= 7
    )
    BEGIN
       SELECT RAISE (ABORT, 'This Physician only acts as a Primary Care Provider for 7 or less patients and none can be removed.'); 
    END;
CREATE TRIGGER CHECK_PCP_COUNT_UPDATE_20
    BEFORE UPDATE ON PATIENT
    FOR EACH ROW
    WHEN (SELECT COUNT(*) FROM PATIENT WHERE Pcp = NEW.Pcp) >= 20
    BEGIN
       SELECT RAISE (ABORT, 'This Physician already acts as a Primary Care Provider for 20 patients and no more can be added.'); 
    END;
CREATE TRIGGER CHECK_PCP_COUNT_UPDATE_7
    BEFORE UPDATE ON PATIENT
    FOR EACH ROW
    WHEN OLD.Pcp IS NOT NULL AND 
        ((SELECT COUNT(*) FROM PATIENT WHERE Pcp = OLD.Pcp) <= 7)
    BEGIN
       SELECT RAISE (ABORT, 'This Physician only acts as a Primary Care Provider for 7 or less patients and none can be removed.'); 
    END;
CREATE TRIGGER CHECK_STAY_DIAGNOSIS_INSERT
    BEFORE INSERT ON STAY
    FOR EACH ROW
    WHEN NOT EXISTS (
        SELECT 1 FROM PATIENT_ILLNESS WHERE DiagnosisNo = NEW.DiagnosisNo AND PatientNo = NEW.PatientNo)
    BEGIN
        SELECT RAISE (ABORT, 'The selected Diagnosis must belong to the selected Patient.');
    END;
CREATE TRIGGER CHECK_STAY_DIAGNOSIS_UPDATE
    BEFORE UPDATE ON STAY
    FOR EACH ROW
    WHEN NOT EXISTS (
        SELECT 1 FROM PATIENT_ILLNESS WHERE DiagnosisNo = NEW.DiagnosisNo AND PatientNo = NEW.PatientNo)
    BEGIN
        SELECT RAISE (ABORT, 'The selected Diagnosis must belong to the selected Patient.');
    END;
CREATE TRIGGER CHECK_STAY_NURSE_INSERT
    BEFORE INSERT ON STAY
    FOR EACH ROW
    WHEN NEW.Nurse IS NOT NULL AND NOT EXISTS (
        SELECT 1 FROM STAFF WHERE EmpNo = NEW.Nurse AND EmpType = 'NURS')
    BEGIN
        SELECT RAISE (ABORT, 'The selected attending Nurse must be a Nurse.');
    END;
CREATE TRIGGER CHECK_STAY_NURSE_UPDATE
    BEFORE UPDATE ON STAY
    FOR EACH ROW
    WHEN NEW.Nurse IS NOT NULL AND NOT EXISTS (
        SELECT 1 FROM STAFF WHERE EmpNo = NEW.Nurse AND EmpType = 'NURS'
        )
    BEGIN
        SELECT RAISE (ABORT, 'The selected attending Nurse must be a Nurse.');
    END;
CREATE TRIGGER CHECK_STAY_NURSE_COUNT_UPDATE
    BEFORE UPDATE ON STAY
    FOR EACH ROW
    WHEN OLD.Nurse IS NOT NULL AND (SELECT COUNT(*) FROM STAY WHERE Nurse = OLD.Nurse) <= 5
    BEGIN
        SELECT RAISE (ABORT, 'This Nurse only acts as an Attending Nurse for 5 or less patients and none can be removed.');
    END;
CREATE TRIGGER CHECK_STAY_PHYS_INSERT
    BEFORE INSERT ON STAY
    FOR EACH ROW
    WHEN NEW.Physician IS NOT NULL AND NOT EXISTS (
        SELECT 1 FROM STAFF WHERE EmpNo = NEW.Physician AND EmpType = 'PHYS')
    BEGIN
        SELECT RAISE (ABORT, 'The selected Physician must be a physician.');
    END;
CREATE TRIGGER CHECK_STAY_PHYS_UPDATE
    BEFORE UPDATE ON STAY
    FOR EACH ROW
    WHEN NEW.Physician IS NOT NULL AND NOT EXISTS (
        SELECT 1 FROM STAFF WHERE EmpNo = NEW.Physician AND EmpType = 'PHYS')
    BEGIN
        SELECT RAISE (ABORT, 'The selected Physician must be a physician.');
    END;
CREATE TRIGGER CHECK_STAY_NURSE_COUNT_DELETE
    BEFORE DELETE ON STAY
    FOR EACH ROW
    WHEN OLD.Nurse IS NOT NULL AND (SELECT COUNT(*) FROM STAY WHERE Nurse = OLD.Nurse) <= 5
    BEGIN
        SELECT RAISE (ABORT, 'This Nurse only acts as an Attending Nurse for 5 or less patients and none can be removed.');
    END;
COMMIT;