from development_settings import DEVELOPMENT

# system credentials
SECRET_KEY ='CHANGE-ME-AS-SOON-AS-POSSIBLE'
SECURITY_PASSWORD_SALT = 'CHANGE-ME-AS-SOON-AS-POSSIBLE'

# Prod Database
URI = ''
PORT = ''
USER = ''
SECRET = ''
NAME = ''

SQLALCHEMY_TRACK_MODIFICATIONS = False 
# Dev Database
if DEVELOPMENT:
    SQLALCHEMY_DATABASE_URI = 'sqlite:///test_database.db'
else:
    SQLALCHEMY_DATABASE_URI = 'mysql+pymysql://{user}:{password}@{host}:{port}/{dbname}'.format(
    user=USER, password=SECRET, host=URI, port=PORT, dbname=NAME)