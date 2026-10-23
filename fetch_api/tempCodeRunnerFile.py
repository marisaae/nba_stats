from datetime import date
import os
import time
import random
from db.connection import get_connection
from fetch_api.nba_fetch import (fetch_all_teams, fetch_team_info, fetch_team_roster, fetch_team_schedule, fetch_player_game_logs, fetch_team_def_stats, fetch_player_headshot)
from fetch_api.odds_fetch import fetch_odds
from utils.fetch_utils import cleanup_old_headshots


def run_all(season="2026-27"):
    today = date.today()
    all_teams = fetch_all_teams()

    lal_team_abbrev = "LAL"
    lal_team_id = all_teams.loc[all_teams['abbreviation'] == lal_team_abbrev, 'id'].iloc[0]

    with get_connection() as conn:
        with conn.cursor() as cur:
            roster_df = fetch_team_roster(lal_team_id, season, cur)
            fetch_team_schedule(lal_team_id, season, cur)