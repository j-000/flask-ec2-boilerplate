from flask_login import UserMixin
from server import db

class User(db.Model, UserMixin):
    __tablename__ = 'users'

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(25))
    email = db.Column(db.String(50))
    password = db.Column(db.String(50))

    def __repr__(self):
        return '{id} - {name}'.format(id=self.id, name=self.name)