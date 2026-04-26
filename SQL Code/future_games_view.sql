DROP MATERIALIZED VIEW future_games;

CREATE MATERIALIZED VIEW future_games AS
SELECT
    s.game_id,
    s.game_date,
    r.player_id,
    r.full_name,
    s.away_team_id AS opp_team_id
FROM schedule s
JOIN roster r
  ON s.home_team_id = r.team_id
WHERE s.game_date >= CURRENT_DATE
UNION ALL
SELECT
    s.game_id,
    s.game_date,
    r.player_id,
    r.full_name,
    s.home_team_id AS opp_team_id
FROM schedule s
JOIN roster r
  ON s.away_team_id = r.team_id
WHERE s.game_date >= CURRENT_DATE
ORDER BY game_date, full_name;


SELECT * FROM future_games;



