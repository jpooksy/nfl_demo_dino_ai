with source as (

    select * from {{ source('activision_data', 'players') }}

),

renamed as (

    select
        player_id,
        email,
        username,
        signup_date,
        country,
        platform,
        
        -- meta fields
        '{{ invocation_id }}' as _dbt_job_id,
        current_timestamp() as _loaded_at_utc

    from source

)

select * from renamed