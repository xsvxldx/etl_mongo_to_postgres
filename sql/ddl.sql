CREATE DATABASE masbien;

CREATE SCHEMA stations;


GRANT USAGE ON SCHEMA stations TO etl_user;
GRANT INSERT ON ALL TABLES IN SCHEMA stations TO etl_user;



-- metadatas
CREATE TABLE stations.metadatas (
    "_id" VARCHAR(24) PRIMARY KEY,
    "composedIdHashed" VARCHAR(56),
    "project" VARCHAR(24),
    "client" VARCHAR(32),
    "station" VARCHAR(24),
    "device" VARCHAR(24),
    "wifi" NUMERIC(9, 6),
    "voltBateria" NUMERIC(9, 6),
    "voltPanel" NUMERIC(9, 6),
    "projectRef" VARCHAR(24),
    "timestamp_arduino" TIMESTAMP WITHOUT TIMEZONE,
    "timestamp_server" TIMESTAMP WITHOUT TIMEZONE,
    "epoch_arduino" BIGINT,
    "is_valid" BOOLEAN
);


-- Create a hash index on composedIdHashed column
CREATE INDEX idx_metadata_composedId ON stations.metadatas USING hash ("composedIdHashed");

-- Create a B-tree index on timestamp_arduino column
CREATE INDEX idx_metadata_timestamp ON stations.metadatas USING btree ("timestamp_arduino");






-- humidities
CREATE TABLE stations.humidities (
    "_id" VARCHAR(24) PRIMARY KEY,
    "composedIdHashed" VARCHAR(56),
    "project" VARCHAR(24),
    "client" VARCHAR(32),
    "station" VARCHAR(24),
    "device" VARCHAR(24),
    "humidity" NUMERIC(8, 3),
    "projectRef" VARCHAR(24),
    "timestamp_arduino" TIMESTAMP,
    "timestamp_server" TIMESTAMP
);

-- Create a hash index on composedIdHashed column
CREATE INDEX idx_hum_composedId ON stations.humidities USING hash ("composedIdHashed");

-- Create a B-tree index on timestamp_arduino column
CREATE INDEX idx_hum_timestamp ON stations.humidities USING btree ("timestamp_arduino");



-- humidities
CREATE TABLE stations.temperatures (
    "_id" VARCHAR(24) PRIMARY KEY,
    "composedIdHashed" VARCHAR(56),
    "project" VARCHAR(24),
    "client" VARCHAR(32),
    "station" VARCHAR(24),
    "device" VARCHAR(24),
    "temperature" NUMERIC(8, 3),
    "projectRef" VARCHAR(24),
    "timestamp_arduino" TIMESTAMP,
    "timestamp_server" TIMESTAMP
);

-- Indexes
CREATE INDEX timestamp_idx ON stations.metadatas USING BTREE (timestamp_arduino);
CREATE INDEX epoch_idx ON stations.metadatas USING BTREE (epoch_arduino);

-- ETL user
CREATE USER etl_user WITH PASSWORD 'fake_password';
GRANT USAGE ON SCHEMA stations TO etl_user;

GRANT SELECT ON TABLE stations.metadatas TO etl_user;
GRANT INSERT ON TABLE stations.metadatas TO etl_user;

GRANT USAGE ON ALL SEQUENCES IN SCHEMA stations TO etl_user;
GRANT SELECT ON TABLE metadata.etl_log TO etl_user;
GRANT INSERT ON TABLE metadata.etl_log TO etl_user;



-- ETL Log table definition





-- atm pressures
CREATE TABLE stations.atmpressures (
    "_id" VARCHAR(24) PRIMARY KEY,
    "composedIdHashed" VARCHAR(56),
    "project" VARCHAR(24),
    "client" VARCHAR(32),
    "station" VARCHAR(24),
    "device" VARCHAR(24),
    "atmPressure" NUMERIC(8, 3),
    "projectRef" VARCHAR(24),
    "timestamp_arduino" TIMESTAMP,
    "timestamp_server" TIMESTAMP
);

-- Create a hash index on composedIdHashed column
CREATE INDEX idx_atm_composedId ON stations.atmpressures USING hash ("composedIdHashed");

-- Create a B-tree index on timestamp_arduino column
CREATE INDEX idx_atm_timestamp ON stations.atmpressures USING btree ("timestamp_arduino");



-- ground hum 1
CREATE TABLE stations.groundhumidity1 (
    "_id" VARCHAR(24) PRIMARY KEY,
    "composedIdHashed" VARCHAR(56),
    "project" VARCHAR(24),
    "client" VARCHAR(32),
    "station" VARCHAR(24),
    "device" VARCHAR(24),
    "groundHumidity1" NUMERIC(8, 3),
    "projectRef" VARCHAR(24),
    "timestamp_arduino" TIMESTAMP,
    "timestamp_server" TIMESTAMP
);

-- Create a hash index on composedIdHashed column
CREATE INDEX idx_ghum1_composedId ON stations.groundhumidity1 USING hash ("composedIdHashed");

-- Create a B-tree index on timestamp_arduino column
CREATE INDEX idx_ghum1_timestamp ON stations.groundhumidity1 USING btree ("timestamp_arduino");


-- ground hum 2
CREATE TABLE stations.groundhumidity2 (
    "_id" VARCHAR(24) PRIMARY KEY,
    "composedIdHashed" VARCHAR(56),
    "project" VARCHAR(24),
    "client" VARCHAR(32),
    "station" VARCHAR(24),
    "device" VARCHAR(24),
    "groundHumidity2" NUMERIC(8, 3),
    "projectRef" VARCHAR(24),
    "timestamp_arduino" TIMESTAMP,
    "timestamp_server" TIMESTAMP
);

-- Create a hash index on composedIdHashed column
CREATE INDEX idx_ghum2_composedId ON stations.groundhumidity2 USING hash ("composedIdHashed");

-- Create a B-tree index on timestamp_arduino column
CREATE INDEX idx_ghum2_timestamp ON stations.groundhumidity2 USING btree ("timestamp_arduino");


-- ground temp
CREATE TABLE stations.groundtemperatures (
    "_id" VARCHAR(24) PRIMARY KEY,
    "composedIdHashed" VARCHAR(56),
    "project" VARCHAR(24),
    "client" VARCHAR(32),
    "station" VARCHAR(24),
    "device" VARCHAR(24),
    "groundTemperature" NUMERIC(8, 3),
    "projectRef" VARCHAR(24),
    "timestamp_arduino" TIMESTAMP,
    "timestamp_server" TIMESTAMP
);

-- Create a hash index on composedIdHashed column
CREATE INDEX idx_gtemp_composedId ON stations.groundtemperatures USING hash ("composedIdHashed");

-- Create a B-tree index on timestamp_arduino column
CREATE INDEX idx_gtemp_timestamp ON stations.groundtemperatures USING btree ("timestamp_arduino");








CREATE TABLE stations.temperatures
(
	_id VARCHAR(24) PRIMARY KEY,
	"composedIdHashed" VARCHAR(48),
	project VARCHAR(16),
	client VARCHAR(24),
	station VARCHAR(14),
	device VARCHAR(14),
	temperature REAL,
	"projectRef" VARCHAR(24),
	timestamp_arduino TIMESTAMP,
	timestamp_server TIMESTAMP,
	is_valid BOOL	
);


CREATE TABLE stations.metadatas
(
	_id VARCHAR(24) PRIMARY KEY,
	"composedIdHashed" VARCHAR(48),
	project VARCHAR(16),
	client VARCHAR(24),
	station VARCHAR(14),
	device VARCHAR(14),
	wifi SMALLINT,
	"voltBateria" REAL,
	"voltPanel" REAL,
	"projectRef" VARCHAR(24),
	timestamp_arduino TIMESTAMP,
	timestamp_server TIMESTAMP,
    epoch_arduino BIGINT,
	is_valid BOOL	
)
;

CREATE INDEX timestamp_idx ON stations.metadatas USING BTREE (timestamp_arduino);
CREATE INDEX epoch_idx ON stations.metadatas USING BTREE (epoch_arduino);


CREATE TABLE metadata.etl_log (
	id SERIAL PRIMARY KEY,
    "timestamp" TIMESTAMP,
    "table" VARCHAR(32),
    "rows" INTEGER,
    "status" VARCHAR(32),
    "message" VARCHAR(256)
)

CREATE INDEX idx_etl_log_timestamp ON metadata.etl_log USING BTREE ("timestamp")