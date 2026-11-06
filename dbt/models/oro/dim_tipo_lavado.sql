-- ORO · DIMENSIÓN dim_tipo_lavado
-- Una fila por cada tipo de lavado distinto del parte: las tres formas de cortar
-- los datos que pide la dirección, junto con operario y furgoneta.
select distinct
    tipo_lavado
from {{ ref('stg_parte') }}
order by tipo_lavado
