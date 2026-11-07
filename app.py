import streamlit as st
import pandas as pd
from fetch_api.nba_fetch import fetch_all_teams
from render_pages.player_stats_page import render_player_list, render_player_page
from render_pages.player_props_page import render_all_props_page, render_player_props_page
from utils.data_format import format_schedule, highlight_lakers_score, highlight_preseason
from utils.data_load import load_all_teams, load_team_schedule, load_team_roster, load_team_info, load_all_player_props
from db.queries import get_next_game
from pathlib import Path
from datetime import date

st.markdown("""
<style>
[data-testid="stImage"] {
    text-align: center;
    display: block;
    margin-left: auto;
    margin-right: auto;
    margin-top: 20px;
    width: 100%;
    border: 2px solid purple;
}
.player-name, .market-name {
    font-size: 1.05rem;
    font-weight: 600;
    text-align: center;
}
.prop-info {
    color: #6B6B6B
}
.nav-link {
    text-align: center;
    font-weight: bold;
    padding: 8px 0;
    font-size: 16px;
}
.nav-link:hover {
    color: #E8BC2A;
}

</style>
""", unsafe_allow_html=True)

# Initialize session state

if "stats_view" not in st.session_state:
    st.session_state.stats_view = "list"
if "selected_player_id" not in st.session_state:
    st.session_state.selected_player_id = None

if "props_view" not in st.session_state:
    st.session_state.props_view = "list"
if "selected_prop_player_id" not in st.session_state:
    st.session_state.selected_prop_player_id = None
if "selected_prop_market" not in st.session_state:
    st.session_state.selected_prop_market = None
if "props_event_id" not in st.session_state:
    st.session_state.props_event_id = None

st.set_page_config(page_title="NBA Data", layout="wide")

all_teams = load_all_teams()

lal_team_nickname = "Lakers"
lal_team_id = all_teams.loc[all_teams['nickname'] == lal_team_nickname, 'id'].iloc[0]

col1, col2 = st.columns([.5, 3])
with col1:

    selected_season = st.selectbox(
        "Select Season",
        ["2026-27", "2025-26"],
        key="selected_season"
    )
    roster_season = selected_season[:4]

team_df = load_team_info(lal_team_id, selected_season)

standing = team_df["standing"].iloc[0].astype(str)
record = team_df["record"].iloc[0]

col1, col2 = st.columns([.5, 3])
with col1:
    img_path = Path("misc_imgs") / "lakers_logo.png"
    st.image(img_path, width=200)

with col2:
    st.header("Los Angeles Lakers", anchor="home")
    st.write(f"Western Conference Standing: **{standing}**")
    st.write(f"Record: **{record}**")


schedule_df = load_team_schedule(lal_team_id, selected_season)
schedule_df = format_schedule(schedule_df, lal_team_id, "Lakers")
styled_schedule_df = schedule_df.style.apply(highlight_lakers_score, axis=1).apply(highlight_preseason, axis=1)

roster_df = load_team_roster(lal_team_id, roster_season)


t1, t2, t3, t4 = st.tabs(["Schedule", "Roster", "Player Stats", "Player Props"])

with t1:
    if not schedule_df.empty:
        st.subheader("Team Schedule")
        st.dataframe(
            styled_schedule_df,
            column_config={
                "game_label": "Game Type",
                "game_date": "Date",
                "season_year": "Season",
                "game_status": "Status",
                "arena_name": "Arena"
            },
            hide_index=True
        )
    else:
        st.warning("Schedule data not found.")

with t2:
    if not roster_df.empty:
        st.subheader("Team Roster")
        st.dataframe(roster_df, 
                    column_config= {
                        "player_id": None,
                        "full_name": "Name",
                        "age": {
                                "label": "Age",
                                "alignment": "left",
                            },
                        "position": "Position",
                        "number": {
                                "label": "Jersey Number",
                                "alignment": "left",
                            },
                        "height": "Height",
                        "weight": "Weight"
                    },
                    hide_index=True)
    else: st.warning("Roster data not found.")

with t3:
    if st.session_state.stats_view == "list":
        render_player_list(roster_df)

    elif st.session_state.stats_view == "player":
        selected_player_id = st.session_state.selected_player_id

        if selected_player_id not in roster_df["player_id"].values:
            st.warning("This player was not on the Lakers' roster during the selected season.")
        else:
            render_player_page(roster_df, selected_player_id, selected_season)

with t4:
    if selected_season == "2025-26":
        props_game = {
            "event_id": "29fe17f5b19da82ce2957c3683a10aa7",
                "game_date": date(2026,4,9),
                "game_status": "Final"
        }

    else:
        props_game = get_next_game(lal_team_id, selected_season)

    if props_game is None:
        st.info("No upcoming games scheduled.")
        st.stop()

    else:
        event_id = props_game["event_id"]

        st.session_state.props_event_id = event_id
        game_date = pd.to_datetime(props_game["game_date"]).strftime("%m/%d/%Y")
        game_time = props_game["game_status"]

        all_props = load_all_player_props(event_id)

        if st.session_state.props_view == "list":
            if all_props.empty:
                st.info(f"No props available yet for the last available game on {game_date}.")
            else:
                if selected_season == "2025-26":
                    st.header(f"Props for the last available game on {game_date}")
                else:
                    st.header(f"Props for the next game on {game_date} at {game_time}")
                render_all_props_page(all_props)

        elif st.session_state.props_view == "player":
            render_player_props_page(all_props, roster_df,
                st.session_state.selected_prop_player_id,
                st.session_state.selected_prop_market,
                st.session_state.props_event_id,
                selected_season
            )