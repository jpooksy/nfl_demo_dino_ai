with source as (

    select * from {{ source('activision_data', 'gameplay_stats') }}

),

renamed as (

    select
        player_id,
        last_login_date,
        total_playtime_hours,
        highest_level_achieved,
        games_played,
        win_rate,
        
        -- meta fields
        '{{ invocation_id }}' as _dbt_job_id,
        current_timestamp() as _loaded_at_utc

    from source

)

select * from renamed