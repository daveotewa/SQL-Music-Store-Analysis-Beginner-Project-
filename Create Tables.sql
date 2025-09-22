-- Drop in dependency order (safe to run multiple times)
DROP TABLE IF EXISTS playlist_track, invoice_line, invoice, customer, employee,
                        track, playlist, album, artist, genre, media_type CASCADE;

-- Core reference tables
CREATE TABLE artist (
  artistid     INTEGER PRIMARY KEY,
  name         TEXT
);

CREATE TABLE album (
  albumid      INTEGER PRIMARY KEY,
  title        TEXT NOT NULL,
  artistid     INTEGER NOT NULL REFERENCES artist(artistid)
);

CREATE TABLE media_type (
  mediatypeid  INTEGER PRIMARY KEY,
  name         TEXT
);

CREATE TABLE genre (
  genreid      INTEGER PRIMARY KEY,
  name         TEXT
);

-- Catalog
CREATE TABLE track (
  trackid      INTEGER PRIMARY KEY,
  name         TEXT NOT NULL,
  albumid      INTEGER REFERENCES album(albumid),
  mediatypeid  INTEGER NOT NULL REFERENCES media_type(mediatypeid),
  genreid      INTEGER REFERENCES genre(genreid),
  composer     TEXT,
  milliseconds INTEGER NOT NULL,
  bytes        INTEGER,
  unitprice    NUMERIC(10,2) NOT NULL
);

-- Playlists
CREATE TABLE playlist (
  playlistid   INTEGER PRIMARY KEY,
  name         TEXT
);

CREATE TABLE playlist_track (
  playlistid   INTEGER NOT NULL REFERENCES playlist(playlistid),
  trackid      INTEGER NOT NULL REFERENCES track(trackid),
  PRIMARY KEY (playlistid, trackid)
);

-- People (employees & customers)
CREATE TABLE employee (
  employeeid   INTEGER PRIMARY KEY,
  lastname     TEXT,
  firstname    TEXT,
  title        TEXT,
  reportsto    INTEGER REFERENCES employee(employeeid),
  birthdate    TIMESTAMP,
  hiredate     TIMESTAMP,
  address      TEXT,
  city         TEXT,
  state        TEXT,
  country      TEXT,
  postalcode   TEXT,
  phone        TEXT,
  fax          TEXT,
  email        TEXT
);

CREATE TABLE customer (
  customerid    INTEGER PRIMARY KEY,
  firstname     TEXT,
  lastname      TEXT,
  company       TEXT,
  address       TEXT,
  city          TEXT,
  state         TEXT,
  country       TEXT,
  postalcode    TEXT,
  phone         TEXT,
  fax           TEXT,
  email         TEXT,
  supportrepid  INTEGER REFERENCES employee(employeeid)
);

-- Orders
CREATE TABLE invoice (
  invoiceid            INTEGER PRIMARY KEY,
  customerid           INTEGER NOT NULL REFERENCES customer(customerid),
  invoicedate          TIMESTAMP NOT NULL,
  billingaddress       TEXT,
  billingcity          TEXT,
  billingstate         TEXT,
  billingcountry       TEXT,
  billingpostalcode    TEXT,
  total                NUMERIC(10,2) NOT NULL
);

CREATE TABLE invoice_line (
  invoicelineid  INTEGER PRIMARY KEY,
  invoiceid      INTEGER NOT NULL REFERENCES invoice(invoiceid),
  trackid        INTEGER NOT NULL REFERENCES track(trackid),
  unitprice      NUMERIC(10,2) NOT NULL,
  quantity       INTEGER NOT NULL
);

-- Helpful indexes (optional but nice for querying)
CREATE INDEX IF NOT EXISTS idx_album_artist   ON album(artistid);
CREATE INDEX IF NOT EXISTS idx_track_album    ON track(albumid);
CREATE INDEX IF NOT EXISTS idx_track_genre    ON track(genreid);
CREATE INDEX IF NOT EXISTS idx_invoice_cust   ON invoice(customerid);
CREATE INDEX IF NOT EXISTS idx_line_invoice   ON invoice_line(invoiceid);
CREATE INDEX IF NOT EXISTS idx_line_track     ON invoice_line(trackid);
