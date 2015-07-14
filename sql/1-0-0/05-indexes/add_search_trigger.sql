DROP TRIGGER IF EXISTS users_search_vector_refresh on membership.users;
CREATE TRIGGER users_search_vector_refresh
BEFORE INSERT OR UPDATE ON membership.users
FOR EACH ROW EXECUTE PROCEDURE
tsvector_update_trigger(search, 'pg_catalog.english',  email, first, last);
