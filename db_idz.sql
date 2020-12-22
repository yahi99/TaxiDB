create table call_request (
   callr_id             SERIAL not null,
   client_id            INT4                 not null,
   operator_id          INT4                 null,
   trip_id              INT4                 null,
   callr_status         INT4                 not null,
   callr_date           TIMESTAMP            not null,
   callr_start_pos      VARCHAR(150)         not null,
   callr_end_pos        VARCHAR(150)         not null,
   callr_pre_distance   FLOAT4               not null,
   callr_pre_price      MONEY                not null,
   callr_desired_category VARCHAR(50)          not null,
   callr_needed_number_seats INT4                 not null,
   constraint PK_CALL_REQUEST primary key (callr_id)
);

create unique index call_request_PK on call_request (
callr_id
);

create  index create_request_FK on call_request (
client_id
);

create  index create_FK on call_request (
operator_id
);

create  index becomes_FK on call_request (
trip_id
);

create table car (
   car_id               SERIAL not null,
   driver_id            INT4                 not null,
   car_gos_number       VARCHAR(9)           not null,
   car_category         VARCHAR(50)          not null,
   car_model            VARCHAR(64)          not null,
   car_number_seats     INT4                 not null,
   car_mark             VARCHAR(64)          not null,
   car_color            VARCHAR(32)          not null,
   constraint PK_CAR primary key (car_id)
);

create unique index car_PK on car (
car_id
);

create  index have_FK on car (
driver_id
);

create table client (
   client_id            SERIAL not null,
   client_last_name     VARCHAR(64)          not null,
   client_first_name    VARCHAR(64)          not null,
   client_father_name   VARCHAR(64)          null,
   client_phone_number  VARCHAR(12)          not null,
   client_login         VARCHAR(50)          null,
   client_password      VARCHAR(128)         null,
   constraint PK_CLIENT primary key (client_id)
);

create unique index client_PK on client (
client_id
);

create table driver (
   driver_id            SERIAL not null,
   driver_last_name     VARCHAR(64)          not null,
   driver_first_name    VARCHAR(64)          not null,
   driver_father_name   VARCHAR(64)          null,
   driver_phone_number  VARCHAR(12)          not null,
   driver_passport      CHAR(10)             not null,
   driver_license       CHAR(10)             not null,
   driver_login         VARCHAR(50)          not null,
   driver_password      VARCHAR(128)         not null,
   constraint PK_DRIVER primary key (driver_id)
);

create unique index driver_PK on driver (
driver_id
);

create table invoice (
   invoice_id           SERIAL not null,
   invoice_payment_method VARCHAR(50)          not null,
   invoice_status       INT4                 not null,
   constraint PK_INVOICE primary key (invoice_id)
);

create unique index invoice_PK on invoice (
invoice_id
);

create table operator (
   operator_id          SERIAL not null,
   operator_last_name   VARCHAR(64)          not null,
   operator_first_name  VARCHAR(64)          not null,
   operator_father_name VARCHAR(64)          null,
   operator_phone_number VARCHAR(12)          not null,
   operator_login       VARCHAR(50)          not null,
   operator_password    VARCHAR(128)         not null,
   constraint PK_OPERATOR primary key (operator_id)
);

create unique index operator_PK on operator (
operator_id
);

create table support_specialist (
   ss_id                SERIAL not null,
   ss_last_name         VARCHAR(64)          not null,
   ss_first_name        VARCHAR(64)          not null,
   ss_father_name       VARCHAR(64)          null,
   ss_phone_number      VARCHAR(12)          not null,
   ss_login             VARCHAR(20)          not null,
   ss_password          VARCHAR(128)         not null,
   constraint PK_SUPPORT_SPECIALIST primary key (ss_id)
);

create unique index support_specialist_PK on support_specialist (
ss_id
);

create table support_ticket (
   st_id                SERIAL not null,
   ss_id                INT4                 not null,
   trip_id              INT4                 not null,
   st_type              INT4                 not null,
   st_status            BOOL                 not null,
   st_description       VARCHAR(500)         not null,
   st_create_date       DATE                 not null,
   constraint PK_SUPPORT_TICKET primary key (st_id)
);

create unique index support_ticket_PK on support_ticket (
st_id
);

create  index processes_FK on support_ticket (
ss_id
);

create  index refers_to_FK on support_ticket (
trip_id
);

create table trip (
   trip_id              SERIAL not null,
   car_id               INT4                 not null,
   invoice_id           INT4                 null,
   trip_distance        FLOAT4               null,
   trip_start_date      TIMESTAMP            not null,
   trip_end_date        TIMESTAMP            null,
   trip_price           MONEY                null,
   trip_status          INT4                 not null,
   constraint PK_TRIP primary key (trip_id)
);

create unique index trip_PK on trip (
trip_id
);

create  index participates_FK on trip (
car_id
);

create  index exhibited_FK on trip (
invoice_id
);

create or replace view driver_information as
SELECT driver.driver_last_name, driver.driver_first_name, driver.driver_father_name, car.car_gos_number,
COUNT(trip_id) AS count_trips, SUM(trip_price) AS proceeds_for_driver
FROM car
INNER JOIN driver ON car.driver_id = driver.driver_id
INNER JOIN trip ON trip.car_id = car.car_id
WHERE (extract(month from trip_start_date) = extract(month from NOW()))
GROUP BY driver_last_name, driver_first_name, driver_father_name, car_gos_number;

create or replace view most_common_characteristics as
SELECT AVG(cr.callr_needed_number_seats) AS avg_needed_number_seats,
(SELECT COUNT(car_category) AS popular_category
FROM car GROUP BY car_category
ORDER BY popular_category DESC) AS popular_category,
AVG(trip.trip_distance) AS avg_distance,
AVG(trip_price::numeric) AS avg_price
FROM trip
INNER JOIN car ON trip.car_id = car.car_id
INNER JOIN call_request AS cr ON cr.trip_id = trip.trip_id
WHERE (extract(month from trip_start_date) = extract(month from NOW()))
limit 1;

create or replace view request_processed_by_operator as
SELECT o.operator_last_name, o.operator_first_name, o.operator_father_name,
COUNT(o.operator_id) AS request_count, SUM(cr.callr_pre_price) AS proceeds_for_operator
FROM operator AS o INNER JOIN call_request AS cr
ON o.operator_id = cr.operator_id
WHERE (extract(month from cr.callr_date) = extract(month from NOW()))
GROUP BY o.operator_last_name, operator_first_name, o.operator_father_name;

create or replace view request_processed_by_specialist as
SELECT ss.ss_last_name, ss.ss_first_name, ss.ss_father_name,
COUNT(ss.ss_id) AS completed_ticket
FROM support_specialist AS ss
INNER JOIN support_ticket AS st
ON ss.ss_id = st.ss_id
WHERE (extract(month from st.st_create_date) = extract(month from NOW()) and st.st_status = true)
GROUP BY ss.ss_last_name, ss.ss_first_name, ss.ss_father_name;

