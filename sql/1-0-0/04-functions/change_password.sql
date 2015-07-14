create or replace function change_password(em varchar, old_pass varchar, new_pass varchar)
returns user_summary
as $$
DECLARE
  found_id bigint;
BEGIN
  set search_path=membership;
  --find the user based on email/password
  select locate_user_by_password(em,old_pass) into found_id;
  if found_id is not null then
    --change the password if all is OK
    update logins set provider_token = crypt(new_pass, gen_salt('bf',10))
    where user_id=found_id and provider='local';

    --log it
    insert into logs(user_id, subject, entry)
    values(found_id, 'Authentication', 'Password changed');

    --add a note to the account
    insert into notes(user_id, note)
    values(found_id, 'Successfully changed password');
  end if;
  return get_user(em);
END;
$$
language plpgsql;
