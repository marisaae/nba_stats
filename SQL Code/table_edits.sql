ALTER TABLE player_game_log
	ADD COLUMN is_home BOOLEAN;

UPDATE player_game_log
SET is_home = CASE
	WHEN matchup LIKE '%@%' THEN FALSE
	WHEN matchup LIKE '%vs%' THEN TRUE
	ELSE NULL
END;


ALTER TABLE player_game_log
	ADD COLUMN is_b2b BOOLEAN;


ALTER TABLE player_game_log
	ADD COLUMN opp_team_abbrev CHAR(3);


UPDATE player_game_log
SET opp_team_abbrev = SPLIT_PART(matchup, ' ', 3);


WITH prev_games AS (
	SELECT
		player_id,
		game_date,
		LAG(game_date) OVER (PARTITION BY player_id ORDER BY game_date) AS prev_game_date
	FROM player_game_log
)
UPDATE player_game_log AS pgl
SET is_b2b = CASE
	WHEN prev_game_date IS NOT NULL AND pgl.game_date - prev_game_date = 1 THEN TRUE
	ELSE FALSE
END
FROM prev_games AS pg
WHERE pgl.player_id = pg.player_id AND pgl.game_date = pg.game_date;


UPDATE player_game_log
SET pts_reb_ast = 0
WHERE pts_reb_ast IS NULL;

