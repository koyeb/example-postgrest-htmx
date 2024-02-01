-- 02_role.sql
CREATE ROLE auth_user NOINHERIT LOGIN PASSWORD 'auth_user_password';
GRANT USAGE ON SCHEMA api TO auth_user;
GRANT ALL ON api.notes TO auth_user;
GRANT USAGE, SELECT ON SEQUENCE api.notes_id_seq TO auth_user;
