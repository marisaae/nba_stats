CREATE MATERIALIZED VIEW player_odds_pivot AS
SELECT 
	event_id,
	player_name,
	MAX(CASE WHEN market = 'player_points' THEN point END) AS pts_line,
    MAX(CASE WHEN market = 'player_points' AND outcome_name='Over' THEN price END) AS pts_over_price,
    MAX(CASE WHEN market = 'player_points' AND outcome_name='Under' THEN price END) AS pts_under_price,

	MAX(CASE WHEN market = 'player_rebounds' THEN point END) AS reb_line,
    MAX(CASE WHEN market = 'player_rebounds' AND outcome_name='Over' THEN price END) AS reb_over_price,
    MAX(CASE WHEN market = 'player_rebounds' AND outcome_name='Under' THEN price END) AS reb_under_price,

	MAX(CASE WHEN market = 'player_assists' THEN point END) AS ast_line,
    MAX(CASE WHEN market = 'player_assists' AND outcome_name='Over' THEN price END) AS ast_over_price,
    MAX(CASE WHEN market = 'player_assists' AND outcome_name='Under' THEN price END) AS ast_under_price,

	MAX(CASE WHEN market = 'player_points_rebounds_assists' THEN point END) AS pra_line,
    MAX(CASE WHEN market = 'player_points_rebounds_assists' AND outcome_name='Over' THEN price END) AS pra_over_price,
    MAX(CASE WHEN market = 'player_points_rebounds_assists' AND outcome_name='Under' THEN price END) AS pra_under_price,

	MAX(CASE WHEN market = 'player_threes' THEN point END) AS thr_line,
    MAX(CASE WHEN market = 'player_threes' AND outcome_name='Over' THEN price END) AS thr_over_price,
    MAX(CASE WHEN market = 'player_threes' AND outcome_name='Under' THEN price END) AS thr_under_price,

	MAX(CASE WHEN market = 'player_blocks' THEN point END) AS blk_line,
    MAX(CASE WHEN market = 'player_blocks' AND outcome_name='Over' THEN price END) AS blk_over_price,
    MAX(CASE WHEN market = 'player_blocks' AND outcome_name='Under' THEN price END) AS blk_under_price,

	MAX(CASE WHEN market = 'player_steals' THEN point END) AS stl_line,
    MAX(CASE WHEN market = 'player_steals' AND outcome_name='Over' THEN price END) AS stl_over_price,
    MAX(CASE WHEN market = 'player_steals' AND outcome_name='Under' THEN price END) AS stl_under_price
FROM player_odds_raw
GROUP BY event_id, player_name;

SELECT * FROM player_odds_pivot ORDER BY event_id;