create or replace function register(
  new_email varchar, password varchar
)
returns table(
  new_id bigint,
  validation_token varchar(36),
  authentication_token varchar(36),
  success boolean,
  message varchar(255)
) as $$
BEGIN
  set search_path=membership;
  -- see if they exist
  if not exists (select users.email
        from users where
        users.email = new_email) then

    --for email validation
    validation_token := random_string(36);
    --for token-based login
    authentication_token := random_string(36);

    -- add them, get new id
    insert into users(email,validation_token)
    values (new_email,validation_token)
    returning id into new_id;

    -- add logins
    insert into logins(user_id, provider_key, provider_token)
    values(new_id, new_email, crypt(password, gen_salt('bf', 10)));

    -- token login
    insert into logins(user_id, provider, provider_key, provider_token)
    values(new_id, 'token', 'token', authentication_token);

    --add them to the user role
    insert into users_roles(user_id, role_id)
    values (new_id, 99);

    -- log it
    insert into logs(user_id, subject, entry)
    values(new_id, 'Registration', 'User registered with email ' || new_email);

    success := true;
    message := 'Welcome!';
  else
    success := false;
    select 'This email is already registered' into message;
  end if;

  -- return the goods
  return query
  select new_id, validation_token, authentication_token, success, message;
END;
$$
language plpgsql;
