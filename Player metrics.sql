with PlayerMetrics as (
        select
            ph.player_id,
            cw.gameweek,
            ph.web_name,
            ph.player_name,
            ph.player_position,
            sum(ph.total_points)                                        as total_points,
            sum(ph.minutes)                                             as total_minutes,
            sum(case when ph.minutes > 0 then 1 else 0 end)             as total_matches,
            sum(ph.bps)                                                 as total_bps,
            round(max(cw.total_points_form)/4, 1)                       as recent_form,
            round(max(cw.total_points_prev_form)/4, 1)                  as previous_form,
            round(max(cw.total_points_form)/4/max(cw.player_price), 1)  as form_per_million,
            max(cw.player_price)                                        as current_price,
            max(cw.total_points)                                        as last_week_points,
            max(cw.ict_index)                                           as current_ict_index,
            max(cw.current_xp)                                          as current_xp,
            max(cw.season_xg)                                           as season_xg,
            max(cw.season_xa)                                           as season_xa,
            max(cw.xg90)                                                as xg90,
            max(cw.xa90)                                                as xa90,
            max(cw.key_passes)                                          as key_passes,
            max(cw.shots)                                               as shots,
            max(cw.non_penalty_goals)                                   as non_penalty_goals,
            max(cw.non_penalty_expected_goals)                          as non_penalty_expected_goals,
            max(cw.xg_chain)                                            as xg_chain,
            max(cw.xg_buildup)                                          as xg_buildup
        from
            v_playerhistory2021 ph
            join v_playerhistory2021 cw on ph.player_id = cw.player_id and cw.row_id = 1
        where
            true
        group by
            1,2,3,4,5,6
)
, PlayerMetrics2 as (
    select
        player_id,
        web_name,
        total_matches,
        player_position,
        current_price,
        total_points,
        round(total_minutes/gameweek/90.0, 1)                    as full_games_index,
        round(total_points/total_matches, 1)                     as points_per_match,
        round(total_points/total_matches/current_price, 2)       as points_per_match_per_million,
        round(total_points/current_price, 2)                     as points_per_million,
        round(((total_points/total_matches)-2)/current_price, 2) as value_added_per_match,
        total_bps*0.001                                          as total_bps,
        (recent_form - previous_form)                            as form_momentum,
        form_per_million,
        current_ict_index,
        current_xp,
        xg_chain,
        season_xg
    from
        PlayerMetrics pm
)
select *
from PlayerMetrics2
where
    true
    and player_position = 'FWD'
    and full_games_index >= 0.5
order by
    season_xg desc,
    points_per_million desc
