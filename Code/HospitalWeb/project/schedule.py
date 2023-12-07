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
    surgery=db.execute('SELECT SURGERY.*,SURGERY_STAFF.*,SURG_TYPE.Name AS surgName,STAFF.Fname AS docFirst,STAFF.Lname AS docLast,PATIENT.Fname AS patientFirst,PATIENT.Lname AS patientLast, OP_THEATRE.Clinic AS clinic'
                           ' FROM SURGERY,SURGERY_STAFF,SURG_TYPE,STAFF,PATIENT,OP_THEATRE'
                           ' WHERE STAFF.EmpNo=SURGERY_STAFF.EmpNo AND PATIENT.PatientNo=SURGERY.PatientNo AND SURG_TYPE.Code=SURGERY.SurgeryType AND SURGERY_STAFF.SurgeryNo=SURGERY.SurgeryNo AND OP_THEATRE.Code=SURGERY.OpTheatre').fetchall()
    print(db)
    return render_template('schedule/surgeries.html',surgery=surgery)

@bp.route('/addSurgery',methods=('GET','POST')) 
def addSurgery():
    db=get_db()
    surgery=db.execute('SELECT APPOINTMENT.*,STAFF.Fname AS docFirst,STAFF.Lname AS docLast,PATIENT.Fname AS patientFirst,PATIENT.Lname AS patientLast'
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

             return redirect(url_for('schedule.surgeryPage'))

    return render_template('schedule/add/addSurgery.html',surgery=surgery)

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