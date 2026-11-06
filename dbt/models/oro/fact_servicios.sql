-- ORO · HECHO fact_servicios
-- Grano: un servicio (una fila por número de servicio, ya único en plata).
-- Las medidas del negocio (minutos, litros_agua, importe_eur) viven en este grano; los
-- descriptores que cortan (operario, furgoneta, tipo_lavado) quedan referenciales: cada
-- uno tiene su dimensión. incidencia pasa a booleana: booleana con_incidencia.
select
    servicio,
    fecha,
    operario,
    furgoneta,
    tipo_lavado,
    minutos,
    litros_agua,
    importe_eur,
    incidencia is not null as con_incidencia
from {{ ref('stg_parte') }}
order by servicio
