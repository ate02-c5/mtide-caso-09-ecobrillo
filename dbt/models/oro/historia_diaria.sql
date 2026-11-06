-- ORO · HISTORIA · El terreno día a día: servicios, agua total y litros por servicio.
-- El gráfico de línea explora así: ¿cómo evoluciona el gasto por servicio del parte?
-- y ¿hay algún día dentro de lo común? Es la base de la comparación con el día del contador.
select
    fecha,
    count(*)                                             as servicios,
    round(sum(importe_eur), 2)                           as ingresos_eur,
    round(sum(litros_agua), 1)                           as agua_total_l,
    round(sum(litros_agua) / count(*), 2)                as l_por_servicio
from {{ ref('fact_servicios') }}
group by fecha
order by fecha
