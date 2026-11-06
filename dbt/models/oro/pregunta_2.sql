-- ORO · PREGUNTA 2 · ¿Qué operario gasta más agua por hora?
-- Una fila por operario; l_agua_hora = litros sobre sus horas efectivas, de mayor a menor.
select
    operario,
    round(sum(litros_agua) / (sum(minutos) / 60.0), 2) as l_agua_hora
from {{ ref('fact_servicios') }}
group by operario
order by l_agua_hora desc
