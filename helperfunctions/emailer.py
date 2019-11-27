# from flask_mail import Mail
# from flask_mail import Message as MailMessage
# from server import app
# from threading import Thread

# from applicationsecrets import MAIL_USERNAME, MAIL_DEFAULT_SENDER, MAIL_PASSWORD
# app.config.update(
#   DEBUG=False,
#   MAIL_SERVER='smtp.123-reg.co.uk',
#   MAIL_PORT=465,
#   MAIL_USE_SSL=True,
#   MAIL_USERNAME = MAIL_USERNAME,
#   MAIL_PASSWORD = MAIL_PASSWORD,
#   MAIL_DEFAULT_SENDER = MAIL_DEFAULT_SENDER
# )



# mail = Mail(app)
# def sendemail(email_subject, recipients, email_text=None, email_html=None):
#   msg = MailMessage(email_subject, recipients=recipients)
#   msg.body = email_text
#   msg.html = email_html
#   with app.app_context():
#     mail.send(msg)
