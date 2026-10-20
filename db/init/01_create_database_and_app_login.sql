-- Creates the ticket_demo database and a least-privilege application login.
-- Idempotent: safe to run on every `docker compose up`.
-- $(APP_DB_PASSWORD) is supplied by sqlcmd from the environment.

IF DB_ID(N'ticket_demo') IS NULL
    CREATE DATABASE ticket_demo COLLATE Chinese_Taiwan_Stroke_CI_AS;
GO

IF SUSER_ID(N'ticket_app') IS NULL
    CREATE LOGIN ticket_app
        WITH PASSWORD = N'$(APP_DB_PASSWORD)',
             DEFAULT_DATABASE = ticket_demo,
             CHECK_POLICY = ON;
ELSE
    ALTER LOGIN ticket_app WITH PASSWORD = N'$(APP_DB_PASSWORD)';
GO

USE ticket_demo;
GO

IF USER_ID(N'ticket_app') IS NULL
    CREATE USER ticket_app FOR LOGIN ticket_app;
GO

-- Read/write data and run schema migrations inside ticket_demo only; no server-level rights.
ALTER ROLE db_datareader ADD MEMBER ticket_app;
ALTER ROLE db_datawriter ADD MEMBER ticket_app;
ALTER ROLE db_ddladmin   ADD MEMBER ticket_app;
GRANT EXECUTE TO ticket_app;
GO
