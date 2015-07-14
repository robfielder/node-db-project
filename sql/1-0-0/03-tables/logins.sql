create table logins(
  id bigint primary key default id_generator(),
  user_id bigint not null,
  provider varchar(50) not null default 'local',
  provider_key varchar(255),
  provider_token varchar(255) not null
);
