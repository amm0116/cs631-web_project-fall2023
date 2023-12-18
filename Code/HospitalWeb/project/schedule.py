#This Blueprint has a View for scheduling
#the code in this will rely on an HTML representation of what
#page will look like
import functools, random

from flask import (
    Blueprint, flash, g, redirect, render_template, request, session, url_for
)
from werkzeug.security import check_password_hash, generate_password_hash

from project.db import get_db

from datetime import datetime

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


    physician=db.execute('SELECT * FROM STAFF WHERE STAFF.EmpType="PHYS" OR STAFF.Title="Chief of Staff"').fetchall()
    return render_template('schedule/appointments.html',appointment=appointment,physician=physician)

@bp.route('/<string:filter>/<int:id>/')
def appointmentFiltering(filter,id):
    db=get_db()
    result=db.execute('  SELECT APPOINTMENT.*,STAFF.Fname AS docFirst,STAFF.Lname AS docLast,PATIENT.Fname AS patientFirst,PATIENT.Lname AS patientLast'
                           ' FROM APPOINTMENT,PATIENT,STAFF'
                           ' WHERE APPOINTMENT.Physician=? AND STAFF.EmpNo=APPOINTMENT.Physician AND PATIENT.PatientNo=APPOINTMENT.PatientNo',(id,) ).fetchall()
    
    physician=db.execute('SELECT * FROM STAFF WHERE STAFF.EmpType="PHYS" OR STAFF.Title="Chief of Staff"').fetchall()
    db.commit()
    return render_template('schedule/appointments.html',appointment=result,physician=physician)

@bp.route('/<string:filter>/<int:month>/')
def appointmentMonthFiltering(filter,month):
    db=get_db()
    result=db.execute('SELECT APPOINTMENT.*,STAFF.Fname AS docFirst,STAFF.Lname AS docLast,PATIENT.Fname AS patientFirst,PATIENT.Lname AS patientLast'
                           ' FROM APPOINTMENT,PATIENT,STAFF'
                           ' WHERE STAFF.EmpNo=APPOINTMENT.Physician AND PATIENT.PatientNo=APPOINTMENT.PatientNo').fetchall()


    value= db.execute('SELECT APPOINTMENT.Time FROM APPOINTMENT')

    for item in value:
        datetime_str = item['Time']

        datetime_object = datetime.strptime(datetime_str, '%m/%d/%Y %I:%M')

        print(datetime_object.strftime('%m'))

    db.commit()
    
    return render_template('schedule/appointments.html',appointment=result)


@bp.route('/addAppointment',methods=('GET','POST')) #'GET','POST')
def addAppointment():
 
    error = None
    appointment=get_db().execute('SELECT APPOINTMENT.*,STAFF.Fname AS docFirst,STAFF.Lname AS docLast,PATIENT.Fname AS patientFirst,PATIENT.Lname AS patientLast'
                           ' FROM APPOINTMENT,PATIENT,STAFF'
                           ' WHERE STAFF.EmpNo=APPOINTMENT.Physician AND PATIENT.PatientNo=APPOINTMENT.PatientNo').fetchall()

    patient= get_db().execute('SELECT * FROM PATIENT').fetchall()
    doctor= get_db().execute('SELECT * FROM STAFF WHERE STAFF.EmpType="PHYS" OR STAFF.Title="Chief of Staff"').fetchall()
    hospital= get_db().execute('SELECT * FROM CLINIC').fetchall()

    if request.method == 'POST':
        patientnum= request.form['PatientNo']
        physician=request.form['Physician']
        clinic=request.form['Clinic']
        apptime=request.form['Time']
        apptype=request.form['Type']

    

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

    return render_template('schedule/add/addAppointment.html',appointment=appointment,patient=patient,doctor=doctor,hospital=hospital)

@bp.route('/surgery')
def surgeryPage():
    db=get_db()
    surgery=db.execute('SELECT SURGERY.SurgeryNo, SURGERY.PatientNo, SURGERY.Surgeon,B.Fname AS patientFirst, B.Lname AS patientLast, E.Name AS surgType, D.Clinic AS clinic, D.Theatre AS theatre, SURGERY.SurgeryTime ,SURGERY.OpTheatre FROM SURGERY , PATIENT AS B, OP_THEATRE AS D, SURG_TYPE AS E WHERE SURGERY.PatientNo = B.PatientNo AND SURGERY.OpTheatre = D.Code AND SURGERY.SurgeryType = E.Code').fetchall()
    surgeon=db.execute('SELECT * FROM STAFF WHERE STAFF.EmpType="SURG"').fetchall()

    
    place= db.execute('SELECT * FROM OP_THEATRE').fetchall()

    return render_template('schedule/surgeries.html',surgery=surgery,surgeon=surgeon,place=place)

@bp.route('/addSurgery',methods=('GET','POST')) 
def addSurgery():
    db=get_db()
    
    # surgery=db.execute('SELECT SURGERY.*, B.Fname AS patientFirst, B.Lname AS patientLast, C.Fname AS docFirst, C.Lname AS docLast, E.Name AS surgType, D.Clinic, D.Theatre FROM SURGERY , PATIENT AS B, STAFF AS C, OP_THEATRE AS D, SURG_TYPE AS E WHERE SURGERY.Surgeon = C.EmpNo AND SURGERY.OpTheatre = D.Code AND SURGERY.SurgeryType = E.Code').fetchall()

    patient= db.execute('SELECT * FROM PATIENT').fetchall()

    surgeryItem= db.execute('SELECT * FROM SURG_TYPE').fetchall()

    opClinic= db.execute('SELECT * FROM OP_THEATRE').fetchall()

    surgeon= db.execute('SELECT * FROM STAFF WHERE STAFF.EmpType="SURG"').fetchall()

#patient number, surgeon, time, op theatre, surgery type
    if request.method == 'POST':
        patientnum= request.form['PatientNo']
        doc=request.form['Surgeon']
        theatre=request.form['OpTheatre']
        surgtime=request.form['SurgeryTime']
        surgtype=1#request.form['SurgeryType']

        
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
             print(surgtime)
             print(patientnum)
             print(doc)
             print(theatre)
             print(surgtime)
             print(surgtype)

             db.commit()

             return redirect(url_for('schedule.surgeryPage'))

    return render_template('schedule/add/addSurgery.html',patient=patient, type=surgeryItem, place=opClinic, doctor=surgeon)

@bp.route('/surgery/<string:filter>/<int:id>/')
def surgeonFiltering(filter,id):
    db=get_db()
    result=db.execute('SELECT SURGERY.SurgeryNo, SURGERY.PatientNo,SURGERY.Surgeon,B.Fname AS patientFirst, B.Lname AS patientLast, E.Name AS surgType, D.Clinic, D.Theatre, SURGERY.SurgeryTime FROM SURGERY ,PATIENT AS B, OP_THEATRE AS D, SURG_TYPE AS E WHERE SURGERY.PatientNo = B.PatientNo AND SURGERY.Surgeon = ? AND SURGERY.OpTheatre = D.Code AND SURGERY.SurgeryType = E.Code',(id,)).fetchall()

    surgeon=db.execute('SELECT * FROM STAFF WHERE STAFF.EmpType="SURG"').fetchall()


    db.commit()
    return render_template('schedule/surgeries.html',surgery=result,surgeon=surgeon,result=result)


@bp.route('/surgery/op/<string:filter>/<int:id>/')
def theatreFiltering(filter,id):
    db=get_db()
    result=db.execute('SELECT SURGERY.SurgeryNo, SURGERY.PatientNo,SURGERY.OpTheatre,SURGERY.Surgeon,B.Fname AS patientFirst, B.Lname AS patientLast, E.Name AS surgType, D.Clinic, D.Theatre, SURGERY.SurgeryTime FROM SURGERY ,PATIENT AS B,STAFF AS C, OP_THEATRE AS D, SURG_TYPE AS E WHERE SURGERY.PatientNo = B.PatientNo AND SURGERY.Surgeon = C.EmpNo AND SURGERY.OpTheatre = ? AND SURGERY.SurgeryType = E.Code',(id,)).fetchall()
    print(id)
    place= db.execute('SELECT * FROM OP_THEATRE').fetchall()


    db.commit()
    return render_template('schedule/surgeries.html',surgery=result,place=place)

def monthProcessing(monthNum):
     
    value= db.execute('SELECT SURGERY.SurgeryTime, SURGERY.PatientNo FROM SURGERY')
    patientNum=[]
    for item in value:
        datetime_str = item['SurgeryTime']
        if "/" in datetime_str:
             datetime_object = datetime.strptime(datetime_str, '%m/%d/%Y')
             if monthNum==datetime_object.month:
                patientNum.append(item['PatientNo'])

        if "-" in datetime_str:
             datetime_object = datetime.strptime(datetime_str, '%Y-%m-%d')
             if monthNum==datetime_object.month:
                patientNum.append(item['PatientNo'])

    return patientNum


@bp.route('/surgery/<string:filter>/<int:month>/')
def surgeonMonthFiltering(filter,month):
    db=get_db()
    # result=db.execute('SELECT SURGERY.SurgeryNo, SURGERY.PatientNo,SURGERY.Surgeon,B.Fname AS patientFirst, B.Lname AS patientLast, E.Name AS surgType, D.Clinic, D.Theatre, SURGERY.SurgeryTime FROM SURGERY ,PATIENT AS B, OP_THEATRE AS D, SURG_TYPE AS E WHERE SURGERY.PatientNo = B.PatientNo AND SURGERY.Surgeon = ? AND SURGERY.OpTheatre = D.Code AND SURGERY.SurgeryType = E.Code',(id,)).fetchall()
    result=db.execute('SELECT SURGERY.SurgeryNo, SURGERY.PatientNo, SURGERY.Surgeon,B.Fname AS patientFirst, B.Lname AS patientLast, C.Fname AS docFirst, C.Lname AS docLast, E.Name AS surgType, D.Clinic, D.Theatre, SURGERY.SurgeryTime FROM SURGERY , PATIENT AS B, STAFF AS C, OP_THEATRE AS D, SURG_TYPE AS E WHERE SURGERY.PatientNo = B.PatientNo AND SURGERY.Surgeon = C.EmpNo AND SURGERY.OpTheatre = D.Code AND SURGERY.SurgeryType = E.Code').fetchall()
    patients=monthProcessing(month)
    print(patients)
    
    db.commit()

    return render_template('schedule/surgeries.html',surgery=result,patients=patients)




@bp.route('/stays')
def stayPage():
    db=get_db()
    #

    stay=db.execute('SELECT STAY.*,PATIENT.Fname AS patientFirst,PATIENT.Lname AS patientLast,STAFF.Fname AS staffFirst,STAFF.Lname AS staffLast'
                           ' FROM STAY,PATIENT,STAFF'
                           ' WHERE PATIENT.PatientNo=STAY.PatientNo AND STAFF.EmpNo=(STAY.Physician OR STAY.Nurse)').fetchall()
    room=db.execute('SELECT * FROM BED, STAY WHERE BED.Code=STAY.Bed')


    print(db)

    return render_template('schedule/inpatient.html',stay=stay,room=room)

@bp.route('/addStay',methods=('GET','POST')) #'GET','POST')
def addStay():
    db=get_db()
    stay=db.execute('SELECT STAY.*,BED.*,BED.Bed AS letter'
                           ' FROM STAY,BED'
                           ' WHERE STAY.Bed=BED.Code').fetchall()


    patient= db.execute('SELECT * FROM PATIENT').fetchall()
    doctor= db.execute('SELECT * FROM STAFF WHERE STAFF.EmpType="PHYS"').fetchall()
    assistant= db.execute('SELECT * FROM STAFF WHERE STAFF.EmpType="NURS"').fetchall()
    ailment= db.execute('SELECT * FROM PATIENT_ILLNESS').fetchall()
    available=db.execute('SELECT * FROM BED WHERE Code NOT IN (SELECT Bed FROM STAY)').fetchall()

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

             return redirect(url_for('schedule.stayPage'))

    return render_template('schedule/add/addStay.html',stay=stay,patient=patient,doctor=doctor,assistant=assistant,ailment=ailment,available=available)


@bp.route('/<int:id>/updateRoom', methods=('GET', 'POST'))
def updateBed(id):
     db=get_db()
     room= db.execute('SELECT BED.* FROM BED').fetchall()
     available=db.execute('SELECT * FROM BED WHERE Code NOT IN (SELECT Bed FROM STAY)').fetchall()
     error=None

     if request.method == 'POST':
        room = request.form['Code']

        if error is not None:
            flash(error)

        else:  
             db=get_db()
             db.execute(
               'UPDATE STAY SET Bed= ?'
                ' WHERE Bed = ?',
                (room,id)
            )
             db.commit()
             return redirect(url_for('schedule.stayPage'))

     return render_template('schedule/update/updateBed.html',room=room,available=available)


@bp.route('/<int:id>/update', methods=('GET', 'POST'))
def updateStaff(id):
     db=get_db()
     phys= db.execute('SELECT STAFF.* FROM STAFF WHERE STAFF.EmpType="PHYS"').fetchall()
     # nurse=db.execute('SELECT STAFF.* FROM STAFF WHERE STAFF.EmpType="NURS"').fetchall()
     error=None

     if request.method == 'POST':
        physician = request.form['Physician']
        # nurse = request.form['Nurse']

        if error is not None:
            flash(error)

        else:  
             db=get_db()
             db.execute(
               'UPDATE STAY SET Physician = ?'
                ' WHERE StayNo = ?',
                (physician,id)
            )
             db.commit()
             return redirect(url_for('schedule.stayPage'))

     return render_template('schedule/update/updateStaff.html',phys=phys)


@bp.route('/<int:id>/updateNurse', methods=('GET', 'POST'))
def updateNurse(id):
     db=get_db()
     nurse=db.execute('SELECT STAFF.* FROM STAFF WHERE STAFF.EmpType="NURS"').fetchall()
     error=None

     if request.method == 'POST':
        nurse = request.form['Nurse']

        if error is not None:
            flash(error)

        else:  
             db=get_db()
             db.execute(
               'UPDATE STAY SET nurse = ?'
                ' WHERE StayNo = ?',
                (nurse,id)
            )
             db.commit()
             return redirect(url_for('schedule.stayPage'))

     return render_template('schedule/update/updateNurse.html',nurse=nurse)

def get_person(id):
    item = get_db().execute(
        'SELECT STAY.*'
        ' FROM STAY'
        ' WHERE StayNo = ?',
        (id,)
    ).fetchone()

    return item

@bp.route('/shift')
def shiftPage():
    db=get_db()
    shift=db.execute('SELECT SHIFT.*,STAFF.Fname AS staffFirst,STAFF.Lname AS staffLast FROM SHIFT,STAFF WHERE STAFF.EmpNo=SHIFT.EmpNo').fetchall()
    print(db)

    return render_template('schedule/shifts.html',shift=shift)

@bp.route('/addShift',methods=('GET','POST')) #'GET','POST')
def addShift():
    db=get_db()

    shift=db.execute('SELECT STAFF.EmpNo,STAFF.Fname AS staffFirst,STAFF.Lname AS staffLast'
                           ' FROM STAFF'
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