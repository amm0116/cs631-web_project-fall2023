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
        'SELECT PATIENT.*,STAFF.Fname AS docFirst,STAFF.Lname AS docLast,STAFF.EmpNo AS empNo'
        ' FROM PATIENT,STAFF'
        ' WHERE PatientNo = ?'
        'AND PATIENT.Pcp=STAFF.EmpNo'
        ,(id,)).fetchone()


    #only of type physician
    error = None

    for person in physician:
        print(person)

    return render_template('members/patient/fullbio.html',item=item) 

#'Cardiology', 'Dermatology', 'Gastroenterology', 'Orthopedics', 'Neurology', 'Ophthalmology', 'Otolaryngology', 'Pediatrics', 'Obstetrics and Gynecology', 'Urology', 'Endocrinology', 'Rheumatology', 'Pulmonology', 'Hematology', 
#'Infectious Disease', 'Emergency Medicine', 'Plastic Surgery', 'Radiology', 'Anesthesiology', 'Pathology'

@bp.route('/addPatient',methods=('GET','POST')) #'GET','POST')
def addPatient():
    # db=get_db()
    # error=None
    physician=get_db().execute('SELECT STAFF.* FROM STAFF WHERE EmpType="PHYS"').fetchall() #db.execute('SELECT * FROM STAFF').fetchall()

    if request.method == 'POST':
        gender=request.form['Gender']
        Fname = request.form['Fname']
        Lname = request.form['Lname']
        mName = request.form['Minit']
        birthdate=request.form['Dob']
        ssn=request.form['Ssn']
        caregiver=request.form['Pcp']
        zipCode= request.form['ZIP']
        blood= request.form['BloodType']
        rh= request.form['RhFactor']
        address= request.form['Addr']
        city= request.form['City']
        state= request.form['StateProv']
        country= request.form['Country']
        phone= request.form['Phone']


        if error is not None:
            flash(error)

        else:  
             db=get_db()
             db.execute(
                'INSERT INTO PATIENT (Fname,Minit,Lname,Gender,Dob,Ssn,Pcp,ZIP,BloodType,RhFactor,Addr,City,StateProv,Country,Phone)'
                ' VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
                (Fname,mName,Lname,gender,birthdate,ssn,caregiver,zipCode,blood,rh,address,city,state,country,phone)
            )
             post_id = db.cursor().fetchone()
             print(post_id)
             db.commit()

             return redirect(url_for('people.seeAllPatients'))

    return render_template('members/patient/addPatient.html',physician=physician)

@bp.route('/add',methods=('GET','POST')) #'GET','POST')
def addStaff():
    # db=get_db()
    # error=None
    specialty= ['Cardiology', 'Dermatology', 'Gastroenterology', 'Orthopedics', 'Neurology', 'Ophthalmology', 
                'Otolaryngology', 'Pediatrics', 'Obstetrics and Gynecology', 'Urology', 'Endocrinology', 'Rheumatology', 'Pulmonology', 'Hematology', 
                'Infectious Disease', 'Emergency Medicine', 'Plastic Surgery', 'Radiology', 'Anesthesiology', 'Pathology']

    if request.method == 'POST':
        gender=request.form['Gender']
        empType=request.form['EmpType']
        Fname = request.form['Fname']
        Lname = request.form['Lname']

        mName = request.form['Minit']
        ssn = request.form['Ssn']
        title = request.form['Title']
        salary=request.form['Salary']
        skill=request.form['Specialty']
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
                'INSERT INTO STAFF (Fname,Minit,Lname,Gender,EmpType,Ssn,Title,Salary,Specialty)'
                ' VALUES (?,?,?,?,?,?,?,?,?)',
                (Fname,mName,Lname,gender,empType,ssn,title,salary,skill)
            )
             post_id = db.cursor().fetchone()
             print(post_id)
             db.commit()

             return redirect(url_for('people.seeAllStaff'))

    return render_template('members/staff/add.html',specialty=specialty)

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
