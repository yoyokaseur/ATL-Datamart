CREATE TABLE IF NOT EXISTS course (
    vendorid INT NOT NULL PRIMARY KEY,
    pulocationid INT REFERENCES location (pulocationid),
    dolocationid INT REFERENCES location (dolocationid),
    timeid INT NOT NULL REFERENCES time (timeid),
    reatecodeid INT,
    paymentid INT REFERENCES payment (paymentid),
    trip_distance FLOAT,
    passager_count INT
    -- ADD CONSTRAINT fk_course_location
    --     FOREIGN KEY(pulocationid)
    --     REFERENCES location(pulocationid),
    -- ADD CONSTRAINT fk_course_location2
    --     FOREIGN KEY(dolocationid)
    --     REFERENCES location(dolocationid),
    -- ADD CONSTRAINT fk_course_time
    --     FOREIGN KEY(timeid)
    --     REFERENCES time(timeid),
    -- ADD CONSTRAINT fk_course_payment
    --     FOREIGN KEY(paymentid)
    --     REFERENCES payment(paymentid),
);

/*----------TIME----------*/
CREATE TABLE IF NOT EXISTS time (
    timeid INT NOT NULL PRIMARY KEY,
    tpep_pickup_datetime TIMESTAMP NOT NULL,
    tpep_dropoff_datetime TIMESTAMP,
    yearid INT NOT NULL REFERENCES year (yearid),
    monthid INT NOT NULL REFERENCES month (monthid),
    dayid INT NOT NULL REFERENCES day (dayid)
    -- ADD CONSTRAINT fk_time_year
    --     FOREIGN KEY(yearid)
    --     REFERENCES year(yearid),
    -- ADD CONSTRAINT fk_time_month
    --     FOREIGN KEY(monthid)
    --     REFERENCES month(monthid),
    -- ADD CONSTRAINT fk_time_day
    --     FOREIGN KEY(dayid)
    --     REFERENCES day(dayid),
);

CREATE TABLE IF NOT EXISTS year (
    yearid INT NOT NULL PRIMARY KEY
);

CREATE TABLE IF NOT EXISTS month (
    monthid INT NOT NULL PRIMARY KEY,
    month VARCHAR(15) DEFAULT NULL
);

CREATE TABLE IF NOT EXISTS day (
    dayid INT NOT NULL PRIMARY KEY
);
/*----------TIME----------*/


/*----------LOCATION----------*/
CREATE TABLE IF NOT EXISTS location (
    pulocationid INT NOT NULL PRIMARY KEY,
    dolocationid INT NOT NULL,
    flagid INT REFERENCES flag (flagid)
    -- ADD CONSTRAINT fk_location_flag
        -- FOREIGN KEY(flagid)
        -- REFERENCES flag(flagid),
);

CREATE TABLE IF NOT EXISTS flag (
    flagid INT NOT NULL PRIMARY KEY,
    store_and_fwd_flag TEXT
);
/*----------LOCATION----------*/

/*----------PAYMENT----------*/
CREATE TABLE IF NOT EXISTS payment (
    paymentid INT NOT NULL PRIMARY KEY,
    taxid INT REFERENCES tax (taxid),
    amountid INT REFERENCES amount (amountid),
    payment_type INT,
    extra FLOAT
    -- ADD CONSTRAINT fk_payment_tax
        -- FOREIGN KEY(taxid)
        -- REFERENCES tax(taxid),
    -- ADD CONSTRAINT fk_payment_amount
        -- FOREIGN KEY(amountid)
        -- REFERENCES amount(amountid),
);

CREATE TABLE IF NOT EXISTS amount (
    amountid INT NOT NULL PRIMARY KEY,
    fare_amount FLOAT,
    tip_amount FLOAT,
    tolls_amount FLOAT,
    total_amount FLOAT
);

CREATE TABLE IF NOT EXISTS tax (
    taxid INT NOT NULL PRIMARY KEY,
    mta_tax FLOAT,
    improvement_surcharge FLOAT,
    congestion_surcharge FLOAT,
    airport_fee FLOAT
);
/*----------PAYMENT----------*/
