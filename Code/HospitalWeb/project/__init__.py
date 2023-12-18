import os

from flask import Flask, flash,render_template

#basic outline
 #Used to create a simple db table to work with 
 #DEV ONLY
 #flask --app project run --debug
 #flask --app project init-db
 #regular
 #flask --app project run 
def create_app(test_config=None):
    # create and configure the app
    app = Flask(__name__, instance_relative_config=True)
    app.config.from_mapping(
        SECRET_KEY='dev',
        DATABASE=os.path.join(app.instance_path, 'project.sqlite'),
    )

    if test_config is None:
        # load the instance config, if it exists, when not testing
        app.config.from_pyfile('config.py', silent=True)
    else:
        # load the test config if passed in
        app.config.from_mapping(test_config)

    # ensure the instance folder exists
    try:
        os.makedirs(app.instance_path)
    except OSError:
        pass

    # a simple page that says hello
    @app.route('/hello')
    def hello():
        return 'Hello, World!'

    @app.route('/')
    def mainpg():
        return render_template('mainpage.html')

    #This is for Database Intiialization 
    from . import db
    db.init_app(app)
    
    #this is for giving the view of the staff
    from . import people
    app.register_blueprint(people.bp)

    from . import schedule
    app.register_blueprint(schedule.bp)
    return app