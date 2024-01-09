-- SELECT 'CREATE DATABASE nyc_datamart'
-- WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'nyc_datamart')\gexec

CREATE SCHEMA IF NOT EXISTS nyc_datamart;

/*----------TIME----------*/
CREATE TABLE IF NOT EXISTS nyc_datamart.year (
    yearid INT NOT NULL PRIMARY KEY
);

CREATE TABLE IF NOT EXISTS nyc_datamart.month (
    monthid INT NOT NULL PRIMARY KEY,
    month VARCHAR(15) DEFAULT NULL
);

CREATE TABLE IF NOT EXISTS nyc_datamart.day (
    dayid INT NOT NULL PRIMARY KEY
);

CREATE TABLE IF NOT EXISTS nyc_datamart.time (
    timeid SERIAL PRIMARY KEY,
    tpep_pickup_datetime TIMESTAMP NOT NULL,
    tpep_dropoff_datetime TIMESTAMP,
    yearid INT NOT NULL REFERENCES nyc_datamart.year (yearid),
    monthid INT NOT NULL REFERENCES nyc_datamart.month (monthid),
    dayid INT NOT NULL REFERENCES nyc_datamart.day (dayid)
);
/*----------TIME----------*/


/*----------LOCATION----------*/
CREATE TABLE IF NOT EXISTS nyc_datamart.flag (
    flagid SERIAL PRIMARY KEY,
    store_and_fwd_flag TEXT
);

CREATE TABLE IF NOT EXISTS nyc_datamart.location (
    pulocationid INT NOT NULL PRIMARY KEY,
    dolocationid INT NOT NULL,
    flagid INT REFERENCES nyc_datamart.flag (flagid)
);
/*----------LOCATION----------*/

/*----------PAYMENT----------*/
CREATE TABLE IF NOT EXISTS nyc_datamart.amount (
    amountid SERIAL PRIMARY KEY,
    fare_amount FLOAT,
    tip_amount FLOAT,
    tolls_amount FLOAT,
    total_amount FLOAT
);

CREATE TABLE IF NOT EXISTS nyc_datamart.tax (
    taxid INT NOT NULL PRIMARY KEY,
    mta_tax FLOAT,
    improvement_surcharge FLOAT,
    congestion_surcharge FLOAT,
    airport_fee FLOAT
);

CREATE TABLE IF NOT EXISTS nyc_datamart.payment (
    paymentid SERIAL PRIMARY KEY,
    taxid INT REFERENCES nyc_datamart.tax (taxid),
    amountid INT REFERENCES nyc_datamart.amount (amountid),
    payment_type INT,
    extra FLOAT
);
/*----------PAYMENT----------*/

CREATE TABLE IF NOT EXISTS nyc_datamart.course (
    vendorid INT NOT NULL PRIMARY KEY,
    pulocationid INT REFERENCES nyc_datamart.location (pulocationid),
    dolocationid INT,
    timeid INT  REFERENCES nyc_datamart.time (timeid),
    ratecodeid INT,
    paymentid INT REFERENCES nyc_datamart.payment (paymentid),
    trip_distance FLOAT,
    passenger_count INT
);

