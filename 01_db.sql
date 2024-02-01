-- 01_db.sql
CREATE SCHEMA api;

CREATE TABLE api.notes (
  id SERIAL PRIMARY KEY,
  title VARCHAR(255) NOT NULL CHECK(title <> ''),
  content TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO api.notes (title, content) VALUES ('PostgREST', 'Notes from learning PostgREST & HTMX');
