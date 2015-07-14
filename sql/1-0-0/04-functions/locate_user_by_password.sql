create or replace function locate_user_by_password(em varchar, pass varchar)
returns bigint
as $$
  set search_path=membership;
  select user_id from logins where
  provider = 'local' and
  provider_key = em and
  provider_token = crypt(pass,provider_token);
$$
language sql;
