WITH numbered_games AS (
	SELECT r.full_name,
		pgl.player_id,
		pgl.min,
		pgl.pts,
		pgl.fgm,
		pgl.fga,
		pgl.fg_pct,
		ROW_NUMBER() OVER (
	        PARTITION BY pgl.player_id
	        ORDER BY game_date
	    ) AS game_number
	FROM player_game_log AS pgl
	LEFT JOIN roster AS r 
	ON pgl.player_id = r.player_id
	WHERE pgl.game_date > '2025-10-01' AND full_name IS NOT NULL
),

player_totals AS (
	SELECT r.full_name,
	    pgl.player_id,
	    COUNT(DISTINCT game_id) AS total_games
	FROM player_game_log AS pgl
	LEFT JOIN roster AS r 
	ON pgl.player_id = r.player_id
	WHERE game_date > '2025-10-01' AND full_name IS NOT NULL
	GROUP BY pgl.player_id, r.full_name
),

games_with_totals AS (
    SELECT
        ng.*,
        pt.total_games,
        CASE
            WHEN ng.game_number <= pt.total_games / 2
                THEN 'Early'
            ELSE 'Late'
        END AS season_half
    FROM numbered_games ng
    JOIN player_totals pt
        ON ng.player_id = pt.player_id
),

player_averages AS (
    SELECT
		full_name,
        player_id,
		total_games,

        AVG(CASE WHEN season_half = 'Early' THEN pts END) AS early_points,
        AVG(CASE WHEN season_half = 'Late' THEN pts END) AS late_points,

        AVG(CASE WHEN season_half = 'Early' THEN fg_pct END) AS early_fg_pct,
        AVG(CASE WHEN season_half = 'Late' THEN fg_pct END) AS late_fg_pct,

        AVG(CASE WHEN season_half = 'Early' THEN min END) AS early_minutes,
        AVG(CASE WHEN season_half = 'Late' THEN min END) AS late_minutes

    FROM games_with_totals
    GROUP BY player_id, full_name, total_games
)

SELECT
	full_name,
	total_games,
	ROUND(early_minutes, 2) AS early_minutes,
    ROUND(late_minutes, 2) AS late_minutes,
    ROUND(early_points, 2) AS early_points,
    ROUND(late_points, 2) AS late_points,
    ROUND(late_points - early_points, 2) AS points_change,
    ROUND(CAST(early_fg_pct AS numeric), 3) AS early_fg_pct,
    ROUND(CAST(late_fg_pct AS numeric), 3) AS late_fg_pct,
	ROUND(CAST(late_fg_pct - early_fg_pct AS numeric), 3) AS fg_pct_change
FROM player_averages
WHERE early_minutes > 25 OR late_minutes > 25
ORDER BY early_minutes DESC;