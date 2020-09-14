CREATE USER 'foglight'@'localhost' IDENTIFIED BY 'foglight';
GRANT SELECT, REPLICATION CLIENT, PROCESS ON *.* TO 'foglight'@'localhost';
FLUSH PRIVILEGES;
