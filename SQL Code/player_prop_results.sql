DROP MATERIALIZED VIEW player_prop_results;

CREATE MATERIALIZED VIEW player_prop_results AS
SELECT
	r.player_id,
	r.position,
	s.game_id, 
	s.game_date,
	pgl.is_home,
	pgl.is_b2b,
	s.home_team_id,
	s.away_team_id,
	pgl.season,
	po.pts_line,
	pgl.pts AS pts_actual,
	(pgl.pts > po.pts_line) AS pts_line_result,
	po.reb_line,
	pgl.tot_reb AS reb_actual,
	(pgl.tot_reb > po.reb_line) AS reb_line_result,
	po.ast_line,
	pgl.ast AS ast_actual,
	(pgl.ast > po.ast_line) AS ast_line_result,
	po.pra_line,
	pgl.pts_reb_ast AS pra_actual,
	(pgl.pts_reb_ast > po.pra_line) AS pra_line_result,
	po.thr_line,
	pgl.three_pts_made AS thr_actual,
	(pgl.three_pts_made > po.thr_line) AS thr_line_result,
	po.blk_line,
	pgl.blk AS blk_actual,
	(pgl.blk > po.blk_line) AS blk_line_result,
	po.stl_line,
	pgl.stl AS stl_actual,
	(pgl.stl > po.stl_line) AS stl_line_result
FROM player_odds_pivot AS po
LEFT JOIN schedule AS s
ON po.event_id = s.event_id
LEFT JOIN roster AS r
ON unaccent(r.full_name) = unaccent(po.player_name)
LEFT JOIN player_game_log AS pgl
ON r.player_id = pgl.player_id AND s.game_id = pgl.game_id
ORDER BY game_date;

SELECT * FROM player_prop_results;

REFRESH MATERIALIZED VIEW player_prop_results;
	