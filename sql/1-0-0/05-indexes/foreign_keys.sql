ALTER TABLE logins
ADD CONSTRAINT logins_users
FOREIGN KEY (user_id) REFERENCES users(id)
ON DELETE CASCADE;

ALTER TABLE logs
ADD CONSTRAINT logs_users
FOREIGN KEY (user_id) REFERENCES users(id)
ON DELETE CASCADE;

ALTER TABLE notes 
ADD CONSTRAINT notes_users 
FOREIGN KEY (user_id) REFERENCES users (id) on delete cascade;

ALTER TABLE users_roles 
ADD CONSTRAINT user_roles_users 
FOREIGN KEY (user_id) REFERENCES users (id) on delete cascade;

ALTER TABLE users_roles 
ADD CONSTRAINT member_roles_roles
FOREIGN KEY (role_id) REFERENCES roles (id) on delete cascade;

ALTER TABLE users 
ADD CONSTRAINT users_status
FOREIGN KEY (status_id) REFERENCES status (id); 
