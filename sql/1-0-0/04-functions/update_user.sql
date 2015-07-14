create or replace function update_user(em varchar, first_name varchar, last_name varchar, profile_data jsonb)
returns user_summary
as $$
declare
  found_id bigint;
begin
  select id from users into found_id where email=em;
  if found_id is not null then
    update users set
    first=first_name,
    last=last_name,
    profile=profile_data
    where id=found_id;
  end if;
  return get_user(em);
end;
$$
language plpgsql;
