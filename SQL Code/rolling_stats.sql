DROP MATERIALIZED VIEW rolling_stats;

CREATE MATERIALIZED VIEW rolling_stats AS
SELECT
	game_date,
	player_id,
	season,
	ROUND(AVG(min) OVER (
		PARTITION BY player_id, season
		ORDER BY game_date
		ROWS BETWEEN 4 PRECEDING AND CURRENT ROW
	), 2) AS min_rolling_avg_over_5,
	ROUND(AVG(pts) OVER (
		PARTITION BY player_id, season
		ORDER BY game_date
		ROWS BETWEEN 4 PRECEDING AND CURRENT ROW
	), 2) AS pts_rolling_avg_over_5,
	ROUND(AVG(fg_pct) OVER (
		PARTITION BY player_id, season
		ORDER BY game_date
		ROWS BETWEEN 4 PRECEDING AND CURRENT ROW
	)::numeric, 2) AS fg_pct_rolling_avg_over_5,
	ROUND(AVG(fga) OVER (
		PARTITION BY player_id, season
		ORDER BY game_date
		ROWS BETWEEN 4 PRECEDING AND CURRENT ROW
	), 2) AS fga_rolling_avg_over_5,
	ROUND(AVG(tot_reb) OVER (
		PARTITION BY player_id, season
		ORDER BY game_date
		ROWS BETWEEN 4 PRECEDING AND CURRENT ROW
	), 2) AS reb_rolling_avg_over_5,
	ROUND(AVG(oreb) OVER (
		PARTITION BY player_id, season
		ORDER BY game_date
		ROWS BETWEEN 4 PRECEDING AND CURRENT ROW
	), 2) AS oreb_rolling_avg_over_5,
	ROUND(AVG(dreb) OVER (
		PARTITION BY player_id, season
		ORDER BY game_date
		ROWS BETWEEN 4 PRECEDING AND CURRENT ROW
	), 2) AS dreb_rolling_avg_over_5,
	ROUND(AVG(three_pts_made) OVER (
		PARTITION BY player_id, season
		ORDER BY game_date
		ROWS BETWEEN 4 PRECEDING AND CURRENT ROW
	), 2) AS threes_rolling_avg_over_5,
	ROUND(AVG(three_pts_att) OVER (
		PARTITION BY player_id, season
		ORDER BY game_date
		ROWS BETWEEN 4 PRECEDING AND CURRENT ROW
	), 2) AS threes_att_rolling_avg_over_5,
	ROUND(AVG(three_pts_pct) OVER (
		PARTITION BY player_id, season
		ORDER BY game_date
		ROWS BETWEEN 4 PRECEDING AND CURRENT ROW
	)::numeric, 2) AS threes_pct_rolling_avg_over_5,
	ROUND(AVG(ast) OVER (
		PARTITION BY player_id, season
		ORDER BY game_date
		ROWS BETWEEN 4 PRECEDING AND CURRENT ROW
	), 2) AS ast_rolling_avg_over_5,
	ROUND(AVG(stl) OVER (
		PARTITION BY player_id, season
		ORDER BY game_date
		ROWS BETWEEN 4 PRECEDING AND CURRENT ROW
	), 2) AS stl_rolling_avg_over_5,
	ROUND(AVG(blk) OVER (
		PARTITION BY player_id, season
		ORDER BY game_date
		ROWS BETWEEN 4 PRECEDING AND CURRENT ROW
	), 2) AS blk_rolling_avg_over_5,
	ROUND(AVG(pts_reb_ast) OVER(
		PARTITION BY player_id, season
		ORDER BY game_date
		ROWS BETWEEN 4 PRECEDING AND CURRENT ROW
	), 2) AS pra_rolling_avg_over_5
FROM player_game_log
ORDER BY game_date;

REFRESH MATERIALIZED VIEW rolling_stats;
SELECT * FROM rolling_stats ORDER BY season;