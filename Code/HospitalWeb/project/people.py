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

   #get_db().execute(
        # 'SELECT rowid,*'
        # ' FROM PATIENT P,STAFF E'
        # ' WHERE P.pcp=E.rowid'
        # ,(id,)).fetchall()


@bp.route('/patient')
def seeAllPatients():
    db=get_db()
    patient=db.execute('SELECT P.rowid, S.rowid, *' ' FROM PATIENT P, STAFF S' 'WHERE P.rowid=S.rowid').fetchall() #db.execute('SELECT * FROM STAFF').fetchall()

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
                'INSERT INTO PATIENT (Fname,Minit,Lname,Gender,Dob,Pcp)'
                ' VALUES (?,?,?,?,?,?)',
                (Fname,mName,Lname,gender,birthdate,caregiver)
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


