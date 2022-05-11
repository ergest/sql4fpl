/* use a date + hour spine to set up hourly reports */
with hour_spine as (
    select
        dateadd(hour, seq4(), date_trunc(day, dateadd(day, -30, current_date()))) as hour_start,
        dateadd(hour, seq4()+1, date_trunc(day, dateadd(day, -30, current_date()))) as hour_end
    from
        table (generator(rowcount => 24 * 31))
)
/* calculate the date boundaries */
, hour_spine_param as (
    select
        min(hour_start) as hour_start,
        max(hour_end) as hour_end
    from
        hour_spine
)
, query_history as (
    select
        qh.*
    from
        snowflake.account_usage.query_history qh
        cross join hour_spine_param hs
    where 
        qh.end_time >= hs.hour_start 
        and qh.start_time < hs.hour_end
)
, warehouse_metering as (
    select
        start_time,
        end_time,
        warehouse_name,
        credits_used_compute
    from 
        snowflake.account_usage.warehouse_metering_history wh
        cross join hour_spine_param hs
    where 
        wh.start_time > hs.hour_start 
        and wh.end_time <= hs.hour_end
)
/* create one row for each hour so we can line it up with metering data */
, query_partitioned_by_hour as (
    select
        qh.*,
        hs.*
    from
        query_history qh
        cross join hour_spine hs
    where
        end_time >= hs.hour_start
        and start_time < hs.hour_end
)
/* calculate how many millisecs the query spent on a given hour */
, millisecs_per_query_in_hour as (
    select
        case 
            when start_time >= hour_start and end_time < hour_end
            then datediff(millisecond, start_time, end_time)
            when start_time < hour_start and end_time <= hour_end
            then datediff(millisecond, hour_start, end_time)
            when start_time >= hour_start and end_time > hour_end
            then datediff(millisecond, start_time, hour_end)
            when start_time < hour_start and end_time > hour_end
            then datediff(millisecond, hour_start, hour_end)
        end as millisecs,
        qhp.*
    from
        query_partitioned_by_hour qhp
)
/* calculate total millisecs spent by a warehouse in a given hour */
, millisecs_per_warehouse_in_hour as (
    select
        warehouse_name,
        hour_start,
        hour_end,
        sum(millisecs) as total_millisecs
    from
       millisecs_per_query_in_hour
    group by 1,2,3,4
)
/* calculate query share on those millisecs above */
, query_share_by_warehouse as (
    select
        (q.millisecs / w.total_millisecs) as query_share,
        (q.millisecs / w.total_millisecs) * wm.credits_used_compute as query_credits_used,
        q.*
    from
        millisecs_per_query_in_hour q
        join millisecs_per_warehouse_in_hour w 
            on  q.warehouse_name = w.warehouse_name
            and q.hour_start = w.hour_start
            and q.hour_end = w.hour_end
        join warehouse_metering wm
            on  w.warehouse_name = wm.warehouse_name
            and w.hour_start = wm.start_time
            and w.hour_end = wm.end_time
)
/* get the credits by query_id */
, query_credits_agg as (
    select
        query_id,
        sum(query_credits_used) as query_credits_used
    from
        query_share_by_warehouse
    group by 1
)
/* finally join credits back to the query history table */
select
    qh.*,
    qagg.query_credits_used
from
    query_history qh
    join query_credits_agg qagg
        on qh.query_id = qagg.query_id
