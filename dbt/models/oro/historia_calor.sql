-- ORO · HISTORIA · El mapa de calor: ¿la furgoneta sobresale en todos los tipos de lavado?
-- Una fila por furgoneta × tipo_lavado, con las incidencias por 100 h de esa combinación.
-- Sirve para descartar la hipótesis del corte: si 8707GBG gasta lo mismo que la flota
-- por furgoneta en cada tipo, su exceso no viene de lavar «servicios duros».
select
    furgoneta,
    tipo_lavado,
    round(sum(case when con_incidencia then 1 else 0 end) / (sum(minutos) / 60.0) * 100, 2) as inc_100h
from {{ ref('fact_servicios') }}
group by furgoneta, tipo_lavado
order by furgoneta, tipo_lavado
