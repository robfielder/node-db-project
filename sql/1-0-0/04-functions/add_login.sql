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