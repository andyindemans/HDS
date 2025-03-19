from os import getenv
import secrets

from apscheduler.schedulers.background import BackgroundScheduler
from flask import Flask, request, render_template, redirect, url_for, flash, send_from_directory
from flask_restful import Api

import os
from werkzeug.utils import secure_filename
from flask_mail import Mail, Message


app = Flask(__name__)
api = Api(app)

if not app.config.get('SECRET_KEY'):
    app.config['SECRET_KEY'] = secrets.token_hex(32)

UPLOAD_FOLDER = os.path.abspath('app/api/uploads')
ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'gif'}
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

if not os.path.exists(UPLOAD_FOLDER):
    os.makedirs(UPLOAD_FOLDER, mode=0o755)


app.config['MAIL_SERVER'] = 'smtp.example.com'
app.config['MAIL_PORT'] = 587
app.config['MAIL_USE_TLS'] = True
app.config['MAIL_USERNAME'] = 'your_email@example.com'
app.config['MAIL_PASSWORD'] = 'your_password'
mail = Mail(app)


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
    # Handle file upload first
    if request.method == 'POST':
        if 'photos' not in request.files:
            flash('No files selected')
            return redirect(url_for('photos'))
            
        files = request.files.getlist('photos')
        uploaded_files = []
        
        for file in files:
            if file and allowed_file(file.filename):
                filename = secure_filename(file.filename)
                file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))
                uploaded_files.append(filename)
        
        if len(uploaded_files) > 0:
            flash(f'Successfully uploaded {len(uploaded_files)} files!')
        else:
            flash('No valid files uploaded')
        
        return redirect(url_for('photos'))

    # Handle GET requests (pagination)
    page = request.args.get('page', 1, type=int)
    per_page = 20
    photos_list = os.listdir(UPLOAD_FOLDER)
    paginated_photos = photos_list[(page-1)*per_page : page*per_page]
    
    if request.headers.get('X-Requested-With') == 'XMLHttpRequest':
        return render_template('_photo_items.html', photos=paginated_photos)
    
    return render_template('photos.html', photos=paginated_photos)


@app.route('/uploads/<filename>')
def uploaded_file(filename):
    return send_from_directory(app.config['UPLOAD_FOLDER'], filename)


if __name__ == '__main__':
    app.run(port=5000, debug=debug)
