from flask_login import UserMixin
from server import db, app
import jwt
import time

class User(db.Model, UserMixin):
  __tablename__ = 'users'

  id = db.Column(db.Integer, primary_key=True)
  name = db.Column(db.String(25))
  email = db.Column(db.String(50))
  password = db.Column(db.String(50))
  token = db.Column(db.String(300), nullable=True)

  def __repr__(self):
    return '{id} - {name}'.format(id=self.id, name=self.name)

  def __init__(self, name, email, password):
    self.name = name
    self.email = email
    self.password = password
    db.session.add(self)
    db.session.commit()
    return

  @staticmethod
  def fetch(email=None, id=None):
    if not email and not id:
      raise 'Required params: Email or Id'
    if email:
      return User.query.filter_by(email=email).first()
    if id:
      return User.query.get(id)

  @staticmethod
  def decode_token(token):
    try:
      tk = jwt.decode(token, app.config['SECRET_KEY'], algorithms=['HS256'])
    except Exception as e:
      return False
    user = User.query.filter_by(email=tk['user_email']).first()
    if not user:
      return False
    return user

  def generate_session_token(self, expires_in=3600):
    # DO NOT rename 'exp' flag. This is used inside jwt.encode() to verify if the token has expired.
    token = jwt.encode({'user_email': self.email, 'id' : self.id , 
    'exp': time.time() + expires_in}, app.config['SECRET_KEY'], algorithm='HS256').decode('utf-8')
    self.token = token
    db.session.add(self)
    db.session.commit()
    return token

  def delete_token(self):
    self.token = None
    db.session.add(self)
    db.session.commit()