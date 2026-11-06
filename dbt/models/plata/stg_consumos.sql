-- PLATA · stg_consumos: el consumo entre lecturas consecutivas de cada furgoneta.
-- El giro del registro: el contador es ACUMULADO y, cuando se rellena el depósito,
-- VUELVE A CERO. Restar sin pensar da consumos negativos (el test protagonista los
-- cazaba: 19 en las 8 furgonetas), así que esa lectura se interpreta como recarga:
-- el gasto de ese tramo es lo que faltaba para el depósito lleno más lo consumido después.
with lecturas as (
    select furgoneta, ts, contador_l
    from {{ ref('stg_eventos') }}
    where tipo = 'lectura'
),
pares as (
    select
        furgoneta,
        ts,
        contador_l,
        lag(contador_l) over (partition by furgoneta order by ts) as lectura_previa,
        lag(ts)         over (partition by furgoneta order by ts) as ts_previa
    from lecturas
),
con_dep as (
    select p.*, f.deposito_l
    from pares p
    join {{ ref('stg_furgonetas') }} f using (furgoneta)
    where p.lectura_previa is not null
)
select
    furgoneta,
    ts,
    contador_l,
    lectura_previa,
    ts_previa,
    date_diff('minute', ts_previa, ts)                             as minutos_desde_previa,
    contador_l - lectura_previa                                    as consumo_bruto_l,   -- «restar sin pensar»
    contador_l - lectura_previa < 0                                as recarga,           -- el depósito se rellenó aquí
    case
        when contador_l - lectura_previa < 0
            then (deposito_l - lectura_previa) + contador_l        -- hasta llenar el depósito + lo nuevo
        else contador_l - lectura_previa
    end                                                            as consumo_l
from con_dep
