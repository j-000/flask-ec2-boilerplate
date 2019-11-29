from server import db
from datamodels.Users import User

def main():
  db.create_all()
  User('Admin', 'Admin@domain.something', 'change-me')
  

if __name__ == "__main__":
  main()