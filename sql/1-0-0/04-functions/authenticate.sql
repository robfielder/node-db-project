create or replace function authenticate(key varchar, token varchar, prov varchar default 'local')
returns table(
  return_id bigint,
  email varchar(255),
  display_name varchar(50),
  success boolean,
  message varchar(50)
) as $$
DECLARE
  found_user membership.users;
  return_message varchar(50);
  success boolean := false;
  found_id bigint;
  can_login boolean := false;
BEGIN
  set search_path=membership;
  --find the user by token/provider and key
  if(prov = 'local') then
    select locate_user_by_password(key, token) into found_id;
  else
    select user_id from logins where
    provider = prov and
    provider_key = key and
    provider_token = token into found_id;
  end if;

  if(found_id is not null) then
    select * from users where users.id = found_id into found_user;

    select status.can_login from status where id=found_user.status_id
    into can_login;

    if(can_login) then
      --add a log entry
      insert into logs(user_id, subject, entry)
      values(found_id, 'Authentication', 'Logged user in using ' || prov);

      --set a last_login
      update users set last_login=now(), login_count=login_count+1
      where users.id=found_id;

      --set the display_name
      display_name := display_name(found_user);

      success := true;
      return_message := 'Welcome!';
    else
      --log failed attempt
      insert into logs(user_id, subject, entry)
      values(found_id, 'Authentication', 'User tried to login, is locked out');

      success := false;
      return_message := 'This user is currently locked out';
    end if;
  else
    return_message := 'Invalid login credentials';
  end if;
  return query
  select found_id, found_user.email, display_name, success, return_message;
END;
$$
language plpgsql;

create or replace function authenticate_by_token(token varchar)
returns table(
  return_id bigint,
  email varchar(255),
  display_name varchar(50),
  success boolean,
  message varchar(50)
) as $$
begin
  return query
  select * from authenticate('token',token,'token');
end;
$$
language plpgsql;
