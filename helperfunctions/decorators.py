from flask import request, jsonify
from datamodels.Users import User
from functools import wraps
import wrapt

def jwt_required():
  @wrapt.decorator
  def wrapper(wrapped, instance, args, kwargs):
    # get auth header
    auth_header = request.headers.get('Authorization')
    # decline if not implemented
    if not auth_header:
      return jsonify({"message": "No authorization header defined.", 'success':False})
    # try to split and get the token
    try:
      auth_token = auth_header.split()[1] # Bearer <token>
    # decline if no token found
    except:
      return jsonify({"message": "No token found in authorization header.", 'success':False})
    # try get the user from the token payload
    user = User.decode_token(auth_token)
    # deline if no user found with the payload data (email)
    if not user:
      return jsonify({'message':'Invalid or expired token.', 'success':False})
    # A user was found with the token so all is good. 
    # (yes, someone can use someone else's token, but how would they get it?)
    return wrapped(*args, **kwargs, user=user)
  return wrapper