create or replace function remove_user_from_role(em varchar(255), remove_role_id int)
returns user_summary
as $$
DECLARE
found_id bigint;
selected_role varchar(50);
BEGIN
  set search_path=membership;
  select id into found_id from users where email=em;
  if found_id is not null then
    --remove it
    delete from users_roles where user_id=found_id and role_id=remove_role_id;
    --add a log entry
    select description into selected_role from roles where id=remove_role_id;
    insert into logs(subject,entry,user_id, created_at)
    values('Registration','Member removed from role ' || selected_role,found_id,now());

    --add a note
    insert into notes(user_id, note)
    values (found_id, 'Removed from role ' || selected_role);

  end if;
  return get_user(em);
END;
$$ LANGUAGE plpgsql;
