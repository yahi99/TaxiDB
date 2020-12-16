from flask import Flask, jsonify, request
from sqlalchemy import create_engine
from sqlalchemy.ext.automap import automap_base
from sqlalchemy.orm import scoped_session, sessionmaker

from config import Config
from controller import *

app = Flask(__name__)
app.config['SECRET_KEY'] = Config.SECRET_KEY
app.config['SQLALCHEMY_DATABASE_URI'] = Config.SQLACHEMY_DATABASE_URI

Base = automap_base()
engine = create_engine(Config.SQLACHEMY_DATABASE_URI)
Base.prepare(engine, reflect=True)

Client = Base.classes.client
CallRequest = Base.classes.call_request
Car = Base.classes.car
Driver = Base.classes.driver
Invoice = Base.classes.invoice
Operator = Base.classes.operator
SupportSpecialist = Base.classes.support_specialist
SupportTicket = Base.classes.support_ticket
Trip = Base.classes.trip

session = scoped_session(sessionmaker(
    autocommit=False, autoflush=False, bind=engine))


@app.route('/register_user', methods=['POST'])
def register_user():
    try:
        params = request.json
        new_client = register_user_controller(Client, **params)
        session.add(new_client)
        session.commit()
        print(new_client.client_id)
        return jsonify({'client_id': str(new_client.client_id)})
    except Exception as e:
        print(str(e))
        return jsonify({'msg': str(e)})


@app.route('/create_request_on_trip', methods=['POST'])
def create_request_on_trip():
    try:
        params = request.json
        new_request = create_request_on_trip_controller(CallRequest, **params)
        session.add(new_request)
        session.commit()
        return jsonify({'callr_id': str(new_request.callr_id)})
    except Exception as e:
        return jsonify({'msg': str(e)})


@app.route('/update_request_on_trip', methods=['PUT'])
def update_request_on_trip():
    try:
        params = request.json
        result = update_request_on_trip_controller(CallRequest, Trip, **params)
        return result
    except Exception as e:
        return jsonify({'msg': str(e)})


@app.route('/create_driver', methods=['POST'])
def create_driver():
    try:
        params = request.json
        new_driver = create_driver_controller(Driver, **params)
        session.add(new_driver)
        session.commit()
        return jsonify({'driver_id': new_driver.driver_id})
    except Exception as e:
        return jsonify({'msg': str(e)})


@app.route('/update_driver', methods=['PUT'])
def update_driver():
    try:
        params = reques.json
        result = update_driver_controller(session, Driver, **params)
    except Exception as e:
        return jsonify({'msg': str(e)})


@app.route('/create_car', methods=['POST'])
def create_car():
    try:
        params = request.json
        new_car = create_car_controller(Car, **params)
        session.add(new_car)
        session.commit()
        return jsonify({'car_id': new_car.car_id})
    except Exception as e:
        return jsonify({'msg': str(e)})


@app.route('/create_invoice', methods=['POST'])
def create_invoice():
    try:
        params = request.json
        new_invoice = create_invoice_controller(Invoice, **parmas)
        session.add(new_invoice)
        session.commit()
        return jsonify({'invoice_id': new_invoice.invoice_id})
    except Exception as e:
        return jsonify({'msg': str(e)})


@app.route('/create_specialist', methods=['POST'])
def create_specialist():
    try:
        params = request.json
        new_specialist = create_specialist_controller(
            SupportSpecialist, **params)
        session.add(new_specialist)
        session.commit()
        return jsonify({'specialist_id': new_specialist.ss_id})
    except Exception as e:
        return jsonify({'msg': str(e)})


@app.route('/create_ticket_for_support', methods=['POST'])
def create_ticket_for_support():
    try:
        params = request.json
        new_ticket = create_request_for_support_controller(SupportTicket, **params)
        session.add(new_ticket)
        session.commit()
        return jsonify({'ticket_id': new_ticket.st_id})
    except Exception as e:
        return jsonify({'msg': str(e)})


@app.route('/update_ticket_for_support', methods=['PUT'])
def update_ticket_for_support():
    try:
        params = request.json
        result = update_request_for_support_controller(session, SupportTicket, **params)
        return result
    except Exception as e:
        return jsonify({'msg': str(e)})


@app.route('/create_trip', methods=['POST'])
def create_trip():
    try:
        params = request.json
        new_trip = create_trip_controller(Trip, **params)
        session.add(new_trip)
        session.commit()
    except Exception as e:
        return jsonify({'msg': str(e)})


@app.route('/update_trip', methods=['PUT'])
def update_trip():
    try:
        params = request.json
        result = update_trip_controller(session, Trip, **params)
        return result
    except Exception as e:
        return jsonify({'msg': str(e)})


@app.route('/get_all_trips_user/<int:client_id>', methods=['GET'])
def get_all_trips_user(client_id: int):
    try:
        result = get_all_trips_user_controller(session, client_id)
        return result
    except Exception as e:
        return jsonify({'msg': str(e)})

@app.route('/get_all_request_for_specialist/<int:specialist_id>', methods=['GET'])
def get_all_request_for_specialist(specialist_id: int):
    try:
        result = get_all_request_for_specialist_controller(session, specialist_id)
        return result
    except Exception as e:
        return jsonify({'msg': str(e)})


@app.route('/register_driver_and_car', methods=['POST'])
def register_driver_and_car():
    try:
        params = request.json
        new_car = create_driver_and_car_controller(session, Driver, Car, **params)
        print(new_car.car_id)
        return jsonify({'car_id': new_car.car_id})
    except Exception as e:
        print(str(e))
        return jsonify({'msg': str(e)})


@app.route('/create_trip_and_update_tripr', methods=['POST'])
def create_trip_and_update_tripr():
    try:
        params = request.json
        new_trip = update_tripId_on_request_controller(session, Trip, CallRequest, **params)
        return new_trip
    except Exception as e:
        return jsonify({'msg': str(e)})


@app.route('/cancel_trip_request', methods=['POST'])
def cancel_trip_request():
    try:
        params = request.json
        callr_r = cancel_trip_request_controller(session, CallRequest, **params)
        return jsonify({'callr_id': callr_r.callr_id, 'callr_status': callr_r.callr_status})
    except Exception as e:
        return jsonify({'msg': str(e)})


if __name__ == '__main__':
    app.run(host=Config.HOST_URL, port=Config.HOST_PORT)
