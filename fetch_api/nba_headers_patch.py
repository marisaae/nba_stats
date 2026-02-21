NBA_STATS_HEADERS: dict[str, str] = {
    "Accept": "application/json, text/plain, */*",
    "Accept-Encoding": "gzip, deflate, br",
    "Accept-Language": "en-US,en;q=0.9",
    "Cache-Control": "no-cache",
    "Connection": "keep-alive",
    "Host": "stats.nba.com",
    "Origin": "https://www.nba.com",
    "Pragma": "no-cache",
    "Referer": "https://www.nba.com/",
    "Sec-Ch-Ua": '"Google Chrome";v="131", "Chromium";v="131", "Not_A Brand";v="24"',
    "Sec-Ch-Ua-Mobile": "?0",
    "Sec-Ch-Ua-Platform": '"Windows"',
    "Sec-Fetch-Dest": "empty",
    "Sec-Fetch-Mode": "cors",
    "Sec-Fetch-Site": "same-site",
    "User-Agent": (
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) "
        "AppleWebKit/537.36 (KHTML, like Gecko) "
        "Chrome/131.0.0.0 Safari/537.36"
    ),
}


def patch_nba_api_headers() -> None:
    try:
        from nba_api.stats.library import http as stats_http
        from nba_api.library import http as base_http

        stats_http.STATS_HEADERS = NBA_STATS_HEADERS
        stats_http.NBAStatsHTTP.headers = NBA_STATS_HEADERS

        # Reset sessions so new headers apply
        stats_http.NBAStatsHTTP._session = None
        base_http.NBAHTTP._session = None

        print("NBA API headers patched successfully.")

    except Exception as e:
        print("Failed to patch NBA API headers:", e)