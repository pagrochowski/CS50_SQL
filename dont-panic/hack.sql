--Alter the password of the website’s administrative account, admin, to instead be “oops!”.
UPDATE users SET password = '982c0381c279d139fd221fce974916e7' WHERE username = 'admin';

--check if password was changed
--SELECT * FROM users WHERE username = 'admin';

--check user logs
--SELECT * FROM user_logs;

--remove id 52 from user logs
DELETE FROM user_logs WHERE id = 52;

--add false log to user logs
INSERT INTO user_logs (type, old_username, new_username, old_password, new_password) VALUES ('update', 'admin', 'admin', 'e10adc3949ba59abbe56e057f20f883e', '44bf025d27eea66336e5c1133c3827f7')

--find out emily33 password: "44bf025d27eea66336e5c1133c3827f7"
--SELECT * FROM users WHERE username = 'emily33'

--new admin password 'oops': 982c0381c279d139fd221fce974916e7