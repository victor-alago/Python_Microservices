CREATE TABLE auth_user (
    id integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    email VARCHAR (255) NOT NULL,
    password VARCHAR (255) NOT NULL
);

--Adding Username and Password for Admin User
INSERT INTO auth_user (email, password) VALUES ('alagovictor2018@gmail.com', '123456');