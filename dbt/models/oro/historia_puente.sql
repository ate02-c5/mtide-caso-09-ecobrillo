-- ORO · HISTORIA · El puente contador-parte: una fila por furgoneta.
-- La cifra del titular: 8707GBG mide hueco_pct % más de agua en el contador (día del
-- registro, recargas ya corregidas en plata) de lo que declara su parte.
-- La prueba de la limpieza, al lado: sin el arreglo de las recargas, l_sv_sin_limpiar
-- da absurdos (consumos negativos que restan litros) y el ranking pierde el sentido.
with total as (
    select sum(case when consumo_bruto_l < 0 then 1 else 0 end) as recargas_tot
    from {{ ref('stg_consumos') }}
)
select
    f.furgoneta,
    round(f.horas, 1)                                                                     as horas,
    round(f.l_por_servicio_parte, 2)                                                      as l_por_servicio_parte,
    round(c.agua / ev.n, 2)                                                               as l_por_servicio_contador,
    round((c.agua / ev.n / f.l_por_servicio_parte - 1) * 100, 1)                           as hueco_pct,
    round(c.bruta / ev.n, 2)                                                              as l_sv_sin_limpiar,
    round((c.bruta / ev.n / f.l_por_servicio_parte - 1) * 100, 1)                          as hueco_sin_limpiar_pct,
    t.recargas_tot                                                                        as recargas,
    ev.n                                                                                  as servicios_contador
from (
    select
        furgoneta,
        sum(minutos) / 60.0   as horas,
        sum(litros_agua) / count(*) as l_por_servicio_parte
    from {{ ref('fact_servicios') }}
    group by furgoneta
) f
join (
    select
        furgoneta,
        sum(consumo_l)       as agua,
        sum(consumo_bruto_l) as bruta
    from {{ ref('stg_consumos') }}
    group by furgoneta
) c using (furgoneta)
join (
    select furgoneta, count(*) as n
    from {{ ref('stg_eventos') }}
    where tipo = 'fin_servicio'
    group by furgoneta
) ev using (furgoneta)
cross join total t
order by hueco_pct desc
