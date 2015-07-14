create or replace function change_status(
  em varchar,
  new_status_id int,
  reason varchar(50)
)
returns user_summary
as $$
DECLARE
  found_id bigint;
  status_name varchar(50);
  user_record user_summary;
BEGIN
  set search_path = membership;
  select name from status where id=new_status_id into status_name;
  select id from users where users.email=em
  into found_id;
  if found_id is not null then
    --reset the status
    update users set status_id=new_status_id where id=found_id;
    --add a note
    insert into notes(user_id, note)
    values (found_id, 'Your status was changed to ' || status_name);
    --add a log
    insert into logs(user_id, subject, entry)
    values(found_id, 'System','Changed status to ' || status_name || ' because ' || reason);
    --pull the user
    user_record := get_user(em);
  end if;
  return user_record;
END;
$$
language plpgsql;

create or replace function suspend_user(em varchar,reason varchar)
returns user_summary
as $$
  select change_status(em,20, reason);
$$ 
language sql;

create or replace function lock_user(em varchar,reason varchar)
returns user_summary
as $$
  select change_status(em,88, reason);
$$ 
language sql;

create or replace function ban_user(em varchar,reason varchar)
returns user_summary
as $$
  select change_status(em,99, reason);
$$ 
language sql;

create or replace function activate_user(em varchar,reason varchar)
returns user_summary
as $$
  select change_status(em,10, reason);
$$ 
language sql;
