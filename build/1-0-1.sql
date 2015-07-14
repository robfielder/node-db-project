set search_path=membership;
drop function if exists add_login(varchar,varchar,varchar,varchar);
create function add_login(
    em varchar(255),
    key varchar(50),
    token varchar(255),
    new_provider varchar(50)
)
returns TABLE(
  message varchar(255),
  success boolean
) as
$$
DECLARE
  success boolean :=false;
  message varchar(255) := 'User not found with this email';
  found_id bigint;
  data_result json;
BEGIN
  set search_path = membership;
  select id into found_id from users where email = em;

  if found_id is not null then
    --replace the provider for this user completely
    delete from logins where 
      found_id = logins.user_id AND 
      logins.provider = new_provider;

    --add the login
    insert into logins(user_id,provider_key, provider_token, provider)
    values (found_id, key,token,new_provider);

    --add log entry
    insert into logs(subject,entry,user_id, created_at)
    values('Authentication','Added ' || new_provider || ' login',found_id,now());

    success := true;
    message :=  'Added login successfully';
  end if;

  return query
  select message, success;

END;
$$
language plpgsql;
DROP TRIGGER IF EXISTS users_search_vector_refresh on membership.users;
CREATE TRIGGER users_search_vector_refresh
BEFORE INSERT OR UPDATE ON membership.users
FOR EACH ROW EXECUTE PROCEDURE
tsvector_update_trigger(search, 'pg_catalog.english',  email, first, last);

drop function if exists validate_email(varchar);
create function validate_email(token varchar)
returns user_summary
as $$
declare
  found_id bigint;
  em varchar(255);
begin
  set search_path = membership;
  -- find the user
  select id from users into found_id where validation_token=token;
  
  if found_id is not null then 
    -- get the email
    select email from users where id=found_id into em;

    -- set status to active
    perform activate_user(em, 'Email validated');

    -- add a note
    insert into notes(user_id, note)
    values (found_id, 'Your email was validated');
  end if;

  --return the summary, which will have logs etc
  return get_user(em);
end;
$$ language plpgsql;