from os import getenv

from apscheduler.schedulers.background import BackgroundScheduler
from flask import Flask, request, render_template, redirect, url_for, flash
from flask_restful import Api

import os
from werkzeug.utils import secure_filename
from flask_mail import Mail, Message


app = Flask(__name__)
api = Api(app)

UPLOAD_FOLDER = 'resources/uploads'
ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'gif'}
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER


app.config['MAIL_SERVER'] = 'smtp.example.com'
app.config['MAIL_PORT'] = 587
app.config['MAIL_USE_TLS'] = True
app.config['MAIL_USERNAME'] = 'your_email@example.com'
app.config['MAIL_PASSWORD'] = 'your_password'
mail = Mail(app)


if not os.path.exists(UPLOAD_FOLDER):
    os.makedirs(UPLOAD_FOLDER)
    
    
def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS


debug = int(getenv("DEBUG", 0)) == 1

scheduler = BackgroundScheduler()

@app.route('/')
def home():
    return render_template('home.html')


@app.route('/contact', methods=['GET', 'POST'])
def contact():
    if request.method == 'POST':
        subject = request.form['subject']
        body = request.form['body']
        recipient = 'recipient@example.com'
        
        msg = Message(subject, sender=app.config['MAIL_USERNAME'], recipients=[recipient])
        msg.body = body
        mail.send(msg)
        flash('Email sent successfully!')
        return redirect(url_for('contact'))
    
    return render_template('contact.html')

@app.route('/photos', methods=['GET', 'POST'])
def photos():
    if request.method == 'POST':
        if 'photos' not in request.files:
            flash('No file part')
            return redirect(request.url)
        
        files = request.files.getlist('photos')
        for file in files:
            if file and allowed_file(file.filename):
                filename = secure_filename(file.filename)
                file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))
        flash('Photos uploaded successfully!')
        return redirect(url_for('photos'))
    
    photos_list = os.listdir(UPLOAD_FOLDER)
    return render_template('photos.html', photos=photos_list)


if __name__ == '__main__':
    app.run(port=5000, debug=debug)
