DROP DATABASE IF EXISTS ultimate_adventure;
CREATE DATABASE ultimate_adventure;

\c ultimate_adventure;

CREATE TABLE users(
	id SERIAL PRIMARY KEY,
	username VARCHAR(128) NOT NULL Unique,
	password_digest VARCHAR(256) NOT NULL,
	image VARCHAR(1024)
);

CREATE TABLE trips(
	id SERIAL PRIMARY KEY,
	name VARCHAR(128) NOT NULL,
	user_id INTEGER REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE stops(
	id SERIAL PRIMARY KEY,
	name VARCHAR(256),
	address VARCHAR(512),
	lat_long VARCHAR(256)
);

CREATE TABLE bookings(
	id SERIAL PRIMARY KEY,
	trip_id INTEGER REFERENCES trips(id) ON DELETE CASCADE,
	stop_id INTEGER REFERENCES stops(id) ON DELETE CASCADE,
	user_id INTEGER REFERENCES users(id) ON DELETE CASCADE
);





