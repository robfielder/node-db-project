create or replace function display_name(u users)
returns varchar(255)
as $$
DECLARE
  dname varchar(100);
BEGIN
  if(u.first is not null) then
      select concat(u.first, ' ', u.last) 
      into dname;
  else
     select u.email into dname;
  end if;
  return dname;
END;
$$
language plpgsql;
