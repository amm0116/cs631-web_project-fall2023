#This Blueprint has a View to view Members of Staff/People
#the code in this will rely on an HTML representation of what
#page will look like
import functools, random

from flask import (
    Blueprint, flash, g, redirect, render_template, request, session, url_for
)
from werkzeug.security import check_password_hash, generate_password_hash

from project.db import get_db

bp = Blueprint('people', __name__, url_prefix='/people')


@bp.route('/staff')
def seeAllStaff():
    db=get_db()
    staff=db.execute('SELECT rowid , * FROM STAFF').fetchall() #db.execute('SELECT * FROM STAFF').fetchall()

    return render_template('members/staff/staff.html',staff=staff)


@bp.route('/viewstaff/<int:id>')
def seeStaff(id):
    item = get_db().execute(
        'SELECT rowid,*'
        ' FROM STAFF'
        ' WHERE rowid = ?'
        ,(id,)).fetchone()


    return render_template('members/staff/fullbio.html',item=item) 

@bp.route('/patient')
def seeAllPatients():
    db=get_db()
    patient=db.execute('SELECT PatientNo, * FROM PATIENT ').fetchall() #db.execute('SELECT * FROM STAFF').fetchall()

    return render_template('members/patient/patient.html',patient=patient) #TODO: Generic person html, changes from DB name

@bp.route('/viewpatient/<int:id>')
def seePatient(id):
    item = get_db().execute(
        'SELECT rowid,*'
        ' FROM PATIENT'
        ' WHERE rowid = ?'
        ,(id,)).fetchone()


    return render_template('members/patient/fullbio.html',item=item) 

# SELECT * FROM PATIENT P, EMPLOYEE E WHERE P.Pcp = E.EmpNo

@bp.route('/addPatient',methods=('GET','POST')) #'GET','POST')
def addPatient():
    # db=get_db()
    # error=None

    if request.method == 'POST':
        gender=request.form['Gender']
        Fname = request.form['Fname']
        Lname = request.form['Lname']
        
        mName = request.form['Minit']
        birthdate=request.form['Dob']
        ssn=request.form['Ssn']
        caregiver=0

        item = get_db().execute('SELECT Fname FROM STAFF').fetchall()

        #get_db().execute(
        # 'SELECT rowid,*'
        # ' FROM PATIENT P,STAFF E'
        # ' WHERE P.pcp=E.rowid'
        # ,(id,)).fetchall()


        #UUID>regular unique number up to 5 digits, no one has the same! COS has unique number(if multiple has the same)
        #descriptive info for name, etc
        # Hopkins,Jenna (#5550) general page after the fact
        error = None

        if error is not None:
            flash(error)

        else:  
             db=get_db()
             db.execute(
                'INSERT INTO PATIENT (Fname,Minit,Lname,Gender,Dob,Ssn,Pcp)'
                ' VALUES (?,?,?,?,?,?,?)',
                (Fname,mName,Lname,gender,birthdate,ssn,caregiver)
            )
             post_id = db.cursor().fetchone()
             print(post_id)
             db.commit()

             return redirect(url_for('people.seeAllPatients',patient=item))

    return render_template('members/patient/addPatient.html')

@bp.route('/add',methods=('GET','POST')) #'GET','POST')
def addStaff():
    # db=get_db()
    # error=None

    if request.method == 'POST':
        status= request.form['EmpStatus']
        gender=request.form['Gender']
        empType=request.form['EmpType']
        Fname = request.form['Fname']
        Lname = request.form['Lname']

        mName = request.form['Minit']
        # ssn = request.form['Ssn']
        # title = request.form['Title']
        
        # empStatus = request.form['EmpStatus']
        # addr = request.form['Addr']
        # city = request.form['City'] 

        # stateProv = request.form['StateProv']
        # zipCode =request.form['ZIP']
        # country =request.form['Country']
        # phone  =request.form['Phone']

        error = None

        if error is not None:
            flash(error)

        else:  
             db=get_db()
             db.execute(
                'INSERT INTO STAFF (Fname,Minit,Lname,Gender,EmpType,EmpStatus)'
                ' VALUES (?,?,?,?,?,?)',
                (Fname,mName,Lname,gender,empType,status)
            )
             post_id = db.cursor().fetchone()
             print(post_id)
             db.commit()

             return redirect(url_for('people.seeAllStaff'))

    return render_template('members/staff/add.html')

def get_person(id):
    item = get_db().execute(
        'SELECT EmpNo'
        ' FROM STAFF'
        ' WHERE EmpNo = ?',
        (id,)
    ).fetchone()
    #for autoincrement
    # if item is None:
    #     abort(404, f"EmpNo {id} doesn't exist.")

    return item

#Update -Small Popup
@bp.route('/<int:id>/update', methods=('GET', 'POST'))
def updatePerson(id):
     db=get_person(id)
     error=None

     if request.method == 'POST':
        name = request.form['name']
        error = None

        if not name:
            error = 'Name is required.'

        if error is not None:
            flash(error)

        else:  
             db=get_db()
             db.execute(
               'UPDATE staffmember SET name = ?'
                ' WHERE id = ?',
                (name, id)
            )
             db.commit()
             return redirect(url_for('people.seeAllStaff'))

     return render_template('update.html')

#staff deletion, smaller pieces
@bp.route('/<int:id>/delete', methods=('POST','GET'))
def delete(id):
    get_person(id)
    db = get_db()
    db.execute('DELETE FROM STAFF WHERE rowid = ?', (id,))
    db.commit()
    return redirect(url_for('people.seeAllStaff'))

# DUMMY DATA DO NOT NAVIAGTE TO UNLESS ADDING DUMMY DATA
@bp.route('/dummy')
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
@bp.route('/dummyPatient')
def createPatientDummy():
    db=get_db()
    list=['VALUES (1,"Mohammad","M","Abdullah","986486000","M","1974/01/16","A","-",2,"789 Cooper St","Newark","New Jersey","07111","United States","555-2536")']#'VALUES (1,"Mohammad","M","Abdullah","986486000","M","1974/1/16","A","-",2,"789 Cooper St","Newark","New Jersey","07111","United States","555-2536")',
# 'VALUES (2,"Bob","A","Smith","455523369","M","1/1/1990","AB","+",2,"87 Maple St","Toronto","Ontario","A1A 2B2","Canada","555-6589")',
# 'VALUES (3,"Grace",NULL,"Nguyen",NULL,"F","1/1/2001","O","-",2,"345 Washington Ave","Newark","New Jersey","07111","United States","555-4455")',
# 'VALUES (5,"Jon","L","Polowski","566999555","M","2/18/1974",NULL,NULL,2,"1111 Main St","Newark","New Jersey","07111","United States","555-8523")',
# 'VALUES (7,"Zack","W","Steiner","752263354","M","9/14/1965","A","+",7,"4 Brookside Dr","Dublin",NULL,"D22","Ireland",NULL)',
# 'VALUES (8,"Gary","M","Jackson","445522779","M","8/30/1954","B","+",2,NULL,NULL,NULL,NULL,NULL,NULL)',
# 'VALUES(9,"Jessica","J","Quincy","556894331","F","8/1/1984","O","+",2,"65 Hickory St","Morristown","New Jersey","07554","United States","555-8897")',
# 'VALUES (10,"Ivan","R","Vitaly","555888666","M","4/5/1967","B","-",1,"1 Eagle St","Atlanta","Georgia","56211","United States","555-9876")']

    
    for i in range(len(list)):
        patient=db.execute( 'INSERT INTO "PATIENT" ("PatientNo","Fname","Minit","Lname","Ssn","Gender","Dob","BloodType","RhFactor","Pcp","Addr","City","StateProv","ZIP","Country","Phone")'
                f'{list[i]}')
        db.commit()
    return render_template('members/patient/patient.html',patient=patient)