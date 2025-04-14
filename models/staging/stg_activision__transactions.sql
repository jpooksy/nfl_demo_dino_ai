with source as (

    select * from {{ source('activision_data', 'transactions') }}

),

renamed as (

    select
        transaction_id,
        player_id,
        transaction_date,
        purchase_amount,
        item_purchased,
        payment_method,
        
        -- meta fields
        '{{ invocation_id }}' as _dbt_job_id,
        current_timestamp() as _loaded_at_utc

    from source

)

select * from renamed