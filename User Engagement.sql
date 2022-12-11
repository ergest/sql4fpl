 -- get the user name and collapse the granularity of post_history to the user_id, post_id, activity type and date
with post_activity as (
    select
        ph.post_id,
        ph.user_id,
        u.display_name as user_name,
        ph.creation_date as activity_date,
        case when ph.post_history_type_id in (1,2,3) then 'created'
             when ph.post_history_type_id in (4,5,6) then 'edited' 
        end as activity_type
    from
        `bigquery-public-data.stackoverflow.post_history` ph
        inner join `bigquery-public-data.stackoverflow.users` u on u.id = ph.user_id
    where
        true 
        and ph.post_history_type_id between 1 and 6
        and user_id > 0 --exclude automated processes
        and user_id is not null --exclude deleted accounts
        and ph.creation_date >= cast('2021-06-01' as timestamp) 
        and ph.creation_date <= cast('2021-09-30' as timestamp)
    group by
        1,2,3,4,5
)
-- get the post types we care about questions and answers only and combine them in one cte
,post_types as (
    select
        id as post_id,
        'question' as post_type,
    from
        `bigquery-public-data.stackoverflow.posts_questions`
    where
        true
        and creation_date >= cast('2021-06-01' as timestamp) 
        and creation_date <= cast('2021-09-30' as timestamp)
    union all
    select
        id as post_id,
        'answer' as post_type,
    from
        `bigquery-public-data.stackoverflow.posts_answers`
    where
        true
        and creation_date >= cast('2021-06-01' as timestamp) 
        and creation_date <= cast('2021-09-30' as timestamp)
 )
 -- finally calculate the post metrics 
, user_post_metrics as (
    select
        user_id,
        user_name,
        cast(activity_date as date) as activity_date ,
        sum(case when activity_type = 'created' and post_type = 'question' then 1 else 0 end) as questions_created,
        sum(case when activity_type = 'created' and post_type = 'answer'   then 1 else 0 end) as answers_created,
        sum(case when activity_type = 'edited'  and post_type = 'question' then 1 else 0 end) as questions_edited,
        sum(case when activity_type = 'edited'  and post_type = 'answer'   then 1 else 0 end) as answers_edited,
        sum(case when activity_type = 'created' then 1 else 0 end) as posts_created,
        sum(case when activity_type = 'edited' then 1 else 0 end)  as posts_edited
    from post_types pt
         join post_activity pa on pt.post_id = pa.post_id
    group by 1,2,3
)
, comments_by_user as (
    select
        user_id,
        cast(creation_date as date) as activity_date,
        count(*) as total_comments
    from
        `bigquery-public-data.stackoverflow.comments`
    where
        true
        and creation_date >= cast('2021-06-01' as timestamp) 
        and creation_date <= cast('2021-09-30' as timestamp)
    group by
        1,2
)
, comments_on_user_post as (
    select
        pa.user_id,
        cast(c.creation_date as date) as activity_date,
        count(*) as total_comments
    from
        `bigquery-public-data.stackoverflow.comments` c
        inner join post_activity pa on pa.post_id = c.post_id
    where
        true
        and pa.activity_type = 'created'
        and c.creation_date >= cast('2021-06-01' as timestamp) 
        and c.creation_date <= cast('2021-09-30' as timestamp)
    group by
        1,2
)
, votes_on_user_post as (
      select
        pa.user_id,
        cast(v.creation_date as date) as activity_date,
        sum(case when vote_type_id = 2 then 1 else 0 end) as total_upvotes,
        sum(case when vote_type_id = 3 then 1 else 0 end) as total_downvotes,
    from
        `bigquery-public-data.stackoverflow.votes` v
        inner join post_activity pa on pa.post_id = v.post_id
    where
        true
        and pa.activity_type = 'created'
        and v.creation_date >= cast('2021-06-01' as timestamp) 
        and v.creation_date <= cast('2021-09-30' as timestamp)
    group by
        1,2
)
, total_metrics_per_user as (
    select
        pm.user_id,
        pm.user_name,
        sum(pm.posts_created)            as total_posts_created, 
        sum(pm.posts_edited)             as total_posts_edited,
        sum(pm.answers_created)          as total_answers_created,
        sum(pm.answers_edited)           as total_answers_edited,
        sum(pm.questions_created)        as total_questions_created,
        sum(pm.questions_edited)         as total_questions_edited,
        sum(vu.total_upvotes)            as total_upvotes,
        sum(vu.total_downvotes)          as total_downvotes,
        sum(cu.total_comments)           as total_comments_by_user,
        sum(cp.total_comments)           as total_comments_on_post,
        count(distinct pm.activity_date) as streak_in_days      
    from
        user_post_metrics pm
        join votes_on_user_post vu
            on pm.activity_date = vu.activity_date
            and pm.user_id = vu.user_id
        join comments_on_user_post cp 
            on pm.activity_date = cp.activity_date
            and pm.user_id = cp.user_id
        join comments_by_user cu
            on pm.activity_date = cu.activity_date
            and pm.user_id = cu.user_id
    group by
        1,2
)
------------------------------------------------
---- main query
select
    user_id,
    user_name,
    total_posts_created, 
    total_answers_created,
    total_answers_edited,
    total_questions_created,
    total_questions_edited,
    total_upvotes,
    total_comments_by_user,
    total_comments_on_post,
    streak_in_days,
    round(cast(total_posts_created / streak_in_days as numeric), 1)          as posts_per_day,
    round(cast(total_posts_edited / streak_in_days as numeric), 1)           as edits_per_day,
    round(cast(total_answers_created / streak_in_days as numeric), 1)        as answers_per_day,
    round(cast(total_questions_created / streak_in_days as numeric), 1)      as questions_per_day,
    round(cast(total_comments_by_user / streak_in_days as numeric), 1)       as comments_by_user_per_day,
    round(cast(total_answers_created / total_posts_created as numeric), 1)   as answers_per_post,
    round(cast(total_questions_created / total_posts_created as numeric), 1) as questions_per_post,
    round(cast(total_upvotes / total_posts_created as numeric), 1)           as upvotes_per_post,
    round(cast(total_downvotes / total_posts_created as numeric), 1)         as downvotes_per_post,
    round(cast(total_comments_by_user / total_posts_created as numeric), 1)  as user_comments_per_post,
    round(cast(total_comments_on_post / total_posts_created as numeric), 1)  as comments_on_post_per_post
from
    total_metrics_per_user
where
    total_posts_created > 0
order by 
    total_questions_created desc;