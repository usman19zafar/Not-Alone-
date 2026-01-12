-- ============================================================
--  Devil's Advocate Model: Corrupt Systems vs AI Objectivity
--  Humor + Truth: Some systems fear AI because AI removes bias.
-- ============================================================

DROP TABLE IF EXISTS CorruptSystem;
DROP TABLE IF EXISTS AIDangerPerception;

-- ============================================================
--  Table: CorruptSystem
--  Represents systems that rely on bias, ambiguity, and gatekeeping.
-- ============================================================

CREATE TABLE CorruptSystem (
    system_id        INT PRIMARY KEY,
    name             VARCHAR(100),
    dependency_bias  DECIMAL(3,2),   -- 0.00 - 1.00 (how much they rely on bias)
    gatekeeping_lvl  DECIMAL(3,2),   -- 0.00 - 1.00 (how much they block others)
    subjectivity_lvl DECIMAL(3,2),   -- 0.00 - 1.00 (how much they avoid rules)
    fear_of_ai       DECIMAL(3,2),   -- 0.00 - 1.00 (how scared they are of AI)
    notes            VARCHAR(500)
);

-- ============================================================
--  Insert Examples (Humorous but Realistic)
-- ============================================================

INSERT INTO CorruptSystem (system_id, name, dependency_bias, gatekeeping_lvl, subjectivity_lvl, fear_of_ai, notes)
VALUES
(1, 'Old Boys Club Hiring', 0.95, 0.90, 0.85, 0.98,
 'AI threatens their ability to hire friends instead of talent.'),
(2, 'Subjective Performance Reviews', 0.88, 0.70, 0.92, 0.90,
 'AI introduces objective metrics, which ruins the fun.'),
(3, 'Gatekeeping Committees', 0.80, 0.95, 0.75, 0.85,
 'AI makes knowledge accessible to everyone, not just insiders.'),
(4, 'Biased Decision-Making', 0.99, 0.60, 0.90, 0.99,
 'AI exposes inconsistencies and forces fairness.'),
(5, 'Fear-Based Anti-AI Influencers', 0.70, 0.40, 0.80, 1.00,
 'They are not afraid of AI; they are afraid of losing control.');

-- ============================================================
--  Table: AIDangerPerception
--  How corrupt systems *claim* AI is dangerous vs the real reason.
-- ============================================================

CREATE TABLE AIDangerPerception (
    system_id        INT,
    claimed_danger   VARCHAR(300),
    real_reason      VARCHAR(300),
    FOREIGN KEY (system_id) REFERENCES CorruptSystem(system_id)
);

-- ============================================================
--  Insert Devil's Advocate Truths
-- ============================================================

INSERT INTO AIDangerPerception (system_id, claimed_danger, real_reason)
VALUES
(1, 'AI will destroy jobs',
     'AI removes favoritism and forces merit-based hiring'),
(2, 'AI cannot understand human nuance',
     'AI prevents managers from manipulating evaluations'),
(3, 'AI is dangerous and unregulated',
     'AI makes gatekeeping obsolete by democratizing knowledge'),
(4, 'AI is biased and untrustworthy',
     'AI exposes *their* bias and forces transparency'),
(5, 'AI will ruin society',
     'AI threatens their influence, not society');

-- ============================================================
--  VIEW: Who Actually Fears AI (Devil’s Advocate Lens)
-- ============================================================

CREATE VIEW CorruptSystemFearAnalysis AS
SELECT
    cs.name AS system_name,
    cs.dependency_bias,
    cs.gatekeeping_lvl,
    cs.subjectivity_lvl,
    cs.fear_of_ai,
    ad.claimed_danger,
    ad.real_reason,
    CASE
        WHEN cs.fear_of_ai >= 0.90 THEN
            'High fear: AI threatens their power structure.'
        WHEN cs.fear_of_ai >= 0.70 THEN
            'Moderate fear: AI reduces their control.'
        ELSE
            'Low fear: They might actually like fairness.'
    END AS fear_interpretation
FROM CorruptSystem cs
JOIN AIDangerPerception ad ON cs.system_id = ad.system_id;

-- ============================================================
--  Query to See the Truth
-- ============================================================

-- SELECT * FROM CorruptSystemFearAnalysis;

-- ============================================================
--  Final Joke Query
-- ============================================================

-- SELECT
--     system_name,
--     claimed_danger,
--     real_reason,
--     fear_interpretation
-- FROM CorruptSystemFearAnalysis;

-- COMMENT:
-- AI is not dangerous.
-- It is only dangerous to systems built on bias, ambiguity, and gatekeeping.
-- Tools don't replace humans; they replace unfair advantages.
