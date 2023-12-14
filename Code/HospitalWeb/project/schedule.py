#This Blueprint has a View for scheduling
#the code in this will rely on an HTML representation of what
#page will look like
import functools, random

from flask import (
    Blueprint, flash, g, redirect, render_template, request, session, url_for
)
from werkzeug.security import check_password_hash, generate_password_hash

from project.db import get_db

bp = Blueprint('schedule', __name__, url_prefix='/schedule')


@bp.route('/')
def schedulePage():
    db=get_db()
    shift=db.execute('SELECT PatientNo, * FROM PATIENT ').fetchall() #db.execute('SELECT * FROM STAFF').fetchall()

   
    return render_template('schedule/shifts.html',shift=shift)

@bp.route('/appointments')
def appointmentPage():
    db=get_db()
    appointment=db.execute('SELECT APPOINTMENT.*,STAFF.Fname AS docFirst,STAFF.Lname AS docLast,PATIENT.Fname AS patientFirst,PATIENT.Lname AS patientLast'
                           ' FROM APPOINTMENT,PATIENT,STAFF'
                           ' WHERE STAFF.EmpNo=APPOINTMENT.Physician AND PATIENT.PatientNo=APPOINTMENT.PatientNo').fetchall()
                           #'SELECT AppointmentNo , * FROM APPOINTMENT').fetchall()


    return render_template('schedule/appointments.html',appointment=appointment,doctors=doctorInfo(appointment))

@bp.route('/<string:filter>/<int:id>/')
def appointmentFiltering(filter,id):
    db=get_db()
    result=db.execute('  SELECT APPOINTMENT.*,STAFF.Fname AS docFirst,STAFF.Lname AS docLast,PATIENT.Fname AS patientFirst,PATIENT.Lname AS patientLast'
                           ' FROM APPOINTMENT,PATIENT,STAFF'
                           ' WHERE APPOINTMENT.Physician=? AND STAFF.EmpNo=APPOINTMENT.Physician AND PATIENT.PatientNo=APPOINTMENT.PatientNo',(id,) ).fetchall()
    db.commit()
    return render_template('schedule/appointments.html',appointment=result)

@bp.route('/<string:filter>/<int:month>/')
def appointmentMonthFiltering(filter,month):
    db=get_db()
    result=db.execute('  SELECT APPOINTMENT.*'
                           ' FROM APPOINTMENT,PATIENT,STAFF'
                           ' WHERE APPOINTMENT.Time=DATE_FORMAT("2023-?-??", "%d")',(month,) ).fetchall()
    db.commit()
    
    return render_template('schedule/appointments.html',appointment=result)

def doctorInfo(appointment):
    list=[]
    physician={}
    for item in appointment:
        id= item['Physician']
        name=item['docLast']+","+item['docFirst']
        list.append((id,name))

    for a,b in list:
        physician[a]=b

    return physician

@bp.route('/addAppointment',methods=('GET','POST')) #'GET','POST')
def addAppointment():
 
    db=get_db()
    appointment=db.execute('SELECT APPOINTMENT.*,STAFF.Fname AS docFirst,STAFF.Lname AS docLast,PATIENT.Fname AS patientFirst,PATIENT.Lname AS patientLast'
                           ' FROM APPOINTMENT,PATIENT,STAFF'
                           ' WHERE STAFF.EmpNo=APPOINTMENT.Physician AND PATIENT.PatientNo=APPOINTMENT.PatientNo').fetchall()

    if request.method == 'POST':
        patientnum= request.form['PatientNo']
        physician=request.form['Physician']
        clinic=request.form['Clinic']
        apptime=request.form['Time']
        apptype=request.form['Type']

        error = None

        if error is not None:
            flash(error)

        else:  
             db=get_db()

             db.execute(
                'INSERT INTO APPOINTMENT(PatientNo,Physician,Clinic,Time,Type)'
                ' VALUES (?,?,?,?,?)',
                (patientnum,physician,clinic,apptime,apptype)
                
            )
       
             db.commit()

             return redirect(url_for('schedule.appointmentPage'))

    return render_template('schedule/add/addAppointment.html',appointment=appointment)

@bp.route('/surgery')
def surgeryPage():
    db=get_db()
    surgery=db.execute('SELECT SURGERY.SurgeryNo, SURGERY.PatientNo, B.Fname AS patientFirst, B.Lname AS patientLast, SURGERY.Surgeon, C.Fname AS docFirst, C.Lname AS docLast, E.Name AS surgType, D.Clinic, D.Theatre, SURGERY.SurgeryTime FROM SURGERY , PATIENT AS B, STAFF AS C, OP_THEATRE AS D, SURG_TYPE AS E WHERE SURGERY.PatientNo = B.PatientNo AND SURGERY.Surgeon = C.EmpNo AND SURGERY.OpTheatre = D.Code AND SURGERY.SurgeryType = E.Code').fetchall()
    print(db)
    return render_template('schedule/surgeries.html',surgery=surgery)

@bp.route('/addSurgery',methods=('GET','POST')) 
def addSurgery():
    db=get_db()
    
    # surgery=db.execute('SELECT SURGERY.*, B.Fname AS patientFirst, B.Lname AS patientLast, C.Fname AS docFirst, C.Lname AS docLast, E.Name AS surgType, D.Clinic, D.Theatre FROM SURGERY , PATIENT AS B, STAFF AS C, OP_THEATRE AS D, SURG_TYPE AS E WHERE SURGERY.Surgeon = C.EmpNo AND SURGERY.OpTheatre = D.Code AND SURGERY.SurgeryType = E.Code').fetchall()

    patient= db.execute('SELECT * FROM PATIENT').fetchall()

    surgeryItem= db.execute('SELECT * FROM SURG_TYPE').fetchall()

    opClinic= db.execute('SELECT * FROM OP_THEATRE')

    surgeon= db.execute('SELECT * FROM STAFF WHERE STAFF.EmpType="SURG"')

#patient number, surgeon, time, op theatre, surgery type
    if request.method == 'POST':
        patientnum= request.form['PatientNo']
        doc=request.form['Surgeon']
        theatre=request.form['OpTheatre']
        surgtime=request.form['SurgeryTime']
        surgtype=request.form['SurgeryType']

  
        error = None

        if error is not None:
            flash(error)

        else:  
             db=get_db()

             db.execute(
                'INSERT INTO SURGERY(PatientNo,Surgeon,SurgeryTime,OpTheatre,SurgeryType)'
                ' VALUES (?,?,?,?,?)',
                (patientnum,doc,surgtime,theatre,surgtype)
                
            )
       
             db.commit()

             return redirect(url_for('schedule.surgeryPage'))

    return render_template('schedule/add/addSurgery.html',patient=patient, type=surgeryItem, place=opClinic, doctor=surgeon)

@bp.route('/stays')
def stayPage():
    db=get_db()
    stay=db.execute('SELECT STAY.*,PATIENT.Fname AS patientFirst,PATIENT.Lname AS patientLast,STAFF.Fname AS staffFirst,STAFF.Lname AS staffLast'
                           ' FROM STAY,PATIENT,STAFF'
                           ' WHERE PATIENT.PatientNo=STAY.PatientNo').fetchall()
    print(db)

    return render_template('schedule/inpatient.html',stay=stay)

@bp.route('/addStay',methods=('GET','POST')) #'GET','POST')
def addStay():
    db=get_db()
    stay=db.execute('SELECT STAY.*,PATIENT.Fname AS patientFirst,PATIENT.Lname AS patientLast,BED.*'
                           ' FROM STAY,PATIENT,BED'
                           ' WHERE PATIENT.PatientNo=STAY.PatientNo AND STAY.Bed=BED.Code').fetchall()

    if request.method == 'POST':
        patientnum= request.form['PatientNo']
        physician=request.form['Physician']
        nurse=request.form['Nurse']
        bed=request.form['Bed']
        admission=request.form['AdmissionDate']
        diagnosis=request.form['DiagnosisNo']



        error = None

        if error is not None:
            flash(error)

        else:  
             db=get_db()

             db.execute(
                'INSERT INTO STAY(PatientNo,Bed,AdmissionDate,DiagnosisNo,Physician,Nurse)'
                ' VALUES (?,?,?,?,?,?)',
                (patientnum,bed,admission,diagnosis,physician,nurse)
                
            )
       
             db.commit()

             return redirect(url_for('schedule/inpatient.html'))

    return render_template('schedule/add/addStay.html',stay=stay)

@bp.route('/shift')
def shiftPage():
    db=get_db()
    shift=db.execute('SELECT SHIFT.*,STAFF.Fname AS staffFirst,STAFF.Lname AS staffLast'
                           ' FROM SHIFT,STAFF'
                           ' WHERE STAFF.EmpNo=SHIFT.EmpNo').fetchall()
    print(db)

    return render_template('schedule/shifts.html',shift=shift)

@bp.route('/addShift',methods=('GET','POST')) #'GET','POST')
def addShift():
    db=get_db()
    shift=db.execute('SELECT SHIFT.*,STAFF.Fname AS staffFirst,STAFF.Lname AS staffLast'
                           ' FROM SHIFT,STAFF'
                           ).fetchall()

    if request.method == 'POST':
        empnum= request.form['EmpNo']
        start=request.form['StartDate']
        shift=request.form['Shift']


        error = None

        if error is not None:
            flash(error)

        else:  
             db=get_db()

             db.execute(
                'INSERT INTO SHIFT(EmpNo, StartDate,Shift)'
                ' VALUES (?,?,?)',
                (empnum,start,shift)
                
            )
             db.commit()

             return redirect(url_for('schedule.shiftPage'))

    return render_template('schedule/add/addShift.html',shift=shift)