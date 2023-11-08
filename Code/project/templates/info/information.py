import functools

from flask import (
    Blueprint, flash, g, redirect, render_template, request, session, url_for
)
from werkzeug.security import check_password_hash, generate_password_hash

from flaskr.db import get_db

bp = Blueprint('information', __name__)

#this SHOULD grab all people that are in the DB, if not ???
@bp.route('/')
def index():
    db=get_db()
    names= db.execute( 'SELECT i.id, person, hospitalNumber'
        'FROM post i JOIN item d on p.id=u.id'
        'ORDER BY name').fetchall()
    return render_template('info/index.html',names=names)