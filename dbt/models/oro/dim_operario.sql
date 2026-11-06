-- ORO · DIMENSIÓN dim_operario
-- Una fila por cada operario distinto del parte. La clave es el propio nombre ya
-- normalizado en plata; aqui no hay medidas: es la lista de personas del negocio.
select distinct
    operario
from {{ ref('stg_parte') }}
order by operario
