from flask import Flask, render_template, url_for
from flask_socketio import SocketIO

import eventlet

app = Flask(__name__)
app.config['SECRET_KEY'] = 'secret!'
socketio = SocketIO(app)

eventlet.monkey_patch()

@app.route('/')
def index():
	return render_template('index.html', filename='js/index.js')

@app.route('/boardsim')
def boardsim():
	return render_template('index.html', filename='js/boardsim.js')

@socketio.on('message', namespace='/users')
def relay_to_board(message):
	print('got msg from users')
	print(message)
	socketio.emit('message', message, namespace='/')

@socketio.on('reset', namespace='/users')
def reset_to_board(message):
	print('got reset from users')
	print(message)
	socketio.emit('reset', namespace='/')

@socketio.on('message', namespace='/')
def relay_to_users(message):
	print('got msg from board')
	socketio.emit('message', message, namespace='/users')

if __name__ == '__main__':
	socketio.run(app, host='0.0.0.0')