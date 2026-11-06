-- PLATA · stg_eventos: el registro de los contadores, una fila por evento.
-- El registro bruto mezcla dos tipos de fila: 'lectura' (cada ~10 min, con contador_l
-- ACUMULADO en litros) y 'fin_servicio' (un aviso por lavado, sin contador_l). Aquí solo
-- se tipa y se separa lo que es, sin decidir aún nada del giro.
select
    evento_id,
    furgoneta,
    tipo,
    ts::timestamp          as ts,
    contador_l::double     as contador_l
from {{ source('bronce', 'eventos') }}
