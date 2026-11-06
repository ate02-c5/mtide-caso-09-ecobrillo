-- ORO · PREGUNTA 4 · ¿Qué furgoneta gasta más agua por servicio, medida por el contador?
-- El contador manda (día 2026-05-18): agua total (consumos ya corregidos de la recarga)
-- repartida entre los fin_servicio del registro. Al lado, lo que dice el parte
-- (litros/servicio histórico). Nivel: una fila por furgoneta; cada parte a ese nivel por
-- separado y luego un join 1-a-1, para no multiplicar filas.
with contador as (
    select
        furgoneta,
        sum(consumo_l) as agua_contador_l
    from {{ ref('stg_consumos') }}
    group by furgoneta
),
eventos as (
    select
        furgoneta,
        count(*) as servicios_contador
    from {{ ref('stg_eventos') }}
    where tipo = 'fin_servicio'
    group by furgoneta
),
parte as (
    select
        furgoneta,
        sum(litros_agua) / count(*) as l_por_servicio_parte
    from {{ ref('fact_servicios') }}
    group by furgoneta
)
select
    c.furgoneta,
    e.servicios_contador,
    round(c.agua_contador_l, 1)                                    as agua_contador_l,
    round(c.agua_contador_l / e.servicios_contador, 2)             as l_por_servicio_contador,
    round(p.l_por_servicio_parte, 2)                               as l_por_servicio_parte
from contador c
join eventos e using (furgoneta)
join parte p using (furgoneta)
order by l_por_servicio_contador desc
