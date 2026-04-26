DROP MATERIALIZED VIEW model_player_stats;

CREATE MATERIALIZED VIEW model_player_stats AS
SELECT 
	pgl.game_id,
	pgl.game_date,
	pgl.season,
	r.full_name,
	split_part(r.position, '-', 1) AS primary_position,
	pgl.is_home,
	pgl.is_b2b,
	pgl.min,
	rs.min_rolling_avg_over_5,
	pgl.pts,
	rs.pts_rolling_avg_over_5,
	pgl.fg_pct,
	rs.fg_pct_rolling_avg_over_5,
	pgl.fga,
	rs.fga_rolling_avg_over_5,
	pgl.three_pts_made,
	rs.threes_rolling_avg_over_5,
	pgl.three_pts_att,
	rs.threes_att_rolling_avg_over_5,
	pgl.three_pts_pct,
	rs.threes_pct_rolling_avg_over_5,
	pgl.oreb,
	rs.oreb_rolling_avg_over_5,
	pgl.dreb,
	rs.dreb_rolling_avg_over_5,
	pgl.tot_reb,
	rs.reb_rolling_avg_over_5,
	pgl.ast,
	rs.ast_rolling_avg_over_5,
	pgl.stl,
	rs.stl_rolling_avg_over_5,
	pgl.blk,
	rs.blk_rolling_avg_over_5,
	pgl.pts_reb_ast,
	rs.pra_rolling_avg_over_5,
	def.opp_pts,
    def.opp_fg_pct,
    def.opp_fg3_pct,
    def.opp_fg_pct_rank,
    def.opp_fg3_pct_rank,
    def.opp_reb,
    def.opp_oreb,
    def.opp_dreb,
    def.opp_ast,
    def.opp_stl,
    def.opp_blk
FROM player_game_log AS pgl
LEFT JOIN roster AS r
ON pgl.player_id = r.player_id
LEFT JOIN team_info AS ti
ON pgl.opp_team_abbrev = ti.abbreviation
LEFT JOIN rolling_stats AS rs
ON pgl.game_date = rs.game_date AND pgl.player_id = rs.player_id
LEFT JOIN team_def_stats AS def
ON ti.id = def.team_id AND def.opp_player_position = split_part(r.position, '-', 1)
AND def.season = pgl.season
ORDER BY game_date;

SELECT * FROM model_player_stats;

