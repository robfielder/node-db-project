create or replace function get_user(em varchar)
returns user_summary
as $$
declare 
  dname varchar(255);
  found_user users;
  member_for interval;
  can_login boolean;
  is_admin boolean;
  return_status varchar(25);
  json_logs jsonb;
  json_notes jsonb;
  user_status status;
begin
  set search_path=membership;
  --are they in the DB?
  if exists (select users.id from users where users.email = em) then
    select * from users into found_user where users.email = em;

    --display name
    dname := display_name(found_user);

    --member for
    select age(now(),found_user.created_at) into member_for;

    -- status
    select * from status where id=found_user.status_id into user_status;
    can_login:=user_status.can_login;
    return_status:=user_status.name;

    -- is_admin
    select exists(select user_id from users_roles where
                  user_id=found_user.id and role_id=10) into is_admin;
    -- logs
    select json_agg(x) into json_logs from
    (select * from logs where logs.user_id = found_user.id) x;

    -- notes
    select json_agg(y) into json_notes from
    (select * from notes where notes.user_id = found_user.id) y;
  end if;

  return (found_user.id, 
     found_user.email, 
     return_status,
     can_login,
     is_admin,
     dname,
     found_user.user_key,
     found_user.validation_token,
     member_for,
     found_user.profile,
     json_logs,
     json_notes)::user_summary;
end;
$$
language plpgsql;
