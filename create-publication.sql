-- Create the Replication publication
ALTER SYSTEM SET wal_level = logical;
CREATE PUBLICATION supabase_realtime FOR ALL TABLES;
