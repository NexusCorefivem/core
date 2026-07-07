-- Migration notes for Nexus Core 0.0.2-beta (existing databases)
-- Run these ALTER statements manually if you upgraded from an older schema.
-- Fresh installs only need schema.sql + seed.sql.

-- ALTER TABLE nexus_characters ADD COLUMN phone VARCHAR(20) DEFAULT NULL;
-- ALTER TABLE nexus_characters ADD COLUMN gang_name VARCHAR(50) NOT NULL DEFAULT 'none';
-- ALTER TABLE nexus_characters ADD COLUMN gang_grade INT NOT NULL DEFAULT 0;
-- ALTER TABLE nexus_characters ADD COLUMN nationality VARCHAR(10) DEFAULT 'NL';
-- ALTER TABLE nexus_characters ADD COLUMN position_x FLOAT DEFAULT NULL;
-- ALTER TABLE nexus_characters ADD COLUMN position_y FLOAT DEFAULT NULL;
-- ALTER TABLE nexus_characters ADD COLUMN position_z FLOAT DEFAULT NULL;
-- ALTER TABLE nexus_characters ADD COLUMN position_h FLOAT DEFAULT NULL;
-- ALTER TABLE nexus_characters ADD COLUMN is_dead TINYINT(1) NOT NULL DEFAULT 0;
-- ALTER TABLE nexus_characters ADD COLUMN injail INT NOT NULL DEFAULT 0;
-- ALTER TABLE nexus_characters ADD COLUMN last_played TIMESTAMP NULL DEFAULT NULL;

-- Then import: nexus-core/sql/seed.sql
