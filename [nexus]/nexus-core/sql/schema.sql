CREATE TABLE IF NOT EXISTS nexus_accounts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    license VARCHAR(80) NOT NULL UNIQUE,
    last_name VARCHAR(80) DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS nexus_characters (
    id INT AUTO_INCREMENT PRIMARY KEY,
    account_id INT NOT NULL,
    citizenid VARCHAR(24) NOT NULL UNIQUE,
    firstname VARCHAR(50) NOT NULL,
    lastname VARCHAR(50) NOT NULL,
    dateofbirth VARCHAR(20) DEFAULT NULL,
    gender VARCHAR(10) DEFAULT "m",
    cash INT NOT NULL DEFAULT 0,
    bank INT NOT NULL DEFAULT 0,
    dirty_money INT NOT NULL DEFAULT 0,
    job_name VARCHAR(50) NOT NULL DEFAULT "unemployed",
    job_grade INT NOT NULL DEFAULT 0,
    job_duty TINYINT(1) NOT NULL DEFAULT 0,
    locale VARCHAR(5) NOT NULL DEFAULT 'nl',
    spawn LONGTEXT DEFAULT NULL,
    appearance LONGTEXT DEFAULT NULL,
    metadata LONGTEXT DEFAULT NULL,
    last_location LONGTEXT DEFAULT NULL,
    deleted_at TIMESTAMP NULL DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_nexus_character_account FOREIGN KEY (account_id) REFERENCES nexus_accounts(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS nexus_jobs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    label VARCHAR(100) NOT NULL,
    data LONGTEXT DEFAULT NULL
);

CREATE TABLE IF NOT EXISTS nexus_vehicles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    character_id INT NOT NULL,
    plate VARCHAR(20) NOT NULL UNIQUE,
    model VARCHAR(60) NOT NULL,
    garage VARCHAR(60) DEFAULT "pillbox",
    state VARCHAR(20) DEFAULT "stored",
    fuel FLOAT DEFAULT 100,
    engine FLOAT DEFAULT 1000,
    body FLOAT DEFAULT 1000,
    mods LONGTEXT DEFAULT NULL,
    keys_json LONGTEXT DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_nexus_vehicle_character FOREIGN KEY (character_id) REFERENCES nexus_characters(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS nexus_properties (
    id INT AUTO_INCREMENT PRIMARY KEY,
    owner_character_id INT DEFAULT NULL,
    property_key VARCHAR(60) NOT NULL UNIQUE,
    label VARCHAR(100) NOT NULL,
    shell VARCHAR(60) DEFAULT NULL,
    storage LONGTEXT DEFAULT NULL
);

CREATE TABLE IF NOT EXISTS nexus_inventories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    owner_type VARCHAR(30) NOT NULL,
    owner_id VARCHAR(80) NOT NULL,
    items LONGTEXT DEFAULT NULL,
    UNIQUE KEY unique_inventory_owner (owner_type, owner_id)
);
