#This Blueprint has a View for testing
#the code in this will rely on an HTML representation of what
#page will look like
import functools, random

from flask import (
    Blueprint, flash, g, redirect, render_template, request, session, url_for
)
from werkzeug.security import check_password_hash, generate_password_hash

from project.db import get_db

bp = Blueprint('dummy', __name__, url_prefix='/dummy')


# DUMMY DATA DO NOT NAVIAGTE TO UNLESS ADDING DUMMY DATA
@bp.route('/staff')
def createDummy():
    db=get_db()
    list=['VALUES (4,"Tony","D","Scarlet","987654321","M","NURS","Head Nurse",100000,NULL,5,10,"345 Willow Ave","Newark","NJ","07123","United States","555-4444")',
       ' VALUES (2,"Jane","B","Doe","111222333","F","PHYS","Generalist",125000,"Pathology",NULL,NULL,"100 Oak St","Jersey City","NJ","07321","United States","555-2222")',
       ' VALUES (5,"Michael","E","Baker","354364136","M","SURG","Surgeon",NULL,"Cardiology",NULL,NULL,"45 Circle Ct","Newark","NJ","07123","United States","555-5555")',
       ' VALUES (6,"Angelina","F","Hernandez","115879266","F","SURG","Surgeon",NULL,"Cardiology",NULL,NULL,"56 45th St","Philadelphia","PA","09654","United States","555-6666")',
       ' VALUES(7,"Peter","M","Parker","559311458","M","PHYS","Specialist",275000,"Gastroenterology",NULL,NULL,"587 Ocean Ln","Hoboken","NJ","07852","United States","555-7777")',
       ' VALUES (8,"David","L","Baldwin","000111222","M","PHYS","Specialist",225000,"Orthopedics",NULL,NULL,"87 Beach St","Red Bank","NJ","07999","United States","555-8888")',
       ' VALUES (9,"Noor","H","Ahmad","222333444","F","PHYS","Generalist",215000,"Pathology",NULL,NULL,"89 Silver Mine Rd","Suffern","NY","08563","United States","555-9999")',
       ' VALUES (10,"Ernest",NULL,"Li","333444555","M","NURS","Nurse",65000,NULL,1,2,"5890 Main St","Newark","NJ","07123","United States","555-0000")',
       ' VALUES (11,"Tracy","O","Allison","555666777","F","NURS","Nurse",65000,NULL,1,2,"54 Eureka Ave","Edison","NJ","07456","United States","555-1000")',
       ' VALUES  (12,"John","P","Smith","666777888","M","SUPP","Shift Manager",90000,NULL,NULL,NULL,"43 Church Rd","Jersey City","NJ","07321","United States","555-2000")',
       ' VALUES (13,"Taylor",NULL,"White","777888999","F","SUPP","Jr. Payroll Accountant",45000,NULL,NULL,NULL,"6547 City St","Newark","NJ","07123","United States","555-3000")',
       ' VALUES (14,"Stanley","P","Arabel","111111111","M","SUPP","IT Director",170000,NULL,NULL,NULL,"22 W 2nd Ave","Jersey City","NJ","07321","United States","555-4000")',
       ' VALUES (15,"Lana","R","Skye","999666333","F","SUPP","Receptionist",40000,NULL,NULL,NULL,"4545 Distant Ln","Yonkers","NY","08521","United States","555-5000")']

    
    for i in range(len(list)):
        staff=db.execute( 'INSERT INTO "STAFF" ("EmpNo","Fname","Minit","Lname","Ssn","Gender","EmpType","Title","Salary","Specialty","NurseGrade","YrsNursingExp","Addr","City","StateProv","ZIP","Country","Phone")'
                f'{list[i]}')
        db.commit()
    return render_template('members/staff/staff.html',staff=staff)

# DUMMY DATA DO NOT NAVIAGTE TO UNLESS ADDING DUMMY DATA
@bp.route('/patient')
def createPatientDummy():
    db=get_db()
    list=['VALUES (1,"Mohammad","M","Abdullah","986486000","M","1/16/1974","A","-",2,"789 Cooper St","Newark","New Jersey","07111","United States","555-2536")',
          'VALUES (2,"Bob","A","Smith","455523369","M","1/1/1990","AB","+",2,"87 Maple St","Toronto","Ontario","A1A 2B2","Canada","555-6589")',
'VALUES (3,"Grace",NULL,"Nguyen",NULL,"F","1/1/2001","O","-",2,"345 Washington Ave","Newark","New Jersey","07111","United States","555-4455")',
'VALUES (5,"Jon","L","Polowski","566999555","M","2/18/1974",NULL,NULL,2,"1111 Main St","Newark","New Jersey","07111","United States","555-8523")',
'VALUES (7,"Zack","W","Steiner","752263354","M","9/14/1965","A","+",7,"4 Brookside Dr","Dublin",NULL,"D22","Ireland",NULL)',
'VALUES (8,"Gary","M","Jackson","445522779","M","8/30/1954","B","+",2,NULL,NULL,NULL,NULL,NULL,NULL)',
'VALUES(9,"Jessica","J","Quincy","556894331","F","8/1/1984","O","+",2,"65 Hickory St","Morristown","New Jersey","07554","United States","555-8897")',
'VALUES (10,"Ivan","R","Vitaly","555888666","M","4/5/1967","B","-",1,"1 Eagle St","Atlanta","Georgia","56211","United States","555-9876")']

    
    for i in range(len(list)):
        patient=db.execute( 'INSERT INTO "PATIENT" ("PatientNo","Fname","Minit","Lname","Ssn","Gender","Dob","BloodType","RhFactor","Pcp","Addr","City","StateProv","ZIP","Country","Phone")'
                f'{list[i]}')
        db.commit()
    return render_template('members/patient/patient.html',patient=patient)

@bp.route('/patient')
def createPatientDummy():
    db=get_db()
    list=['VALUES (1,"Mohammad","M","Abdullah","986486000","M","1/16/1974","A","-",2,"789 Cooper St","Newark","New Jersey","07111","United States","555-2536")',
          'VALUES (2,"Bob","A","Smith","455523369","M","1/1/1990","AB","+",2,"87 Maple St","Toronto","Ontario","A1A 2B2","Canada","555-6589")',
'VALUES (3,"Grace",NULL,"Nguyen",NULL,"F","1/1/2001","O","-",2,"345 Washington Ave","Newark","New Jersey","07111","United States","555-4455")',
'VALUES (5,"Jon","L","Polowski","566999555","M","2/18/1974",NULL,NULL,2,"1111 Main St","Newark","New Jersey","07111","United States","555-8523")',
'VALUES (7,"Zack","W","Steiner","752263354","M","9/14/1965","A","+",7,"4 Brookside Dr","Dublin",NULL,"D22","Ireland",NULL)',
'VALUES (8,"Gary","M","Jackson","445522779","M","8/30/1954","B","+",2,NULL,NULL,NULL,NULL,NULL,NULL)',
'VALUES(9,"Jessica","J","Quincy","556894331","F","8/1/1984","O","+",2,"65 Hickory St","Morristown","New Jersey","07554","United States","555-8897")',
'VALUES (10,"Ivan","R","Vitaly","555888666","M","4/5/1967","B","-",1,"1 Eagle St","Atlanta","Georgia","56211","United States","555-9876")']

    
    for i in range(len(list)):
        patient=db.execute( 'INSERT INTO "PATIENT" ("PatientNo","Fname","Minit","Lname","Ssn","Gender","Dob","BloodType","RhFactor","Pcp","Addr","City","StateProv","ZIP","Country","Phone")'
                f'{list[i]}')
        db.commit()
    return render_template('members/patient/patient.html',patient=patient)


@bp.route('/patient')
def createPatientDummy():
    db=get_db()
    list=['VALUES (1,"Mohammad","M","Abdullah","986486000","M","1/16/1974","A","-",2,"789 Cooper St","Newark","New Jersey","07111","United States","555-2536")',
          'VALUES (2,"Bob","A","Smith","455523369","M","1/1/1990","AB","+",2,"87 Maple St","Toronto","Ontario","A1A 2B2","Canada","555-6589")',
'VALUES (3,"Grace",NULL,"Nguyen",NULL,"F","1/1/2001","O","-",2,"345 Washington Ave","Newark","New Jersey","07111","United States","555-4455")',
'VALUES (5,"Jon","L","Polowski","566999555","M","2/18/1974",NULL,NULL,2,"1111 Main St","Newark","New Jersey","07111","United States","555-8523")',
'VALUES (7,"Zack","W","Steiner","752263354","M","9/14/1965","A","+",7,"4 Brookside Dr","Dublin",NULL,"D22","Ireland",NULL)',
'VALUES (8,"Gary","M","Jackson","445522779","M","8/30/1954","B","+",2,NULL,NULL,NULL,NULL,NULL,NULL)',
'VALUES(9,"Jessica","J","Quincy","556894331","F","8/1/1984","O","+",2,"65 Hickory St","Morristown","New Jersey","07554","United States","555-8897")',
'VALUES (10,"Ivan","R","Vitaly","555888666","M","4/5/1967","B","-",1,"1 Eagle St","Atlanta","Georgia","56211","United States","555-9876")']

    
    for i in range(len(list)):
        patient=db.execute( 'INSERT INTO "PATIENT" ("PatientNo","Fname","Minit","Lname","Ssn","Gender","Dob","BloodType","RhFactor","Pcp","Addr","City","StateProv","ZIP","Country","Phone")'
                f'{list[i]}')
        db.commit()
    return render_template('members/patient/patient.html',patient=patient)

@bp.route('/clinic')
def createClinicDummy():
    db=get_db()
     list=[ 'VALUES ("Newark Medical Clinic","1500 Commerce Avenue","Newark","New Jersey","07101","United States","555-123-4567")',
 'VALUES ("Jersey City Health","12-04 Market Street","Jersey City","New Jersey","07302","United States","555-234-5678")',
 'VALUES ("High Point Hospital","86 Trade Boulevard","Harrison","New Jersey","07029","United States","555-456-7890")']

    for i in range(len(list)):
        clinic=db.execute( 'INSERT INTO "CLINIC" ("Name","Addr","City","StateProv","ZIP","Country","Phone")'
                f'{list[i]}')
        db.commit()


@bp.route('/corp')
def createCorpoDummy():
    db=get_db()
     list=[
 'VALUES ('Newark Medical Associates, Inc.','500 Main St','Newark','New Jersey','17101','United States')',
 'VALUES ('MediLife Healthcare Corporation','100 Commerce St','New York','New York','10001','United States')',
 'VALUES ('HealthLink Medical Group','123 Health Way','Dublin',NULL,'D14','Ireland')',
 'VALUES ('MediCore Hospitals, Inc.','1200 Jersey St','Jersey City','New Jersey','07030','United States')',
 'VALUES ('MediServe Health Systems','5000 Insurance Dr','Toronto','Ontario','M4C 1T6','Canada')']
    for i in range(len(list)):
        corp=db.execute( 'INSERT INTO "CORPORATION" ("CorpName","HqAddr","HqCity","HqStateProv","HqZIP","HqCountry")'
                f'{list[i]}')
        db.commit()


@bp.route('/anatomical')
def createAnatomDummy():
    db=get_db()
     list=['VALUES (1,"Abdominal-Epigastric")',
'VALUES (2,"Abdominal-Umbilical")',
'VALUES (3,"Abdominal-Hypogastric (Suprapubic)")',
'VALUES (4,"Abdominal-Right Hypochondriac")',
'VALUES (5,"Abdominal-Left Hypochondriac")',
'VALUES (6,"Abdominal-Right Lumbar (Flank)")',
'VALUES (7,"Abdominal-Left Lumbar (Flank)")',
'VALUES (8,"Abdominal-Right Inguinal (Iliac)")',
'VALUES (9,"Abdominal-Left Inguinal (Iliac)")',
'VALUES (10,"Abdominal-Upper Right Quadrant (URQ)")',
'VALUES (11,"Abdominal-Upper Left Quadrant (ULQ)")',
'VALUES (12,"Abdominal-Lower Right Quadrant (LRQ)")',
'VALUES (13,"Abdominal-Lower Left Quadrant (LLQ)")',
'VALUES (14,"Abdominal-Liver")',
'VALUES (15,"Abdominal-Kidney")',
'VALUES (16,"Abdominal-Spleen")',
'VALUES (17,"Abdominal-Appendix")',
'VALUES (18,"Chest-Right Upper Quadrant (RUQ)")',
'VALUES (19,"Chest-Left Upper Quadrant (LUQ)")',
'VALUES (20,"Chest-Right Lower Quadrant (RLQ)")',
'VALUES (21,"Chest-Left Lower Quadrant (LLQ)")',
'VALUES (22,"Chest-Pectoral Region (Breast)")',
'VALUES (23,"Chest-Sternal Region (Sternum)")',
'VALUES (24,"Head and Neck-Frontal Region")',
'VALUES (25,"Head and Neck-Occipital Region")',
'VALUES (26,"Head and Neck-Temporal Region")',
'VALUES (27,"Head and Neck-Parietal Region")',
'VALUES (28,"Head and Neck-Cervical Region (Neck)")',
'VALUES (29,"Head and Neck-Facial Region")',
'VALUES (30,"Head and Neck-Oral Region")',
'VALUES (31,"Cranial Compartments-Anterior Cranial Fossa")',
'VALUES (32,"Cranial Compartments-Middle Cranial Fossa")',
'VALUES (33,"Cranial Compartments-Posterior Cranial Fossa")',
'VALUES (34,"Extremities-Upper Arm")',
'VALUES (35,"Extremities-Forearm")',
'VALUES (36,"Extremities-Hand")',
'VALUES (37,"Extremities-Thigh")',
'VALUES (38,"Extremities-Leg")',
'VALUES (39,"Extremities-Foot")',
'VALUES (40,"Spinal Regions-Cervical Spine")',
'VALUES (41,"Spinal Regions-Thoracic Spine")',
'VALUES (42,"Spinal Regions-Lumbar Spine")',
'VALUES (43,"Spinal Regions-Sacral Spine")',
'VALUES (44,"Breast-Upper Outer Quadrant")',
'VALUES (45,"Breast-Upper Inner Quadrant")',
'VALUES (46,"Breast-Lower Outer Quadrant")',
'VALUES (47,"Breast-Lower Inner Quadrant")',
'VALUES (48,"Breast-Lower Inner Quadrant")',
'VALUES (49,"Cranial-Sagittal")',
'VALUES (50,"Cranial-Coronal")',
'VALUES (51,"Cranial-Lambdoid")',
'VALUES (52,"Cranial-Squamous")']

    for i in range(len(list)):
        anat=db.execute( 'INSERT INTO "ANATOMICAL_LOC" ("Code","Description")'
                f'{list[i]}')
        db.commit()

@bp.route('/surgical')
def createSurgicalSkillDummy():
    db=get_db()
      list=['VALUES (1,"Anatomy Knowledge")',
'VALUES (2,"Manual Dexterity")',
'VALUES (3,"Surgical Instrument Proficiency")',
'VALUES (4,"Suture Techniques")',
'VALUES (5,"Tissue Handling")',
'VALUES (6,"Hemostasis")',
'VALUES (7,"Tissue Dissection")',
'VALUES (8,"Minimally Invasive Surgery (MIS) Skills")',
'VALUES (9,"Patient Positioning and Access")',
'VALUES (10,"Infection Control")',
'VALUES (11,"Decision-Making")',
'VALUES (12,"Communication")',
'VALUES (13,"Teamwork")',
'VALUES (14,"Patient Assessment")',
'VALUES (15,"Ethical and Legal Understanding")',
'VALUES (16,"Postoperative Care")']

    for i in range(len(list)):
        skill=db.execute('INSERT INTO "SURG_SKILL" ("Code","Description")'
                f'{list[i]}')
        db.commit()

@bp.route('/med')
def createMedicationDummy():
    db=get_db()
     list=[ 'VALUES ("00168047515","Ibuprofen 200mg Tablets",0.15,500,100,300)',
 'VALUES ("00378046501","Amoxicillin 500mg Capsules",0.25,300,50,200)',
 'VALUES ("00093529201","Lisinopril 10mg Tablets",0.3,200,20,150)',
 'VALUES ("00054446001","Metformin 500mg Tablets",0.2,400,30,250)',
 'VALUES ("00378233001","Simvastatin 20mg Tablets",0.35,150,10,100)',
 'VALUES ("00173048710","Omeprazole 20mg Capsules",0.4,100,5,80)',
 'VALUES ("00781101001","Levothyroxine 50mcg Tablets",0.18,250,15,180)',
 'VALUES ("00378636501","Losartan 50mg Tablets",0.33,180,25,120)',
 'VALUES ("00527313101","Atorvastatin 40mg Tablets",0.45,120,8,90)',
 'VALUES ("00093714901","Hydrochlorothiazide 25mg Tablets",0.28,220,18,160)']
    for i in range(len(list)):
        med=db.execute( 'INSERT INTO "MEDICATION" ("Code","Name","UnitCost","QtyOnHand","QtyOnOrder","YTDUsage")'
                f'{list[i]}')
        db.commit()


@bp.route('/allergy')
def createAllergyDummy():
    db=get_db()
     list=[ 'VALUES ("T78.1XXA","Adverse Food Reactions")',
 'VALUES ("T78.07XA","Anaphylaxis to dairy, initial encounter")',
 'VALUES ("T78.08XA","Anaphylaxis to egg, initial encounter")',
 'VALUES ("T78.01XA","Anaphylaxis to peanut, initial encounter")',
 'VALUES ("T78.05XA","Anaphylaxis to tree nuts or seeds, initial encounter")',
 'VALUES ("T78.02XA","Anaphylaxis to shellfish, initial encounter")',
 'VALUES ("T78.03XA","Anaphylaxis to fish, initial encounter")',
 'VALUES ("T78.00XA","Anaphylactic reaction due to unspecified food, initial encounter")',
 'VALUES ("T78.06XA","Anaphylactic reaction due to food additives, initial encounter")',
 'VALUES ("T88.6XXA","Anaphylactic reaction due to adverse effect of correct drug or medicament properly administered, initial encounter")',
 'VALUES ("L50.0","Allergic Urticaria")',
 'VALUES ("T78.3XXA","Angioneurotic Edema, initial encounter")',
 'VALUES ("L20.9","Atopic Dermatitis")',
 'VALUES ("L23.9","Allergic Contact Dermatitis")',
 'VALUES ("L23.6","Allergic Contact Dermatitis due to food in contact with the skin")',
 'VALUES ("J30.81","Allergic Rhinitis due to animal")',
 'VALUES ("J30.1","Allergic Rhinitis due to seasonal allergen")',
 'VALUES ("J30.89","Other Allergic Rhinitis (mold, dust mite, perennial)")',
 'VALUES ("J30.2","Other Seasonal Allergic Rhinitis")',
 'VALUES ("J30.5","Allergic Rhinitis Due to Food")',
 'VALUES ("H10.45","Other Chronic Allergic Conjunctivitis")']
    for i in range(len(list)):
        allergy=db.execute( 'INSERT INTO "ALLERGY" ("Code","Description")'
                f'{list[i]}')
        db.commit()


#         @bp.route('/*')
# def create*****Dummy():
#     db=get_db()
#      list=[]

#     for i in range(len(list)):
#         dasda=db.execute( ''
#                 f'{list[i]}')
#         db.commit()






