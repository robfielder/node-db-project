create table logs(
  id serial primary key,
  subject log_type,
  user_id bigint,
  entry text not null,
  data jsonb,
  created_at timestamptz default now()
);
