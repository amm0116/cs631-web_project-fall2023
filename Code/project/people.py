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
def seeAll():
    db=get_db()
    staff=db.execute('SELECT * FROM STAFF').fetchall()
    print(staff)
    return render_template('staff.html',staff=staff)


@bp.route('/add',methods=('GET','POST')) #'GET','POST')
def addOne():
    # db=get_db()
    # error=None

    if request.method == 'POST':
        id = db.Column(db.Integer, primary_key=True)
        
        status= request.form['EmpStatus']
        gender=request.form['Gender']
        empType=request.form['EmpType']
        Fname = request.form['Fname']
        Lname = request.form['Lname']

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
             db.commit()
             return redirect(url_for('people.seeAll'))

    return render_template('add.html')

# def get_post(id):
#     item = get_db().execute(
#         'SELECT id, name, staffNumber'
#         ' FROM staffmember'
#         ' WHERE id = ?',
#         (id,)
#     ).fetchone()

#     if item is None:
#         abort(404, f"Staff id {id} doesn't exist.")

#     return item

# #Update -Small Popup
# @bp.route('/<int:id>/update', methods=('GET', 'POST'))
# def updatePerson(id):
#      db=get_post(id)
#      error=None

#      if request.method == 'POST':
#         name = request.form['name']
#         error = None

#         if not name:
#             error = 'Name is required.'

#         if error is not None:
#             flash(error)

#         else:  
#              db=get_db()
#              db.execute(
#                'UPDATE staffmember SET name = ?'
#                 ' WHERE id = ?',
#                 (name, id)
#             )
#              db.commit()
#              return redirect(url_for('people.seeAll'))

#      return render_template('update.html')

# #you do not navigate to this page, you just click, should this be done for update?
# @bp.route('/<int:id>/delete', methods=('POST','GET'))
# def deletePerson(id):
#     get_post(id)
#     db = get_db()
#     db.execute('DELETE FROM staffmember WHERE id = ?', (id,))
#     db.commit()
#     return redirect(url_for('people.seeAll'))


