-- Nexus Core seed data — jobs & gangs
-- Run after schema.sql (also included in recipe import order)

INSERT IGNORE INTO nexus_jobs (name, label, type, default_duty) VALUES
    ('unemployed', 'Unemployed', 'none', 0),
    ('police', 'Police', 'leo', 0),
    ('ambulance', 'Ambulance', 'ems', 0),
    ('taxi', 'Taxi', 'civ', 0),
    ('bus', 'Bus', 'civ', 0),
    ('trucker', 'Trucker', 'civ', 0),
    ('garbage', 'Garbage', 'civ', 0),
    ('mechanic', 'Mechanic', 'mechanic', 0);

INSERT IGNORE INTO nexus_job_grades (job_name, grade, label, payment, isboss) VALUES
    ('unemployed', 0, 'Freelancer', 75, 0),
    ('police', 0, 'Cadet', 350, 0),
    ('police', 1, 'Officer', 450, 0),
    ('police', 2, 'Sergeant', 600, 1),
    ('ambulance', 0, 'Trainee', 300, 0),
    ('ambulance', 1, 'Medic', 425, 0),
    ('ambulance', 2, 'Chief Medic', 550, 1),
    ('taxi', 0, 'Driver', 200, 0),
    ('bus', 0, 'Driver', 180, 0),
    ('trucker', 0, 'Driver', 220, 0),
    ('garbage', 0, 'Collector', 160, 0),
    ('mechanic', 0, 'Trainee', 250, 0),
    ('mechanic', 1, 'Mechanic', 350, 1);

INSERT IGNORE INTO nexus_gangs (name, label) VALUES
    ('none', 'No Gang'),
    ('ballas', 'Ballas'),
    ('families', 'Families'),
    ('vagos', 'Vagos');

INSERT IGNORE INTO nexus_gang_grades (gang_name, grade, label, isboss) VALUES
    ('none', 0, 'None', 0),
    ('ballas', 0, 'Recruit', 0),
    ('ballas', 1, 'Soldier', 0),
    ('ballas', 2, 'Boss', 1),
    ('families', 0, 'Recruit', 0),
    ('families', 1, 'Soldier', 0),
    ('families', 2, 'Boss', 1),
    ('vagos', 0, 'Recruit', 0),
    ('vagos', 1, 'Soldier', 0),
    ('vagos', 2, 'Boss', 1);
