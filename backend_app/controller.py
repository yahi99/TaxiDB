from flask import jsonify
from passlib.hash import sha512_crypt
from datetime import datetime


def hash_password(password):
    return sha512_crypt.hash(password)


def register_user_controller(Client, **kwargs):
    try:
        login = kwargs.get('login')
        client_fio = kwargs.get('name')
        phone = kwargs.get('phone')
        password = kwargs.get('password')
        fio = client_fio.split(' ')
        if len(fio) == 2:
            return Client(client_login=login,
                          client_phone_number=phone,
                          client_password=hash_password(password),
                          client_first_name=fio[1],
                          client_last_name=fio[0])
        elif len(fio) == 3:
            return Client(client_login=login,
                          client_phone_number=phone,
                          client_password=hash_password(password),
                          client_first_name=fio[1],
                          client_last_name=fio[0],
                          client_father_name=fio[2])
    except Exception as e:
        raise Exception(str(e))


def create_request_on_trip_controller(CallRequest, **kwargs):
    try:
        client_id = kwargs.get('client_id')
        callr_status = 1
        callr_date = datetime.now()
        callr_start_pos = kwargs.get('start_pos')
        callr_end_pos = kwargs.get('end_pos')
        callr_pre_distance = kwargs.get('distance')
        callr_pre_price = callr_pre_distance / 500,
        callr_desired_category = kwargs.get('category')
        callr_needd_number_seats = kwargs.get('number_seats')
        return CallRequest(client_id=client_id,
                           callr_status=callr_status,
                           callr_date=callr_date,
                           callr_start_pos=callr_start_pos,
                           callr_end_pos=callr_end_pos,
                           callr_pre_distance=callr_pre_distance,
                           callr_pre_price=callr_pre_price,
                           callr_desired_category=callr_desired_category,
                           callr_needed_number_seats=callr_needd_number_seats)
    except Exception as e:
        raise Exception(str(e))


def update_request_on_trip_controller(session, callRequest, **kwargs):
    try:
        callr_id = kwargs.get('callr_id')
        client_id = kwargs.get('client_id')
        callr_status = 1
        callr_date = datetime.now()
        callr_start_pos = kwargs.get('start_pos')
        callr_end_pos = kwargs.get('end_pos')
        callr_pre_distance = kwargs.get('distance')
        callr_pre_money = kwargs.get('money'),
        callr_desired_category = kwargs.get('category')
        callr_needd_number_seats = kwargs.get('number_seats')
        trip_request = session.query(callRequest).filter(callRequest.callr_id == callr_id).first()
        if not trip_request:
            raise Exception('No trip with that ID')
        for key, value in kwargs.items():
            setattr(trip_request, key, value)
        session.commit()
        return jsonify({'msg': 'Success'})
    except Exception as e:
        raise Exception(e)


def update_tripId_on_request_controller(session, Trip, CallRequest, **kwargs):
    try:
        request_id = kwargs.get('request_id')
        car_id = kwargs.get('car_id')
        new_trip = Trip(car_id = car_id,
                        trip_start_date = datetime.now(),
                        trip_status = 1)
        session.add(new_trip)
        session.commit()
        trip_request = session.query(CallRequest).filter(CallRequest.callr_id == request_id).first()
        trip_request.trip_id = new_trip.trip_id
        session.commit()
        return jsonify({'trip_id': new_trip.trip_id})
    except Exception as e:
        raise e


def create_driver_controller(Driver, **kwargs):
    try:
        login = kwargs.get('login')
        driver_fio = kwargs.get('name')
        phone = kwargs.get('phone')
        password = kwargs.get('password')
        passport = kwargs.get('passport')
        drive_license = kwargs.get('license')
        fio = driver_fio.split(' ')
        if len(fio) == 2:
            return Driver(driver_last_name=fio[0],
                          driver_first_name=fio[1],
                          driver_phone_number=phone,
                          driver_passport=passport,
                          driver_license=drive_license,
                          driver_login=login,
                          driver_password=hash_password(password))
        elif len(fio) == 3:
            return Driver(driver_last_name=fio[0],
                          driver_first_name=fio[1],
                          driver_father_name=fio[2],
                          driver_phone_number=phone,
                          driver_passport=passport,
                          driver_license=drive_license,
                          driver_login=login,
                          driver_password=hash_password(password))
    except Exception as e:
        return jsonify({'msg': str(e)})


def update_driver_controller(session, Driver, **kwargs):
    try:
        driver_id = kwargs.get('driver_id')
        login = kwargs.get('login')
        phone = kwargs.get('phone')
        passport = kwargs.get('passport')
        drive_license = kwargs.get('license')
        finded_driver = session.query(Driver).filter(Driver.driver_id == driver_id).first()
        if not finded_driver:
            return jsonify({'msg': 'No driver with that ID'})
        for key, value in kwargs.items():
            setattr(finded_driver, key, value)
        session.commit()
        return jsonify({'msg': 'Success'})
    except Exception as e:
        raise e


def create_car_controller(Car, **kwargs):
    try:
        driver_id = kwargs.get('driver_id')
        car_gos_number = kwargs.get('car_gos_number')
        car_category = kwargs.get('car_category')
        car_model = kwargs.get('car_model')
        car_number_seats = kwargs.get('car_number_seats')
        car_mark = kwargs.get('car_mark')
        car_color = kwargs.get('car_color')
        return Car(driver_id=driver_id,
                   car_gos_number=car_gos_number,
                   car_category=car_category,
                   car_model=car_model,
                   car_number_seats=car_number_seats,
                   car_mark=car_mark,
                   car_color=car_color)
    except Exception as e:
        raise e


def create_invoice_controller(Invoice, **kwargs):
    try:
        invoice_payment_method = kwargs.get('method')
        invoice_status = kwargs.get('status')
        return Invoice(invoice_payment_method=invoice_payment_method,
                       invoice_status=invoice_status)
    except Exception as e:
        raise e


def create_specialist_controller(SupportSpecialist, **kwargs):
    try:
        login = kwargs.get('login')
        specialist_fio = kwargs.get('name')
        phone = kwargs.get('phone')
        password = kwargs.get('password')
        fio = specialist_fio.split(' ')
        if len(fio) == 2:
            return SupportSpecialist(ss_login=login,
                                     ss_phone_number=phone,
                                     ss_password=hash_password(password),
                                     ss_first_name=fio[1],
                                     ss_last_name=fio[0])
        elif len(fio) == 3:
            return SupportSpecialist(ss_login=login,
                                     ss_phone_number=phone,
                                     ss_password=hash_password(password),
                                     ss_first_name=fio[1],
                                     ss_last_name=fio[0],
                                     ss_father_name=fio[2])
    except Exception as e:
        raise e


def create_request_for_support_controller(SupportTicket, **kwargs):
    try:
        ss_id = kwargs.get('support_id')
        trip_id = kwargs.get('trip_id')
        st_type = 1
        st_status = 0
        st_description = kwargs.get('description')
        st_create_date = datetime.now()
        return SupportTicket(ss_id=ss_id,
                             trip_id=trip_id,
                             st_type=st_type,
                             st_status=st_status,
                             st_description=st_description,
                             st_create_date=st_create_date)
    except Exception as e:
        raise e


def update_request_for_support_controller(session, SupportTicket, **kwargs):
    try:
        st_id = kwargs.get('ticket_id')
        st_status = 1
        support_ticket = session.query(SupportTicket).filter(SupportTicket.st_id == st_id).first()
        if not support_ticket:
            return jsonify({'msg': 'No request with that ID'})
        for key, value in kwargs.items():
            setattr(support_ticket, key, value)
        session.commit()
        return jsonify({'msg': 'Success'})
    except Exception as e:
        raise e


def create_trip_controller(Trip, **kwargs):
    try:
        car_id = kwargs.get('car_id')
        invoice_id = kwargs.get('invoice_id')
        trip_start_date = datetime.now()
        trip_status = 1
        return Trip(car_id=car_id,
                    invoice_id=invoice_id,
                    trip_start_date=trip_start_date,
                    trip_status=trip_status)
    except Exception as e:
        raise e


def update_trip_controller(session, Trip, **kwargs):
    try:
        trip_id = kwargs.get('trip_id')
        trip_distance = kwargs.get('distance')
        trip_end_date = datetime.now()
        trip_price = kwargs.get('price')
        trip_status = kwargs.get('status')
        current_trip = session.query(Trip).filter(Trip.trip_id == trip_id).first()
        if not current_trip:
            return jsonify({'msg': 'No trip with that ID'})
        for key, value in kwargs.items():
            setattr(current_trip, key, value)
        session.commit()
        return jsonify({'msg': 'Success'})
    except Exception as e:
        raise e


def get_all_trips_user_controller(session, client_id):
    try:
        sql = f"select t.trip_id, car_id, invoice_id, trip_distance, trip_start_date, trip_end_date, trip_price, trip_status from trip as t inner join call_request as cr on t.trip_id = cr.trip_id where cr.client_id = {client_id};"
        all_trips = session.execute(sql)
        if all_trips.rowcount > 0:
            data = [{'trip_id': r.trip_id,
                     'car_id': r.car_id,
                     'invoice_id': r.invoice_id,
                     'trip_distance': r.trip_distance,
                     'trip_start_date': r.trip_start_date,
                     'trip_end_date': r.trip_end_date,
                     'trip_price': r.trip_price,
                     'trip_status': r.trip_status} for r in all_trips]
            return jsonify(data)
        else:
            return jsonify({'msg': 'No trips by that user'})
    except Exception as e:
        raise e


def get_all_trips_driver_controller(session, driver_id):
    try:
        sql = f"select t.trip_id, car_id, invoice_id, trip_distance, trip_start_date, trip_end_date, trip_price, trip_status from trip as t inner join call_request as cr on t.trip_id = cr.trip_id where t.car_id = {driver_id};"
        all_trips = session.execute(sql)
        if all_trips.rowcount > 0:
            data = [{'trip_id': r.trip_id,
                     'car_id': r.car_id,
                     'invoice_id': r.invoice_id,
                     'trip_distance': r.trip_distance,
                     'trip_start_date': r.trip_start_date,
                     'trip_end_date': r.trip_end_date,
                     'trip_price': r.trip_price,
                     'trip_status': r.trip_status} for r in all_trips]
            return jsonify(data)
        else:
            return jsonify({'msg': 'No trips by that driver'})
    except Exception as e:
        raise e


def get_all_request_for_specialist_controller(session, specialist_id):
    try:
        sql = f"select st.st_status, st.st_description, st.st_create_date, t.trip_price, cr.callr_pre_price, cr.callr_desired_category, concat(c.client_last_name, ' ', substring(c.client_first_name, 1, 1), '.', substring(c.client_father_name, 1, 1), '.') as client_fio from support_ticket as st inner join trip as t on st.trip_id = t.trip_id inner join call_request as cr on t.trip_id = cr.trip_id inner join client as c on cr.client_id = c.client_id where st.ss_id = {specialist_id};"
        all_request = session.execute(sql)
        if all_request.rowcount > 0:
            data = [{'st_status': r.st_status,
                     'st_description': r.st_description,
                     'st_create_date': r.st_create_date,
                     'trip_price': r.trip_price,
                     'callr_pre_price': r.callr_pre_price,
                     'callr_desired_category': r.callr_desired_category,
                     'client_fio': r.client_fio} for r in all_request]
            return jsonify(data)
        else:
            return jsonify({'msg': 'No trips for that ID'})
    except Exception as e:
        raise e


def create_driver_and_car_controller(session, Driver, Car, **kwargs):
    try:
        login = kwargs.get('login')
        driver_fio = kwargs.get('name')
        phone = kwargs.get('phone')
        password = kwargs.get('password')
        passport = kwargs.get('passport')
        drive_license = kwargs.get('license')
        fio = driver_fio.split(' ')
        if len(fio) == 2:
            new_driver = Driver(driver_last_name=fio[0],
                          driver_first_name=fio[1],
                          driver_phone_number=phone,
                          driver_passport=passport,
                          driver_license=drive_license,
                          driver_login=login,
                          driver_password=hash_password(password))
            session.add(new_driver)
            session.commit()
            driver_id = new_driver.driver_id
            car_gos_number = kwargs.get('car_gos_number')
            car_category = kwargs.get('car_category')
            car_model = kwargs.get('car_model')
            car_number_seats = kwargs.get('car_number_seats')
            car_mark = kwargs.get('car_mark')
            car_color = kwargs.get('car_color')
            new_car = Car(driver_id=driver_id,
                    car_gos_number=car_gos_number,
                    car_category=car_category,
                    car_model=car_model,
                    car_number_seats=car_number_seats,
                    car_mark=car_mark,
                    car_color=car_color)
            session.add(new_car)
            session.commit()
            return new_car
        elif len(fio) == 3:
            new_driver = Driver(driver_last_name=fio[0],
                          driver_first_name=fio[1],
                          driver_father_name=fio[2],
                          driver_phone_number=phone,
                          driver_passport=passport,
                          driver_license=drive_license,
                          driver_login=login,
                          driver_password=hash_password(password))
            session.add(new_driver)
            session.commit()
            driver_id = new_driver.driver_id
            car_gos_number = kwargs.get('car_gos_number')
            car_category = kwargs.get('car_category')
            car_model = kwargs.get('car_model')
            car_number_seats = kwargs.get('car_number_seats')
            car_mark = kwargs.get('car_mark')
            car_color = kwargs.get('car_color')
            new_car = Car(driver_id=driver_id,
                    car_gos_number=car_gos_number,
                    car_category=car_category,
                    car_model=car_model,
                    car_number_seats=car_number_seats,
                    car_mark=car_mark,
                    car_color=car_color)
            session.add(new_car)
            session.commit()
            return new_car
    except Exception as e:
        raise e


def cancel_trip_request_controller(session, CallRequest, **kwargs):
    try:
        callr_id = kwargs.get('callr_id')
        callr_r = session.query(CallRequest).filter(CallRequest.callr_id == callr_id).first()
        callr_r.callr_status = 0
        session.commit()
        return callr_r
    except Exception as e:
        raise e