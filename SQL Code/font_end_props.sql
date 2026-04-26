DROP MATERIALIZED VIEW front_end_props;

CREATE MATERIALIZED VIEW front_end_props AS
SELECT por.event_id, 
	s.game_date, 
	s.game_status,
	r.player_id, 
	r.full_name,
	por.market,
	por.outcome_name,
	por.price,
	por.point
FROM player_odds_raw AS por
LEFT JOIN schedule AS s
ON por.event_id = s.event_id
LEFT JOIN roster AS r
ON unaccent(por.player_name) = unaccent(r.full_name)
ORDER BY s.game_date;

SELECT * FROM front_end_props;