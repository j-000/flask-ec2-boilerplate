# database credentials and configuration
SQLALCHEMY_DATABASE_URI = ''
SQLALCHEMY_TRACK_MODIFICATIONS = False 

# system credentials
SECRET_KEY =''

# Database
URI = ''
PORT = ''
USER = ''
SECRET = ''
NAME = ''

SQLALCHEMY_DATABASE_URI = 'mysql+pymysql://{user}:{password}@{host}:{port}/{dbname}'.format(
    user=USER, password=SECRET, host=URI, port=PORT, dbname=NAME)