CREATE OR REPLACE VIEW public.v_playerhistory2021
AS 
SELECT
     ph.element AS player_id,
    p.web_name,
    p.first_name || ' ' || p.second_name AS player_name,
    pu.player_name AS understat_name,
    pos.singular_name_short AS player_position,
    ph.round AS gameweek,
    ph.value::numeric / 10 AS player_price,
    ph.influence::numeric AS influence,
    ph.creativity::numeric AS creativity,
    ph.threat::numeric AS threat,
    ph.ict_index::numeric AS ict_index,
    ph.minutes::numeric AS minutes,
    ph.total_points::numeric AS total_points,
    ph.bps::numeric AS bps,
    ph."xP"::numeric AS current_xp,
    pu."xG"::numeric AS season_xg,
    pu."xA"::numeric AS season_xa,
    pu.shots::numeric AS shots,
    pu.key_passes::numeric  AS key_passes,
    pu.npg::numeric    AS non_penalty_goals,
    pu."npxG"::numeric AS non_penalty_expected_goals,
    pu."xGChain"::numeric AS xg_chain,
    pu."xGBuildup"::numeric AS xg_buildup,
    pu."xG" / pu.games AS xg90,
    pu."xA" / pu.games AS xa90,
    COALESCE(SUM(ph.total_points::numeric) OVER form, 0::numeric) AS total_points_form,
    COALESCE(SUM(ph.minutes::numeric) OVER form, 0::numeric) AS total_minutes_form,
    COALESCE(SUM(ph.total_points::numeric) OVER prev_form, 0::numeric) AS total_points_prev_form,
    ROUND(SUM(ph.total_points::numeric) OVER per_game / ph.round::numeric, 2) AS points_per_game,
    ROW_NUMBER() OVER (PARTITION BY ph.element ORDER BY ph.round DESC) AS row_id
FROM
    player_history_2021 ph
    JOIN player_2021 p ON p.id = ph.element
    JOIN player_positions pos ON pos.id = p.element_type
    JOIN player_understat_2021 pu on p.id = pu.fpl_id
WHERE true
    WINDOW  form AS (PARTITION BY ph.element ORDER BY ph.round ROWS BETWEEN 3 PRECEDING AND CURRENT ROW),
            prev_form AS (PARTITION BY ph.element ORDER BY ph.round ROWS BETWEEN 4 PRECEDING AND 1 PRECEDING), 
            per_game AS (PARTITION BY ph.element ORDER BY ph.round ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW);
