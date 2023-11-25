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
    # db=get_db()
    # staff=db.execute('SELECT empNo , * FROM STAFF').fetchall() #db.execute('SELECT * FROM STAFF').fetchall()

    return render_template('schedule/shifts.html')

@bp.route('/appointments')
def appointmentPage():
    # db=get_db()
    # staff=db.execute('SELECT empNo , * FROM STAFF').fetchall() #db.execute('SELECT * FROM STAFF').fetchall()

    return render_template('schedule/appointments.html')

    # @bp.route('/addAppointment',methods=('GET','POST')) #'GET','POST')
# def addAppointment():
#     pass

#     return render_template('members/patient/addPatient.html')


@bp.route('/surgery')
def surgeryPage():
    # db=get_db()
    # staff=db.execute('SELECT empNo , * FROM STAFF').fetchall() #db.execute('SELECT * FROM STAFF').fetchall()

    return render_template('schedule/surgeries.html')

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
