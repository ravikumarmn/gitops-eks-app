import os
import uuid
import requests
from flask import Flask, request, jsonify

app = Flask(__name__)

PRODUCT_SERVICE_URL = os.environ.get('PRODUCT_SERVICE_URL', 'http://localhost:3002')

orders = {}


@app.route('/health')
def health():
    return jsonify({'status': 'ok', 'service': 'order-service'})


@app.route('/orders', methods=['POST'])
def create_order():
    data = request.get_json(silent=True) or {}
    product_id = data.get('product_id')
    quantity = data.get('quantity', 1)

    if not product_id:
        return jsonify({'error': 'product_id required'}), 400

    try:
        resp = requests.get(f'{PRODUCT_SERVICE_URL}/products/{product_id}', timeout=3)
        if resp.status_code == 404:
            return jsonify({'error': 'product not found'}), 404
        product = resp.json()
    except requests.RequestException:
        return jsonify({'error': 'product service unavailable'}), 503

    order_id = str(uuid.uuid4())
    order = {
        'id': order_id,
        'product_id': product_id,
        'product_name': product.get('name'),
        'quantity': quantity,
        'total': product.get('price', 0) * quantity,
        'status': 'created',
    }
    orders[order_id] = order
    return jsonify(order), 201


@app.route('/orders/<order_id>')
def get_order(order_id):
    order = orders.get(order_id)
    if not order:
        return jsonify({'error': 'order not found'}), 404
    return jsonify(order)


if __name__ == '__main__':
    port = int(os.environ.get('PORT', 3003))
    app.run(host='0.0.0.0', port=port)
