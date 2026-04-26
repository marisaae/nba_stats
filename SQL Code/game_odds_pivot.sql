CREATE MATERIALIZED VIEW game_odds_pivot AS
SELECT
	event_id,
	MAX(CASE WHEN market = 'h2h' AND outcome_name = 'Los Angeles Lakers' THEN price END) AS h2h_lal_price,
	MAX(CASE WHEN market = 'h2h' AND outcome_name != 'Los Angeles Lakers' THEN price END) AS h2h_opp_price,
	MAX(CASE WHEN market = 'totals' THEN point END) AS tot_points,
	MAX(CASE WHEN market = 'totals' AND outcome_name = 'Over' THEN price END) AS tot_over_price,
	MAX(CASE WHEN market = 'totals' AND outcome_name = 'Under' THEN price END) AS tot_under_price
FROM game_odds_raw
GROUP BY event_id;

SELECT * FROM game_odds_pivot;