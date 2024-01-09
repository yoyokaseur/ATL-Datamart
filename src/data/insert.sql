INSERT INTO nyc_datamart.year(yearid)
SELECT generate_series(2000, 2024)::int;

INSERT INTO nyc_datamart.month(monthid,month)
VALUES
    (1,'Janauary'),
    (2,'February'),
    (3,'March'),
    (4, 'April'),
    (5, 'May'),
    (6, 'June'),
    (7, 'July'),
    (8, 'August'),
    (9, 'September'),
    (10, 'October'),
    (11, 'November'),
    (12, 'December');

INSERT INTO nyc_datamart.day(dayid)
SELECT generate_series(1, 32)::int;

INSERT INTO nyc_datamart.time(tpep_pickup_datetime,tpep_dropoff_datetime, yearid, monthid, dayid)
SELECT
    tpep_pickup_datetime,
    tpep_dropoff_datetime,
    EXTRACT(YEAR FROM tpep_pickup_datetime) AS yearid,
    EXTRACT(MONTH FROM tpep_pickup_datetime) AS monthid,
    EXTRACT(DAY FROM tpep_pickup_datetime) AS dayid
FROM nyc_raw LIMIT 5000000;

INSERT INTO nyc_datamart.flag(store_and_fwd_flag)
SELECT store_and_fwd_flag
FROM nyc_raw LIMIT 5000000;

INSERT INTO nyc_datamart.amount(fare_amount,tip_amount,tolls_amount,total_amount)
SELECT fare_amount,tip_amount,tolls_amount,total_amount
FROM nyc_raw LIMIT 5000000;

INSERT INTO nyc_datamart.tax(mta_tax,improvement_surcharge,congestion_surcharge,airport_fee)
SELECT mta_tax, improvement_surcharge, congestion_surcharge, airport_fee
FROM nyc_raw LIMIT 5000000;

INSERT INTO nyc_datamart.location(pulocationid,dolocationid, flagid)
SELECT DISTINCT pulocationid, dolocationid, flagid
FROM nyc_raw AS nraw
INNER JOIN nyc_datamart.flag using (store_and_fwd_flag) LIMIT 5000000;

-- INSERT INTO nyc_datamart.payment
INSERT INTO nyc_datamart.payment (payment_type, extra, amountid, taxid)
SELECT nraw.payment_type, nraw.extra, am.amountid, t.taxid
FROM nyc_raw AS nraw
INNER JOIN nyc_datamart.amount AS am ON (nraw.fare_amount = am.fare_amount AND nraw.tip_amount = am.tip_amount AND nraw.tolls_amount = am.tolls_amount AND nraw.total_amount = am.total_amount)
INNER JOIN nyc_datamart.tax AS t ON (nraw.mta_tax = t.mta_tax AND nraw.improvement_surcharge = t.improvement_surcharge AND nraw.congestion_surcharge = t.congestion_surcharge AND nraw.airport_fee = t.airport_fee)
LIMIT 5000000;

INSERT INTO nyc_datamart.course(timeid, vendorid,ratecodeid,trip_distance,passenger_count)
SELECT  t.timeid, nraw.vendorid,nraw.ratecodeid,nraw.trip_distance,nraw.passenger_count
FROM nyc_raw AS nraw
INNER JOIN nyc_datamart.time AS t ON (t.tpep_pickup_datetime = nraw.tpep_pickup_datetime AND t.tpep_dropoff_datetime = nraw.tpep_dropoff_datetime)
LIMIT 5000000;