-- ============================================================
-- Nexus Core — Full database schema (0.0.2-beta)
-- Import via txAdmin recipe or manually before first start.
-- ============================================================

CREATE TABLE IF NOT EXISTS nexus_accounts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    license VARCHAR(80) NOT NULL UNIQUE,
    discord VARCHAR(80) DEFAULT NULL,
    steam VARCHAR(80) DEFAULT NULL,
    last_name VARCHAR(80) DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_nexus_accounts_license (license)
);

CREATE TABLE IF NOT EXISTS nexus_bans (
    id INT AUTO_INCREMENT PRIMARY KEY,
    license VARCHAR(80) DEFAULT NULL,
    discord VARCHAR(80) DEFAULT NULL,
    ip VARCHAR(45) DEFAULT NULL,
    reason TEXT NOT NULL,
    expire_at TIMESTAMP NULL DEFAULT NULL,
    banned_by VARCHAR(80) DEFAULT 'system',
    active TINYINT(1) NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_nexus_bans_license (license),
    INDEX idx_nexus_bans_active (active)
);

CREATE TABLE IF NOT EXISTS nexus_jobs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    label VARCHAR(100) NOT NULL,
    type VARCHAR(30) DEFAULT 'none',
    default_duty TINYINT(1) DEFAULT 0,
    data LONGTEXT DEFAULT NULL
);

CREATE TABLE IF NOT EXISTS nexus_job_grades (
    id INT AUTO_INCREMENT PRIMARY KEY,
    job_name VARCHAR(50) NOT NULL,
    grade INT NOT NULL,
    label VARCHAR(100) NOT NULL,
    payment INT NOT NULL DEFAULT 0,
    isboss TINYINT(1) NOT NULL DEFAULT 0,
    UNIQUE KEY unique_nexus_job_grade (job_name, grade),
    CONSTRAINT fk_nexus_job_grades_job FOREIGN KEY (job_name) REFERENCES nexus_jobs(name) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS nexus_gangs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    label VARCHAR(100) NOT NULL,
    data LONGTEXT DEFAULT NULL
);

CREATE TABLE IF NOT EXISTS nexus_gang_grades (
    id INT AUTO_INCREMENT PRIMARY KEY,
    gang_name VARCHAR(50) NOT NULL,
    grade INT NOT NULL,
    label VARCHAR(100) NOT NULL,
    isboss TINYINT(1) NOT NULL DEFAULT 0,
    UNIQUE KEY unique_nexus_gang_grade (gang_name, grade),
    CONSTRAINT fk_nexus_gang_grades_gang FOREIGN KEY (gang_name) REFERENCES nexus_gangs(name) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS nexus_characters (
    id INT AUTO_INCREMENT PRIMARY KEY,
    account_id INT NOT NULL,
    citizenid VARCHAR(24) NOT NULL UNIQUE,
    firstname VARCHAR(50) NOT NULL,
    lastname VARCHAR(50) NOT NULL,
    dateofbirth VARCHAR(20) DEFAULT NULL,
    gender VARCHAR(10) DEFAULT 'm',
    nationality VARCHAR(10) DEFAULT 'NL',
    phone VARCHAR(20) DEFAULT NULL,
    cash INT NOT NULL DEFAULT 0,
    bank INT NOT NULL DEFAULT 0,
    dirty_money INT NOT NULL DEFAULT 0,
    job_name VARCHAR(50) NOT NULL DEFAULT 'unemployed',
    job_grade INT NOT NULL DEFAULT 0,
    job_duty TINYINT(1) NOT NULL DEFAULT 0,
    gang_name VARCHAR(50) NOT NULL DEFAULT 'none',
    gang_grade INT NOT NULL DEFAULT 0,
    locale VARCHAR(5) NOT NULL DEFAULT 'nl',
    spawn LONGTEXT DEFAULT NULL,
    appearance LONGTEXT DEFAULT NULL,
    metadata LONGTEXT DEFAULT NULL,
    last_location LONGTEXT DEFAULT NULL,
    position_x FLOAT DEFAULT NULL,
    position_y FLOAT DEFAULT NULL,
    position_z FLOAT DEFAULT NULL,
    position_h FLOAT DEFAULT NULL,
    is_dead TINYINT(1) NOT NULL DEFAULT 0,
    injail INT NOT NULL DEFAULT 0,
    deleted_at TIMESTAMP NULL DEFAULT NULL,
    last_played TIMESTAMP NULL DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_nexus_character_account FOREIGN KEY (account_id) REFERENCES nexus_accounts(id) ON DELETE CASCADE,
    INDEX idx_nexus_characters_account (account_id),
    INDEX idx_nexus_characters_citizenid (citizenid),
    INDEX idx_nexus_characters_job (job_name)
);

CREATE TABLE IF NOT EXISTS nexus_licenses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    character_id INT NOT NULL,
    license_type VARCHAR(50) NOT NULL,
    issued_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY unique_nexus_character_license (character_id, license_type),
    CONSTRAINT fk_nexus_licenses_character FOREIGN KEY (character_id) REFERENCES nexus_characters(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS nexus_vehicles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    character_id INT NOT NULL,
    plate VARCHAR(20) NOT NULL UNIQUE,
    model VARCHAR(60) NOT NULL,
    garage VARCHAR(60) DEFAULT 'pillbox',
    state VARCHAR(20) DEFAULT 'stored',
    fuel FLOAT DEFAULT 100,
    engine FLOAT DEFAULT 1000,
    body FLOAT DEFAULT 1000,
    mods LONGTEXT DEFAULT NULL,
    keys_json LONGTEXT DEFAULT NULL,
    impound_price INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_nexus_vehicle_character FOREIGN KEY (character_id) REFERENCES nexus_characters(id) ON DELETE CASCADE,
    INDEX idx_nexus_vehicles_character (character_id),
    INDEX idx_nexus_vehicles_plate (plate)
);

CREATE TABLE IF NOT EXISTS nexus_properties (
    id INT AUTO_INCREMENT PRIMARY KEY,
    owner_character_id INT DEFAULT NULL,
    property_key VARCHAR(60) NOT NULL UNIQUE,
    label VARCHAR(100) NOT NULL,
    shell VARCHAR(60) DEFAULT NULL,
    price INT DEFAULT 0,
    storage LONGTEXT DEFAULT NULL,
    keys_json LONGTEXT DEFAULT NULL,
    CONSTRAINT fk_nexus_properties_owner FOREIGN KEY (owner_character_id) REFERENCES nexus_characters(id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS nexus_stashes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    stash_id VARCHAR(80) NOT NULL UNIQUE,
    label VARCHAR(100) DEFAULT NULL,
    owner_type VARCHAR(30) DEFAULT 'public',
    owner_id VARCHAR(80) DEFAULT NULL,
    items LONGTEXT DEFAULT NULL,
    max_weight INT DEFAULT 100000,
    coords LONGTEXT DEFAULT NULL
);

CREATE TABLE IF NOT EXISTS nexus_inventories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    owner_type VARCHAR(30) NOT NULL,
    owner_id VARCHAR(80) NOT NULL,
    items LONGTEXT DEFAULT NULL,
    max_weight INT DEFAULT 50000,
    UNIQUE KEY unique_inventory_owner (owner_type, owner_id)
);

CREATE TABLE IF NOT EXISTS nexus_contacts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    character_id INT NOT NULL,
    contact_name VARCHAR(80) NOT NULL,
    contact_number VARCHAR(20) NOT NULL,
    CONSTRAINT fk_nexus_contacts_character FOREIGN KEY (character_id) REFERENCES nexus_characters(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS nexus_phone_messages (
    id INT AUTO_INCREMENT PRIMARY KEY,
    sender_citizenid VARCHAR(24) NOT NULL,
    receiver_citizenid VARCHAR(24) NOT NULL,
    message TEXT NOT NULL,
    read_at TIMESTAMP NULL DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_nexus_phone_receiver (receiver_citizenid)
);

CREATE TABLE IF NOT EXISTS nexus_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    category VARCHAR(50) NOT NULL,
    message TEXT NOT NULL,
    citizenid VARCHAR(24) DEFAULT NULL,
    source INT DEFAULT NULL,
    data LONGTEXT DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_nexus_logs_category (category)
);

CREATE TABLE IF NOT EXISTS nexus_dispatch (
    id INT AUTO_INCREMENT PRIMARY KEY,
    call_type VARCHAR(50) NOT NULL,
    message TEXT NOT NULL,
    coords LONGTEXT DEFAULT NULL,
    caller_citizenid VARCHAR(24) DEFAULT NULL,
    assigned_job VARCHAR(50) DEFAULT NULL,
    status VARCHAR(20) DEFAULT 'open',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_nexus_dispatch_status (status)
);
