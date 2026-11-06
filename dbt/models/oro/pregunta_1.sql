-- ORO · PREGUNTA 1 · ¿Qué tipo de lavado deja menos ingreso por hora?
-- Una fila por tipo de lavado; ingreso_hora = € del tipo sobre sus horas efectivas.
-- El menor (primera fila) es el candidato a revisión de precio y proceso.
select
    tipo_lavado,
    round(sum(importe_eur) / (sum(minutos) / 60.0), 2) as ingreso_hora
from {{ ref('fact_servicios') }}
group by tipo_lavado
order by ingreso_hora asc
