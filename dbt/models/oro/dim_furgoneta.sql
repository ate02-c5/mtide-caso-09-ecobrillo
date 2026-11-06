-- ORO · DIMENSIÓN dim_furgoneta
-- Una fila por cada furgoneta (matrícula) distinta del parte.
select distinct
    furgoneta
from {{ ref('stg_parte') }}
order by furgoneta
