-- PLATA · el parte diario limpio: la limpieza que hiciste en la J3, ahora como modelo dbt.
-- Cada entrega del parte es una carpeta fecha_carga=… en bronce: aquí se leen todas juntas.
with bruto as (
    select *, parse_filename(filename) as archivo
    from {{ source('bronce', 'parte') }}
),
sin_dup as (
    -- una fila por servicio
    select * from bruto
    qualify row_number() over (partition by servicio order by fecha_carga desc) = 1
),
mediana_tipo_lavado as (
    select tipo_lavado, median(minutos::integer) as minutos_mediana
    from sin_dup
    where minutos::integer between 1 and 360
    group by tipo_lavado
)
select
    s.servicio,
    -- La remesa de fecha_carga=2026-05-16 (136 filas, SRV-00552..00687) llega con la fecha en
    -- formato DD/MM/YYYY (ej. 06/05/2026): otro ordenador con configuración regional distinta.
    -- Las entregas anteriores venían en ISO YYYY-MM-DD. Se detecta por el separador '/' y se
    -- interpreta día primero: 39 filas de la remesa tienen día > 12 (p.ej. 15/05/2026), sin
    -- ambigüedad posible. Bronce no se toca: el arreglo vive aquí, en plata.
    case when regexp_matches(s.fecha, '^[0-9]{2}/[0-9]{2}/[0-9]{4}$')
         then strptime(s.fecha, '%d/%m/%Y')
         else strptime(s.fecha, '%Y-%m-%d') end::date             as fecha,
    upper(trim(s.operario))                                         as operario,
    s.furgoneta,
    s.tipo_lavado,
    case when s.minutos::integer between 1 and 360 then s.minutos::integer
         else round(m.minutos_mediana)::integer end               as minutos,
    not (s.minutos::integer between 1 and 360)                   as minutos_corregido,
    s.litros_agua::double                                              as litros_agua,
    s.importe_eur::double                                      as importe_eur,
    s.incidencia,
    s.archivo,
    s.fecha_carga
from sin_dup s
join mediana_tipo_lavado m using (tipo_lavado)
