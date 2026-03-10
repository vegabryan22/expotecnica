CREATE DATABASE IF NOT EXISTS expotecnica_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

CREATE USER IF NOT EXISTS 'expotecnica_user'@'localhost' IDENTIFIED BY 'expotecnica123';
GRANT ALL PRIVILEGES ON expotecnica_db.* TO 'expotecnica_user'@'localhost';
FLUSH PRIVILEGES;

