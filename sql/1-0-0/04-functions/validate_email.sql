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