DROP MATERIALIZED VIEW model_evaluation;

CREATE MATERIALIZED VIEW model_evaluation AS

WITH eligible_players AS (
    SELECT *
    FROM player_prop_results
    WHERE minutes_played > 0
),

stat_results AS(
	SELECT
		player_id,
		game_id,
		game_date,
	    'Points' AS stat_type,
		CASE
	    	WHEN minutes_played = 0 THEN NULL
	    	ELSE COALESCE(pts_actual, 0)
		END AS actual,
	    pred_pts AS prediction,
	    pts_line AS prop_line
	FROM eligible_players
	WHERE pred_pts IS NOT NULL
	  AND pts_line IS NOT NULL
	
	UNION ALL
	
	SELECT
		player_id,
		game_id,
		game_date,
	    'Rebounds' AS stat_type,
	    reb_actual AS actual,
	    pred_rebs AS prediction,
	    reb_line AS prop_line
	FROM eligible_players
	WHERE pred_rebs IS NOT NULL
	  AND reb_line IS NOT NULL
	
	UNION ALL
	
	SELECT
		player_id,
		game_id,
		game_date,
	    'Assists' AS stat_type,
	    ast_actual AS actual,
	    pred_asts AS prediction,
	    ast_line AS prop_line
	FROM eligible_players
	WHERE pred_asts IS NOT NULL
	  AND ast_line IS NOT NULL
	
	UNION ALL
	
	SELECT
		player_id,
		game_id,
		game_date,
	    'PRA' AS stat_type,
	    pra_actual AS actual,
	    pred_pra AS prediction,
	    pra_line AS prop_line
	FROM eligible_players
	WHERE pred_pra IS NOT NULL
	  AND pra_line IS NOT NULL
	
	UNION ALL
	
	SELECT
		player_id,
		game_id,
		game_date,
	    'Threes' AS stat_type,
	    thr_actual AS actual,
	    pred_three AS prediction,
	    thr_line AS prop_line
	FROM eligible_players
	WHERE pred_three IS NOT NULL
	  AND thr_line IS NOT NULL
	
	UNION ALL
	
	SELECT
		player_id,
		game_id,
		game_date,
	    'Blocks' AS stat_type,
	    blk_actual AS actual,
	    pred_blks AS prediction,
	    blk_line AS prop_line
	FROM eligible_players
	WHERE pred_blks IS NOT NULL
	  AND blk_line IS NOT NULL
	
	UNION ALL
	
	SELECT
		player_id,
		game_id,
		game_date,
	    'Steals' AS stat_type,
	    stl_actual AS actual,
	    pred_stls AS prediction,
	    stl_line AS prop_line
	FROM eligible_players
	WHERE pred_stls IS NOT NULL
	  AND stl_line IS NOT NULL
)

SELECT
    *,
    ABS(actual - prediction) AS absolute_error,
	CASE
		WHEN actual = 0 THEN NULL
		ELSE ROUND((ABS(actual - prediction) / actual) * 100, 2)
	END AS relative_error
FROM stat_results;

SELECT player_id, stat_type,
    AVG(absolute_error) AS mae,
	SQRT(AVG(POWER(absolute_error, 2))) AS rmse,
	AVG(relative_error) AS relative_error
FROM model_evaluation 
GROUP BY player_id, stat_type
ORDER BY player_id;

SELECT
    stat_type,
    COUNT(*) AS predictions,
    AVG(absolute_error) AS mae,
	SQRT(AVG(POWER(absolute_error, 2))) AS rmse,
	(SQRT(AVG(POWER(absolute_error, 2))) / AVG(absolute_error)) AS ratio
FROM model_evaluation
GROUP BY stat_type
ORDER BY stat_type;
