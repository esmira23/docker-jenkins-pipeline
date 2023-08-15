-- CREATE DATABASE jiraproject;
-- USE `jiraproject`;

CREATE TABLE user (
    user_id int NOT NULL PRIMARY KEY AUTO_INCREMENT,
    email varchar(50),
    password varchar(50),
    user_type varchar(50)
);

CREATE TABLE Project (
    project_id int NOT NULL PRIMARY KEY AUTO_INCREMENT,
    name varchar(50),
    description varchar(50),
    status varchar(50),
    priority varchar(50),
    level varchar(50),
    candidate int,
    FOREIGN KEY(candidate) REFERENCES user(user_id)
);
