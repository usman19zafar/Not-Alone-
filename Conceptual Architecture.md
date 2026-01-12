```code
                +-----------------------------+
                |         External World      |
                |  (pressures, culture, work) |
                +--------------+--------------+
                               |
                               v
+---------------------------------------------------------------+
|                       Ingestion Layer                         |
|                                                               |
|   - Psychological Events (self-doubt, fear, confusion)        |
|   - Sociological Inputs (expectations, comparison, stigma)    |
|   - Economic Signals (costs, instability, job pressure)       |
|   - AI Narratives (fear, misinformation, bias)                |
|                                                               |
+------------------------------+--------------------------------+
                               |
                               v
+---------------------------------------------------------------+
|                     Processing / Transformation               |
|                                                               |
|   - Emotional ETL (Extract → Think → Let-go)                  |
|   - Boundary Document Normalization                           |
|   - Cognitive Partitioning (separating real vs imagined fear) |
|   - Bias Filtering (removing stereotypes & noise)             |
|   - Clarity Engine (Copilot-assisted structuring)             |
|                                                               |
+------------------------------+--------------------------------+
                               |
                               v
+---------------------------------------------------------------+
|                     Storage / Data Models                     |
|                                                               |
|   - Mental Health Fact Table                                  |
|   - Support Dimension (friends, habits, AI)                   |
|   - Pressure Dimension (psychology, society, economy)         |
|   - Clarity Slowly Changing Dimension (SCD Type 2)            |
|                                                               |
+------------------------------+--------------------------------+
                               |
                               v
+---------------------------------------------------------------+
|                     Serving / Output Layer                    |
|                                                               |
|   - Good Mental Health → Good Life Dashboard                  |
|   - AI Companion Insights                                     |
|   - Daily Reflection Reports                                  |
|   - “You Are Not Alone” API                                   |
|                                                               |
+---------------------------------------------------------------+

```

```code
                 +----------------------+
                 |   dim_support        |
                 |----------------------|
                 | support_id (PK)      |
                 | type                 |
                 | effectiveness        |
                 | is_ai                |
                 +----------+-----------+
                            |
                            |
                            v
+----------------------+     +------------------------+
|   fact_mental_state  | --> |   dim_pressure         |
|----------------------|     |------------------------|
| day_id (PK)          |     | pressure_id (PK)       |
| person_id (FK)       |     | category               |
| mental_health_score  |     | intensity              |
| clarity_score        |     | source                 |
| energy_score         |     +------------------------+
+----------------------+
            |
            |
            v
+----------------------+
|   dim_person         |
|----------------------|
| person_id (PK)       |
| name                 |
| base_resilience      |
| ai_companion_flag    |
+----------------------+
```
