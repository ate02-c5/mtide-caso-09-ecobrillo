-- ORO · PREGUNTA 3 · ¿Qué furgoneta acumula más incidencias por cada 100 horas?
-- Una fila por furgoneta; incidencias_100h = incidencias por cada 100 h de servicio.
select
    furgoneta,
    round(sum(case when con_incidencia then 1 else 0 end) / (sum(minutos) / 60.0) * 100, 2) as incidencias_100h
from {{ ref('fact_servicios') }}
group by furgoneta
order by incidencias_100h desc
