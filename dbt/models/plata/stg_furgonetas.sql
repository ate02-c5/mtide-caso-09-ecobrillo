-- PLATA · stg_furgonetas: la fuente de referencia con la capacidad del depósito.
select
    furgoneta,
    deposito_l::integer as deposito_l
from {{ source('bronce', 'furgonetas') }}
