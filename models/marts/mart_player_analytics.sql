with player_transactions as (
    select 
        player_id,
        sum(purchase_amount) as total_spend,
        count(transaction_id) as transaction_count
    from {{ ref('stg_activision__transactions') }}
    group by player_id
)

select 
    p.player_id,
    p.email,
    p.username,
    p.signup_date,
    p.country,
    p.platform,
    g.last_login_date,
    g.total_playtime_hours,
    g.highest_level_achieved,
    g.games_played,
    g.win_rate,
    coalesce(pt.total_spend, 0) as total_spend,
    coalesce(pt.transaction_count, 0) as transaction_count,
    case 
        when coalesce(pt.total_spend, 0) > 100 then 'High Value'
        when coalesce(pt.total_spend, 0) > 50 then 'Medium Value'
        else 'Low Value'
    end as player_segment,
    datediff(day, g.last_login_date, current_date()) as days_since_last_login

from {{ ref('stg_activision__players') }} p
left join {{ ref('stg_activision__gameplay_stats') }} g 
    on p.player_id = g.player_id
left join player_transactions pt 
    on p.player_id = pt.player_id