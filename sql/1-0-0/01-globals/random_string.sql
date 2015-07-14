create or replace function random_string(len int default 36)
returns text
as $$
select upper(substring(md5(random()::text), 0, len+1));
$$ 
language sql;
