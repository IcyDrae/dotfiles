
-- 1. Copy backup files into /var/opt/mssql/data/
-- 2. Run: "sudo chown -R mssql:mssql /var/opt/mssql/data/"
-- 3. Run: "sqlcmd -S localhost -U rgj -i ./ImportDatabases.sql -No"
-- 4. Test if the databases are there using "sqlcmd"

CREATE DATABASE CustomizedWorkoutGenerator
    ON (FILENAME = '/var/opt/mssql/data/CustomizedWorkoutGenerator.mdf'),
    (FILENAME = '/var/opt/mssql/data/CustomizedWorkoutGenerator_log.ldf')
    FOR ATTACH;

CREATE DATABASE gregs_list
    ON (FILENAME = '/var/opt/mssql/data/gregs_list.mdf'),
    (FILENAME = '/var/opt/mssql/data/gregs_list_log.ldf')
    FOR ATTACH;

CREATE DATABASE Invoices
    ON (FILENAME = '/var/opt/mssql/data/Invoices.mdf'),
    (FILENAME = '/var/opt/mssql/data/Invoices_log.ldf')
    FOR ATTACH;

CREATE DATABASE Matter
    ON (FILENAME = '/var/opt/mssql/data/Matter.mdf'),
    (FILENAME = '/var/opt/mssql/data/Matter_log.ldf')
    FOR ATTACH;

CREATE DATABASE SP500Insights
    ON (FILENAME = '/var/opt/mssql/data/SP500Insights.mdf'),
    (FILENAME = '/var/opt/mssql/data/SP500Insights_log.ldf')
    FOR ATTACH;
