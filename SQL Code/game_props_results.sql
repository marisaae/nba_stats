DROP MATERIALIZED VIEW game_props_results;

CREATE MATERIALIZED VIEW game_props_results AS
WITH game_results AS (
	SELECT
		game_id,
		MAX(wl) AS wl
	FROM player_game_log
	GROUP BY game_id
),
game_points AS (
	SELECT
		game_id,
		home_team_score + away_team_score as actual_points
	FROM schedule
	GROUP BY game_id
)
SELECT 
	s.game_id,
	s.game_date,
	godp.*,
	gr.wl,
	gp.actual_points
FROM game_odds_pivot AS godp
LEFT JOIN schedule AS s
ON godp.event_id = s.event_id
LEFT JOIN game_results AS gr
ON s.game_id = gr.game_id
LEFT JOIN game_points AS gp
ON gr.game_id = gp.game_id
ORDER BY game_date;

SELECT * FROM game_props_results;

SELECT
	game_id,
	game_date,
	tot_points,
	actual_points,
	(actual_points > tot_points) AS pts_line_results,
	h2h_lal_price,
	h2h_opp_price,
	wl
FROM game_props_results
ORDER BY game_date;

REFRESH MATERIALIZED VIEW game_props_results;