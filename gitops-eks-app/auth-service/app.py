import os
import jwt
import datetime
from flask import Flask, request, jsonify

app = Flask(__name__)
JWT_SECRET = os.environ.get('JWT_SECRET', 'dev-secret-change-in-prod')


@app.route('/health')
def health():
    return jsonify({'status': 'ok', 'service': 'auth-service'})


@app.route('/login', methods=['POST'])
def login():
    data = request.get_json(silent=True) or {}
    username = data.get('username')
    password = data.get('password')

    if not username or not password:
        return jsonify({'error': 'username and password required'}), 400

    # Hardcoded for demo — real auth would query a DB
    if username == 'admin' and password == 'password':
        token = jwt.encode(
            {
                'sub': username,
                'exp': datetime.datetime.utcnow() + datetime.timedelta(hours=1),
            },
            JWT_SECRET,
            algorithm='HS256',
        )
        return jsonify({'token': token})

    return jsonify({'error': 'invalid credentials'}), 401


if __name__ == '__main__':
    port = int(os.environ.get('PORT', 3001))
    app.run(host='0.0.0.0', port=port)
