import functools, random

from flask import (
    Blueprint, flash, g, redirect, render_template, request, session, url_for
)
from werkzeug.security import check_password_hash, generate_password_hash

from project.db import get_db

bp = Blueprint('patient', __name__, url_prefix='/patient')

@bp.route('/patient')
def seeAll():
    db=get_db()
    staff=db.execute('SELECT rowid , * FROM PATIENT').fetchall() #db.execute('SELECT * FROM STAFF').fetchall()
    print(staff)
    return render_template('staff.html',patient=patient) #TODO: Generic person html, changes from DB name


@bp.route('/add',methods=('GET','POST')) #'GET','POST')
def addOne():
    # db=get_db()
    # error=None

    if request.method == 'POST':
         status= request.form['EmpStatus']
        gender=request.form['Gender']
        empType=request.form['EmpType']
        Fname = request.form['Fname']
        Lname = request.form['Lname']

        midName = request.form['Minit']
        ssn = request.form['Ssn']
        
        empStatus = request.form['EmpStatus']
        addr = request.form['Addr']
        city = request.form['City'] 

        stateProv = request.form['StateProv']
        zipCode =request.form['ZIP']
        country =request.form['Country']
        phone  =request.form['Phone']

        # Dob
        # BloodType 
        # RhFactor 
        # InsProvider 
        # InsMemberId 

        error = None

        if error is not None:
            flash(error)

        else:  
             db=get_db()
             db.execute(
                'INSERT INTO STAFF (Fname,Lname,Gender,EmpType,EmpStatus)'
                ' VALUES (?,?,?,?,?)',
                (Fname,Lname,gender,empType,status)
            )
             post_id = db.cursor().fetchone()
             print(post_id)
             db.commit()

             return redirect(url_for('people.seeAll'))

    return render_template('add.html')

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
             return redirect(url_for('people.seeAll'))

     return render_template('update.html')

#staff deletion, smaller pieces
@bp.route('/<int:id>/delete', methods=('POST','GET'))
def delete(id):
    get_person(id)
    db = get_db()
    db.execute('DELETE FROM STAFF WHERE rowid = ?', (id,))
    db.commit()
    return redirect(url_for('people.seeAll'))