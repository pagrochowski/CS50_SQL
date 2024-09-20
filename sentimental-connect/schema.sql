

CREATE DATABASE IF NOT EXISTS `linkedin`;

CREATE TABLE IF NOT EXISTS `users` (
    `id` INT AUTO_INCREMENT,
    `name` VARCHAR(32) NOT NULL UNIQUE,
    `last_name` VARCHAR(32) NOT NULL UNIQUE,
    `username` VARCHAR(32) NOT NULL UNIQUE,
    `password` VARCHAR(32) NOT NULL,
    PRIMARY KEY(`id`)
);

CREATE TABLE IF NOT EXISTS `user_connections` (
    `user_id` INT,
    `connection_id` INT,
    FOREIGN KEY (`user_id`) REFERENCES `users`(`id`),
    FOREIGN KEY (`connection_id`) REFERENCES `users`(`id`)
);

CREATE TABLE IF NOT EXISTS `schools` (
    `id` INT AUTO_INCREMENT,
    `name` VARCHAR(32) NOT NULL UNIQUE,
    `type` VARCHAR(32) NOT NULL,
    `location` VARCHAR(32) NOT NULL,
    `founded` SMALLINT UNSIGNED NOT NULL,
    PRIMARY KEY(`id`)
);

CREATE TABLE IF NOT EXISTS `school_connections` (
    `user_id` INT,
    `school_id` INT,
    `affiliation_start` SMALLINT UNSIGNED NOT NULL,
    `affiliation_end` SMALLINT UNSIGNED NOT NULL,
    `degree_type` ENUM('BA', 'MA', 'PhD'),
    FOREIGN KEY (`user_id`) REFERENCES `users`(`id`),
    FOREIGN KEY (`school_id`) REFERENCES `schools`(`id`)
);

CREATE TABLE IF NOT EXISTS `companies` (
    `id` INT AUTO_INCREMENT,
    `name` VARCHAR(32) NOT NULL UNIQUE,
    `industry` ENUM('Technology', 'Education', 'Business'),
    `location` VARCHAR(32) NOT NULL,
    PRIMARY KEY(`id`)
);

CREATE TABLE IF NOT EXISTS `company_connections` (
    `user_id` INT,
    `company_id` INT,
    `affiliation_start` SMALLINT UNSIGNED NOT NULL,
    `affiliation_end` SMALLINT UNSIGNED NOT NULL,
    FOREIGN KEY (`user_id`) REFERENCES `users`(`id`),
    FOREIGN KEY (`company_id`) REFERENCES `companies`(`id`)
);

