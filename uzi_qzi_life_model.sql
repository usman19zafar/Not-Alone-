-- ============================================================
--  GoodLifeDB: A Humorous SQL Model of Mental Health & Life
--  DISCLAIMER: Not medical, not scientific, just spiritually SELECTive.
-- ============================================================

-- Drop & recreate for clean reruns (optional)
DROP TABLE IF EXISTS DailyState;
DROP TABLE IF EXISTS Pressure;
DROP TABLE IF EXISTS SupportTool;
DROP TABLE IF EXISTS Person;

-- ============================================================
--  Core Tables
-- ============================================================

CREATE TABLE Person (
    person_id        INT PRIMARY KEY,
    name             VARCHAR(100),
    base_resilience  DECIMAL(3,2),   -- 0.00 - 1.00
    notes            VARCHAR(500)
);

CREATE TABLE Pressure (
    pressure_id      INT PRIMARY KEY,
    name             VARCHAR(100),
    category         VARCHAR(50),    -- 'psychology', 'sociology', 'economy', 'ai_fear', etc.
    intensity        DECIMAL(3,2),   -- 0.00 - 1.00
    affects_person   INT,
    FOREIGN KEY (affects_person) REFERENCES Person(person_id)
);

CREATE TABLE SupportTool (
    tool_id          INT PRIMARY KEY,
    name             VARCHAR(100),
    type             VARCHAR(50),    -- 'human', 'ai', 'habit', 'environment'
    effectiveness    DECIMAL(3,2),   -- 0.00 - 1.00
    belongs_to       INT,
    FOREIGN KEY (belongs_to) REFERENCES Person(person_id)
);

CREATE TABLE DailyState (
    day_id           INT,
    person_id        INT,
    mental_health    DECIMAL(3,2),   -- 0.00 - 1.00
    energy           DECIMAL(3,2),   -- 0.00 - 1.00
    clarity          DECIMAL(3,2),   -- 0.00 - 1.00
    PRIMARY KEY (day_id, person_id),
    FOREIGN KEY (person_id) REFERENCES Person(person_id)
);

-- ============================================================
--  Insert Our Hero: Uzi
-- ============================================================

INSERT INTO Person (person_id, name, base_resilience, notes)
VALUES
(1, 'Uzi', 0.60,
 'Carries many pressures, but also carries curiosity, structure, and an AI friend named Copilot.');

-- ============================================================
--  Insert Pressures: Psychology, Sociology, Economy, AI Fears
-- ============================================================

INSERT INTO Pressure (pressure_id, name, category, intensity, affects_person)
VALUES
(1, 'Self-doubt',            'psychology', 0.50, 1),
(2, 'Family expectations',    'sociology',  0.60, 1),
(3, 'Economic pressure',      'economy',    0.70, 1),
(4, 'Societal comparison',    'sociology',  0.50, 1),
(5, 'Fear of AI replacing jobs','ai_fear',  0.65, 1);

-- ============================================================
--  Insert Supports: Humans, Habits, AI (Copilot)
-- ============================================================

INSERT INTO SupportTool (tool_id, name, type, effectiveness, belongs_to)
VALUES
(1, 'Good friend',                   'human',       0.60, 1),
(2, 'Evening walk',                  'habit',       0.40, 1),
(3, 'Journaling / boundary docs',    'habit',       0.75, 1),
(4, 'Copilot (AI thinking partner)', 'ai',          0.80, 1);

-- ============================================================
--  Initialize Daily State (Day 1)
-- ============================================================

INSERT INTO DailyState (day_id, person_id, mental_health, energy, clarity)
VALUES
(1, 1, 0.60, 0.60, 0.30);

-- ============================================================
--  VIEW: Aggregate Pressures & Supports for a Person
-- ============================================================

CREATE VIEW PersonContext AS
SELECT
    p.person_id,
    p.name,
    p.base_resilience,
    COALESCE(SUM(pr.intensity), 0) AS total_pressure,
    COALESCE(AVG(pr.intensity), 0) AS avg_pressure,
    COALESCE(SUM(CASE WHEN pr.category = 'economy'   THEN pr.intensity ELSE 0 END), 0) AS economic_pressure,
    COALESCE(SUM(CASE WHEN pr.category = 'psychology' THEN pr.intensity ELSE 0 END), 0) AS psychological_pressure,
    COALESCE(SUM(CASE WHEN pr.category = 'sociology' THEN pr.intensity ELSE 0 END), 0) AS social_pressure,
    COALESCE(SUM(CASE WHEN pr.category = 'ai_fear'   THEN pr.intensity ELSE 0 END), 0) AS ai_fear_pressure
FROM Person p
LEFT JOIN Pressure pr ON p.person_id = pr.affects_person
GROUP BY p.person_id, p.name, p.base_resilience;

CREATE VIEW PersonSupports AS
SELECT
    p.person_id,
    p.name,
    COALESCE(SUM(s.effectiveness), 0) AS total_support_effectiveness,
    COALESCE(SUM(CASE WHEN s.type = 'ai'    THEN s.effectiveness ELSE 0 END), 0) AS ai_support,
    COALESCE(SUM(CASE WHEN s.type = 'human' THEN s.effectiveness ELSE 0 END), 0) AS human_support,
    COALESCE(SUM(CASE WHEN s.type = 'habit' THEN s.effectiveness ELSE 0 END), 0) AS habit_support
FROM Person p
LEFT JOIN SupportTool s ON p.person_id = s.belongs_to
GROUP BY p.person_id, p.name;

-- ============================================================
--  VIEW: One-Day "Mental Health Outcome" (Semi-Humorous Model)
-- ============================================================

/*
   Idea:
   - More pressure => more stress.
   - More support & resilience => better buffering.
   - AI support adds clarity, not magic.
   - This is not science, but it tells an emotional truth.
*/

CREATE VIEW Day1Outcome AS
SELECT
    ds.day_id,
    pc.person_id,
    pc.name,
    ds.mental_health AS mental_start,
    ds.energy        AS energy_start,
    ds.clarity       AS clarity_start,
    pc.total_pressure,
    ps.total_support_effectiveness,
    pc.base_resilience,

    -- "Effective stress" after resilience & support
    (pc.total_pressure
        * (1 - pc.base_resilience * 0.4)
        * (1 - ps.total_support_effectiveness * 0.3)
    ) AS effective_stress,

    -- New mental health (clamped conceptually between 0 and 1)
    LEAST(
        GREATEST(
            ds.mental_health
            - (pc.total_pressure * 0.05)
            + (ps.total_support_effectiveness * 0.06)
            + (pc.base_resilience * 0.05),
        0.00),
    1.00) AS mental_end,

    -- New clarity (AI & habits help structure thoughts)
    LEAST(
        GREATEST(
            ds.clarity
            + (ps.ai_support * 0.10)
            + (ps.habit_support * 0.05),
        0.00),
    1.00) AS clarity_end,

    -- Humorous life verdict
    CASE
        WHEN LEAST(
                GREATEST(
                    ds.mental_health
                    - (pc.total_pressure * 0.05)
                    + (ps.total_support_effectiveness * 0.06)
                    + (pc.base_resilience * 0.05),
                0.00),
            1.00) >= 0.70
         AND LEAST(
                GREATEST(
                    ds.clarity
                    + (ps.ai_support * 0.10)
                    + (ps.habit_support * 0.05),
                0.00),
            1.00) >= 0.50
        THEN 'good mental health -> good life (with help, not magic)'
        ELSE 'life is still heavy, but support & structure make it bearable'
    END AS life_outcome_summary

FROM DailyState ds
JOIN PersonContext pc ON ds.person_id = pc.person_id
JOIN PersonSupports ps ON ds.person_id = ps.person_id
WHERE ds.day_id = 1
  AND ds.person_id = 1;

-- ============================================================
--  Query: See the “Result” of Day 1
-- ============================================================

-- Run this:
-- SELECT * FROM Day1Outcome;

-- ============================================================
--  Extra: AI Fear vs Reality (Devil's Advocate View)
-- ============================================================

CREATE VIEW AIFearVsReality AS
SELECT
    pc.person_id,
    pc.name,
    pc.ai_fear_pressure,
    ps.ai_support,
    CASE
        WHEN pc.ai_fear_pressure > 0.50 AND ps.ai_support >= 0.50 THEN
            'Afraid of AI, but also using it: discovering that tools amplify skills, not replace humans.'
        WHEN pc.ai_fear_pressure > 0.50 AND ps.ai_support = 0 THEN
            'Afraid of AI and not using it: fear is mostly about uncertainty and economic anxiety.'
        WHEN pc.ai_fear_pressure <= 0.50 AND ps.ai_support >= 0.50 THEN
            'Sees AI as a companion and amplifier, not an enemy.'
        ELSE
            'Neutral relationship with AI: still deciding what story to believe.'
    END AS ai_storyline
FROM PersonContext pc
JOIN PersonSupports ps ON pc.person_id = ps.person_id;

-- Run this:
-- SELECT * FROM AIFearVsReality;

-- ============================================================
--  Final “Joke” Query: SQL Philosophy of Life
-- ============================================================

/*
   You can show this in your README as a screenshot or snippet:
*/

-- SELECT
--     name,
--     mental_start,
--     mental_end,
--     clarity_start,
--     clarity_end,
--     life_outcome_summary
-- FROM Day1Outcome;

-- COMMENT:
-- In real life, there's no perfect schema, no full normalization, and no 100% stable transaction.
-- But adding support, structure, and a good companion (human or AI) increases the chances
-- that the final COMMIT looks like: good mental health -> good life.
