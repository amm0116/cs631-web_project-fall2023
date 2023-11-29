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
                           ' WHERE STAFF.EmpNo=APPOINTMENT.Physician AND PATIENT.PatientNo=APPOINTMENT.PatientNo').fetchall()#'SELECT AppointmentNo , * FROM APPOINTMENT').fetchall()
    return render_template('schedule/appointments.html',appointment=appointment,doctors=doctorInfo(appointment))

@bp.route('/<string:filter>/<int:id>/')
def appointmentFiltering(filter,id):
    db=get_db()
    result=db.execute('  SELECT APPOINTMENT.*,STAFF.Fname AS docFirst,STAFF.Lname AS docLast,PATIENT.Fname AS patientFirst,PATIENT.Lname AS patientLast'
                           ' FROM APPOINTMENT,PATIENT,STAFF'
                           ' WHERE APPOINTMENT.Physician=? AND STAFF.EmpNo=APPOINTMENT.Physician AND PATIENT.PatientNo=APPOINTMENT.PatientNo',(id,) ).fetchall()
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

    # @bp.route('/addAppointment',methods=('GET','POST')) #'GET','POST')
# def addAppointment():
#      # "APPOINTMENT" ("AppointmentNo","PatientNo","Physician","Clinic","Time","Type")

#     return render_template('members/patient/addPatient.html')


@bp.route('/surgery')
def surgeryPage():
    db=get_db()
    surgery=db.execute('SELECT SURGERY.*,SURGERY_STAFF.*,SURG_TYPE.Name AS surgName,STAFF.Fname AS docFirst,STAFF.Lname AS docLast,PATIENT.Fname AS patientFirst,PATIENT.Lname AS patientLast, OP_THEATRE.Clinic AS clinic'
                           ' FROM SURGERY,SURGERY_STAFF,SURG_TYPE,STAFF,PATIENT,OP_THEATRE'
                           ' WHERE STAFF.EmpNo=SURGERY_STAFF.EmpNo AND PATIENT.PatientNo=SURGERY.PatientNo AND SURG_TYPE.Code=SURGERY.SurgeryType AND SURGERY_STAFF.SurgeryNo=SURGERY.SurgeryNo AND OP_THEATRE.Code=SURGERY.OpTheatre').fetchall()
    print(db)
    return render_template('schedule/surgeries.html',surgery=surgery)

# @bp.route('/addSurgery',methods=('GET','POST')) #'GET','POST')
# def addSurgery():
#     pass

#     return render_template('members/patient/addPatient.html')


@bp.route('/incoming')
def inpatientPage():
    # db=get_db()
    # staff=db.execute('SELECT empNo , * FROM STAFF').fetchall() #db.execute('SELECT * FROM STAFF').fetchall()

    return render_template('schedule/inpatient.html')

# @bp.route('/addStay',methods=('GET','POST')) #'GET','POST')
# def addStay():
#     pass

#     return render_template('members/patient/addPatient.html')